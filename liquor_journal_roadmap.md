# Liquor Journal – Flutter + PocketBase Build Roadmap

<!--
This document is meant to live in /docs/architecture.md (or similar) inside your repo.
It covers prerequisites, repo layout, backend & frontend setup, CI/CD, and a 12‑week timeline.
-->

## 0 · Prerequisites

| Tool                        | Version / note                             |
| --------------------------- | ------------------------------------------ |
| **Flutter SDK**             | ≥ 3.22 (stable)                            |
| **Dart SDK**                | ships with Flutter                         |
| **PocketBase CLI**          | v0.28+ binary                              |
| **Docker + Docker‑Compose** | containerisation / local dev               |
| **Git + GitHub CLI**        | source control & CI hooks                  |
| **Node LTS**                | only for Fastlane / Play Store automations |

---

## 1 · Repository Layout (`monorepo`)

```
/liquor_journal
 ├─ /app/            # Flutter code
 ├─ /pb/             # PocketBase instance + migrations
 │   ├ pb_data/      # SQLite file (volume‑mounted in prod)
 │   └ migrations/
 └─ /infra/          # Docker‑compose, CI, terraform (later)
```

---

## 2 · Backend (PocketBase)

1. **Bootstrap server**

   ```bash
   cd pb
   ./pocketbase serve --http 127.0.0.1:8090
   ```

2. **Create collections**

| Collection        | Fields (type)                                                                  | Access Rules                   |
| ----------------- | ------------------------------------------------------------------------------ | ------------------------------ |
| users (built‑in)  | username · email · avatar                                                      | —                              |
| drinks            | name (text) · type (enum) · abv (number) · country (text) · image (file)       | `read:*`, `write:@admin`       |
| ingredients       | name (text) · category (enum)                                                  | `read:*`                       |
| drink_ingredients | drink (rel) · ingredient (rel) · qty (text)                                    | `read:*`                       |
| ratings           | user (rel) · drink (rel) · score (number 0‑5) · note (text) · photos (file[])  | `read:@request.auth.id = user` |
| inventory         | user (rel) · drink (rel) · qty (number) · price (number) · purchaseDate (date) | same as ratings                |
| badges            | user (rel) · code (text) · unlockedAt (date)                                   | same as ratings                |

3. **Auth flows**

- Email + password (built‑in)
- OAuth Google (optional) – enable in _Settings → Auth Providers_

4. **Realtime**

Keep default WS endpoint `/api/realtime` for live sync.

5. **Migrations**

```bash
./pocketbase migrations create "init_schema"
```

Commit generated JSON into `/pb/migrations/`.

6. **Seed data**

Optional script that pulls TheCocktailDB and inserts base spirits/cocktails via REST.

7. **Production image (Docker)**

```Dockerfile
FROM alpine
COPY pocketbase /pb
COPY pb_data/ /pb/pb_data
EXPOSE 80
ENTRYPOINT ["/pb/pocketbase", "serve", "--http", ":80"]
```

Mount `pb_data` for backups.

---

## 3 · Flutter Project

### 3.1  Create & configure

```bash
flutter create app
cd app
flutter pub add   pocketbase riverpod flutter_riverpod   go_router   floor floor_generator build_runner   google_mlkit_barcode_scanning   speech_to_text   image_picker flutter_image_compress   connectivity_plus intl charts_flutter
```

- **PocketBase Dart SDK** – typed CRUD + realtime
- **ML Kit barcode** – offline scans
- **Floor** – on‑device SQLite ORM
- **Riverpod** – state management

Generate Floor code:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3.2  App architecture

```
lib/
 ├─ main.dart              # GoRouter & theme
 ├─ features/
 │   ├─ auth/
 │   ├─ tasting/
 │   ├─ scan/
 │   ├─ search/
 │   ├─ cabinet/
 │   ├─ social/
 │   └─ analytics/
 ├─ data/                  # DTOs, PB adapters
 ├─ local/                 # Floor DAOs + offline queue
 └─ shared/                # widgets, utils, themes
```

Use a clean “data → domain → presentation” layering per feature.

### 3.3  Core implementation steps

| Step                     | What to code                                                | Tips                               |
| ------------------------ | ----------------------------------------------------------- | ---------------------------------- |
| 1  Onboarding & Age Gate | Intro screens + flag in `SharedPreferences`                 | Mandatory for store approval       |
| 2  Auth                  | Email / Google sign‑in → PocketBase                         | Store token securely               |
| 3  Barcode scanner       | Camera → MLKit → `/drinks?filter=barcode=...`               | 404 opens _Add Drink_ draft        |
| 4  Add / Edit Drink      | Form with image picker, ingredient chips, ABV slider        | Upload to PB file field            |
| 5  Rate Drink            | Stars, note, photo                                          | Save offline first then push       |
| 6  Offline sync          | Riverpod `SyncController`; push Floor queue on connectivity |
| 7  Search & Filters      | Query builder → PB filter DSL                               | Save smart lists (Pro = unlimited) |
| 8  Cabinet & Inventory   | Grouped list, decrement via after‑rating dialog             |
| 9  Gamification          | Badge calc client‑side; writes badge record                 |
| 10 Analytics charts      | `charts_flutter` radar & scatter                            |
| 11 Speech‑to‑text        | `speech_to_text` mic on note field                          |
| 12 Push notifications    | FCM “low‑stock” after cron check                            |
| 13 Ads & IAP             | Google Ads free tier; `in_app_purchase` for Pro             |

### 3.4  Local‑first Floor schema

| Entity      | Purpose                                          |
| ----------- | ------------------------------------------------ |
| `PendingOp` | id · table · recordJson · opType                 |
| Mirrors     | `DrinkLocal`, `RatingLocal`, `InventoryLocal`, … |

Sync algorithm: flush `PendingOp` on connectivity; delete row when server 2xx.

---

## 4 · Quality & CI/CD

- **Unit tests** – Riverpod providers, Floor DAOs
- **Widget tests** – golden screenshots
- **E2E** – `integration_test` on Android & iOS

### GitHub Actions (starter)

```yaml
name: Flutter CI
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v3
        with:
          channel: "stable"
      - run: flutter pub get
      - run: flutter test
      - run: flutter build apk --release
      - uses: actions/upload-artifact@v4
        with:
          name: android-apk
          path: build/app/outputs/flutter-apk/app-release.apk
```

Extend with Fastlane lanes for Play Store & TestFlight deploys.

---

## 5 · Deployment & Ops

| Env         | How                                                     | Notes                        |
| ----------- | ------------------------------------------------------- | ---------------------------- |
| **Dev**     | `docker compose up` – mounts `pb/pb_data`               | Hot‑reload `flutter run`     |
| **Staging** | ECS Fargate task (PocketBase) + S3 backups              | `.env` points to staging URL |
| **Prod**    | Same infra multi‑AZ; CloudFront for images / WAF blocks | HTTPS certificates via ACM   |

Nightly backup: zip `pb_data/data.db3` to S3, 30‑day retention.

---

## 6 · Compliance Checklist

- 17+ age rating + first‑launch gate
- WCAG 2.2 AA contrast & scaling
- Privacy policy on ML Kit (all on‑device)
- GDPR/CPRA export & delete endpoints (PocketBase built‑in)

---

## 7 · 12‑Week Timeline

| Week  | Goal                                     |
| ----- | ---------------------------------------- |
| 0 ‑ 1 | Repo + schema + skeleton + age‑gate      |
| 2 ‑ 3 | Auth, barcode scan, _Add Drink_ flow     |
| 4 ‑ 5 | Rating drafts + offline queue            |
| 6 ‑ 7 | Search & cabinet basics                  |
| 8 ‑ 9 | Inventory alerts & analytics             |
| 10    | Gamification, ads & IAP                  |
| 11    | Closed beta (TestFlight / Play Internal) |
| 12    | Public launch & marketing site           |

---

## 8 · Next Steps

1. Commit **this file** to `/docs/architecture.md`
2. Generate PocketBase migration `init_schema`
3. Scaffold Flutter project & install deps
4. Break each roadmap bullet into Jira tickets (point & assign)

---

### Cheers 🥃 — ship it!
