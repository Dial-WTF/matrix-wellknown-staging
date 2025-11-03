# Migration from GitHub Pages to Cloudflare Pages

## Why Migrate?

GitHub Pages serves files without extensions as `application/octet-stream` (binary), causing etke.cc to fail validation. Cloudflare Pages supports custom headers via `_headers` file, allowing us to set `Content-Type: application/json`.

## Steps to Migrate

### 1. Create Cloudflare Pages Site

1. Go to [Cloudflare Dashboard](https://dash.cloudflare.com)
2. Select your account
3. Go to **Pages** → **Create a project**
4. Choose **Connect to Git**
5. Select **GitHub** and authorize Cloudflare
6. Select repository: `Dial-WTF/matrix-wellknown-staging`
7. Configure build settings:
   - **Framework preset**: None
   - **Build command**: (leave empty)
   - **Build output directory**: `/`
8. Click **Save and Deploy**

### 2. Update DNS

Once Cloudflare Pages is deployed:

1. In Cloudflare Pages, go to your project → **Custom domains**
2. Add custom domain: `staging-4.dial.wtf`
3. Cloudflare will provide DNS instructions
4. Update your Dynadot DNS:
   - **Remove** the CNAME pointing to `Dial-WTF.github.io`
   - **Add** CNAME: `staging-4` → `[your-cloudflare-pages-url].pages.dev` (Cloudflare will provide this)

### 3. Disable GitHub Pages (Optional)

After Cloudflare Pages is working:
1. Go to GitHub repo → Settings → Pages
2. Remove custom domain `staging-4.dial.wtf`
3. (Optional) Disable GitHub Pages entirely

### 4. Verify

After DNS propagates (5-30 minutes):

```bash
# Check Content-Type header
curl -I https://staging-4.dial.wtf/.well-known/matrix/server | grep -i content-type
# Should show: Content-Type: application/json

# Test endpoints
curl https://staging-4.dial.wtf/.well-known/matrix/server
curl https://staging-4.dial.wtf/.well-known/matrix/client
```

Both should return JSON with `Content-Type: application/json`.

## Alternative: Netlify

If you prefer Netlify:

1. Go to [Netlify](https://app.netlify.com)
2. **Add new site** → **Import an existing project**
3. Connect GitHub and select `matrix-wellknown-staging`
4. Build settings:
   - Build command: (empty)
   - Publish directory: `/`
5. Add custom domain: `staging-4.dial.wtf`
6. Update DNS CNAME in Dynadot to point to Netlify's URL

The `_headers` file will work automatically on Netlify too.

