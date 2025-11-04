# Vercel Setup Guide

## Quick Setup Steps

### 1. Create Vercel Account

1. Go to https://vercel.com
2. Click **Sign Up** (free)
3. Sign up with GitHub (recommended)

### 2. Import Project

1. In Vercel dashboard, click **Add New...** → **Project**
2. Import from GitHub repository: `Dial-WTF/matrix-wellknown-staging`
3. Configure:
   - **Framework Preset**: Other
   - **Build Command**: (leave empty - no build needed)
   - **Output Directory**: (leave empty - files are at root)
4. Click **Deploy**

### 3. Add Custom Domain

1. After deployment completes, go to your project
2. Click **Settings** → **Domains**
3. Add domain: `staging-4.dial.wtf`
4. Vercel will show you DNS instructions

### 4. Update DNS in Dynadot

Vercel will give you a CNAME record. In Dynadot:

1. Remove old CNAME: `staging-4` → `Dial-WTF.github.io`
2. Add new CNAME: `staging-4` → `[vercel-provided-url].vercel.app`
   - Vercel will show the exact value in the domain settings

### 5. Wait for DNS Propagation

- Usually takes 5-30 minutes
- Vercel will automatically provision SSL certificate

### 6. Verify

After DNS propagates:

```bash
# Check redirects (should show 301 redirect)
curl -I https://staging-4.dial.wtf/.well-known/matrix/server
# Should show: HTTP/2 301 and Location: https://matrix.staging-4.dial.wtf/.well-known/matrix/server

# Follow redirect and check content
curl -L https://staging-4.dial.wtf/.well-known/matrix/server
curl -L https://staging-4.dial.wtf/.well-known/matrix/client
```

## What's Configured

The `vercel.json` file automatically redirects:
- ✅ `/.well-known/matrix/server` → `https://matrix.staging-4.dial.wtf/.well-known/matrix/server`
- ✅ `/.well-known/matrix/client` → `https://matrix.staging-4.dial.wtf/.well-known/matrix/client`
- ✅ `/.well-known/matrix/support` → `https://matrix.staging-4.dial.wtf/.well-known/matrix/support`

These are permanent (301) redirects, which is what etke.cc requires for Matrix server delegation.

## Vercel Free Tier Limits

- ✅ 100 GB bandwidth/month
- ✅ Unlimited requests
- ✅ Free SSL certificates
- ✅ Custom domains supported
- ✅ Keep DNS at Dynadot (just CNAME)

## Troubleshooting

If redirects don't work:
1. Check that `vercel.json` is committed to the repo
2. Redeploy in Vercel dashboard (redirects need redeploy to take effect)
3. Verify redirects with: `curl -I https://staging-4.dial.wtf/.well-known/matrix/server`
4. Should show `HTTP/2 301` and `Location: https://matrix.staging-4.dial.wtf/.well-known/matrix/server`

If domain doesn't work:
1. Wait 30+ minutes for DNS propagation
2. Check CNAME in Dynadot matches Vercel's instructions
3. Verify in Vercel dashboard that domain shows "Valid Configuration"

**Important**: Make sure your Matrix server at `matrix.staging-4.dial.wtf` is serving the `.well-known/matrix/*` files correctly, as the redirects point to it.

