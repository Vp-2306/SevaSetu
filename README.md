# SevaSetu

AI-powered NGO volunteer coordination platform for the Hack2Skill Google Solution Challenge 2026 (Smart Resource Allocation track). Connects field workers, NGO coordinators, volunteers, and community members across India.

## Repository Structure

```
sevasetu/
├── apps/
│   ├── web/              ← React + Vite marketing landing page
│   └── flutter_app/      ← Flutter mobile app (all 5 user screens)
├── backend/
│   ├── cloud_run/        ← Python FastAPI services
│   └── firebase/         ← Firebase Cloud Functions (TypeScript)
├── ml/                   ← ML models, agents, pipelines
├── maps/                 ← Maps scripts and Looker dashboards
└── docs/                 ← Setup guides and documentation
```

---

## Web App (`sevasetu/apps/web/`)

Marketing and demo landing page built with React 18 + Vite + TypeScript + Tailwind CSS + Framer Motion.

### Run locally

```bash
cd sevasetu/apps/web
npm install
npm run dev
```

### Build for production

```bash
npm run build
```

See [`sevasetu/apps/web/README.md`](sevasetu/apps/web/README.md) for more details.

---

## Flutter App (`sevasetu/apps/flutter_app/`)

Full-featured mobile app with 5 user-type screens built with Flutter 3.19+, Riverpod 2.x, and go_router.

### Prerequisites

- Flutter SDK 3.19+
- Dart 3.x
- Android Studio / Xcode for device emulation
- A `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) from your Firebase project

### Setup

```bash
cd sevasetu/apps/flutter_app
flutter pub get
flutter run
```

### Screens

| Route | Screen | User Type |
|---|---|---|
| `/` | Role Selector | All users |
| `/field-worker` | Field Worker Home | Field Worker |
| `/voice-survey` | Voice Survey | Field Worker |
| `/volunteer` | Volunteer Home | Volunteer |
| `/coordinator` | NGO Coordinator Dashboard | Coordinator |
| `/community` | Community Member Home | Community Member |

### Architecture

- **State management**: Riverpod 2.x with `@riverpod` annotations
- **Navigation**: go_router 12.x with named routes
- **Animations**: flutter_animate + built-in AnimatedContainer
- **Theme**: Custom dark MaterialTheme (Space Grotesk + Inter fonts)
- **Maps**: google_maps_flutter (requires Google Maps API key)

---

## Tech Stack

Built entirely on Google's technology stack:

- **AI/ML**: Gemini 3.1 Pro, Vertex AI ADK, Agent Engine, Vertex AutoML
- **Language**: Speech-to-Text v2, Document AI, Cloud Translation, Natural Language API
- **Maps**: Maps SDK, Routes API, Distance Matrix, Places API
- **Firebase**: Firestore, Firebase Auth, Firebase FCM, Offline Persistence
- **Cloud**: Cloud Run, BigQuery, Pub/Sub, Cloud Scheduler
- **Dev Tools**: Looker Studio, Firebase Analytics, Gemini Code Assist, Firebase Studio

---

*Built for Bharat. Powered by Google AI.*  
Hack2Skill Google Solution Challenge 2026
