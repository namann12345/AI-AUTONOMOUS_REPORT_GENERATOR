# Troubleshooting Guide - Render Deployment

## 🔴 Common Deployment Errors & Solutions

---

## 1. Pandas Build Error (FIXED ✓)

### Error Message
```
error: metadata-generation-failed for pandas==2.1.3
error: too few arguments to function '_PyLong_AsByteArray'
```

### Root Cause
- `pandas==2.1.3` is incompatible with Python 3.13
- `_PyLong_AsByteArray` API changed in Python 3.13

### Solution Applied
```
✓ Python: 3.13 → 3.11 (in render.yaml)
✓ pandas: 2.1.3 → 2.2.3 (in requirements.txt)
✓ numpy: 1.24.3 → 1.26.4 (in requirements.txt)
✓ Build command: Added --no-build-isolation flag
```

### How to Verify
1. Check `backend/render.yaml` has `runtime: python-3.11`
2. Check `backend/requirements.txt` has `pandas==2.2.3`
3. Rebuild on Render to confirm success

---

## 2. Build Times Out

### Error Message
```
Build step 'pip install' timed out
```

### Solutions

**Option 1: Increase Timeout** (Already done in render.yaml)
```yaml
startCommand: gunicorn -w 2 -k uvicorn.workers.UvicornWorker main:app --bind 0.0.0.0:$PORT --timeout 120
```

**Option 2: Reduce Dependencies**
- Remove unused packages from requirements.txt
- Combine build steps

**Option 3: Use Pre-built Wheels**
```
pip install --no-cache-dir --only-binary=:all: package_name
```

**Option 4: Upgrade Render Plan**
- Free tier has limited build time
- Consider upgrading to Starter/Pro

---

## 3. Service Crashes After Build

### Check Logs
1. Go to Render Dashboard
2. Select your service
3. Click **Logs** tab
4. Look for error messages

### Common Causes

**A. Missing Environment Variables**
```
KeyError: 'MONGODB_URI' not found
```

**Solution**:
1. Go to Environment tab
2. Add all required variables:
   - MONGODB_URI
   - MONGODB_DB_NAME
   - SECRET_KEY
   - CORS_ORIGINS

**B. MongoDB Connection Failed**
```
ConnectionFailure: [Errno 111] Connection refused
```

**Solution**:
1. Verify MONGODB_URI in environment variables
2. Check MongoDB Atlas IP whitelist
3. Ensure cluster is running

**C. Import Errors**
```
ModuleNotFoundError: No module named 'fastapi'
```

**Solution**:
1. Verify requirements.txt is in `/backend` directory
2. Check buildCommand uses correct path
3. Ensure all imports exist in requirements.txt

---

## 4. Cold Start Issues

### Problem
Service takes 30+ seconds to start after idle period

### Why It Happens
- Free tier spins down services after 15 min inactivity
- Startup requires rebuilding environment

### Solutions

**Option 1: Use Paid Tier**
- Starter tier ($7/month) keeps services warm
- Pro tier ($12/month) better performance

**Option 2: Keep-Alive Service**
- Use external uptime monitor
- Send ping request every 10 minutes
- Example services: UptimeRobot, Healthchecks.io

**Option 3: Optimize Startup**
```python
# In main.py, minimize imports at startup
import logging
logger = logging.getLogger(__name__)

# Lazy load heavy dependencies
def get_ai_agent():
    from ai_models.llama_agent import get_llama_agent
    return get_llama_agent()
```

---

## 5. CORS Errors

### Error Message
```
Access to XMLHttpRequest blocked by CORS policy
```

### Solution
Update `CORS_ORIGINS` environment variable:

```
CORS_ORIGINS=https://your-frontend-domain.vercel.app
```

### For Multiple Domains
```
CORS_ORIGINS=https://frontend1.com,https://frontend2.com,http://localhost:3000
```

### In Backend Code
Update `main.py`:
```python
allowed_origins = os.getenv("CORS_ORIGINS", "http://localhost:3000").split(",")

app.add_middleware(
    CORSMiddleware,
    allow_origins=allowed_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

---

## 6. Memory Issues

### Error Message
```
Process exceeded maximum memory limit
```

### Causes
- Large file uploads
- Memory leaks in code
- Inefficient data processing

### Solutions

**A. Limit File Size**
```python
from fastapi import UploadFile, File

@app.post("/upload")
async def upload_file(file: UploadFile = File(...)):
    # Check file size (limit to 50MB)
    contents = await file.read()
    if len(contents) > 50 * 1024 * 1024:
        raise HTTPException(status_code=413, detail="File too large")
    # Process file...
```

**B. Stream Large Files**
```python
async def process_large_file(file: UploadFile):
    async for chunk in file.file:
        # Process chunk by chunk
        process_chunk(chunk)
```

**C. Use Pagination**
```python
@app.get("/data")
async def get_data(skip: int = 0, limit: int = 100):
    # Return paginated results
    return data[skip:skip+limit]
```

---

## 7. Database Connection Issues

### Error Message
```
ServerSelectionTimeoutError: No suitable servers found
```

### Solutions

**1. Check MongoDB URI**
```
mongodb+srv://username:password@cluster.mongodb.net/database_name
```

**2. Whitelist Render IP**
- Go to MongoDB Atlas
- Security → Network Access
- Add Render's IP (or use 0.0.0.0/0 for testing)

**3. Verify Credentials**
```bash
# Test connection locally
python -c "from pymongo import MongoClient; client = MongoClient('your_uri'); print(client.server_info())"
```

**4. Check Connection Pooling**
```python
# In main.py
client = AsyncIOMotorClient(
    mongodb_uri,
    maxPoolSize=10,
    minPoolSize=1,
    serverSelectionTimeoutMS=5000
)
```

---

## 8. API 504 Gateway Timeout

### Problem
Requests timeout after 60 seconds

### Solutions

**A. Increase Timeout in render.yaml**
```yaml
startCommand: gunicorn -w 2 -k uvicorn.workers.UvicornWorker main:app --bind 0.0.0.0:$PORT --timeout 120
```

**B. Use Background Tasks for Long Operations**
```python
from fastapi import BackgroundTasks

@app.post("/analyze")
async def analyze_data(data: dict, background_tasks: BackgroundTasks):
    # Start analysis in background
    background_tasks.add_task(long_analysis_task, data)
    # Return immediately
    return {"status": "processing", "id": task_id}

@app.get("/result/{task_id}")
async def get_result(task_id: str):
    # Check if analysis is complete
    return result
```

**C. Implement WebSocket for Real-time Updates**
```python
from fastapi import WebSocket

@app.websocket("/ws/analyze")
async def websocket_analyze(websocket: WebSocket):
    await websocket.accept()
    # Stream results as they're computed
    for result in analyze_stream(data):
        await websocket.send_json(result)
```

---

## 9. High CPU Usage

### Problem
Service frequently restarts due to CPU limits

### Solutions

**1. Profile Your Code**
```python
import cProfile
import pstats

def profile_function():
    profiler = cProfile.Profile()
    profiler.enable()
    
    # Your code here
    
    profiler.disable()
    stats = pstats.Stats(profiler)
    stats.sort_stats('cumulative')
    stats.print_stats(10)
```

**2. Optimize Pandas Operations**
```python
# Bad
df = pd.read_csv('large_file.csv')
filtered = df[df['column'] > 100]

# Good
df = pd.read_csv('large_file.csv', dtype={...}, nrows=100000)
filtered = df.query('column > 100')
```

**3. Cache Results**
```python
from functools import lru_cache

@lru_cache(maxsize=128)
def expensive_computation(param):
    return result
```

**4. Upgrade Plan**
- Free tier: Limited CPU
- Starter: Better CPU allocation

---

## 10. File Upload Issues

### Problem
File uploads fail or are incomplete

### Solutions

```python
from fastapi import UploadFile, File, HTTPException
import shutil

@app.post("/upload")
async def upload_file(file: UploadFile = File(...)):
    try:
        # Save to temp location
        with open(f"/tmp/{file.filename}", "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
        
        # Validate file
        if not file.filename.endswith('.csv'):
            raise HTTPException(status_code=400, detail="Only CSV files allowed")
        
        # Process file
        df = pd.read_csv(f"/tmp/{file.filename}")
        
        return {"status": "success", "rows": len(df)}
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        await file.close()
```

---

## 11. Authentication Issues

### JWT Token Errors

```python
# Verify SECRET_KEY is set
SECRET_KEY = os.getenv("SECRET_KEY")
if not SECRET_KEY:
    raise ValueError("SECRET_KEY not set in environment")

# Use secure algorithm
ALGORITHM = "HS256"

def create_access_token(data: dict, expires_delta: timedelta = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(hours=24)
    
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt
```

---

## 12. Frontend Not Loading

### Problem
Frontend deployment fails or doesn't connect to backend

### Vercel Deployment

1. Set environment variables:
```
VITE_API_URL=https://your-render-service.onrender.com
VITE_API_TIMEOUT=30000
```

2. Update frontend client:
```javascript
// src/api/client.js
const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:8000'
const client = axios.create({ baseURL: apiUrl })
```

3. Add error handling:
```javascript
client.interceptors.response.use(
    response => response,
    error => {
        if (error.code === 'ECONNREFUSED') {
            console.error('Backend is down')
        }
        return Promise.reject(error)
    }
)
```

---

## 📋 Debugging Checklist

Use this checklist when troubleshooting:

- [ ] Check Render Logs tab (10+ lines)
- [ ] Verify environment variables are set
- [ ] Test MongoDB connection separately
- [ ] Validate requirements.txt syntax
- [ ] Check Python version compatibility
- [ ] Review buildCommand execution
- [ ] Test API endpoints with curl/Postman
- [ ] Check frontend CORS headers
- [ ] Verify JWT token validity
- [ ] Monitor memory and CPU usage

---

## 🔍 Useful Commands

### Test Locally
```bash
cd backend
python -m uvicorn main:app --reload --port 8000
```

### Build Like Render
```bash
pip install --upgrade pip setuptools wheel
pip install --no-cache-dir --no-build-isolation -r requirements.txt
```

### Test Import
```bash
python -c "import fastapi; import pandas; import motor; print('All imports OK')"
```

### Check Environment Variables
```bash
# Windows
set
# Linux/Mac
env | grep MONGODB
```

### Test MongoDB Connection
```python
from pymongo import MongoClient
client = MongoClient('your_mongodb_uri')
print(client.server_info())
```

---

## 📞 Getting Help

1. **Check Render Logs** - Most detailed information
2. **Review Error Message** - Usually points to issue
3. **Test Locally** - Reproduce issue in dev environment
4. **Search Online** - Include error message in search
5. **Contact Support**:
   - Render: https://render.com/support
   - MongoDB: https://www.mongodb.com/support
   - FastAPI: https://github.com/tiangolo/fastapi/issues

---

**Last Updated**: December 30, 2025

For more help, see `DEPLOYMENT_GUIDE.md` or `PROJECT_OVERVIEW.md`
