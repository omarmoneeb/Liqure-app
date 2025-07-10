# Security Setup

## ⚠️ IMMEDIATE ACTION REQUIRED

If you're setting up this project for the first time, you MUST create secure credentials:

### 1. Create Environment File
```bash
cp infra/.env.example infra/.env
```

### 2. Set Secure Credentials
Edit `infra/.env` and replace the placeholder values:

```bash
# Replace with your own secure credentials
PB_ADMIN_EMAIL=your-secure-email@example.com
PB_ADMIN_PASSWORD=your-very-secure-password-123!
```

### 3. Verify Security
- ✅ Never commit `.env` files (already in .gitignore)
- ✅ Use strong passwords (12+ characters, mixed case, numbers, symbols)
- ✅ Use a unique email address for admin access
- ✅ Rotate credentials regularly in production

## 🔒 What Was Fixed

**Previous Issue**: Admin credentials were hardcoded in:
- `docker-compose.yml` 
- `setup_collections.sh`
- `seed_data.sh`

**Security Risk**: Anyone with repository access could use these credentials.

**Solution**: All credentials are now environment variables that you control.

## 📋 Environment Variables Required

| Variable | Description | Example |
|----------|-------------|---------|
| `PB_ADMIN_EMAIL` | PocketBase admin email | `admin@yourapp.com` |
| `PB_ADMIN_PASSWORD` | PocketBase admin password | `SecurePass123!` |

## 🚀 Quick Start After Security Setup

```bash
# 1. Create and configure environment
cp infra/.env.example infra/.env
# Edit infra/.env with secure credentials

# 2. Start with Docker
cd infra
docker-compose up -d

# 3. Setup collections (first time only)
cd ../pb
./setup_collections.sh

# 4. Add seed data (optional)
./seed_data.sh
```

## 🛡️ Production Security

For production deployments:
- Use secrets management (AWS Secrets Manager, Azure Key Vault, etc.)
- Enable HTTPS/TLS
- Configure proper firewall rules
- Regular security audits
- Monitor access logs