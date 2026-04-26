# backend — Firebase

Règles Firestore, indexes, règles Storage et Cloud Functions.

## Démarrage local

```bash
cd backend/functions
npm ci
npm run build
npm test
```

Pour démarrer les emulators :

```bash
cd backend
firebase emulators:start
```

## Déploiement

```bash
cd backend
firebase deploy --only firestore,storage,functions
```

Région : `europe-west1`.

## Structure

```
backend/
├── firebase.json
├── .firebaserc
├── firestore.rules
├── firestore.indexes.json
├── storage.rules
└── functions/
    ├── package.json
    ├── tsconfig.json
    ├── jest.config.js
    ├── src/
    │   ├── index.ts
    │   ├── moderation.ts
    │   └── aggregates.ts
    └── test/
        ├── moderation.test.ts
        └── aggregates.test.ts
```

Voir aussi [`docs/architecture/`](../docs/architecture/).
