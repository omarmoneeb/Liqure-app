# PocketBase Backend

This directory contains the PocketBase backend server for Liquor Journal.

## Setup

1. Download PocketBase binary for your platform:
   ```bash
   # macOS/Linux
   curl -L https://github.com/pocketbase/pocketbase/releases/latest/download/pocketbase_darwin_amd64.zip -o pb.zip
   unzip pb.zip
   
   # Make executable
   chmod +x pocketbase
   ```

2. Start the server:
   ```bash
   ./pocketbase serve --http 127.0.0.1:8090
   ```

3. Access admin dashboard at `http://127.0.0.1:8090/_/`

## Collections Schema

- **users** - Built-in user authentication
- **drinks** - Spirits and cocktails database
- **ingredients** - Ingredient catalog
- **drink_ingredients** - Many-to-many relationships
- **ratings** - User ratings and reviews
- **inventory** - Personal collection tracking
- **badges** - Gamification achievements

## Migrations

Database migrations are stored in `/migrations` and applied automatically on server start.

To create a new migration:
```bash
./pocketbase migrate create "description_of_change"
```

## Development

The `pb_data` directory is gitignored and contains:
- SQLite database file
- Uploaded files
- Logs

## Production

See `/infra` for Docker deployment configuration.