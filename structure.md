# DoctApp — Medical App: Full Codebase & Architecture Reference

> Generated from a full read of the working tree on **2026-08-03**.
> Covers both halves of the solution: the Flutter client (`medical-app/`) and the
> Node/Express + MongoDB API (`backend/`).

---

## 1. Executive Summary

| | |
|---|---|
| **Product name (in UI)** | DoctApp — "Find Your Specialist" |
| **Purpose** | Let patients browse doctors by specialty and book appointments |
| **Client** | Flutter 3.22+ / Dart 3.6.1+, Material Design |
| **Server** | Node.js + Express 4 + MongoDB (Mongoose 7), JWT auth |
| **Alternate backend** | Firebase (Auth + Cloud Firestore) — wired in `pubspec.yaml` and `lib/services/`, but not initialised |
| **Target platforms** | Android, iOS, Web, Windows, macOS, Linux (all six scaffolded) |
| **Maturity** | Early prototype / UI-first. Screens are static mockups; no screen is wired to either backend yet. |
| **Repo state** | `medical-app/` is a git repo (1 commit: `344795a Initial commit`). `backend/` is **not** under version control. |

**One-line assessment:** the UI shell and the REST API both exist and are individually coherent, but nothing connects them yet — every button is a `Navigator.push`, and the two candidate backends (Firebase and Express/Mongo) are both half-wired, with neither chosen.

---

## 2. Top-Level Layout

```
D:\keshan\medical-app-with-backend\
├── medical-app\        # Flutter client  (git repo, branch: main)
└── backend\            # Express + MongoDB REST API  (NOT version-controlled)
```

The two are sibling folders, not a monorepo. There is no shared tooling, no
workspace file, no docker-compose, and no CI configuration anywhere in the tree.

---

## 3. Technology Stack

### 3.1 Frontend — Flutter

| Layer | Technology | Version |
|---|---|---|
| Language | Dart | SDK `^3.6.1` (lock resolves `>=3.8.0-0 <4.0.0`) |
| Framework | Flutter | `>=3.22.0`, stable channel, revision `c519ee916e` |
| UI kit | Material (`package:flutter/material.dart`) | bundled |
| Icons | `cupertino_icons` | `^1.0.8` |
| HTTP | `http` | `^1.2.0` |
| Auth (BaaS) | `firebase_auth` | `^5.4.0` |
| Database (BaaS) | `cloud_firestore` | `^5.4.0` |
| Firebase bootstrap | `firebase_core` | `^3.4.0` |
| Lints | `flutter_lints` | `^5.0.0` (via `analysis_options.yaml`) |
| Tests | `flutter_test` | SDK |
| Fonts | Poppin, PoppinBold (`fonts/*.ttf`) | local |

**State management:** none. A single `setState` in `_IndexState` drives the bottom
nav. No Provider / Riverpod / Bloc / GetX.

**Routing:** imperative only — `Navigator.push(MaterialPageRoute(...))`. No named
routes, no `onGenerateRoute`, no router package.

### 3.2 Backend — Node.js

| Layer | Technology | Version |
|---|---|---|
| Runtime | Node.js | v14+ (per README) |
| Framework | Express | `^4.18.2` |
| ODM | Mongoose | `^7.0.0` |
| Database | MongoDB (local or Atlas) | — |
| Auth | `jsonwebtoken` | `^9.0.0` — HS256, 7-day expiry |
| Password hashing | `bcryptjs` | `^2.4.3` — salt rounds 10 |
| Validation | `express-validator` | `^7.0.0` |
| CORS | `cors` | `^2.8.5` — wide open (`app.use(cors())`) |
| Config | `dotenv` | `^16.0.3` |
| Dev reload | `nodemon` | `^2.0.20` (devDependency) |

**Architecture pattern:** classic MVC-minus-V — `routes → middleware → controllers → models`.

### 3.3 Native / Build Toolchain

| Platform | Toolchain |
|---|---|
| Android | Gradle 8.1.0 AGP, Kotlin 1.8.22, Java 8 target, `namespace`/`applicationId` = `com.example.medical_app`, JVM heap 4G, AndroidX + Jetifier on |
| iOS | Xcode project (`ios/Runner.xcodeproj`), Swift `AppDelegate`, CocoaPods (implied by Firebase plugins) |
| Web | `web/index.html` + `manifest.json`, PWA icons incl. maskable |
| Windows | CMake + Win32 runner (`win32_window.cpp`, `flutter_window.cpp`) |
| macOS | Xcode project, Swift `MainFlutterWindow`, entitlements files |
| Linux | CMake + GTK runner (`my_application.cc`) |

Generated plugin registrants for Windows, macOS and Linux currently register
**CloudFirestore**, **FirebaseAuth**, and **FirebaseCore** — these are modified in
the working tree (uncommitted), a side effect of adding the Firebase packages.

---

## 4. Directory Structure — Complete

### 4.1 `medical-app/` (Flutter client)

```
medical-app/
├── .metadata                      # Flutter project metadata & migration tracking
├── .gitignore                     # standard Flutter ignore set
├── .flutter-plugins-dependencies  # generated plugin graph
├── analysis_options.yaml          # includes package:flutter_lints/flutter.yaml
├── pubspec.yaml                   # deps, assets, fonts
├── pubspec.lock                   # 41 resolved packages
├── README.md                      # untouched Flutter template README
├── structure.md                   # ← this document
│
├── lib/                           # ★ ALL APPLICATION CODE (11 files)
│   ├── main.dart                  # entry point → MyApp → StartPage
│   ├── pages/
│   │   ├── start_page.dart        # onboarding / splash — "Find Your Specialist"
│   │   ├── login_page.dart        # email + password form (visual only)
│   │   ├── signup_page.dart       # 5-field registration form (visual only)
│   │   ├── index.dart             # main app shell: search + specialty grid + bottom nav
│   │   ├── general.dart           # "General Practitioner" info panel
│   │   ├── home                   # ⚠ 0-byte file, no extension — leftover
│   │   └── widgets/
│   │       ├── signup_input.dart          # reusable icon + TextField row
│   │       └── bottom_navigation.dart     # 4-tab nav bar — ⚠ defined but never used
│   └── services/                  # ⚠ untracked in git; not imported by any page
│       ├── auth_service.dart      # Firebase Auth email/password wrapper
│       ├── firestore_service.dart # Firestore 'patients' collection CRUD
│       └── backend_api.dart       # REST client for the Express server
│
├── assests/                       # ⚠ note the misspelling — used consistently
│   ├── logo.png       brain.png   eye.png     heart.png
│   ├── doc.png        laboo.png   stet.png    teeth.png
│   ├── profile.jpg    signup.jpg
│
├── fonts/
│   ├── Poppin.ttf
│   └── PoppinBold.ttf
│
├── test/
│   └── widget_test.dart           # ⚠ default counter test — will FAIL against MyApp
│
├── android/                       # Kotlin MainActivity, manifest, Gradle, launcher icons
├── ios/                           # Swift Runner, storyboards, asset catalogs, Info.plist
├── web/                           # index.html, manifest.json, favicon, PWA icons
├── windows/                       # CMake, Win32 runner, app_icon.ico, .rc resources
├── macos/                         # Xcode Runner, xcconfigs, entitlements
├── linux/                         # CMake, GTK application runner
├── build/                         # ⚠ build output — should be gitignored (it is)
└── .dart_tool/                    # pub cache metadata
```

### 4.2 `backend/` (Express API)

```
backend/
├── server.js                      # app bootstrap: db, middleware, route mounts, error handlers
├── package.json                   # name: medical-app-backend, main: server.js
├── .env                           # MONGODB_URI, PORT, JWT_SECRET, NODE_ENV (untracked by design)
├── .gitignore                     # node_modules/, .env*
├── README.md                      # setup + endpoint documentation
│
├── config/
│   └── database.js                # connectDB() — mongoose.connect, process.exit(1) on failure
│
├── middleware/
│   └── auth.js                    # Bearer-token JWT verify → req.user
│
├── models/
│   ├── User.js                    # credentials + role; pre-save bcrypt hook; comparePassword()
│   ├── Patient.js                 # medical profile + embedded appointments[]
│   └── Doctor.js                  # professional profile + availableSlots[] + patients[]
│
├── controllers/
│   ├── authController.js          # register, login, getCurrentUser
│   ├── patientController.js       # create/get/update own profile; list all; get by id
│   └── doctorController.js        # create/get/update own profile; list all; get by id
│
└── routes/
    ├── auth.js                    # /api/auth/*   (+ express-validator chains)
    ├── patients.js                # /api/patients/*
    └── doctors.js                 # /api/doctors/*
```

> `node_modules/` is **absent** — run `npm install` in `backend/` before first start.

---

## 5. Frontend Deep Dive

### 5.1 Entry point — `lib/main.dart`

```dart
void main() => runApp(MyApp());
// MaterialApp(debugShowCheckedModeBanner: false, home: StartPage())
```

No theme, no localisation, no routes table, and — importantly — **no
`Firebase.initializeApp()`**, despite `firebase_core` being a dependency.

### 5.2 Screen inventory

| File | Class | Type | What it renders |
|---|---|---|---|
| `start_page.dart` | `StartPage` | Stateless | Hero image (`doc.png`), headline "Find Your Specialist", subtitle, black "Get Stared" *(sic)* CTA → `LoginPage` |
| `login_page.dart` | `LoginPage` | Stateless | Logo, "DoctApp" wordmark, email + password fields, "Forgot password ?" text, "Sign in" → `General()`, "Need an Account ? Sign up" → `SignupPage` |
| `signup_page.dart` | `SignupPage` | Stateless | Full-bleed `signup.jpg` background, 5 × `SignupInput` (First Name, Last Name, Email, Phone Number, Date of Birth), T&C text, "Create an account" → `Index()`, "Already have an account ?" → `LoginPage` |
| `index.dart` | `Index` | **Stateful** | AppBar (menu / "Hello User !!" / bell), search box, 2×3 grid of specialty cards, `BottomNavigationBar` with 3 tabs. Tabs 2 and 3 are `Center(Text("Page N Content"))` placeholders |
| `general.dart` | `General` | Stateless | Teal panel with a circular `profile.jpg` and a paragraph describing a general practitioner |

### 5.3 Reusable widgets

| Widget | Params | Notes |
|---|---|---|
| `SignupInput` | `hintText: String`, `inputIcon: IconData` | 280 px pill container, icon + borderless `TextField`. No controller, no validator. |
| `CustomBottomNavigationBar` | `onTabSelected: Function(int)`, `selectedIndex: int` | 4 tabs (Home / Search / Notifications / Profile). **Dead code** — `Index` inlines its own 3-tab bar instead. |

### 5.4 Navigation graph

```
main()
  └─▶ StartPage
        └─(Get Stared)─▶ LoginPage
                           ├─(Sign in)──────────────▶ General        ← ⚠ likely wrong target
                           └─(Need an Account)──────▶ SignupPage
                                                        ├─(Create an account)─▶ Index
                                                        └─(Already have…)─────▶ LoginPage
Index
  ├─ tab 0 ─▶ specialty grid  (cards are non-interactive)
  ├─ tab 1 ─▶ "Page 2 Content"
  └─ tab 2 ─▶ "Page 3 Content"
```

There is no back-stack management, no auth guard, and no route from `Index` to
any doctor detail screen.

### 5.5 Specialty catalogue (hardcoded in `index.dart`)

| Specialty | Colour | Icon asset |
|---|---|---|
| General | `#477cfe` | `stet.png` |
| Optalmology *(sic — Ophthalmology)* | `#56b3d4` | `eye.png` |
| Neurology | `#fdb45f` | `brain.png` |
| Dental | `#fdb45f` | `teeth.png` |
| Cardiology | `#ef7069` | `heart.png` |
| Laboratory | `#477cfe` | `laboo.png` |

### 5.6 Design tokens (as used, not centralised)

| Token | Value | Where |
|---|---|---|
| Primary mint | `#aaeaf4` | StartPage background, Sign-in button |
| Pale cyan bg | `#ecfbff` | LoginPage scaffold |
| Input fill | `#D9F5F3` / `Color.fromARGB(255,192,244,248)` | Login / Signup inputs |
| Signup CTA | `#7de2ea` | SignupPage button |
| App shell grey | `#E5E5E5` | Index scaffold + AppBar |
| Body text grey | `#565656` / `ARGB(255,79,79,79)` | headings & labels |
| Accent teal | `ARGB(135,50,211,200)` | General panel |
| Radius | 12 / 15 / 20 / 25 / 28 px | ad hoc per widget |
| Font | `Poppin`, `PoppinBold` | all text |

⚠ These are literal values repeated across files. There is no `ThemeData`, no
colour constants file, and no spacing scale.

### 5.7 Service layer — `lib/services/` (untracked, unused)

```dart
// auth_service.dart      — FirebaseAuth.instance
AuthService.signUp(email, password) -> Future<User?>
AuthService.login(email, password)  -> Future<User?>
// errors are swallowed: print() + return null

// firestore_service.dart — FirebaseFirestore.instance
FirestoreService.addPatient(name, age, condition) -> Future<void>   // collection 'patients'
FirestoreService.getPatients() -> Stream<QuerySnapshot>

// backend_api.dart       — package:http
BackendApi.baseUrl = "http://localhost:8080"
BackendApi.fetchPatients() -> Future<String>   // GET  $baseUrl/patients
```

These three classes are the *only* code in the project that talks to a backend,
and **no widget imports any of them**.

---

## 6. Backend Deep Dive

### 6.1 Bootstrap — `server.js`

```
dotenv.config()
connectDB()                              // exits process on failure
app.use(cors())                          // all origins, all methods
app.use(express.json())
app.use('/api/auth',     routes/auth)
app.use('/api/patients', routes/patients)
app.use('/api/doctors',  routes/doctors)
GET /health              → 200 { message: 'Server is running' }
404 fallback             → { message: 'Route not found' }
error middleware         → 500 { message, error: error.message }   // leaks internals
PORT = process.env.PORT || 8080
```

### 6.2 Environment variables (`backend/.env`)

| Key | Purpose |
|---|---|
| `MONGODB_URI` | Mongo connection string (local or Atlas) |
| `PORT` | HTTP listen port — defaults to 8080 |
| `JWT_SECRET` | HMAC signing key for access tokens |
| `NODE_ENV` | `development` / `production` |

*(Values intentionally omitted from this document.)*

### 6.3 Data models

**`User`** — the identity record.

| Field | Type | Rules |
|---|---|---|
| `firstName` | String | required |
| `lastName` | String | required |
| `email` | String | required, unique, lowercased |
| `password` | String | required, bcrypt-hashed on save |
| `phone` | String | optional |
| `role` | String | enum `patient` \| `doctor` \| `admin`, default `patient` |
| `isActive` | Boolean | default `true` |
| `createdAt` / `updatedAt` | Date | via `timestamps: true` |

Hooks: `pre('save')` hashes `password` when modified (salt 10).
Methods: `comparePassword(entered) → Promise<boolean>`.

**`Patient`** — 1:1 medical profile keyed by `userId`.

| Field | Type |
|---|---|
| `userId` | ObjectId → `User`, required |
| `age` | Number |
| `bloodType` | enum `O+ O- A+ A- B+ B- AB+ AB-` |
| `medicalHistory`, `allergies`, `currentMedications` | String |
| `emergencyContact` | `{ name, phone, relation }` |
| `appointments[]` | `{ doctorId, date, reason, status: scheduled\|completed\|cancelled }` |

**`Doctor`** — 1:1 professional profile keyed by `userId`.

| Field | Type |
|---|---|
| `userId` | ObjectId → `User`, required |
| `specialization` | String, required |
| `licenseNumber` | String, required, **unique** |
| `hospital` | String |
| `experience` | Number (years) |
| `consultationFee` | Number |
| `availableSlots[]` | `{ day, startTime, endTime }` |
| `patients[]` | ObjectId[] → `Patient` |

**Relationships**

```
User (1) ──── (0..1) Patient ──┐
  │                            ├── appointments[] { doctorId, date, reason, status }
  └──── (0..1) Doctor ─────────┘
                 └── patients[] → Patient
```

### 6.4 API surface

Base URL: `http://localhost:8080`

| Method | Path | Auth | Body / Params | Response |
|---|---|---|---|---|
| `GET` | `/health` | — | — | `{ message }` |
| `POST` | `/api/auth/register` | — | `firstName, lastName, email, password(≥6), role?` | `201 { message, token, user }` |
| `POST` | `/api/auth/login` | — | `email, password` | `200 { message, token, user }` |
| `GET` | `/api/auth/me` | Bearer | — | `200 { user }` (password stripped) |
| `POST` | `/api/patients/profile` | Bearer | `age, bloodType, medicalHistory, allergies, currentMedications` | `201 { message, patient }` |
| `GET` | `/api/patients/profile` | Bearer | — | `200 { patient }` |
| `PUT` | `/api/patients/profile` | Bearer | any subset + `emergencyContact` | `200 { message, patient }` |
| `GET` | `/api/patients` | Bearer + **doctor/admin** | `?page&limit` | `200 { patients, page, limit, total }` |
| `GET` | `/api/patients/:id` | Bearer + **owner or doctor/admin** | — | `200 { patient }` |
| `POST` | `/api/doctors/profile` | Bearer + **doctor/admin** | `specialization, licenseNumber, hospital, experience, consultationFee, availableSlots` | `201 { message, doctor }` |
| `GET` | `/api/doctors/profile` | Bearer + **doctor/admin** | — | `200 { doctor }` |
| `PUT` | `/api/doctors/profile` | Bearer + **doctor/admin** | any subset (not `licenseNumber`) | `200 { message, doctor }` |
| `GET` | `/api/doctors` | none (public) | `?specialization&page&limit` | `200 { doctors, page, limit, total }` |
| `GET` | `/api/doctors/:id` | none (public) | — | `200 { doctor }` |

**Validation** (`express-validator`): register/login as before, plus typed
chains on every patient and doctor profile endpoint (blood-type enum, numeric
ranges for age/experience/fee, string length caps, `availableSlots` shape).

**Rate limits:** `POST /api/auth/login` 10 per 15 min per IP;
`POST /api/auth/register` 20 per hour per IP. In-process counters — see
`middleware/rateLimit.js`.

**Field exposure:** populated `User` documents are projected, never
`-password`. Staff-facing routes return `firstName lastName email phone role`;
the public doctor directory returns `firstName lastName` only.

**Auth scheme:** `Authorization: Bearer <jwt>`; payload `{ id, email, role }`;
`expiresIn: '7d'`; verified in `middleware/auth.js`, decoded onto `req.user`.

⚠ Route-order note: in `routes/doctors.js` and `routes/patients.js`, `/profile`
is declared before `/:id`, so `GET /api/doctors/profile` resolves correctly.

---

## 7. Integration Status — the Gap

```
┌──────────────────┐        ┌──────────────────────┐
│  Flutter screens │        │  lib/services/*.dart │
│  (5 pages)       │  ✗ no  │  Auth / Firestore /  │
│                  │ import │  BackendApi          │
└──────────────────┘        └──────────┬───────────┘
                                       │
                    ┌──────────────────┴──────────────────┐
                    ▼                                     ▼
        ┌───────────────────────┐             ┌───────────────────────┐
        │ Firebase              │             │ Express + MongoDB     │
        │ Auth + Firestore      │             │ /api/auth /patients   │
        │ ⚠ never initialised   │             │ ⚠ wrong path in client│
        │ ⚠ no config files     │             │ ⚠ localhost only      │
        └───────────────────────┘             └───────────────────────┘
```

**Two backends, neither connected.** Firebase packages are installed and native
registrants regenerated, but no `firebase_options.dart`, no
`android/app/google-services.json`, and no `ios/Runner/GoogleService-Info.plist`
exist anywhere in the tree. Meanwhile the Express API is complete and functional
but the client's only reference to it targets the wrong path.

---

## 8. Known Issues & Technical Debt

> **Status update (2026-08-03):** issues 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14,
> 15, 16, 17, 18, 19, 20, 21, 23, 26 and 29 have been fixed — see §12.
> The remaining open items are marked **OPEN** below.

### Blocking (app will break at runtime)

1. **`Firebase.initializeApp()` is never called** — `main.dart` goes straight to
   `runApp`. Any call into `AuthService` or `FirestoreService` throws
   `[core/no-app] No Firebase App '[DEFAULT]' has been created`.
2. **No Firebase configuration files** — even after adding `initializeApp`, there
   is no `firebase_options.dart` / `google-services.json` /
   `GoogleService-Info.plist`. Run `flutterfire configure`.
3. **`BackendApi.fetchPatients()` hits the wrong path** —
   `GET http://localhost:8080/patients`, but the server mounts patients at
   `/api/patients`. Always a 404. → [backend_api.dart:11](lib/services/backend_api.dart:11)
4. **`localhost` is unreachable from a device/emulator** — Android emulators need
   `10.0.2.2`, iOS simulators can use `localhost`, physical devices need the LAN IP.
   The base URL should be configurable (`--dart-define`).
5. **`test/widget_test.dart` is the untouched counter template** — it pumps
   `MyApp()` then asserts a `'0'` Text and an `Icons.add` button that do not exist.
   `flutter test` fails today.

### Functional gaps

6. **No `TextEditingController` anywhere** — email, password and all five signup
   fields are display-only. Nothing is read, validated, or submitted.
7. **"Sign in" navigates to `General()`** — the GP information panel, not the app
   shell. `Index()` is only reachable via the signup path. Likely a placeholder
   left in during layout work. → [login_page.dart:530](lib/pages/login_page.dart:530)
8. **Specialty cards are inert** — no `GestureDetector`/`InkWell`; tapping
   "Cardiology" does nothing.
9. **Search box is decorative** — a `TextField` with no controller and no handler.
10. **Bottom-nav tabs 2 and 3 are `Text("Page N Content")` placeholders.**
11. **`CustomBottomNavigationBar` is dead code** — 4-tab widget never mounted;
    `Index` inlines a separate 3-tab bar. The two are already out of sync.
12. **No appointment endpoints** — both Mongoose schemas model appointments, but
    no route or controller creates, lists, or cancels one. This is the app's
    headline feature ("book appointments") and it is unimplemented end to end.
13. **`lib/pages/home` is a 0-byte, extension-less file** — delete it.
14. **`index.dart` declares a second `main()`** — harmless but confusing; it was
    scaffolded as a standalone entry point.

### Security

15. **`GET /api/patients` and `GET /api/patients/:id` are unauthenticated** and
    return every patient's `medicalHistory`, `allergies`, `currentMedications`,
    blood type, and (via `populate`) name, email and phone. This is unrestricted
    PHI disclosure. Gate behind `authMiddleware` + a role check.
16. **No role-based authorization anywhere** — `req.user.role` is decoded but
    never checked. Any authenticated patient can `POST /api/doctors/profile` and
    become a doctor.
17. **`cors()` with no options** — reflects any origin, and with credentials off
    this is workable for a mobile client but wrong for web deployment.
18. **Error middleware returns `error.message` to the client** — leaks stack-level
    detail and Mongo errors in production.
19. **`JWT_SECRET` default in the README is a placeholder string** — must be
    replaced with a high-entropy secret before any deployment.
20. **No rate limiting on `/api/auth/login`** — unbounded credential stuffing.
21. **7-day non-refreshable tokens** with no revocation list; `isActive` on `User`
    is never consulted at auth time.

### Code quality / maintainability

22. **`assests/` is misspelled** (should be `assets/`) — consistent, so it works,
    but it will confuse every new contributor and every tutorial you follow.
23. **Hardcoded heights** — `SignupPage` fixes its container at `780`, `General`
    at `600`. These will overflow on small screens ("RenderFlex overflowed").
24. **No design system** — colours, radii and spacing are magic literals repeated
    across five files. No `ThemeData`, no constants file.
25. **No state management, no models, no repository layer** on the client.
26. **`lib/services/` is untracked in git** (`?? lib/services/` in `git status`) —
    it will be lost on a clean clone.
27. **`backend/` is not under version control at all** — no `.git`, so the entire
    server has no history and no backup.
28. **Errors are swallowed** in `AuthService` — `print()` then `return null`, so
    the caller cannot distinguish "wrong password" from "network down".
29. **Copy errors in shipped UI text** — "Get Stared", "Email Adress",
    "Optalmology", "appoinment".
30. **README is the untouched Flutter template.**
31. **No CI, no linting in CI, no Dockerfile, no deployment config.**

---

## 9. Running the Project

### Backend

```bash
cd backend && npm install
```

Ensure `backend/.env` has a valid `MONGODB_URI`, then:

```bash
cd backend && npm run dev
```

Verify:

```bash
curl http://localhost:8080/health
```

### Frontend

```bash
cd medical-app && flutter pub get
```

```bash
cd medical-app && flutter run
```

Static analysis and tests:

```bash
cd medical-app && flutter analyze
```

```bash
cd medical-app && flutter test
```

*(`flutter test` currently fails — see issue 5.)*

Release builds:

```bash
cd medical-app && flutter build apk --release
```

```bash
cd medical-app && flutter build web --release
```

---

## 10. Recommended Next Steps

**Decide the backend first.** Firebase and Express/Mongo are both half-wired;
maintaining both doubles the work and guarantees drift. The Express API is the
more complete of the two (models, roles, validation, JWT), so unless you
specifically want Firebase's realtime sync and managed auth, delete
`firebase_auth`, `cloud_firestore`, `firebase_core` from `pubspec.yaml` and drop
`auth_service.dart` / `firestore_service.dart`.

Then, in order:

1. **Commit `lib/services/` and `git init` the backend.** Nothing else matters if
   the code isn't tracked.
2. **Fix `BackendApi`** — correct the path to `/api/patients`, make `baseUrl` a
   `--dart-define`, return typed models instead of `String`, and surface errors.
3. **Wire the auth forms** — add `TextEditingController`s and a `GlobalKey<FormState>`,
   call `POST /api/auth/register` and `/api/auth/login`, persist the JWT
   (`flutter_secure_storage`), and route to `Index()` on success.
4. **Close the PHI leak** — put `authMiddleware` + a role check on
   `GET /api/patients` and `/api/patients/:id`.
5. **Add role authorization** — a `requireRole('doctor')` middleware on
   `POST /api/doctors/profile`, and equivalents elsewhere.
6. **Build the appointments feature** — `POST /api/appointments`,
   `GET /api/appointments/me`, `PATCH /api/appointments/:id/cancel`; make the
   specialty cards navigate to a doctor list backed by `GET /api/doctors`.
7. **Introduce state management** (Riverpod or Provider) plus a `models/` and
   `repositories/` layer, so screens stop owning network logic.
8. **Extract a `ThemeData`** and replace the magic colour literals.
9. **Replace `widget_test.dart`** with real tests; add backend tests (Jest +
   supertest + mongodb-memory-server).
10. **Housekeeping** — delete `lib/pages/home`, remove or adopt
    `CustomBottomNavigationBar`, fix the UI copy, and consider renaming
    `assests/` → `assets/`.

---

## 11. File Census

| Area | Files |
|---|---|
| Dart application code | 11 (`lib/`) + 1 test |
| Backend JavaScript | 12 |
| Image assets | 10 |
| Fonts | 2 |
| Android scaffold | 17 |
| iOS scaffold | 33 |
| macOS scaffold | 20 |
| Windows scaffold | 14 |
| Linux scaffold | 9 |
| Web scaffold | 7 |
| **Tracked in git (client)** | **149** |
| **Tracked in git (backend)** | **0 — not a repo** |

---

## 12. Remediation Log — 2026-08-03

Ten issue groups from §8 were fixed. Everything below is implemented; nothing
here is aspirational.

### 1. PHI exposure closed (was issue 15)

`GET /api/patients` now requires a token **and** the `doctor` or `admin` role.
`GET /api/patients/:id` allows the record's owner or staff, and returns 403
otherwise. Both are paginated (`?page&limit`, limit capped at 100) so a single
call can no longer dump the collection.
→ [routes/patients.js](../backend/routes/patients.js), [patientController.js](../backend/controllers/patientController.js)

### 2. Role-based authorization added (was issue 16)

New `requireRole(...roles)` middleware. `authMiddleware` now re-reads the
user's `role` and `isActive` from the database on every request rather than
trusting a 7-day-old token claim, so a disabled or demoted account loses access
immediately. Doctor-profile writes are gated to `doctor`/`admin`.
Registration can no longer self-assign `admin`.
→ [middleware/auth.js](../backend/middleware/auth.js), [authController.js](../backend/controllers/authController.js)

### 3. Login brute-force protection (was issue 20)

`middleware/rateLimit.js` — a dependency-free in-process limiter, so
`package.json` is unchanged. Login 10/15 min, register 20/hour, both per IP.
Returns 429 with a `Retry-After` header. Buckets are swept every 5 minutes.
**Caveat:** counters are per-process; behind multiple workers this needs a
shared store.

### 4. Internal error details no longer leaked (was issue 18)

The error handler maps `ValidationError` → 400, `CastError` → 400, duplicate
key → 409, and returns a bare `Internal server error` for everything else.
`error.message` is included only when `NODE_ENV !== 'production'`. The server
also refuses to boot without `MONGODB_URI`/`JWT_SECRET`, and rejects a
`JWT_SECRET` shorter than 32 chars in production (was issue 19).
Also: `cors()` now honours a `CORS_ORIGIN` allowlist (was issue 17), and JSON
bodies are capped at 100 kb.
→ [server.js](../backend/server.js)

### 5. Input validation on every profile endpoint (was part of issue 21's cluster)

Blood-type enum, `age` 0–130, `experience` 0–80, non-negative fee, length caps
on free-text PHI fields, and `availableSlots` shape checks. Controllers now
call `validationResult` and switch from truthiness to `!== undefined`, so
clearing a field to `0` or `""` actually persists.

### 6. `BackendApi` rewritten and reachable (was issues 3 and 4)

The old client called `/patients` — a guaranteed 404 against a server that
mounts `/api/patients`. Every path is now correct. Added:
- `AppConfig.apiBaseUrl`, overridable with
  `--dart-define=API_BASE_URL=...`, defaulting to `10.0.2.2` on Android and
  `localhost` elsewhere.
- `ApiClient` — bearer-token handling, 15 s timeout, and `ApiException` with
  messages unpacked from either `{ message }` or `{ errors: [{ msg }] }`.
- Typed methods for auth, the doctor directory, and patient profiles.

**Known limitation:** the token is held in memory only, so it is lost when the
app is killed. Persisting it needs `flutter_secure_storage`, which would add a
dependency — deliberately not done here.
→ [app_config.dart](lib/config/app_config.dart), [api_client.dart](lib/services/api_client.dart), [backend_api.dart](lib/services/backend_api.dart), [auth_user.dart](lib/models/auth_user.dart)

### 7. Login and signup actually authenticate (was issues 6 and 7)

Both pages are now `StatefulWidget`s with a `Form`, `TextEditingController`s,
per-field validators, a spinner and disabled inputs while in flight, and
inline error text. Success does `pushReplacement` to `Index()` — the "Sign in"
button used to open `General()`, the GP information panel.

**Signup changed shape:** the backend requires a password to register, and the
form did not collect one. "Date of Birth" — which had no field on any server
model — was replaced by "Password" + "Confirm Password". If you want DOB
captured, it needs a column on `User` (or `age` on `Patient`) first.
→ [login_page.dart](lib/pages/login_page.dart), [signup_page.dart](lib/pages/signup_page.dart)

### 8. Home screen is interactive (was issues 8, 9, 10, 11)

- Specialty cards are real `InkWell`s; "General" opens its detail page, the
  others show an explicit "not available yet" snackbar instead of doing nothing.
- The search box filters the grid live and has a clear button.
- The six specialties moved into a `kSpecialties` list, and the two hand-built
  `Column`s became a `GridView.count`, so cards reflow instead of overflowing.
- `CustomBottomNavigationBar` is no longer dead code — `Index` uses it, so the
  two tab lists cannot drift apart again. Tab 4 (Profile) exists; placeholders
  now read "<Tab> is not built yet".
- "Optalmology" → "Ophthalmology".
→ [index.dart](lib/pages/index.dart), [bottom_navigation.dart](lib/pages/widgets/bottom_navigation.dart)

### 9. Layout overflow fixes (was issue 23)

`SignupPage` dropped its hardcoded `height: 780` for a full-viewport background
plus `SafeArea`; `General` dropped `height: 600` and is now a proper `Scaffold`
with an AppBar and a scroll view. All `withOpacity` calls (deprecated) became
`withValues(alpha:)`.

### 10. Test suite replaced (was issue 5)

`test/widget_test.dart` was the stock counter test asserting a `'0'` and an
`Icons.add` that never existed — it failed on every run. It now has seven tests
covering startup routing, start→login navigation, empty-form and
malformed-email validation, password confirmation, specialty rendering and
search filtering, and tab switching. All validation tests short-circuit before
any network call, so the suite needs no running backend.

Housekeeping: deleted the 0-byte `lib/pages/home` (issue 13) and fixed
"Get Stared" → "Get Started" and "appoinments" → "appointments" (issue 29).

### Verification status

- **Backend:** all 13 files pass `node --check`. Not executed — `node_modules`
  is absent and `npm install` was not run.
- **Flutter:** **not compiled or tested.** The Flutter SDK is not installed on
  this machine — `android/local.properties` points at `D:\soft\flutter`, which
  does not exist, and no `flutter.bat` was found on either drive. Run
  `flutter analyze` and `flutter test` before trusting the client changes.

### Still open

Issues **1** and **2** (Firebase never initialised, no Firebase config files),
**12** (no appointment endpoints), **22** (`assests/` misspelling), **24** (no
`ThemeData`), **25** (no state management), **27** (`backend/` not under version
control), **28** (errors swallowed in the unused `AuthService`), **30** (client
README is the Flutter template) and **31** (no CI) are untouched.

Issues 1, 2 and 28 all live in the Firebase half of the codebase, which §10
recommends deleting outright. That is a product decision, so nothing there was
changed.
