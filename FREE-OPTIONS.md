# Free Hosting Options (Keep Your DNS at Dynadot)

## ✅ Good News: You Can Keep Your DNS at Dynadot!

All these services allow you to **keep your DNS at Dynadot** - you just add a CNAME record pointing to their service. You don't have to move your DNS to them.

## Free Options That Support Custom Headers

### 1. **Cloudflare Pages** (Recommended)
- ✅ **Free tier**: Unlimited sites, unlimited bandwidth
- ✅ **Keep DNS at Dynadot**: Just add CNAME `staging-4` → `[your-project].pages.dev`
- ✅ **Supports `_headers` file**: Automatically sets `Content-Type: application/json`
- ✅ **No vendor lock-in**: You own the domain, can move anytime
- ❌ **Minor**: Free tier requires Cloudflare account (but you don't have to use their DNS)

**Setup**: 
1. Create account at cloudflare.com (free)
2. Pages → Create project → Connect GitHub
3. Add custom domain: `staging-4.dial.wtf`
4. Cloudflare gives you a CNAME like `abc123.pages.dev`
5. In Dynadot: Add CNAME `staging-4` → `abc123.pages.dev`
6. Done! Your DNS stays at Dynadot.

### 2. **Netlify**
- ✅ **Free tier**: 100 GB bandwidth/month, 300 build minutes/month
- ✅ **Keep DNS at Dynadot**: Just add CNAME `staging-4` → `[your-site].netlify.app`
- ✅ **Supports `_headers` file**: Automatically sets `Content-Type: application/json`
- ✅ **No vendor lock-in**: You own the domain, can move anytime

**Setup**:
1. Create account at netlify.com (free)
2. Add new site → Import from GitHub
3. Add custom domain: `staging-4.dial.wtf`
4. Netlify gives you a CNAME like `your-site.netlify.app`
5. In Dynadot: Add CNAME `staging-4` → `your-site.netlify.app`
6. Done! Your DNS stays at Dynadot.

### 3. **Vercel**
- ✅ **Free tier**: Still exists! (Hobby plan - 100 GB bandwidth/month)
- ✅ **Keep DNS at Dynadot**: Just add CNAME `staging-4` → `[your-project].vercel.app`
- ✅ **Supports `vercel.json` headers**: Can set `Content-Type: application/json`
- ✅ **No vendor lock-in**: You own the domain, can move anytime

**Setup**:
1. Create account at vercel.com (free)
2. Import project from GitHub
3. Add custom domain: `staging-4.dial.wtf`
4. Vercel gives you a CNAME like `your-project.vercel.app`
5. In Dynadot: Add CNAME `staging-4` → `your-project.vercel.app`
6. Done! Your DNS stays at Dynadot.

### 4. **Render**
- ✅ **Free tier**: 100 GB bandwidth/month
- ✅ **Keep DNS at Dynadot**: Just add CNAME
- ✅ **Supports custom headers**: Via `_headers` file
- ✅ **No vendor lock-in**: You own the domain, can move anytime

## Important: You DON'T Need to Move DNS!

All these services work with **external DNS**:
- You keep your DNS at Dynadot
- You just add a CNAME record pointing to their service
- They handle SSL certificates automatically
- If you want to leave, just change the CNAME

## Recommendation

**Cloudflare Pages** is the best choice because:
1. ✅ Truly unlimited on free tier (no bandwidth limits)
2. ✅ Supports `_headers` file (we already created it)
3. ✅ Fast global CDN
4. ✅ Free SSL automatically
5. ✅ You keep DNS at Dynadot (just add CNAME)

## Setup Steps for Cloudflare Pages

1. Go to https://dash.cloudflare.com → Sign up (free)
2. **Pages** → **Create a project** → **Connect to Git**
3. Select GitHub → Authorize → Choose `matrix-wellknown-staging`
4. Build settings:
   - Framework preset: **None**
   - Build command: (leave empty)
   - Build output directory: `/`
5. Click **Save and Deploy**
6. Wait for deployment (~2 minutes)
7. Go to **Custom domains** → **Set up a custom domain**
8. Enter: `staging-4.dial.wtf`
9. Cloudflare will show you a CNAME like: `matrix-wellknown-staging.pages.dev`
10. In **Dynadot DNS**:
    - Remove old CNAME: `staging-4` → `Dial-WTF.github.io`
    - Add new CNAME: `staging-4` → `matrix-wellknown-staging.pages.dev`
11. Wait 5-30 minutes for DNS propagation
12. Done! The `_headers` file will automatically set `Content-Type: application/json`

## Verification

After DNS propagates:
```bash
curl -I https://staging-4.dial.wtf/.well-known/matrix/server | grep content-type
# Should show: content-type: application/json
```

## No Vendor Lock-In!

- ✅ Your domain stays registered at Dynadot
- ✅ Your DNS stays at Dynadot
- ✅ You just point a CNAME to their service
- ✅ If you want to leave, change the CNAME
- ✅ You own the domain, not them

