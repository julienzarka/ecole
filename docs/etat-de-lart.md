# État de l'art — App de signalement des absences non remplacées (enseignants, AESH, animateurs)

> Rédigé le 2026-04-25. Cible : app mobile Flutter + backend GCP free-tier, validation par les APE, statistiques par école / agglomération.

---

## 1. Le problème, en chiffres

Le sujet est documenté et chiffré, ce qui valide la pertinence du projet :

- **Cour des comptes (déc. 2025, rapport « Le temps d'enseignement perdu par les élèves »)** : en 2023-2024, **9 % du temps d'enseignement n'est pas assuré** au collège public, **11 % en éducation prioritaire**.
- **Remplacements courts** : taux d'efficacité ~10,5 % dans le second degré en 2024-2025 (très faible).
- **Remplacements longs** : dégradation de 97 % (2018-19) à 94 % (2024-25).
- **Absences pour santé** : 29,3 % du total ; **+43 % d'arrêts de travail en 5 ans**.
- **Coût budgétaire estimé des absences** : ~4 Md€/an.
- **AESH** : pas de dispositif national de remplacement ; le non-remplacement repose sur le PIAL et l'IA-DASEN, et les parents n'ont aujourd'hui pour recours que le téléphone « Aide Handicap École » ou un référé-liberté (audience sous 48 h).

Ces chiffres viennent de sources institutionnelles, mais reposent sur des remontées internes Éducation nationale ; ils sous-estiment le ressenti côté familles et **n'isolent quasiment pas les AESH ni le périscolaire municipal** (animateurs, grèves de cantine/garderie). C'est précisément le trou que le projet peut combler.

---

## 2. L'existant : 3 dispositifs, aucune app mobile dédiée

### 2.1 Ouyapacours (FCPE) — le concurrent direct
- Plateforme **web** lancée en **2009** par la FCPE nationale. URL : https://ouyapacours.fcpe.asso.fr/.
- Permet de déclarer : heures de cours non assurées, journées d'école non prises en charge, **absence d'AESH**.
- Compteur national affiché en page d'accueil (~50 000 h sur la session courante ; cumul historique annoncé > 570 000 h).
- Connexion par identifiants adhérent FCPE ou compte invité ; relance email à 1 mois pour clôturer le dossier.
- **Limites identifiées** :
  - **Pas d'app mobile** ; UX web vieillissante.
  - **Pas de mécanisme formel de contre-validation** par l'APE locale → critiqué pour le risque de classement d'établissements (ou pire, d'enseignants nommément cités).
  - **Pas de tableau de bord public** par établissement, commune ou agglo — seul un cumul national est visible.
  - **Pas de couverture du périscolaire** (animateurs, grèves municipales).
  - Coloration FCPE forte → freine l'adoption par les APE indépendantes ou PEEP.

### 2.2 #OnVeutDesProfs (Justice.cool, 2022)
- Collectif lancé par les avocats Le Foyer de Costil et Pitcher, soutenu par la FCPE Paris.
- Formulaire en ligne pour **collecter les preuves** d'absences non remplacées et engager une action en justice administrative groupée (référé indemnitaire).
- Demandes types : **10 €/h** dans le secondaire, **50 €/jour** en primaire, **500 €** au titre du préjudice parental.
- Modèle : 100 % en ligne, gratuit pour la famille, rémunération de l'avocat au succès (24 % TTC).
- **Ce que ça n'est pas** : un outil statistique. C'est un funnel juridique, ciblé indemnisation individuelle.

### 2.3 Canaux institutionnels (à connaître pour le funnel)
- Cahier de doléances en conseil d'école / CA.
- Saisine IEN, IA-DASEN, rectorat.
- Aide Handicap École : 0800 730 123 / `aidehandicapecole@education.gouv.fr`.
- Référé-liberté (TA, audience < 48 h).

### 2.4 Synthèse — le différentiel à viser
| Axe | Ouyapacours | OnVeutDesProfs | **Notre app** |
|---|---|---|---|
| App mobile native | ❌ | ❌ | ✅ Flutter |
| Saisie en 30 secondes (notification matin) | ❌ | ❌ | ✅ |
| Couverture AESH | ✅ | partielle | ✅ |
| Couverture périscolaire/animateurs | ❌ | ❌ | ✅ |
| Validation APE (workflow à 2 niveaux) | ❌ | ❌ | ✅ |
| Stats publiques par école / commune / agglo | ❌ | ❌ | ✅ (open data) |
| Indépendant fédération | ❌ | partiel | ✅ |

---

## 3. Cadre légal — ce qui contraint l'architecture

### 3.1 RGPD : le risque numéro 1
Signaler un agent public (prof, AESH, ATSEM, animateur) **par son nom** est un traitement de données personnelles, qui plus est **sensible** car il touche potentiellement à la santé (cause de l'absence) et à la réputation. Risques concrets :

- **Diffamation** si publication nominative non vérifiée (les enseignants peuvent porter plainte au pénal et le syndicat peut se constituer partie civile).
- **Mise en demeure CNIL** si pas de base légale claire et pas d'information des personnes concernées.
- **Atteinte au droit à l'oubli / rectification** : il faut prévoir DPO, registre des traitements, procédure d'exercice des droits.

### 3.2 Conséquences de design (non négociables)
1. **Ne jamais stocker le nom d'un enseignant ou AESH.** On stocke : `école` (UAI), `niveau` (CM2, 6e…), `discipline` (maths, français…), `type d'agent` (prof / AESH / animateur), `date`, `durée`, `remplacé oui/non`.
2. **Données enfants** : ne stocker **aucune** donnée nominative sur les élèves. Le compte parent suffit.
3. **Base légale** : *intérêt légitime* (mission civique de l'APE) + *consentement explicite* du parent à la publication agrégée. Les données nominatives parents restent privées.
4. **Publication uniquement agrégée** : seuils de k-anonymat (ex. on n'affiche une statistique que si ≥ 3 signalements distincts ou ≥ 2 parents distincts par école/semaine), sinon on masque.
5. **Hébergement UE** (régions GCP `europe-west1` Belgique, `europe-west9` Paris).
6. **DPO + mentions légales + politique de conf** dès le MVP.
7. **Modération** : CGU explicites interdisant la mention d'un agent par son nom, avec filtrage automatique côté serveur (regex + liste noire), et droit de retrait sur demande.

---

## 4. Référentiels et données ouvertes à brancher

- **Annuaire de l'Éducation nationale** (data.gouv.fr / data.education.gouv.fr) : 66 000 établissements, code **UAI** (7 chiffres + 1 lettre), géocodage, type, secteur, rattachement académique. → Source de vérité pour le picker « mon école ».
- **Découpage administratif** (INSEE / API Découpage) : commune → EPCI (agglomération) → département → académie → région. → Indispensable pour les agrégats par agglo.
- **Calendrier scolaire** (data.education.gouv.fr) : neutralise vacances et jours fériés dans les stats.

---

## 5. Architecture cible — Flutter + GCP free-tier

### 5.1 Backend GCP — ce qui rentre dans le « always free »
| Service | Quota gratuit perpétuel | Usage prévu |
|---|---|---|
| **Firebase Auth** | illimité (e-mail / Google / Apple) | comptes parents et APE |
| **Firestore (Native)** | 1 Gio stockage + **50 000 lectures**, **20 000 écritures**, **20 000 suppressions / jour** | base principale (signalements, écoles, validations) |
| **Cloud Functions / Cloud Run** | **2 M invocations/mois** + 400 000 GB-s + 200 000 GHz-s | webhooks, agrégats programmés, modération |
| **Cloud Storage** | 5 Go + 1 Go egress NA / mois | éventuelles pièces jointes (photos affiches grève) |
| **Cloud Scheduler** | 3 jobs gratuits | recalcul nocturne des stats |
| **App Hosting / Firebase Hosting** | 10 Go transfert + 360 Mo stockage / mois | dashboard public (Web) |
| **BigQuery** | 1 Tio requêtes + 10 Gio stockage / mois | export & vues annuelles |

⚠️ **Cloud Functions et Cloud Storage egress facturés** au-delà des seuils → activer **alertes de budget à 0 €** dès le jour 1, et plafonner avec App Check (anti-spam mobile).

### 5.2 Schéma de données Firestore (esquisse)
```
schools/{uai}                       # snapshot annuaire EN
  - name, type, commune, epci, dep, academy, geo

reports/{reportId}
  - schoolId (UAI)
  - reporterId (uid parent)
  - agentType: 'teacher'|'aesh'|'animator'|'atsem'
  - level: 'maternelle'|'cp'|...|'terminale'  (nullable AESH)
  - discipline: codifiée, jamais texte libre        # second degré
  - date, durationHours
  - replaced: bool|null
  - context: 'absence'|'greve'|'formation'|'inconnu'
  - status: 'pending'|'validated'|'rejected'|'duplicate'
  - createdAt, updatedAt

validations/{validationId}
  - reportId, apeId, validatorUid
  - decision, comment, evidenceCount

aggregates/{epci}/{period}          # pré-calculé via Cloud Function nocturne
  - hoursLost, replacementRate, byAgentType, bySchool (top N)
```

### 5.3 Mobile Flutter — stack recommandée
- **Flutter 3.x stable**, Dart 3.
- **State management** : **Riverpod** (mieux adapté aux dépendances Firebase asynchrones que Provider, plus simple que BLoC pour ce périmètre).
- **Architecture en 3 couches** : `data` (Firestore + Auth) → `domain` (use cases, modèles immuables `freezed`) → `presentation` (écrans + Riverpod notifiers).
- **Navigation** : `go_router` (deep links nécessaires pour la consultation des stats publiques).
- **Hors-ligne** : cache Firestore activé par défaut + écritures en attente (les parents signalent souvent depuis la grille de l'école sans 4G).
- **Notifications** : FCM, rappel quotidien optionnel à 8 h 30 « as-tu un signalement à faire ? ».
- **Anti-abus** : Firebase **App Check** (Play Integrity / DeviceCheck) obligatoire en prod, sinon la free tier sera vidée par des bots en 24 h.
- **Tests** : `flutter_test` + `mocktail` ; emulator suite Firebase pour CI.
- **i18n** : FR uniquement au lancement, mais arborescence `intl` prête.

### 5.4 Modération & validation APE — le cœur fonctionnel
1. Le **parent** déclare → `status = pending`.
2. Cloud Function **vérifie** : champs obligatoires, fenêtre temporelle (≤ 30 j), absence de nom propre dans le commentaire, école valide, parent rattaché à cette école.
3. Un **second parent** ou un **représentant APE rattaché à l'école** confirme → `status = validated`.
4. Les agrégats publics ne consomment **que** les `validated`.
5. Les APE locales ont un rôle « modérateur » : peuvent rejeter, fusionner les doublons, ajouter le contexte.

### 5.5 Modèle de confiance (trust score)
Inspiré des plateformes civic-tech (Civic360, Civic Drishti) :
- Score parent ↑ à chaque signalement validé, ↓ à chaque rejet.
- Au-delà d'un seuil, validation single-vote suffit ; sinon double-vote requis.
- Score APE = 1 par construction (organisation déclarée).

---

## 6. Risques et points d'attention

| Risque | Mitigation |
|---|---|
| Stigmatisation d'un enseignant identifiable | Données strictement non nominatives, modération auto + humaine, CGU explicites |
| Détournement par un syndicat / parti | Gouvernance pluraliste (charte signée par les APE adhérentes), logo neutre |
| Faux signalements coordonnés | App Check, double validation, trust score, alerte si pic anormal sur une école |
| Coût GCP qui dérape | Alerte budget 0 €, plafonds Cloud Functions, agrégats pré-calculés (pas de queries lourdes côté client) |
| Concurrence Ouyapacours | Positionnement « mobile + APE indépendantes + périscolaire + dataviz agglo » |
| Appel d'offres rectoral / récupération institutionnelle | Open data (CC-BY) dès le jour 1, code en open source |
| Contentieux avec une école / un agent | DPO identifié, procédure de retrait sous 72 h, journal d'audit |

---

## 7. Ce qu'il reste à décider avant le MVP

1. **Périmètre géographique de lancement** : une seule agglomération pilote (ex. Métropole de Lyon, Nantes Métropole) ou national d'emblée ?
2. **Statut juridique** : asso loi 1901 portant le traitement RGPD, ou s'adosser à une APE existante ?
3. **Public cible v1** : 1er degré uniquement (plus simple : 1 prof / classe) ou 1er + 2nd degré ?
4. **Inclure le périscolaire dès le v1** ? (différenciant fort, mais nouveau modèle de données : agent municipal, pas EN).
5. **Modèle de validation APE** : adhésion explicite des APE (chaque APE a un compte « modérateur »), ou validation par 2 parents quelconques de la même école ?
6. **Monétisation / soutenabilité** : 100 % bénévole + dons, ou subvention CNAF / collectivités ?

---

## 8. Recommandation de démarrage

Plan en 3 jalons sur ~3 mois temps-plein :

- **J1 — Spec & RGPD** (2 sem) : maquettes Figma, AIPD (analyse d'impact RGPD), CGU, charte APE, choix agglo pilote.
- **J2 — MVP technique** (6 sem) : Flutter + Firebase Auth + Firestore + Functions, ingestion annuaire EN, écrans signalement / validation / dashboard agglo, App Check, alerte budget.
- **J3 — Pilote terrain** (4 sem) : 5–10 APE pilotes sur l'agglo cible, itération UX, premier rapport mensuel public, presse locale.

---

## Sources

- FCPE — campagne « Absences non remplacées, signalez-les » : https://www.fcpe.asso.fr/campagne/absences-non-remplacees-signalez-les
- Ouyapacours (plateforme FCPE) : https://ouyapacours.fcpe.asso.fr/
- Café Pédagogique — Cour des comptes, 10 % d'heures non remplacées (déc. 2025) : https://www.cafepedagogique.net/2025/12/15/cour-des-comptes-10-des-heures-de-cours-non-remplaces-et-des-inegalites-territoriales-sociales-disciplinaires/
- Café Pédagogique — Santé des profs, +43 % d'arrêts en 5 ans : https://www.cafepedagogique.net/2025/12/15/la-cour-des-comptes-alerte-sur-la-sante-des-professeurs-43-darrets-de-travail-en-5-ans/
- Cour des comptes — Rapport « Le temps d'enseignement perdu par les élèves » (PDF, déc. 2025) : https://www.ccomptes.fr/sites/default/files/2025-12/20251212-Temps-enseignement-perdu-par-eleves-au-college_0.pdf
- Cour des comptes — page « La gestion des absences des enseignants » : https://www.ccomptes.fr/fr/publications/la-gestion-des-absences-des-enseignants
- Justice.cool — OnVeutDesProfs : https://www.justice.cool/onveutdesprofs/
- Pitcher Avocat — Comment apporter la preuve de l'absence et du non-remplacement : https://pitcher-avocat.fr/comment-apporter-la-preuve-de-l-absence-de-professeur-et-du-non-remplacement/
- Sénat — Rapport sur le remplacement des enseignants (r24-730) : https://www.senat.fr/rap/r24-730/r24-730_mono.html
- Enfant Différent — Que faire en cas d'absence d'AESH : https://www.enfant-different.org/scolarite/absence-aesh-avs-enfant-ecole/
- École et Handicap — AESH absents, parents désemparés : https://ecole-et-handicap.fr/absence-aesh/
- CNIL — Référentiel GRH : https://www.cnil.fr/sites/default/files/atoms/files/referentiel_grh_novembre_2019_0.pdf
- CNIL — Contenu des documents publiés (anonymisation) : https://www.cnil.fr/fr/quel-peut-etre-le-contenu-des-documents-publies
- API Annuaire de l'Éducation nationale (data.gouv.fr) : https://www.data.gouv.fr/dataservices/annuaire-de-leducation-nationale
- data.education.gouv.fr — Annuaire de l'éducation : https://data.education.gouv.fr/explore/dataset/fr-en-annuaire-education/api/
- Google Cloud — Free Tier : https://cloud.google.com/free
- Firebase — Pricing & quotas Firestore : https://firebase.google.com/pricing
- Firestore quotas : https://docs.cloud.google.com/firestore/quotas
- Cloud Run pricing : https://cloud.google.com/run/pricing
- Cloud Functions pricing : https://cloud.google.com/functions/pricing-1stgen
- Code With Andrea — Starter architecture Flutter & Firebase (Riverpod) : https://codewithandrea.com/videos/starter-architecture-flutter-firebase/
- Flutter docs — Guide to app architecture : https://docs.flutter.dev/app-architecture/guide
- arXiv — Establishing Trust in Crowdsourced Data (2025) : https://arxiv.org/pdf/2511.03016
