# SignalForge AI

An AI-native Rails application for intelligent CRM workflow automation and conversational advisor operations.

SignalForge AI is a focused MVP for financial advisors and wealth management teams. It demonstrates how to combine strong Rails fundamentals with practical AI workflows: meeting summarization, action extraction, follow-up drafting, and conversational retrieval over advisor knowledge.

## Table of Contents

- [Overview](#overview)
- [Product Goals](#product-goals)
- [Core Features](#core-features)
- [System Architecture](#system-architecture)
- [Technology Stack](#technology-stack)
- [Security Posture](#security-posture)
- [Local Development](#local-development)
- [Environment Configuration](#environment-configuration)
- [Demo Script (5 Minutes)](#demo-script-5-minutes)
- [Architecture Decisions](#architecture-decisions)
- [Testing](#testing)
- [Codebase Structure](#codebase-structure)
- [Roadmap](#roadmap)
- [License](#license)

## Overview

This project is intentionally scoped as a 3-day demo-quality build:

- Clean Rails conventions over unnecessary abstractions.
- Production-oriented defaults where they matter.
- Interview-friendly architecture that is simple to explain and maintain.

## Product Goals

- Demonstrate full-stack Rails execution for a modern SaaS use case.
- Show AI integration patterns using service objects and background jobs.
- Model realistic advisor workflows rather than toy prompts.
- Keep implementation lean and credible for a solo engineer.

## Core Features

- Authentication with Devise.
- Advisor dashboard with activity overview.
- Client CRM CRUD.
- Notes and transcript ingestion.
- AI-generated meeting summaries.
- AI-generated action items.
- AI-generated follow-up email drafts.
- Conversational assistant search.
- Document knowledge base with pgvector-powered retrieval.
- Background AI processing with Sidekiq.

## System Architecture

### Request Layer

- Rails controllers remain thin and focused on HTTP concerns.
- Authentication enforced at the application controller level.

### Domain Layer

- Models represent CRM entities: users, clients, notes, documents, activity logs, and AI tasks.
- Associations and validations live with the domain objects.

### AI Layer

- Service objects under app/services/ai:
  - ProviderConfig for feature flags and provider selection.
  - ClientFactory for OpenAI/DeepSeek-compatible client construction.
  - MeetingProcessor for structured post-meeting outputs.
  - Embeddings and ConversationalSearch for retrieval + response generation.

### Async Layer

- Sidekiq jobs execute non-blocking AI tasks:
  - ProcessNoteJob for meeting post-processing.
  - EmbedDocumentJob for document embeddings.

### Data Layer

- PostgreSQL is the system of record.
- pgvector extension supports simple, local semantic retrieval.

## Technology Stack

- Ruby on Rails 8
- PostgreSQL 16 + pgvector
- Hotwire (Turbo + Stimulus)
- TailwindCSS
- Sidekiq + Redis
- Devise
- RSpec
- Docker / Docker Compose

## Security Posture

Current implementation includes practical, MVP-appropriate safeguards:

- CSRF protection via Rails defaults.
- Authentication on all app pages except landing and Devise flows.
- Content Security Policy enabled with constrained sources.
- Production host allowlist via ALLOWED_HOSTS.
- Force SSL enabled in production.
- Sensitive parameter filtering enabled.
- User-safe AI error messages (detailed errors stay in server logs).
- Server-side control of document status/source attributes.

## Local Development

### Prerequisites

- Docker + Docker Compose (recommended)

### 1) Configure env

```bash
cp .env.example .env
```

### 2) Start services

```bash
docker compose up --build
```

### 3) Bootstrap database

```bash
docker compose run --rm --user "$(id -u):$(id -g)" web bash -lc "bundle exec rails db:create db:migrate db:seed"
```

### 4) Access application

- App: http://localhost:3000
- Sidekiq UI: http://localhost:3000/sidekiq

Seed user:

- Email: advisor@signalforge.ai
- Password: password123

## Environment Configuration

Reference file: .env.example

Key variables:

- RAILS_ENV
- POSTGRES_HOST / POSTGRES_PORT / POSTGRES_USER / POSTGRES_PASSWORD
- REDIS_URL
- ALLOWED_HOSTS
- DEVISE_MAILER_SENDER
- AI_PROVIDER=openai|deepseek
- FEATURE_RAG_ENABLED=true|false
- OPENAI_API_KEY
- OPENAI_CHAT_MODEL
- OPENAI_EMBEDDING_MODEL
- DEEPSEEK_API_KEY
- DEEPSEEK_BASE_URI
- DEEPSEEK_CHAT_MODEL
- DEEPSEEK_EMBEDDING_MODEL

## Demo Script (5 Minutes)

1. Sign in with the seeded advisor account.
2. Open Dashboard and explain KPI cards + activity feed as operational visibility.
3. Go to Clients, create a new client, and open the detail page.
4. Paste a meeting note/transcript and trigger AI processing.
5. Show generated summary, action items, and email draft on the client timeline.
6. Upload an advisor document on Documents and describe how embedding powers retrieval.
7. Open AI Assistant and ask a client-centric question to demonstrate conversational ops.

## Architecture Decisions

1. Service Objects For AI Boundaries
Use `app/services/ai/*` to isolate prompting/provider logic from controllers and models.
Reason: easier testing, cleaner HTTP layer, straightforward provider switching.

2. Sidekiq For AI Latency Isolation
AI tasks run via background jobs (`ProcessNoteJob`, `EmbedDocumentJob`) instead of request/response.
Reason: better user experience, reliability under model/API latency, retriable failures.

3. pgvector For Lightweight RAG
Retrieval is implemented directly in PostgreSQL instead of adding a separate vector database.
Reason: lowest operational overhead for MVP while preserving realistic retrieval behavior.

4. Convention-First Rails Structure
Controllers are thin, models hold domain associations/validations, and infra remains minimal.
Reason: maintainability, interview clarity, and speed of iteration for solo execution.

## Testing

Run tests:

```bash
docker compose run --rm --user "$(id -u):$(id -g)" web bash -lc "bundle exec rspec"
```

Current baseline includes request-spec infrastructure and a smoke test.

## Codebase Structure

```text
app/
  controllers/
  jobs/
  models/
  services/ai/
  views/
config/
  environments/
  initializers/
db/
  migrate/
  seeds.rb
spec/
```

## Roadmap

- Add richer AI workflow tests around note processing services.
- Add role-based admin controls for Sidekiq dashboard access.
- Add audit/event exports for advisor compliance workflows.
- Introduce lightweight multi-tenant boundaries for organizations.

## License

MIT
