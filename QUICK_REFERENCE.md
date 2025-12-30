# 🚀 Quick Reference Card - Render Deployment

## Problem Solved ✅

```
ERROR: pandas==2.1.3 fails on Python 3.13 with _PyLong_AsByteArray
STATUS: FIXED - Ready to deploy
```

---

## Files Changed

```
✅ backend/requirements.txt
   - pandas: 2.1.3 → 2.2.3
   - numpy: 1.24.3 → 1.26.4

✅ backend/render.yaml
   - runtime: python-3.10 → python-3.11
   - build: added --no-build-isolation
```

---

## Deployment in 5 Minutes

### 1. Push Code (1 min)
```bash
git add .
git commit -m "Fix: Update dependencies for Render"
git push origin main
```

### 2. Create Database (2 min)
- Go to https://www.mongodb.com/cloud/atlas
- Create free cluster
- Get URI: `mongodb+srv://...`

### 3. Deploy (2 min)
- Go to https://render.com
- New → Web Service
- Select your repo
- Add env vars (see below)
- Deploy

---

## Required Environment Variables

```
MONGODB_URI               = mongodb+srv://user:pass@cluster.mongodb.net/
MONGODB_DB_NAME          = report_generator
SECRET_KEY               = (generate random string)
CORS_ORIGINS             = https://your-frontend-url.com
PYTHONUNBUFFERED         = 1
PORT                     = 8000
```

---

## Test Deployment

```bash
# Health check
curl https://your-service.onrender.com/docs

# Should show Swagger UI
```

---

## Common Issues

| Error | Solution |
|-------|----------|
| Build timeout | Wait 15+ min or upgrade |
| CORS error | Update CORS_ORIGINS env |
| DB connection fails | Check MongoDB URI |
| Service crashes | Check logs for errors |

---

## Documentation

- **[DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)** - Full instructions
- **[TROUBLESHOOTING.md](./TROUBLESHOOTING.md)** - Error solutions
- **[PROJECT_OVERVIEW.md](./PROJECT_OVERVIEW.md)** - Architecture

---

## Helper Commands

**Linux/Mac:**
```bash
bash deploy.sh check        # Verify setup
bash deploy.sh prepare      # Pre-flight check
bash deploy.sh deploy       # Show instructions
```

**Windows:**
```batch
deploy.bat check           # Verify setup
deploy.bat prepare         # Pre-flight check
deploy.bat deploy          # Show instructions
```

---

## Key URLs

- **Render**: https://render.com
- **MongoDB**: https://www.mongodb.com/cloud/atlas
- **Your API**: https://your-service.onrender.com/docs
- **Vercel** (frontend): https://vercel.com

---

## Status: READY FOR DEPLOYMENT ✅

No more errors. Everything is configured. Just deploy!
