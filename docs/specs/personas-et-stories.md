# 01 — Personas et user stories

## Personas

### Camille — parent, 38 ans
- 2 enfants : un en CM2, un en 4e dans la même ville.
- Travaille à plein temps, ouvre l'app dans le métro à 8 h 15.
- Smartphone Android milieu de gamme, forfait 4G correct mais pas illimité.
- **Attente** : signaler vite l'absence du jour, voir si elle est reprise par d'autres parents, oublier l'app le reste du temps.
- **Frustration historique** : a renoncé à utiliser Ouyapacours après une session web trop longue.

### Karim — président d'APE de collège, 45 ans
- Bénévole, élu pour 2 ans, ~50 e-mails APE par semaine.
- iPhone, à l'aise avec le numérique.
- **Attente** : valider en bloc les signalements crédibles de son collège, repérer les pics, sortir un rapport mensuel à présenter au CA.
- **Frustration historique** : remontées éparpillées entre WhatsApp, Pronote et bouche-à-oreille.

### Léa — admin de la plateforme (= toi pour démarrer)
- Pas développeuse, mais sait lire un tableau de bord.
- Gère 10 à 50 demandes d'adhésion APE par semaine au pic de rentrée.
- **Attente** : un back-office web sobre, file d'attente claire, audit log, action en 2 clics.

### Le public
- Journaliste local qui prépare un papier sur la rentrée.
- Élu municipal qui veut comparer ses écoles.
- Parent qui hésite à s'inscrire et veut voir si l'app a déjà des données chez lui.
- **Attente** : une page web sobre, des graphes lisibles, un export CSV.

---

## User stories

Format : `En tant que <rôle>, je veux <action> afin de <bénéfice>`. Critères d'acceptation listés sous chaque story importante.

### Epic A — Inscription et rattachement

**A1.** En tant que **parent**, je veux créer un compte avec mon e-mail, Google ou Apple afin d'accéder rapidement à l'app.
- AC1 : 3 méthodes proposées sur le même écran.
- AC2 : aucune saisie de mot de passe en cas de Google/Apple.
- AC3 : aucune obligation de saisir le nom de l'enfant.

**A2.** En tant que **parent**, je veux rattacher une ou plusieurs écoles afin de couvrir ma fratrie.
- AC1 : recherche par nom + ville + code postal, ≥ 3 caractères.
- AC2 : suggestion par géolocalisation (opt-in).
- AC3 : maximum 5 écoles par compte (anti-spam).

**A3.** En tant que **membre d'APE**, je veux déclarer mon rattachement à l'APE de mon école et uploader un justificatif afin d'obtenir le rôle de validateur.
- AC1 : 1 école max par demande, 1 demande active à la fois par utilisateur.
- AC2 : formats acceptés PDF/JPG/PNG, 5 Mo max.
- AC3 : mes droits restent ceux d'un parent tant que l'admin n'a pas validé.

**A4.** En tant que **membre d'APE**, je veux pouvoir demander une double-vérification par mail public afin d'accélérer ma validation.
- AC1 : champ e-mail pré-rempli depuis l'annuaire EN si disponible.
- AC2 : mail envoyé au clic, lien magique signé valable 7 jours.
- AC3 : statut « mail_verified » visible côté admin, mais l'admin garde le dernier mot.

### Epic B — Déclaration

**B1.** En tant que **parent**, je veux signaler une absence en moins de 30 secondes afin de ne pas y passer ma matinée.
- AC1 : écran d'accueil expose un CTA primaire « Signaler ».
- AC2 : 4 à 6 écrans de saisie max, défaut intelligent à chaque étape.
- AC3 : confirmation atomique en bas du dernier écran.

**B2.** En tant que **parent**, je veux que l'app s'adapte au niveau de mon enfant afin de ne pas me poser de questions inutiles.
- AC1 : si école = maternelle/élémentaire, pas de question sur la discipline.
- AC2 : si école = collège/lycée + agent prof, la discipline devient obligatoire.
- AC3 : si agent = AESH/ATSEM/CPE/AED/cantine/garderie/étude, pas de discipline.

**B3.** En tant que **parent**, je veux signaler hors ligne afin de pouvoir saisir devant la grille de l'école sans réseau.
- AC1 : la déclaration se met en file d'attente locale.
- AC2 : badge « en attente d'envoi » visible.
- AC3 : sync automatique au retour du réseau, notification de succès.

**B4.** En tant que **parent**, je veux modifier ou supprimer mon signalement avant validation afin de corriger une erreur.
- AC1 : fenêtre de modification : tant que `status='pending'`.
- AC2 : suppression possible à tout moment (RGPD).

### Epic C — Validation

**C1.** En tant que **membre d'APE validé**, je veux voir la file des signalements en attente de mon école afin de les traiter par lots.
- AC1 : tri par date décroissante.
- AC2 : filtres rapides : agent, niveau, discipline, période.
- AC3 : compteur en badge sur l'icône de l'app (FCM topic).

**C2.** En tant que **membre d'APE**, je veux valider, rejeter ou marquer en doublon en deux taps afin d'aller vite.
- AC1 : actions au swipe + boutons de bas d'écran.
- AC2 : commentaire optionnel, jamais nominatif.
- AC3 : mes rejets motivés permettent au parent d'apprendre (« date hors fenêtre », « doublon », etc.).

**C3.** En tant que **membre d'APE**, je veux fusionner deux signalements doublons afin de ne pas gonfler les stats.
- AC1 : sélection multiple → action « fusionner ».
- AC2 : un signalement maître est désigné, les autres référencent son ID.

### Epic D — Administration

**D1.** En tant qu'**admin**, je veux voir la file des demandes d'adhésion APE afin de les traiter au fil de l'eau.
- AC1 : tri par ancienneté.
- AC2 : aperçu de la pièce uploadée + info utilisateur.
- AC3 : actions : approuver, rejeter (avec motif), demander mail de double-vérif.

**D2.** En tant qu'**admin**, je veux résoudre les conflits (deux APE sur la même école) afin de garantir le principe « 1 APE par école ».
- AC1 : alerte automatique en cas de seconde demande sur une école déjà rattachée.
- AC2 : possibilité de transférer le rattachement APE d'un compte à un autre.

**D3.** En tant qu'**admin**, je veux valider directement les signalements orphelins (école sans APE) afin de ne pas bloquer le système.
- AC1 : file dédiée séparée de la file APE.
- AC2 : validation marquée `validatedBy.role='admin'` pour transparence.

**D4.** En tant qu'**admin**, je veux retirer un signalement ou un compte sur réclamation RGPD afin de respecter mes obligations légales.
- AC1 : action tracée dans un journal d'audit (qui, quand, motif).
- AC2 : suppression effective sous 30 jours (purge par Cloud Function).

### Epic E — Public et statistiques

**E1.** En tant que **visiteur** (non connecté), je veux consulter les stats de mon école / commune / agglo / département / France afin de me faire mon opinion.
- AC1 : URL publique stable type `/stats/school/0750001A`, partageable.
- AC2 : seuils de k-anonymat respectés (≥ 3 signalements distincts par maille).
- AC3 : export CSV libre (CC-BY).

**E2.** En tant que **journaliste**, je veux télécharger un jeu agrégé par mois afin de réaliser une cartographie.
- AC1 : ZIP d'archives mensuelles regénéré chaque nuit.
- AC2 : licence CC-BY explicite + DOI/permalien.

**E3.** En tant que **parent**, je veux suivre l'évolution mensuelle de mon école afin de mesurer si la situation s'améliore.
- AC1 : graphe 12 derniers mois sur la fiche école.
- AC2 : comparaison avec la moyenne de la commune et de l'agglo.

### Epic F — Notifications et compte

**F1.** En tant que **parent**, je veux recevoir une notification quand mon signalement est validé / rejeté afin de comprendre la suite.
- AC1 : push FCM + entrée dans l'historique.
- AC2 : opt-in clair lors de l'onboarding.

**F2.** En tant qu'**utilisateur**, je veux exporter mes données et supprimer mon compte afin d'exercer mes droits RGPD.
- AC1 : export JSON depuis le profil.
- AC2 : suppression instantanée du compte, anonymisation (et non suppression) des signalements validés pour préserver la cohérence des stats.

---

## Hors-périmètre v1 (volontairement)

- Discussions / chat entre parents.
- Évaluation/notation des établissements.
- Intégration ENT (Pronote, EcoleDirecte, etc.).
- Notifications hyperlocales en temps réel (« 12 parents viennent de signaler le même prof » → risque de chasse à l'agent).
- Appels à l'action juridique (laissé à OnVeutDesProfs / Justice.cool).
