# AI Autonomous Report Generator - Deployment Guide

## 🚀 Quick Start Deployment on Render

This guide will help you successfully deploy the AI Autonomous Report Generator on Render.com.

---

## 📋 Prerequisites

Before deployment, ensure you have:

1. **GitHub Account** - Repository pushed to GitHub
2. **Render.com Account** - Free account available at https://render.com
3. **MongoDB Atlas Account** - Free tier available at https://www.mongodb.com/cloud/atlas
4. **Environment Variables** - Listed below

---

## 🔑 Environment Variables Setup

### Backend (FastAPI) Environment Variables

Create these environment variables on Render Dashboard:

```
SECRET_KEY=your-secret-key-here (generate a random string)
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/
MONGODB_DB_NAME=report_generator
PYTHONUNBUFFERED=1
CORS_ORIGINS=https://your-frontend-url.vercel.app
PORT=8000
```

### How to Set Environment Variables on Render:

1. Go to your service dashboard
2. Navigate to **Environment** tab
3. Add each variable as a key-value pair
4. Click "Save"

---

## 📦 What Was Fixed (Deployment Error Resolution)

### Problem
The original deployment failed with:
```
error: metadata-generation-failed for pandas==2.1.3
_PyLong_AsByteArray signature mismatch with Python 3.13.4
```

### Root Cause
- **pandas 2.1.3** is incompatible with **Python 3.13**
- Python 3.13 changed internal API signatures

### Solution Applied
1. **Downgraded Python Runtime** from 3.13 to **3.11** (Render default)
2. **Updated Dependencies**:
   - `pandas==2.2.3` (compatible with Python 3.11)
   - `numpy==1.26.4` (compatible with Python 3.11)
3. **Optimized Build Command** with `--no-build-isolation` flag

---

## 🔧 Step-by-Step Deployment Instructions

### Step 1: Prepare Your Repository

```bash
cd AI-AUTONOMOUS_REPORT_GENERATOR
git add .
git commit -m "Fix deployment: Update pandas version and Python runtime"
git push origin main
```

### Step 2: Update Render.yaml (Already Done)

The `backend/render.yaml` has been updated with:
```yaml
runtime: python-3.11
buildCommand: pip install --upgrade pip setuptools wheel && pip install --no-cache-dir --no-build-isolation -r requirements.txt
startCommand: gunicorn -w 2 -k uvicorn.workers.UvicornWorker main:app --bind 0.0.0.0:$PORT --timeout 120
```

### Step 3: Create MongoDB Atlas Database

1. Go to https://www.mongodb.com/cloud/atlas
2. Create a free cluster
3. Get connection string: `mongodb+srv://user:password@cluster.mongodb.net/`
4. Save this as `MONGODB_URI` environment variable

### Step 4: Deploy on Render

#### Option A: Using Render Dashboard (Recommended)

1. Go to https://render.com
2. Click **"New +"** → **"Web Service"**
3. Select **"Deploy existing repository"**
4. Choose your GitHub repo: `AI-AUTONOMOUS_REPORT_GENERATOR`
5. Configure:
   - **Name**: `autonomous-report-backend`
   - **Root Directory**: `backend`
   - **Environment**: Python
   - **Build Command**: (use from render.yaml)
   - **Start Command**: (use from render.yaml)
   - **Instance Type**: Free (for testing)
6. Add environment variables
7. Click **"Deploy"**

#### Option B: Using Infrastructure as Code (render.yaml)

Render.yaml already configured. Just push to GitHub and Render will auto-detect it.

### Step 5: Monitor Deployment

1. Go to **Logs** tab in Render dashboard
2. Watch for successful build completion
3. Check for "Service is live at" message
4. Note your service URL (e.g., `https://autonomous-report-backend.onrender.com`)

---

## ✅ Verification Checklist

After deployment, verify:

- [ ] Build completes without errors
- [ ] Service is showing as "Live" (green)
- [ ] Check health endpoint:
  ```bash
  curl https://your-service-url.onrender.com/docs
  ```
- [ ] MongoDB connection is working
- [ ] All environment variables are set

---

## 🐛 Troubleshooting

### Build Fails with Pandas Error
**Solution**: Ensure Python 3.11+ is set (already fixed in render.yaml)

### Service Crashes After Deploy
**Check logs**:
```
1. Go to Logs tab
2. Look for errors in PYTHONUNBUFFERED output
3. Check MongoDB connection string
```

### Cold Start Timeout
**Solution**: Increase timeout in render.yaml to 120 seconds (already done)

### CORS Origin Error
**Update environment variable**:
```
CORS_ORIGINS=https://your-actual-frontend-url.vercel.app
```

---

## 📱 Frontend Deployment (Vercel)

For the React/Vite frontend:

1. Push to GitHub (separate repo or same repo in `/frontend`)
2. Go to https://vercel.com
3. Import project
4. Configure build:
   - **Framework**: Vite
   - **Build Command**: `npm run build`
   - **Output Directory**: `dist`
5. Add environment variable:
   ```
   VITE_API_URL=https://your-backend-url.onrender.com
   ```

---

## 🚨 Important Notes

1. **Free Tier Limitations**:
   - Services spin down after 15 minutes of inactivity
   - Limited to 750 hours per month
   - Consider upgrading for production

2. **MongoDB**:
   - Free Atlas cluster has limitations
   - Good for development/testing
   - Upgrade for production use

3. **Python Version**:
   - Currently set to **3.11**
   - Change in render.yaml if needed
   - Ensure dependencies support chosen version

4. **Security**:
   - Never commit secrets to git
   - Use Render environment variables for all secrets
   - Rotate `SECRET_KEY` regularly

---

## 📚 Additional Resources

- [Render Python Deployment Guide](https://render.com/docs/deploy-python)
- [MongoDB Atlas Documentation](https://docs.mongodb.com/manual/)
- [FastAPI Deployment Guide](https://fastapi.tiangolo.com/deployment/concepts/)
- [Gunicorn Configuration](https://docs.gunicorn.org/en/stable/settings.html)

---

## 🎯 Summary of Changes Made

### Files Modified:
1. ✅ `backend/requirements.txt` - Updated pandas and numpy versions
2. ✅ `backend/render.yaml` - Set Python 3.11, optimized build command

### Dependencies Updated:
- `pandas==2.1.3` → `pandas==2.2.3`
- `numpy==1.24.3` → `numpy==1.26.4`

### Runtime:
- `python-3.10` → `python-3.11`

---

**Last Updated**: December 30, 2025

For questions or issues, check Render documentation or create an issue on GitHub.
