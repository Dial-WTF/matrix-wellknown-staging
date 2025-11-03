#!/bin/bash
# Setup script for self-hosted .well-known files on staging-4.dial.wtf
# This assumes you have nginx and certbot installed

set -e

echo "🚀 Setting up self-hosted Matrix .well-known files"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "❌ Please run as root (use sudo)"
    exit 1
fi

# Check if nginx is installed
if ! command -v nginx &> /dev/null; then
    echo "❌ nginx is not installed. Please install it first:"
    echo "   sudo apt-get install nginx  # Debian/Ubuntu"
    echo "   sudo yum install nginx      # CentOS/RHEL"
    exit 1
fi

# Check if certbot is installed
if ! command -v certbot &> /dev/null; then
    echo "⚠️  certbot is not installed. Installing..."
    sudo apt-get update
    sudo apt-get install -y certbot python3-certbot-nginx
fi

echo "📝 Creating nginx configuration..."
sudo cp nginx-config.conf /etc/nginx/sites-available/staging-4.dial.wtf

echo "🔗 Enabling site..."
sudo ln -sf /etc/nginx/sites-available/staging-4.dial.wtf /etc/nginx/sites-enabled/

echo "✅ Testing nginx configuration..."
sudo nginx -t

if [ $? -eq 0 ]; then
    echo "✅ Nginx configuration is valid"
    echo ""
    echo "🔒 Obtaining SSL certificate..."
    sudo certbot --nginx -d staging-4.dial.wtf --non-interactive --agree-tos --email your-email@example.com
    
    echo ""
    echo "🔄 Reloading nginx..."
    sudo systemctl reload nginx
    
    echo ""
    echo "✅ Setup complete!"
    echo ""
    echo "🧪 Test the endpoints:"
    echo "   curl https://staging-4.dial.wtf/.well-known/matrix/server"
    echo "   curl https://staging-4.dial.wtf/.well-known/matrix/client"
    echo ""
    echo "📋 Verify Content-Type header:"
    echo "   curl -I https://staging-4.dial.wtf/.well-known/matrix/server | grep content-type"
else
    echo "❌ Nginx configuration test failed. Please check the config file."
    exit 1
fi

