# Architecture — Cloud Functions

Runtime : **Node 22** + TypeScript. Région : `europe-west1`. Code dans `backend/functions/`.

## Fonctions

### Triggers Firestore

| Nom | Trigger | Rôle |
|---|---|---|
| `onReportCreate` | `reports/{id}` create | modération auto : check fenêtre temporelle, mots interdits, cohérence school/reporter ; rejette si KO |
| `onReportValidated` | `reports/{id}` update where `status==validated` | incrémente compteurs locaux pour pré-agrégat, envoie notif au parent |
| `onApeRequestApproved` | `apeMembershipRequests/{id}` update where `status==approved` | met à jour `customClaims.role='ape'`, ajoute uid à `apes/{apeId}.memberUids`, notif user |
| `onApeRequestRejected` | idem `status==rejected` | notif user |

### Callables (HTTPS authentifiées)

| Nom | Caller | Rôle |
|---|---|---|
| `requestApeMailValidation` | utilisateur APE candidat | génère token, envoie mail à l'adresse publique |
| `confirmApeMail` | non-auth (lien magique) | marque la demande comme `mailVerified=true` |
| `deleteUser` | utilisateur authentifié | suppression de compte conforme RGPD (cf. spec RGPD) |
| `exportUserData` | utilisateur authentifié | déclenche export JSON, envoyé par mail sous 24 h |
| `mergeReports` | membre APE | fusionne plusieurs reports en doublons d'un master |

### Schedulers

| Nom | Cron (`europe-west1`) | Rôle |
|---|---|---|
| `recomputeAggregates` | `0 2 * * *` (2 h du matin) | recalcule `aggregates/*/months/{yyyy-mm}` du mois en cours et précédent |
| `purgeOldEvidence` | `0 3 * * 0` (dimanche 3 h) | supprime les pièces jointes de demandes APE > 24 mois |
| `purgeStaleAuditLogs` | `0 3 1 * *` (1er du mois 3 h) | supprime les `auditLog` > 12 mois |
| `refreshSchoolDirectory` | `0 4 1 * *` (1er du mois 4 h) | re-télécharge l'annuaire EN, met à jour `schools/*` |

### HTTPS publiques

| Nom | Rôle |
|---|---|
| `apiAggregatesCsv` | exporte un CSV pour une maille (cache 24 h, CDN Cloud Run) |

## Limites et coûts
- 2 M invocations / mois gratuites (Cloud Run / Cloud Functions 2nd gen).
- `recomputeAggregates` : 1 run nocturne, 30 s estimés → 30 min/mois CPU, OK.
- `onReportCreate` : ~10 ms ; même avec 100k signalements/mois on reste sous quota.

## Stratégie de tests
- Unitaires (jest + ts-jest) : modération (`isNominative`), validation de fenêtre temporelle, calcul d'agrégat.
- Intégration emulator : à venir post-MVP (CI initialement sur `tsc` + `jest`).

## Variables d'environnement
- `MAIL_SENDER` : adresse expéditeur des mails de double-vérif (SendGrid / Mailgun).
- `MAIL_API_KEY` : secret (Secret Manager).
- `APP_BASE_URL` : URL de l'app pour générer les liens magiques.
