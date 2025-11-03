# Matrix .well-known Files for staging-4.dial.wtf

This repository hosts the Matrix server delegation files required for `staging-4.dial.wtf`.

## Files

- `/.well-known/matrix/server` - Server delegation file
- `/.well-known/matrix/client` - Client discovery file

## Deployment

This repository is configured for **Cloudflare Pages** (recommended) or **Netlify** to ensure proper `Content-Type: application/json` headers.

### Why not GitHub Pages?
GitHub Pages serves files without extensions as `application/octet-stream` (binary), which causes Matrix clients to fail validation. Cloudflare Pages and Netlify support custom headers via `_headers` file.

### Cloudflare Pages Setup

1. Connect this GitHub repository to Cloudflare Pages
2. Configure build settings:
   - Build command: (leave empty)
   - Build output directory: `/`
3. Add custom domain: `staging-4.dial.wtf`
4. The `_headers` file will automatically set `Content-Type: application/json`

### Netlify Setup

1. Connect this GitHub repository to Netlify
2. Configure build settings:
   - Build command: (leave empty)
   - Publish directory: `/`
3. Add custom domain: `staging-4.dial.wtf`
4. The `_headers` file will automatically set `Content-Type: application/json`

## Verification

After deployment, verify the files are accessible with correct content type:

```bash
curl -I https://staging-4.dial.wtf/.well-known/matrix/server
# Should show: Content-Type: application/json

curl https://staging-4.dial.wtf/.well-known/matrix/server
curl https://staging-4.dial.wtf/.well-known/matrix/client
```

Both should return valid JSON responses with `Content-Type: application/json`.
