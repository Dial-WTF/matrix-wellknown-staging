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
# Check Content-Type header
curl -I https://staging-4.dial.wtf/.well-known/matrix/server | grep -i content-type
# Should show: content-type: application/json

# Test endpoints
curl https://staging-4.dial.wtf/.well-known/matrix/server
curl https://staging-4.dial.wtf/.well-known/matrix/client
```

## What's Configured

The `vercel.json` file automatically sets:
- ✅ `Content-Type: application/json` for both files
- ✅ `Access-Control-Allow-Origin: *` for CORS
- ✅ Proper headers via Vercel's headers configuration

## Vercel Free Tier Limits

- ✅ 100 GB bandwidth/month
- ✅ Unlimited requests
- ✅ Free SSL certificates
- ✅ Custom domains supported
- ✅ Keep DNS at Dynadot (just CNAME)

## Troubleshooting

If Content-Type is still wrong:
1. Check that `vercel.json` is committed to the repo
2. Redeploy in Vercel dashboard
3. Clear browser cache

If domain doesn't work:
1. Wait 30+ minutes for DNS propagation
2. Check CNAME in Dynadot matches Vercel's instructions
3. Verify in Vercel dashboard that domain shows "Valid Configuration"

