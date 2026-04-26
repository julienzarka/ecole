# école-asso

App mobile (Flutter) + backend GCP/Firebase pour signaler les absences non remplacées (enseignants, AESH, ATSEM, animateurs, AED, CPE, cantine, garderie, étude). Validation par les **APE**, statistiques publiques par école / commune / agglomération.

> Open source, gratuit. Sources d'inspiration : [Ouyapacours (FCPE)](https://ouyapacours.fcpe.asso.fr/), [#OnVeutDesProfs](https://www.justice.cool/onveutdesprofs/), rapport Cour des comptes décembre 2025.

## Documentation

- [`docs/etat-de-lart.md`](docs/etat-de-lart.md) — état de l'art et arbitrages produit
- [`docs/specs/`](docs/specs/) — specs fonctionnelles et design
- [`docs/architecture/`](docs/architecture/) — schéma Firestore, règles, Functions

## Code

- [`app/`](app/) — application Flutter (mobile + Web)
- [`backend/`](backend/) — Firestore rules, indexes, Storage rules, Cloud Functions

## CI

GitHub Actions : `flutter analyze` + `flutter test` + Functions `tsc` + `jest` + sanité des règles Firestore.

## Démarrage rapide

```bash
# App
cd app && flutter pub get && flutter run

# Backend (emulators)
cd backend/functions && npm ci && npm run build
cd backend && firebase emulators:start
```

## Branche de développement

`claude/school-absence-tracker-RGJJh`

## Licence

À définir — visée AGPL-3.0 (serveur) + MIT (mobile).
