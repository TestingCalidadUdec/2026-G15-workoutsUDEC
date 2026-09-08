# 🏋️‍♂️ Workout Tracker - Full Stack Application

A full-stack workout tracking application that helps users manage their fitness journey with detailed workout logging, exercise management, and progress tracking. 

## 🌟 Overview

This application consists of FastAPI backend with a React TypeScript frontend, providing a complete solution for personal fitness tracking and gym management.

### ✨ Key Features

**👤 For Users:**
- 🔐 Secure authentication and profile management
- 🏃‍♂️ Interactive workout session tracking
- 📊 Detailed exercise logging with sets, reps, weights, and duration
- 📈 Workout history
- 📝 Workout and exercise notes
- 📋 Pre-built workout templates
- 📱 Responsive design for mobile and desktop

**👨‍💼 For Administrators:**
- 👥 Complete user management system
- 💪 Exercise database administration
- 📋 Workout template creation and management
- 🛡️ Role-based access control

## 🏗️ Architecture

### Technology Stack

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Backend** | FastAPI + SQLAlchemy | REST API with ORM database access |
| **Frontend** | React 19 + TypeScript | Modern SPA with type safety |
| **Database** | PostgreSQL | Reliable relational data storage |
| **Styling** | Tailwind CSS 4.x | Utility-first responsive design |
| **Authentication** | JWT Tokens | Secure stateless authentication |
| **Build Tools** | Vite + ESLint | Fast development and quality assurance |


## 🚀 Quick Start

### With Docker (recommended)

Requires Docker and Docker Compose.

```bash
cp .env.example .env
docker compose up -d --build
```

- Frontend: http://localhost:3000
- Backend / Swagger: http://localhost:8080/docs
- The admin account (`admin@example.com` / `admin123`) is created automatically on first boot.

Services: `frontend` (nginx serving the React build, reverse-proxying `/api` to the backend), `backend` (FastAPI + Uvicorn), `database` (PostgreSQL with a persistent `db_data` volume). All three have a `healthcheck`, and `backend`/`frontend` wait (`depends_on: condition: service_healthy`) for their dependency to actually be ready, not just started.

Useful commands:
```bash
docker compose logs -f            # logs for all services
docker compose ps                 # status / health of each container
docker compose down               # stop (data persists in the volume)
docker compose down -v            # stop and also wipe the data
docker compose up -d --build      # rebuild after changing code or a Dockerfile
```

See `EXPLICACION_DOCKER.md` for the full breakdown of how the containerization is put together and why.

### Without Docker

Check the README in `workouts_udec_backend` and `workouts_udec_frontend`.