# Architecture — règles Firestore (lecture)

Les règles canoniques sont dans `backend/firestore.rules`. Ce document explique l'**intention** par collection.

## Principes
1. **Aucune lecture sans auth** sauf `aggregates/*` et `schools/*`.
2. **Aucune écriture client direct** sur `aggregates/*`, `auditLog/*`, `users/*` (champs sensibles), `apes/*` — tout passe par Cloud Functions.
3. **Le rôle est lu depuis les `customClaims`** (`request.auth.token.role`).
4. **Le rattachement école** est lu depuis `users/{uid}.schoolIds`.

## Détail par collection

### `users/{uid}`
- Read : auth ET (`uid == request.auth.uid` OU rôle admin).
- Create : auth ET `uid == request.auth.uid` ET rôle ne contient que `'parent'` à la création (un user ne peut pas se promouvoir APE/admin).
- Update : auth ET `uid == request.auth.uid` MAIS uniquement champs « libres » (`displayName`, `notificationsOptIn`, `fcmTokens`, `schoolIds`). Les champs `role`, `rejectedReportsCount`, `createdAt` sont en lecture seule côté client.
- Delete : interdit côté client (passer par Cloud Function `delete-user`).

### `schools/{uai}`
- Read : public.
- Write : Cloud Functions only (refresh annuaire).

### `apes/{apeId}`
- Read : auth (rôle parent ou ape, et `schoolId` doit être dans ses `schoolIds`) OU admin.
- Write : Cloud Functions only.

### `apeMembershipRequests/{reqId}`
- Read : auth ET (auteur OU admin).
- Create : auth ET `uid == request.auth.uid` ET pas d'autre demande `pending` ouverte de cet user.
- Update : Cloud Functions only (statut, validation).
- Delete : interdit.

### `reports/{reportId}`
- Read : auth ET (
   `reporterUid == request.auth.uid` OU
   (rôle == 'ape' ET `schoolId` rattachée à son APE) OU
   rôle == 'admin'
  ).
- Create : auth ET `reporterUid == request.auth.uid` ET (école dans ses `schoolIds`) ET respect des contraintes de modèle (date < now, pas de champ texte libre).
- Update :
  - par auteur tant que `status == 'pending'` (édition).
  - par membre APE rattaché → écriture limitée aux champs `status`, `rejectCode`, `validatedBy`, `validatedAt`, `duplicateOf`.
  - par admin → idem APE + suppression logique (`status = 'rejected'`).
- Delete : par auteur tant que `status == 'pending'`. Sinon Cloud Function.

### `aggregates/**`
- Read : public.
- Write : Cloud Functions only.

### `auditLog/{logId}`
- Read : admin only.
- Write : Cloud Functions only.

## Modélisation de la « rule helper »

```
function isParentOf(school) {
  return get(/databases/$(database)/documents/users/$(request.auth.uid))
            .data.schoolIds.hasAny([school]);
}

function isApeOf(school) {
  return request.auth.token.role == 'ape'
      && get(/databases/$(database)/documents/users/$(request.auth.uid))
            .data.schoolIds.hasAny([school]);
}

function isAdmin() {
  return request.auth.token.role == 'admin';
}
```
