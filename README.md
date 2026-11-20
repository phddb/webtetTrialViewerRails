# Webtet Trial Viewer (Rails)

Transforms raw trial data from the data warehouse
([jsontocsvpipeline.onrender.com](https://jsontocsvpipeline.onrender.com/))
into CSV files for EDA and statistical analysis.

Backend: Rails + Postgres + Sidekiq. Frontend: React.

## What it does

- **Synchronize** lists warehouse item ids for an optional date range (warehouse
  `created_at`), then enqueues a Sidekiq job for each id not already stored.
- Each job fetches the item and stores a **Trial** (`uuid`, `start_time`,
  `score`, `cookie`, `audio_file_hash`, `raw`).
- **Export** downloads those fields (except `raw`) as CSV, filtered by local
  `start_time` using the same form dates.

See `GLOSSARY.md` and `docs/adr/` for the domain language and decisions.

## Prerequisites

- Ruby (see `.ruby-version`)
- Node 23 (see `.nvmrc`)
- Postgres and Redis (or Docker)

## Setup

```bash
docker compose up -d   # optional if Postgres/Redis already run locally
bundle install
npm install
bin/rails db:prepare
npm run build
gem install foreman    # used by bin/dev
```

## Run

```bash
bin/dev
```

That starts Rails, the JS watcher, and Sidekiq. Open
[http://localhost:3000](http://localhost:3000).

Optional env:

- `WAREHOUSE_URL` (default `https://jsontocsvpipeline.onrender.com`)
- `REDIS_URL` (default `redis://localhost:6379/0`)

## Warehouse source

Source: `/Users/davebenson/git/jsonToCsvPipeline`  
Live: https://jsontocsvpipeline.onrender.com/
