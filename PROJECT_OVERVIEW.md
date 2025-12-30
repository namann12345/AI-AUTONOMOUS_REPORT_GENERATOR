# 🤖 AI Autonomous Report Generator - Project Overview

## 📊 Project Description

The **AI Autonomous Report Generator** is a full-stack web application that automatically analyzes data (CSV files, databases) and generates comprehensive business reports using AI agents. It combines a React frontend with a FastAPI backend and integrates with AI models for intelligent data analysis.

### Key Features:
- 📈 Automated data analysis and report generation
- 🔐 JWT-based authentication
- 🗄️ MongoDB database integration
- 🤖 Multiple AI agents (Llama, OpenAI, Groq)
- 📊 CSV data processing and analysis
- 📄 PDF report generation
- 🔄 Async/await support for long-running operations
- 🎨 Modern React UI with Tailwind CSS

---

## 🏗️ Project Architecture

### Frontend (React + Vite)
```
frontend/
├── src/
│   ├── components/          # React components
│   │   ├── AIAssistant.jsx
│   │   ├── Dashboard.jsx
│   │   ├── Departments.jsx
│   │   ├── Navbar.jsx
│   │   ├── Reports.jsx
│   │   ├── Settings.jsx
│   │   ├── Sidebar.jsx
│   │   └── SignUp.jsx
│   ├── services/            # API service layer
│   │   ├── aiAnalysisAgent.js
│   │   ├── aiReportService.js
│   │   ├── AIAgentReportViewer.js
│   │   └── llamaService.js
│   ├── contexts/            # React contexts
│   │   └── AuthContext.jsx
│   ├── api/                 # API client setup
│   │   └── client.js
│   ├── App.jsx              # Main app component
│   ├── main.jsx             # React entry point
│   └── index.css            # Global styles
├── public/                  # Static assets
├── package.json             # Dependencies
├── vite.config.js           # Vite configuration
├── tailwind.config.js       # Tailwind CSS configuration
└── postcss.config.js        # PostCSS configuration
```

### Backend (FastAPI + Python)
```
backend/
├── app/
│   └── ai_agents/
│       └── csv_analysis_agent.py    # CSV data analysis agent
├── ai_models/
│   ├── llama_agent.py               # Llama AI model integration
│   └── analysis_agent.py            # Analysis agent
├── main.py                          # FastAPI application
├── requirements.txt                 # Python dependencies
├── render.yaml                      # Render.com deployment config
├── test_backend.py                  # Backend tests
├── test_imports.py                  # Import validation tests
└── test_llama.py                    # Llama model tests
```

---

## 🛠️ Technology Stack

### Frontend
- **React 18.3** - UI library
- **Vite** - Build tool (lightning-fast)
- **Tailwind CSS** - Utility-first CSS framework
- **Axios** - HTTP client
- **Recharts** - Data visualization
- **Lucide React** - Icon library

### Backend
- **FastAPI 0.104.1** - Modern Python web framework
- **Uvicorn 0.24.0** - ASGI server
- **Gunicorn 21.2.0** - Production HTTP server
- **Pydantic 2.5.0** - Data validation
- **Motor 3.3.2** - Async MongoDB driver
- **PyMongo 4.5.0** - MongoDB client
- **Pandas 2.2.3** - Data analysis
- **scikit-learn** - Machine learning
- **ReportLab** - PDF generation

### Database
- **MongoDB Atlas** - NoSQL database (cloud)

### AI/ML Services
- **OpenAI API** - GPT models
- **Groq API** - Llama models
- **Llama 2** - Local LLM capability

### Deployment
- **Render.com** - Backend hosting
- **Vercel** - Frontend hosting (optional)
- **Docker** - Containerization support

---

## ✨ Key Functionality

### 1. Authentication System
- User registration and login
- JWT token-based authentication
- Password hashing with bcrypt
- CORS security headers

### 2. Data Processing
- CSV file upload and parsing
- Pandas DataFrame analysis
- Data validation and transformation
- Multiple data format support

### 3. AI Analysis
- Multiple AI agent options:
  - **Llama Agent** - Local or API-based
  - **OpenAI Agent** - GPT-3.5/4 models
  - **Groq Agent** - High-speed inference
- CSV-specific analysis agent
- Natural language query processing
- Context-aware responses

### 4. Report Generation
- Automated report creation from analysis
- PDF export capability
- Customizable report templates
- Multiple output formats

### 5. API Endpoints
- `/auth/register` - User registration
- `/auth/login` - User login
- `/api/upload` - File upload
- `/api/analyze` - Data analysis
- `/api/reports` - Report management
- `/api/ai-agents` - AI agent interaction

---

## 🚀 Deployment Status

### ✅ Fixed Issues

**Deployment Error**: `pandas==2.1.3` incompatibility with Python 3.13

**Resolution**:
- Downgraded Python runtime: `python-3.13` → `python-3.11`
- Updated pandas: `2.1.3` → `2.2.3`
- Updated numpy: `1.24.3` → `1.26.4`
- Enhanced build command with `--no-build-isolation` flag

### 📋 Deployment Requirements

**Backend (Render)**:
- Runtime: Python 3.11
- Build time: ~10-15 minutes
- Memory: 512MB (free tier)
- Cold start: Yes (spins down after 15 min inactivity)

**Frontend (Vercel)**:
- Build: `npm run build`
- Output: `/dist`
- Deploy time: ~2-5 minutes

---

## 🔧 Configuration Files

### render.yaml
```yaml
runtime: python-3.11
buildCommand: pip install --upgrade pip setuptools wheel && pip install --no-cache-dir --no-build-isolation -r requirements.txt
startCommand: gunicorn -w 2 -k uvicorn.workers.UvicornWorker main:app --bind 0.0.0.0:$PORT
```

### Environment Variables Required
```
# Backend
MONGODB_URI=mongodb+srv://user:pass@cluster.mongodb.net/
MONGODB_DB_NAME=report_generator
SECRET_KEY=your-secret-key
CORS_ORIGINS=https://your-frontend-url
PYTHONUNBUFFERED=1
PORT=8000

# AI Services
OPENAI_API_KEY=sk-...
GROQ_API_KEY=...
LLAMA_MODEL_PATH=/path/to/model
```

---

## 📦 Dependencies Breakdown

### Core Web Framework
- FastAPI, Uvicorn, Gunicorn, Starlette

### Authentication & Security
- python-jose, passlib, bcrypt, cryptography

### Async & File Handling
- aiofiles, python-multipart, Motor (async MongoDB)

### Data Processing
- pandas, numpy, openpyxl, scikit-learn

### API & HTTP
- requests, httpx, urllib3

### Utilities
- python-dotenv, jsonschema, colorama

---

## 🧪 Testing

### Run Backend Tests
```bash
cd backend
python -m pytest test_backend.py
python -m pytest test_imports.py
python -m pytest test_llama.py
```

### Run Local Development
```bash
# Backend
cd backend
pip install -r requirements.txt
python -m uvicorn main:app --reload

# Frontend
cd frontend
npm install
npm run dev
```

---

## 📖 API Documentation

Once deployed, access interactive API docs at:
```
https://your-service-url.onrender.com/docs
```

This provides Swagger UI with:
- All available endpoints
- Request/response schemas
- Try-it-out functionality
- Authentication setup

---

## 🔐 Security Considerations

1. **Never commit secrets** to git
2. **Use environment variables** for all sensitive data
3. **Rotate SECRET_KEY** regularly
4. **MongoDB credentials** stored securely
5. **CORS configuration** restricted to frontend domain
6. **JWT tokens** with expiration time
7. **HTTPS enforcement** on production

---

## 📈 Performance Optimization

- Async/await for non-blocking I/O
- Connection pooling for MongoDB
- Gunicorn worker processes (2x)
- Uvicorn worker class for FastAPI
- 120-second timeout for long operations
- Pandas optimization for large datasets

---

## 🐛 Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| Build fails: pandas error | Python 3.11+ required (fixed in render.yaml) |
| Service timeout | Increase timeout in startCommand (done) |
| CORS errors | Update CORS_ORIGINS env var |
| MongoDB connection fails | Verify MONGODB_URI in env vars |
| Cold start issues | Use paid tier on Render |
| AI model errors | Check API keys and model availability |

---

## 📚 Documentation Files

- **DEPLOYMENT_GUIDE.md** - Step-by-step deployment instructions
- **BUILD_REPORT.md** - Build configuration details
- **DEPLOY_NOW.md** - Quick deployment checklist
- **RENDER_DEPLOYMENT.md** - Render-specific setup

---

## 🎯 Next Steps

1. ✅ Update dependencies (DONE)
2. ✅ Fix Python version (DONE)
3. Push changes to GitHub
4. Deploy to Render
5. Configure MongoDB connection
6. Deploy frontend to Vercel
7. Test API endpoints
8. Set up monitoring and logging

---

## 📞 Support & Resources

- [Render Documentation](https://render.com/docs)
- [FastAPI Guide](https://fastapi.tiangolo.com)
- [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
- [React Documentation](https://react.dev)
- [Vite Guide](https://vitejs.dev)

---

**Last Updated**: December 30, 2025  
**Status**: ✅ Ready for Deployment

For deployment help, refer to `DEPLOYMENT_GUIDE.md`
