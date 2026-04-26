# 08 — Backlog v1 (MoSCoW)

## Must (v1.0)

### Authentification
- M-001 Inscription / connexion e-mail + mot de passe
- M-002 Connexion Google (Android, Web)
- M-003 Connexion Apple (iOS, Web)
- M-004 Choix du rôle (parent / APE candidat) à l'inscription
- M-005 Custom claims côté serveur, refresh forcé après promotion APE

### Données de référence
- M-010 Ingestion annuaire EN (data.education.gouv.fr) → collection `schools`
- M-011 Recherche d'école par nom + ville + CP
- M-012 Rattachement multi-écoles (max 5)

### Déclaration parent
- M-020 Flow 6 étapes E.20 → E.27
- M-021 Validation côté client (date, champs requis selon agent type)
- M-022 Soumission Firestore + statut `pending`
- M-023 File d'attente locale hors-ligne (`offline persistence` Firestore)
- M-024 Affichage de mes signalements + statuts
- M-025 Suppression d'un signalement par son auteur tant que `pending`

### Adhésion APE
- M-030 Demande d'adhésion + upload preuve Cloud Storage
- M-031 Champ optionnel : e-mail public APE
- M-032 Écran « état de la demande »
- M-033 Notif push à chaque transition de statut

### Validation APE
- M-040 File des signalements de l'école
- M-041 Action valider / rejeter (motif codifié) / doublon
- M-042 Sélection multiple et action en lot

### Administration
- M-050 Back-office Web responsive (mêmes écrans que mobile, mais pensés desktop)
- M-051 File des demandes APE
- M-052 Approbation / rejet avec motif obligatoire
- M-053 Bouton « envoyer mail de double-vérif » + Cloud Function
- M-054 Validation directe d'un signalement orphelin (école sans APE)
- M-055 Audit log

### Statistiques publiques
- M-060 Pré-calcul d'agrégats (Cloud Scheduler nuit)
- M-061 Page maille (école / commune / EPCI / dep / national)
- M-062 K-anonymat (≥ 3 signalements + ≥ 2 parents)
- M-063 Export CSV CC-BY

### RGPD
- M-070 Politique de conf et CGU accessibles depuis l'app
- M-071 Export JSON de mes données
- M-072 Suppression de compte (Cloud Function `delete-user`)
- M-073 Mentions légales

### Sécurité plateforme
- M-080 Firestore rules complètes
- M-081 Storage rules
- M-082 App Check activé en prod
- M-083 Modération auto serveur (regex non-nominatif)

### Qualité
- M-090 Thème M3 + tokens (cf. design-system)
- M-091 i18n FR via `intl`
- M-092 Tests widget et unit ≥ 30 % de couverture sur la couche `domain`
- M-093 CI GitHub Actions verte (analyze, test, functions build)
- M-094 README de démarrage (clone → run)

## Should (v1.1, post-lancement)
- S-100 Connexion par lien magique (`emailLink`) — alternative au mot de passe
- S-101 Rappel push quotidien optionnel
- S-102 Tableau de bord personnel APE (mes validations, ma cadence)
- S-103 Fusion automatique des doublons proposée à l'APE
- S-104 Recherche full-text des écoles (Algolia ou Typesense free tier)
- S-105 Page « presse » avec accès aux datasets mensuels archivés
- S-106 Bouton « partager les stats de mon école » (deep link)

## Could (v1.2 ou plus)
- C-200 Notifications hyperlocales **désactivées** par défaut (sensibilité)
- C-201 Cumul rétrospectif depuis Ouyapacours via import opt-in (à négocier)
- C-202 Mode sombre forcé / clair forcé dans le profil
- C-203 Ouverture aux APE plurielles (FCPE + PEEP + indé sur la même école)
- C-204 Connecteur ENT (Pronote) — uniquement sur opt-in et après audit RGPD

## Won't (v1, explicitement hors-périmètre)
- W-300 Chat / messagerie entre parents
- W-301 Notation des établissements
- W-302 Identification d'un agent absent (interdit RGPD)
- W-303 Funnel juridique d'indemnisation (laissé à OnVeutDesProfs)
- W-304 1er degré uniquement (déjà arbitré : on couvre les deux)
- W-305 Multi-langue (FR seulement à la v1)
- W-306 Export institutionnel temps réel vers le rectorat (à négocier ultérieurement)

## Dépendances et ordre de réalisation suggéré

```
Sprint 1 (semaine 1-2) — Fondations
  M-090, M-091, M-093 (CI), M-080, M-082
  M-001 → M-005   (auth + rôles)

Sprint 2 (semaine 3-4) — Lecture seule
  M-010, M-011, M-012   (annuaire EN + sélection école)
  M-070, M-073           (mentions légales et CGU)

Sprint 3 (semaine 5-6) — Déclaration
  M-020, M-021, M-022, M-023, M-024, M-025
  M-083                  (modération auto)
  M-092                  (premiers tests)

Sprint 4 (semaine 7-8) — APE
  M-030, M-031, M-032, M-033
  M-040, M-041, M-042

Sprint 5 (semaine 9) — Admin
  M-050, M-051, M-052, M-053, M-054, M-055

Sprint 6 (semaine 10) — Stats publiques
  M-060, M-061, M-062, M-063

Sprint 7 (semaine 11) — RGPD final
  M-071, M-072
  AIPD signée, charte APE distribuée

Sprint 8 (semaine 12) — Pilote
  Tests bêta avec 5-10 APE pilotes, corrections
  Publication CGU + politique conf finalisées
  Déploiement Play Store / App Store / Web
```
