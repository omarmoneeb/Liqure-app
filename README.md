# Liquor Journal

A Flutter-based mobile application for tracking and rating spirits, cocktails, and other beverages with PocketBase backend.

## 🏗️ Monorepo Structure

```
/liquor_journal
 ├─ /app/            # Flutter mobile application
 ├─ /pb/             # PocketBase backend server
 │   ├─ pb_data/     # SQLite database (gitignored)
 │   └─ migrations/  # Database migrations
 └─ /infra/          # Docker, CI/CD, and deployment configs
```

## 🚀 Quick Start

### Prerequisites
- Flutter SDK ≥ 3.22
- PocketBase v0.28+
- Docker & Docker Compose
- Node.js LTS (for tooling)

### Development Setup

1. **Backend (PocketBase)**
   ```bash
   cd pb
   ./pocketbase serve --http 127.0.0.1:8090
   ```

2. **Frontend (Flutter)**
   ```bash
   cd app
   flutter pub get
   flutter run
   ```

3. **Docker Development**
   ```bash
   docker-compose up
   ```

## 📱 Features

- 📷 Barcode scanning for quick drink identification
- ⭐ Rating system with photos and notes
- 📊 Personal analytics and taste profiles
- 🏆 Gamification with badges and achievements
- 💾 Offline-first architecture with sync
- 🔍 Advanced search and filtering
- 📦 Inventory management
- 🎤 Voice notes with speech-to-text

## 🛠️ Tech Stack

- **Frontend**: Flutter, Riverpod, GoRouter, Floor
- **Backend**: PocketBase (Go)
- **Database**: SQLite (local + server)
- **ML**: Google ML Kit for barcode scanning
- **Deployment**: Docker, AWS ECS

## 📖 Documentation

See `/docs` for detailed documentation:
- [Architecture](./docs/architecture.md)
- [API Documentation](./docs/api.md)
- [Development Guide](./docs/development.md)
- [Deployment Guide](./docs/deployment.md)

## 📄 License

MIT License - see [LICENSE](./LICENSE) file