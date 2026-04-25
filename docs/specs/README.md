# Specs fonctionnelles & design — index

Ce dossier rassemble les specs de la v1. Chaque fichier traite un thème.

| # | Fichier | Contenu |
|---|---|---|
| 01 | [`personas-et-stories.md`](./personas-et-stories.md) | Personas (parent, APE, admin, public) et user stories par rôle |
| 02 | [`parcours.md`](./parcours.md) | Parcours utilisateur de bout en bout (signup, déclaration, validation, admin, stats) |
| 03 | [`ecrans.md`](./ecrans.md) | Wireframes ASCII écran par écran |
| 04 | [`design-system.md`](./design-system.md) | Tokens (couleurs, typo, espacements), composants, thème Flutter |
| 05 | [`etats-et-messages.md`](./etats-et-messages.md) | États vides / chargement / erreur, messages utilisateur, copywriting FR |
| 06 | [`accessibilite.md`](./accessibilite.md) | Règles WCAG, contrastes, lecteur d'écran, taille dynamique |
| 07 | [`rgpd.md`](./rgpd.md) | Consentement, conservation, suppression de compte, export, mentions |
| 08 | [`backlog-v1.md`](./backlog-v1.md) | Backlog priorisé MoSCoW + hors-périmètre v1 |

## Principes directeurs (non négociables)

1. **Saisie d'un signalement en ≤ 30 secondes** depuis l'écran d'accueil.
2. **Une action principale par écran**, jamais deux CTA de même poids visuel.
3. **Sobre** : pas de gamification, pas d'illustrations gadget, pas d'emojis dans l'UI.
4. **Hors-ligne first** : un signalement saisi dans une zone blanche se synchronise quand le réseau revient.
5. **Aucune donnée nominative** sur un agent. Champs structurés uniquement, pas de zone de texte libre côté parent.
6. **Accessibilité WCAG 2.2 AA** par défaut.
7. **Anonyme par défaut côté public** : le dashboard public ne révèle jamais l'identité d'un déclarant.

## Cible technique de la v1 (rappel)

- Flutter 3.x + Riverpod + go_router + freezed.
- Firebase Auth (Email + Google + Apple), Firestore, Cloud Storage, Cloud Functions, App Check.
- Région GCP `europe-west1` (UE) imposée.
- Dashboard public Web servi par Firebase Hosting (Flutter Web compilé du même code).
