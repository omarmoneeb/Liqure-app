# PocketBase Setup Complete! 🎉

Your PocketBase instance is now running with all the required collections for the Liquor Journal app.

## Quick Start

### Access Points
- **Admin Dashboard**: http://localhost:8090/_/
- **API Base URL**: http://localhost:8090/api/
- **Health Check**: http://localhost:8090/api/health

### Admin Credentials
- **Email**: admin@liquorjournal.app
- **Password**: liquorjournal123!

### Test User Credentials
- **Email**: test@liquorjournal.app
- **Password**: Test123!

## Collections Created

### 1. **drinks** 🥃
- `name` (text, required)
- `type` (select: whiskey, bourbon, scotch, vodka, gin, rum, tequila, mezcal, liqueur, wine, beer, cocktail, other)
- `abv` (number, 0-100)
- `country` (text)
- `barcode` (text) - for barcode scanning
- `image` (file) - product photo

### 2. **ingredients** 🍋
- `name` (text, required)
- `category` (select: spirit, mixer, garnish, syrup, juice, bitter, other)

### 3. **drink_ingredients** 🔗
- `drink` (relation to drinks)
- `ingredient` (relation to ingredients)
- `quantity` (text) - e.g., "2 oz", "1 dash"

### 4. **ratings** ⭐
- `user` (relation to users)
- `drink` (relation to drinks)
- `score` (number, 0-5)
- `note` (text, max 1000 chars)
- `photos` (file array, max 5)

### 5. **inventory** 📦
- `user` (relation to users)
- `drink` (relation to drinks)
- `quantity` (number)
- `price` (number)
- `purchaseDate` (date)

### 6. **badges** 🏆
- `user` (relation to users)
- `code` (text) - unique badge identifier
- `unlockedAt` (date)

## Docker Commands

### Start PocketBase
```bash
docker-compose -f infra/docker-compose.yml up -d
```

### Stop PocketBase
```bash
docker-compose -f infra/docker-compose.yml down
```

### View logs
```bash
docker-compose -f infra/docker-compose.yml logs -f pocketbase
```

### Backup database
```bash
docker cp infra-pocketbase-1:/pb/pb_data/data.db ./backup-$(date +%Y%m%d).db
```

## Next Steps

1. **Configure OAuth (Optional)**
   - Go to Settings → Auth providers in admin dashboard
   - Enable Google OAuth for social login

2. **Set up Email (Optional)**
   - Go to Settings → Mail settings
   - Configure SMTP for password resets

3. **Start Flutter Development**
   - Update your Flutter app's API URL to `http://localhost:8090`
   - Use the PocketBase Dart SDK for authentication and data operations

4. **Production Deployment**
   - Update environment variables in `.env`
   - Configure SSL/TLS for HTTPS
   - Set up automated backups
   - Enable rate limiting

## Sample API Calls

### Get all drinks
```bash
curl http://localhost:8090/api/collections/drinks/records
```

### Search drinks by name
```bash
curl "http://localhost:8090/api/collections/drinks/records?filter=(name~'whiskey')"
```

### Get user's ratings (requires auth)
```bash
curl http://localhost:8090/api/collections/ratings/records \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN"
```

## Troubleshooting

- **Container not starting**: Check logs with `docker-compose logs`
- **Port already in use**: Change port in docker-compose.yml
- **Database locked**: Restart the container
- **Collections not showing**: Refresh the admin dashboard

---

Happy coding! 🚀 Your PocketBase backend is ready for the Liquor Journal app.