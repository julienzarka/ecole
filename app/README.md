# app — application Flutter

App mobile (Android, iOS) et Web (dashboard public) du projet école-asso.

Voir aussi : [`docs/specs/`](../docs/specs/) et [`docs/architecture/`](../docs/architecture/).

## Démarrage

```bash
cd app
flutter pub get
flutter run -d <device>
```

Pour brancher Firebase (non inclus à la v0.1) :

```bash
dart pub global activate flutterfire_cli
flutterfire configure --project <ton-projet-firebase>
```

Puis ajouter au `pubspec.yaml` :

```yaml
firebase_core: ^3.6.0
firebase_auth: ^5.3.1
cloud_firestore: ^5.4.4
firebase_storage: ^12.3.4
```

## Structure

```
lib/
├── main.dart
├── app.dart                       # MaterialApp.router + thème
├── core/
│   ├── theme.dart                 # Material 3 + tokens
│   └── router.dart                # go_router
├── features/
│   ├── auth/
│   │   ├── domain/app_user.dart
│   │   └── presentation/{onboarding,login,role_selection}_screen.dart
│   ├── schools/
│   │   ├── domain/school.dart
│   │   └── presentation/school_search_screen.dart
│   ├── reports/
│   │   ├── domain/{report,report_validation}.dart
│   │   └── presentation/{home,declare_flow}_screen.dart
│   ├── ape/
│   │   ├── domain/ape_membership_request.dart
│   │   └── presentation/ape_request_screen.dart
│   ├── stats/
│   │   └── presentation/stats_screen.dart
│   └── profile/
│       └── presentation/profile_screen.dart
└── shared/
    └── widgets/
test/
├── widget_test.dart
└── report_validation_test.dart
```

## Tests

```bash
flutter analyze
flutter test
```
