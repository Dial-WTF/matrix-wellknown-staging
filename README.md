# Matrix .well-known Files for staging-4.dial.wtf

This repository hosts the Matrix server delegation files required for `staging-4.dial.wtf`.

## Files

- `/.well-known/matrix/server` - Server delegation file
- `/.well-known/matrix/client` - Client discovery file

## Setup for GitHub Pages

1. Make this repository **public** (required for free GitHub Pages)
2. Go to Settings → Pages
3. Select source branch (usually `main`)
4. Configure custom domain: `staging-4.dial.wtf`
5. Add a DNS CNAME record pointing `staging-4.dial.wtf` to `[username].github.io`

## Verification

After deployment, verify the files are accessible:

```bash
curl https://staging-4.dial.wtf/.well-known/matrix/server
curl https://staging-4.dial.wtf/.well-known/matrix/client
```

Both should return valid JSON responses.

## Alternative: Cloudflare Pages / Netlify

If you prefer to keep the repo private:
- **Cloudflare Pages**: Can deploy from private GitHub repos
- **Netlify**: Can also deploy from private GitHub repos

Both services will serve the files publicly over HTTPS.

