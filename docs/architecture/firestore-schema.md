# Architecture — schéma Firestore

Région : `europe-west1`. Mode : Native. Une base par projet (free tier).

## Collections

### `users/{uid}`
Mirroir des `customClaims` Firebase Auth pour pouvoir requêter sur le rôle.

```
users/{uid}
  email: string
  displayName: string?
  role: 'parent' | 'ape' | 'admin'
  schoolIds: string[]                  // jusqu'à 5 UAI
  notificationsOptIn: bool
  createdAt: timestamp
  updatedAt: timestamp
  rejectedReportsCount: number         // anti-spam
  fcmTokens: string[]
```

### `schools/{uai}`
Cache de l'annuaire EN, rafraîchi mensuellement par batch.

```
schools/{uai}                           // doc id = code UAI
  name: string
  type: string                          // ex: 'École', 'Collège', 'Lycée'
  stage: 'maternelle'|'elementaire'|'college'|'lycee'
  sector: 'public' | 'prive'
  address: { street, postalCode, city }
  geo: { lat, lng }
  inseeCode: string                     // code commune
  epciSiren: string?                    // agglomération
  departement: string                   // ex: '75'
  academy: string                       // ex: 'Paris'
  apeId: string?                        // FK vers apes/{apeId}
  publicEmail: string?
  updatedAt: timestamp
```

### `apes/{apeId}`
Une APE par école au plus.

```
apes/{apeId}
  schoolId: string                      // unique, indexé
  memberUids: string[]                  // pour requêter les écoles d'un APE membre
  createdAt: timestamp
```

### `apeMembershipRequests/{reqId}`

```
apeMembershipRequests/{reqId}
  uid: string                            // demandeur
  schoolId: string
  claimedRole: 'president' | 'tresorier' | 'secretaire' | 'membre'
  evidenceStoragePath: string?           // gs://.../proofs/{reqId}.{pdf,jpg,png}
  publicEmail: string?
  mailToken: string?                     // hashé
  mailVerified: bool
  status: 'pending' | 'approved' | 'rejected'
  rejectReason: string?
  reviewedBy: string?                    // admin uid
  reviewedAt: timestamp?
  createdAt: timestamp
```

### `reports/{reportId}`
Cœur métier.

```
reports/{reportId}
  schoolId: string                       // UAI
  reporterUid: string | 'deleted'
  agentType: 'teacher'|'aesh'|'atsem'|'animator'|'aed'|'cpe'|'cantine'|'garderie'|'etude'
  schoolStage: 'maternelle'|'elementaire'|'college'|'lycee'   // dérivé de schools/{uai}
  level: string?                         // 'ps'..'terminale', null si AESH/ATSEM/etc.
  discipline: string?                    // codifié, obligatoire si stage∈{college,lycee} && agent='teacher'
  date: timestamp                        // jour, sans heure (00:00 UTC+1)
  durationHours: number                  // 0.5 = demi-journée, 1..7
  replaced: bool | null
  context: 'absence'|'greve'|'formation'|'inconnu'
  status: 'pending'|'validated'|'rejected'|'duplicate'
  rejectCode: 'out_of_window'|'duplicate'|'wrong_school'|'nominative'|'incoherent'|'other' | null
  validatedBy: { uid: string, role: 'ape'|'admin' } | null
  validatedAt: timestamp?
  duplicateOf: string?                   // reportId master
  createdAt: timestamp
  updatedAt: timestamp
```

### `aggregates/{scopeKey}/months/{yyyy-mm}`
Pré-calculés la nuit. `scopeKey` = `school:{uai}`, `commune:{insee}`, `epci:{siren}`, `dep:{dep}`, `national:fr`.

```
aggregates/{scopeKey}/months/{yyyy-mm}
  hoursLost: number
  reportsCount: number                   // nb reports validés distincts
  reportersCount: number                 // nb parents distincts
  byAgentType: { [type]: number }
  byStage: { [stage]: number }
  byDiscipline: { [discipline]: number }
  replacementRate: number                // 0..1
  topSchools: { uai, hoursLost }[]       // tronqué top 10
  generatedAt: timestamp
  kAnonymitySatisfied: bool
```

### `auditLog/{logId}`
Append-only, lecture admin only.

```
auditLog/{logId}
  actorUid: string
  action: string                         // 'approve_ape', 'reject_ape', 'delete_user', 'remove_report', ...
  targetType: 'user'|'report'|'apeRequest'|'school'
  targetId: string
  metadata: map
  ip: string?
  userAgent: string?
  createdAt: timestamp
```

## Index composites

| Collection | Champs | Usage |
|---|---|---|
| `reports` | `schoolId` ASC, `status` ASC, `createdAt` DESC | file APE de l'école |
| `reports` | `reporterUid` ASC, `createdAt` DESC | « mes signalements » |
| `reports` | `status` ASC, `schoolId` ASC, `createdAt` ASC | détection orphelins |
| `apeMembershipRequests` | `status` ASC, `createdAt` ASC | file admin |
| `apeMembershipRequests` | `uid` ASC, `status` ASC | sa demande active |

`firestore.indexes.json` est dans `backend/`.

## Contraintes côté app
- Pas de listener long sur `reports/*` complet : toujours filtré `schoolId == X`.
- Aggregates lus en lecture publique (sans auth) — fait économiser des reads payants.
- Pagination (`limit(20)`) systématique sur les listes.

## Diagramme synthétique

```
users ──┬── schoolIds[] ──▶ schools ──┬── apeId ──▶ apes ──┬── memberUids[]
        │                              │                    │
        ▼                              ▼                    ▼
   reports                        aggregates           apeMembershipRequests
        ▲
        └── validatedBy.uid ──▶ users (rôle ape ou admin)
```
