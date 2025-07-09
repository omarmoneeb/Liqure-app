.PHONY: help setup backend frontend docker clean test

# Default target
help:
	@echo "Liquor Journal Development Commands"
	@echo "=================================="
	@echo "make setup       - Initial project setup"
	@echo "make backend     - Start PocketBase server"
	@echo "make frontend    - Start Flutter app"
	@echo "make docker      - Run with Docker Compose"
	@echo "make test        - Run all tests"
	@echo "make clean       - Clean build artifacts"

# Setup development environment
setup:
	@echo "Setting up Liquor Journal development environment..."
	@cp infra/.env.example infra/.env
	@echo "✓ Environment file created"
	@cd app && flutter pub get
	@echo "✓ Flutter dependencies installed"
	@echo "Setup complete! Edit infra/.env with your settings"

# Backend commands
backend:
	@cd pb && ./pocketbase serve --http 127.0.0.1:8090

backend-migrate:
	@cd pb && ./pocketbase migrate up

# Frontend commands
frontend:
	@cd app && flutter run

frontend-build-android:
	@cd app && flutter build apk --release

frontend-build-ios:
	@cd app && flutter build ios --release

# Docker commands
docker:
	@docker-compose -f infra/docker-compose.yml up

docker-build:
	@docker-compose -f infra/docker-compose.yml build

docker-down:
	@docker-compose -f infra/docker-compose.yml down

# Testing
test:
	@cd app && flutter test

test-integration:
	@cd app && flutter test integration_test

# Cleaning
clean:
	@cd app && flutter clean
	@find . -name "*.log" -delete
	@echo "✓ Cleaned build artifacts"