#!/bin/bash
# Check GitHub Pages HTTPS status and enable enforcement when ready
# Loops every 15 minutes until HTTPS is working

INTERVAL=900  # 15 minutes in seconds
MAX_ATTEMPTS=48  # 12 hours max (48 * 15 min)

check_status() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo "🕐 Check at $timestamp"
    echo "═══════════════════════════════════════════════════════════════"
    echo ""
    
    # Get GitHub Pages status
    local pages_data=$(gh api repos/Dial-WTF/matrix-wellknown-staging/pages 2>/dev/null)
    
    if [ $? -ne 0 ]; then
        echo "❌ Error: Could not fetch GitHub Pages status"
        return 1
    fi
    
    local pages_status=$(echo "$pages_data" | jq -r '.status')
    local https_enforced=$(echo "$pages_data" | jq -r '.https_enforced')
    local cert_state=$(echo "$pages_data" | jq -r '.https_certificate.state // "unknown"')
    local cert_desc=$(echo "$pages_data" | jq -r '.https_certificate.description // "N/A"')
    
    echo "📊 GitHub Pages Status:"
    echo "  Status: $pages_status"
    echo "  HTTPS Enforced: $https_enforced"
    echo "  Certificate State: $cert_state"
    echo "  Certificate Description: $cert_desc"
    echo ""
    
    # Test HTTPS endpoint
    echo "🧪 Testing HTTPS endpoint..."
    local curl_stderr=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 https://staging-4.dial.wtf/.well-known/matrix/server 2>&1)
    local https_test=$(echo "$curl_stderr" | grep -E '^[0-9]{3}$' | tail -1)
    local https_error=$(echo "$curl_stderr" | grep -iE "ssl|certificate|verify" | head -1)
    
    if [ -n "$https_error" ]; then
        echo "  ⏳ SSL certificate error: $(echo $https_error | cut -c1-60)..."
        echo ""
        return 1  # Not ready yet
        elif [ "$https_test" = "200" ]; then
        echo "  ✅ HTTPS endpoint working! (HTTP 200)"
        echo ""
        
        # Verify the content
        local content=$(curl -s --max-time 10 https://staging-4.dial.wtf/.well-known/matrix/server)
        if echo "$content" | grep -q "m.server"; then
            echo "  ✅ Content verified - JSON response looks correct"
            echo ""
            
            # Try to enable HTTPS enforcement if not already enabled
            if [ "$https_enforced" = "false" ]; then
                echo "🔒 Attempting to enable HTTPS enforcement..."
                local response=$(echo '{"cname":"staging-4.dial.wtf","https_enforced":true}' | gh api repos/Dial-WTF/matrix-wellknown-staging/pages --method PUT --input - 2>&1)
                
                if echo "$response" | grep -q "certificate does not exist"; then
                    echo "  ⚠️  Certificate not yet fully provisioned, but HTTPS is working"
                    return 2  # HTTPS works but enforcement can't be enabled yet
                    elif echo "$response" | jq -e '.https_enforced' > /dev/null 2>&1; then
                    echo "  ✅ HTTPS enforcement enabled!"
                    return 0  # Success!
                else
                    echo "  ⚠️  HTTPS works but couldn't enable enforcement yet"
                    return 2
                fi
            else
                echo "  ✅ HTTPS enforcement is already enabled!"
                return 0  # Success!
            fi
        else
            echo "  ⚠️  HTTPS works but content validation failed"
            return 2
        fi
        elif [ "$https_test" = "000" ] || [ -z "$https_test" ]; then
        echo "  ⏳ Connection timeout or DNS issue"
        echo ""
        return 1  # Not ready yet
    else
        echo "  ⏳ HTTPS returned HTTP $https_test (not ready yet)"
        echo ""
        return 1  # Not ready yet
    fi
}

# Main loop
attempt=1
echo "🚀 Starting HTTPS monitoring for staging-4.dial.wtf"
echo "   Checking every 15 minutes..."
echo "   Maximum attempts: $MAX_ATTEMPTS (12 hours)"
echo "   Press Ctrl+C to stop"
echo ""

while [ $attempt -le $MAX_ATTEMPTS ]; do
    check_status
    result=$?
    
    if [ $result -eq 0 ]; then
        echo ""
        echo "═══════════════════════════════════════════════════════════════"
        echo "🎉 SUCCESS! HTTPS is fully configured and working!"
        echo "═══════════════════════════════════════════════════════════════"
        echo ""
        echo "✅ HTTPS endpoint: https://staging-4.dial.wtf/.well-known/matrix/server"
        echo "✅ HTTPS enforcement: Enabled"
        echo ""
        echo "You can now retry the etke.cc installation check!"
        exit 0
        elif [ $result -eq 2 ]; then
        echo ""
        echo "⚠️  HTTPS is working but enforcement may need a bit more time"
        echo "   Will continue monitoring..."
    else
        echo ""
        echo "⏳ Still waiting for certificate provisioning..."
        echo "   Attempt $attempt of $MAX_ATTEMPTS"
    fi
    
    if [ $attempt -lt $MAX_ATTEMPTS ]; then
        echo ""
        echo "💤 Sleeping for 15 minutes..."
        next_time=$(date -v+15M '+%H:%M:%S' 2>/dev/null || date -d '+15 minutes' '+%H:%M:%S' 2>/dev/null || echo "15 minutes")
        echo "   Next check in 15 minutes (at $next_time)"
        sleep $INTERVAL
    fi
    
    attempt=$((attempt + 1))
done

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "⏰ Maximum attempts reached. HTTPS may still be provisioning."
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "Current status:"
gh api repos/Dial-WTF/matrix-wellknown-staging/pages | jq '{status, cname, https_enforced, https_certificate}'
echo ""
echo "You can run this script again later or check manually:"
echo "  ./check-https.sh"
exit 1

