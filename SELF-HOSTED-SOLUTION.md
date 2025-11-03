# Self-Hosted Solution (Free, No Vendor Lock-in)

## Best Option: Serve from Your Matrix Server

Your Matrix server at `matrix.staging-4.dial.wtf` **already serves these files correctly** with `Content-Type: application/json`.

## Solution: Configure Nginx/Apache to Serve from Matrix Server

Since you control the Matrix server infrastructure, configure your web server (nginx/apache) on `staging-4.dial.wtf` to serve the `.well-known` files.

### Option 1: Nginx Reverse Proxy (Recommended)

If you have nginx on `staging-4.dial.wtf`, add this configuration:

```nginx
server {
    listen 443 ssl http2;
    server_name staging-4.dial.wtf;

    ssl_certificate /path/to/ssl/cert.pem;
    ssl_certificate_key /path/to/ssl/key.pem;

    # Serve .well-known/matrix files with correct content type
    location /.well-known/matrix/server {
        add_header Content-Type application/json;
        add_header Access-Control-Allow-Origin *;
        return 200 '{"m.server": "matrix.staging-4.dial.wtf:443"}';
    }

    location /.well-known/matrix/client {
        add_header Content-Type application/json;
        add_header Access-Control-Allow-Origin *;
        return 200 '{"m.homeserver": {"base_url": "https://matrix.staging-4.dial.wtf"}, "m.identity_server": {"base_url": "https://vector.im"}}';
    }

    # Or proxy to Matrix server if you prefer
    # location /.well-known/matrix/ {
    #     proxy_pass https://matrix.staging-4.dial.wtf;
    #     proxy_set_header Host matrix.staging-4.dial.wtf;
    #     add_header Content-Type application/json always;
    # }
}
```

### Option 2: Copy Files to Static Directory

If you have a static file server on `staging-4.dial.wtf`:

1. Copy the files from `matrix.staging-4.dial.wtf`:
   ```bash
   curl https://matrix.staging-4.dial.wtf/.well-known/matrix/server > /var/www/html/.well-known/matrix/server
   curl https://matrix.staging-4.dial.wtf/.well-known/matrix/client > /var/www/html/.well-known/matrix/client
   ```

2. Configure nginx to serve with correct content type:
   ```nginx
   location /.well-known/matrix/ {
       root /var/www/html;
       default_type application/json;
       add_header Content-Type application/json;
   }
   ```

### Option 3: Simple Python/Node Static Server

If you have a small VPS or server:

```python
# simple-server.py
from http.server import HTTPServer, BaseHTTPRequestHandler
import json

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/.well-known/matrix/server':
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            self.wfile.write(b'{"m.server": "matrix.staging-4.dial.wtf:443"}')
        elif self.path == '/.well-known/matrix/client':
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            self.wfile.write(b'{"m.homeserver": {"base_url": "https://matrix.staging-4.dial.wtf"}, "m.identity_server": {"base_url": "https://vector.im"}}')
        else:
            self.send_response(404)
            self.end_headers()

HTTPServer(('0.0.0.0', 443), Handler).serve_forever()
```

Run with SSL using `stunnel` or `certbot`.

## Benefits

✅ **Free** - Uses your existing infrastructure  
✅ **No vendor lock-in** - Full control  
✅ **Correct headers** - You control Content-Type  
✅ **Fast** - No external dependencies  

## DNS Configuration

Point `staging-4.dial.wtf` to your server IP:
- **A record**: `staging-4` → `[your-server-ip]`
- Or **CNAME**: `staging-4` → `[your-server-hostname]`

## SSL Certificate

Use Let's Encrypt (free):
```bash
certbot --nginx -d staging-4.dial.wtf
```

This is the most self-hosted, vendor-free solution!

