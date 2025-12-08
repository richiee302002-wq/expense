# Expense Tracker

A Flutter expense tracker app built with Clean Architecture, Drift (local DB), Riverpod (state management), and offline-first sync.

## Features
- **Offline-first**: Works completely offline, syncs when online.
- **Clean Architecture**: Separation of concerns (Domain, Data, Presentation).
- **Local Database**: Powered by Drift (SQLite).
- **State Management**: Riverpod 2.x.
- **Deep Links**: Navigate directly to transactions.
- **Notifications**: Daily reminders.
- **Localization**: English & Tamil support.
- **Theming**: Light & Dark modes.

## Architecture
The project follows Clean Architecture principles:
- `lib/core`: Shared utilities and constants.
- `lib/domain`: Business logic (Entities, UseCases, Repository Interfaces).
- `lib/data`: Data implementation (Models, Datasources, Repository Impl).
- `lib/presentation`: UI (Widgets, Pages, State).

## Setup
1. **Prerequisites**: Flutter SDK installed.
2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```
3. **Run Code Generation**:
   ```bash
   dart run build_runner build -d
   ```

## Mock Backend
The app uses `json-server` for a mock backend.
1. Install `json-server`:
   ```bash
   npm i -g json-server
   ```
| Metric | Value |
|---|---|
| Cold Start Time | TBD |
| Jank % (Profile) | TBD |
| Release APK Size | TBD |

## Tradeoffs
- **Drift vs Isar**: Chose Drift for robust SQL support and relational data handling, though Isar might be faster for simple reads.
- **Sync Frequency**: Using background sync to balance freshness vs battery life.

## CI/CD
GitHub Actions is set up to run analysis, tests, and build the release APK.

[![CI](https://github.com/username/expense_tracker/actions/workflows/main.yml/badge.svg)](https://github.com/username/expense_tracker/actions/workflows/main.yml)
