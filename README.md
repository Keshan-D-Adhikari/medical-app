# 🏥 Medical App (Flutter UI)

A Flutter mobile app UI for booking and browsing medical services. This is an early-stage, front-end-only project.

## Screens

- **Start page**: welcome screen with entry to login or sign-up
- **Login / Sign-up**: forms with reusable input widgets
- **Home**: greeting, search prompt and service categories (General, Ophthalmology, Neurology, Dental, Laboratory and more)
- **General**: details page for the General category
- **Bottom navigation**: Home, Search and Notifications tabs

## Project structure

```
lib/
├── main.dart
└── pages/
    ├── start_page.dart
    ├── login_page.dart
    ├── signup_page.dart
    ├── index.dart          # home screen + bottom navigation
    ├── general.dart
    └── widgets/
        ├── bottom_navigation.dart
        └── signup_input.dart
```

## Run locally

```bash
flutter pub get
flutter run
```

## Status

UI only: there is no backend or authentication yet. Planned next steps are connecting login and sign-up to Firebase and adding appointment booking.
