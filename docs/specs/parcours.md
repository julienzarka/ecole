# 02 — Parcours utilisateur

Chaque parcours est décrit avec : déclencheur, étapes, branches conditionnelles, sortie. Les références d'écrans (`E.xx`) renvoient à [`ecrans.md`](./ecrans.md).

---

## P1 — Première ouverture (parent)

```
Splash (logo, 800 ms max)
   │
   ▼
E.01 Onboarding (3 slides skippables)
   │   slide 1 : « Signalez en 30 sec »
   │   slide 2 : « Votre APE valide »
   │   slide 3 : « Stats publiques par école »
   │
   ▼
E.02 Login / Signup
   ├─ Continuer avec Google ─┐
   ├─ Continuer avec Apple   │
   └─ E-mail + mot de passe ─┤
                              │
                              ▼
                    E.03 Choix du rôle
                       ├─ « Je suis parent »  ─────────────┐
                       └─ « Je suis membre d'une APE » ─┐  │
                                                        │  │
                                                        ▼  ▼
                                              E.04 Recherche école
                                                        │
                                                        ▼
                                              E.05 Confirmation rattachement
                                                        │
                              ┌─────────────────────────┴────────┐
                              ▼ (parent)                          ▼ (APE)
                       E.06 Demande           E.07 Upload preuve + claimedRole
                       opt-in notifs                       │
                              │                            ▼
                              ▼                  E.08 Demande envoyée (pending)
                       E.10 Home parent                   │
                                                          ▼
                                                E.10 Home (rôle parent par défaut
                                                tant que admin n'a pas validé)
```

**Notes** :
- L'utilisateur APE peut **utiliser l'app comme parent** dès l'inscription. La validation admin lui débloque seulement la file de validation.
- L'opt-in notifications respecte le système (Android 13+, iOS).
- E-mail/mot de passe propose une vérif e-mail mais elle n'est pas bloquante pour la déclaration.

---

## P2 — Signalement d'une absence (parent)

Cible : **30 secondes**, 4 à 6 taps.

```
E.10 Home parent
   │  CTA primaire : « Signaler une absence »
   ▼
E.20 Choix école (skippé si une seule école rattachée)
   │
   ▼
E.21 Type d'agent (grille de 8 cartes)
   │   teacher | aesh | atsem | animator | aed | cpe | cantine | etude
   │
   ▼
E.22 Niveau (chips)
   │   maternelle: PS, MS, GS
   │   élémentaire: CP, CE1, CE2, CM1, CM2
   │   collège: 6e, 5e, 4e, 3e
   │   lycée: 2nde, 1ère, terminale
   │   (filtré selon le type d'établissement de l'école rattachée)
   │
   ▼
[branche]
   ├─ Si agentType=teacher ET schoolStage∈{collège,lycée} :
   │      E.23 Discipline (chips)
   │
   └─ Sinon : skip
   │
   ▼
E.24 Date + durée
   │   défaut : aujourd'hui, durée selon agent
   │   - teacher 1er degré + AESH/ATSEM : « demi-journée » / « journée »
   │   - teacher 2nd degré : nb d'heures (1, 2, 3, 4, 5, 6, ≥7)
   │   - cantine : « 1 repas »
   │   - garderie/etude : « 1 service »
   │
   ▼
E.25 Remplacé ?  (3 boutons : Oui / Non / Je ne sais pas)
   │
   ▼
E.26 Contexte    (4 boutons : absence / grève / formation / inconnu)
   │
   ▼
E.27 Récap + bouton « Envoyer »
   │
   ▼
[branche réseau]
   ├─ En ligne : envoi → E.28 Confirmation « Envoyé, en attente de validation »
   │
   └─ Hors-ligne : enfilé localement → E.28' « Sera envoyé dès la reconnexion »
                                   │
                                   ▼
                                 E.10 Home (badge « 1 en attente d'envoi »)
```

**Règles de validation à chaque étape** :
- Pas de retour-arrière destructeur : la barre de progression haute permet de revenir sans perdre les choix précédents.
- Date : refuse les dates > aujourd'hui ; refuse les dates antérieures à 30 jours (paramétrable côté serveur).
- Détection de doublon côté client : si même école + même date + même agentType + même level dans les 5 minutes précédentes → propose « Vous avez déjà signalé ceci, modifier ? ».

---

## P3 — Demande d'adhésion APE (utilisateur APE)

```
E.07 Upload preuve
   │   - choix d'école unique (sélection précédente)
   │   - rôle déclaré : président | trésorier | secrétaire | membre
   │   - upload obligatoire (PDF/JPG/PNG, 5 Mo max)
   │   - case « J'autorise l'envoi d'un mail à l'adresse publique de l'APE »
   │
   ▼
E.08 État de la demande
   │   timeline : envoyée → mail envoyé (opt) → validée par admin → rôle débloqué
   │   - notif push à chaque étape
   │
   ▼ [admin valide]
E.10 Home APE (déverrouillé)
```

**Branches admin** :
- Approuvée → notif « Votre rôle de validateur est actif ».
- Rejetée → notif avec motif visible dans E.08 ; possibilité de soumettre une nouvelle demande après 24 h.
- Mail public envoyé → champ « En attente de votre confirmation par mail » dans E.08 ; lien magique signé valable 7 jours.

---

## P4 — Validation d'un signalement (APE)

```
E.10 Home APE
   │  Onglet « À valider » avec compteur (badge)
   ▼
E.40 File de validation
   │  - liste paginée, 20 items / page
   │  - filtres : agent, niveau, discipline, période
   │  - tri : date desc (par défaut)
   │
   ▼ [tap sur un item]
E.41 Détail signalement
   │  - infos structurées (école, niveau, agent, date, durée, remplacé, contexte)
   │  - aucune donnée nominative
   │  - 3 actions :
   │       Valider          → vert
   │       Rejeter           → rouge (motif obligatoire dans une liste codifiée)
   │       Marquer doublon  → ambre, choix du signalement maître
   │
   ▼
E.42 Confirmation discrète + retour automatique à E.40
```

**Actions par lot** depuis E.40 :
- Sélection multiple via long-press → bouton flottant « Valider X » / « Rejeter X ».
- Confirmation modale unique pour le lot.

---

## P5 — Administration (admin)

```
E.50 Home admin (web responsive, mais adapté mobile)
   │  3 sections en colonne :
   │     - Demandes APE en attente (n)
   │     - Conflits APE détectés (n)
   │     - Signalements orphelins (école sans APE) (n)
   │
   ▼ [section Demandes APE]
E.51 File des demandes APE
   │  - infos utilisateur (e-mail, date d'inscription)
   │  - infos demande (école, rôle déclaré, statut mail)
   │  - aperçu pièce jointe
   │
   ▼ [tap sur demande]
E.52 Détail + actions
   │  - bouton « Approuver »
   │  - bouton « Demander vérification mail » (si pas encore fait)
   │  - bouton « Rejeter » avec motif obligatoire
   │
   ▼ [écho retour à E.51]
```

**Audit log** : toute action admin écrit une entrée immuable dans `auditLog/{id}` (qui, quoi, quand, ID cible, motif, IP, user-agent). Lecture admin only.

---

## P6 — Consultation des stats publiques (visiteur, sans compte)

```
URL https://app.ecole.example.fr/stats
   │
   ▼
E.60 Carte de France
   │  - choropleth par département
   │  - barre de recherche : commune, école, code postal, UAI
   │
   ▼ [recherche ou clic]
E.61 Page maille (ex. agglo Lyon Métropole)
   │  - 3 chiffres-clés : heures perdues, taux de remplacement, écoles couvertes
   │  - graphe 12 mois
   │  - tableau top 10 écoles les plus impactées (anonymisé si seuil non atteint)
   │  - lien export CSV
   │
   ▼ [clic école]
E.62 Page école (UAI)
   │  - carte d'identité (annuaire EN)
   │  - chiffres-clés agrégés
   │  - pas de vue par enseignant ni par classe
```

**K-anonymat** : si une maille n'a pas atteint **≥ 3 signalements distincts validés** ET **≥ 2 parents distincts** sur la période demandée, on affiche « Données insuffisantes » plutôt qu'un chiffre.

---

## P7 — Suppression de compte (RGPD)

```
E.10 Home parent / APE
   │  → Profil
   ▼
E.70 Profil
   │  - bouton « Exporter mes données » (JSON, mail dans 24 h max)
   │  - bouton « Supprimer mon compte » (rouge, en bas)
   │
   ▼
E.71 Confirmation suppression
   │  - rappel : signalements validés conservés mais anonymisés (cf. RGPD doc)
   │  - case « Je comprends » obligatoire
   │  - bouton « Supprimer définitivement »
   │
   ▼ [serveur]
   ├─ Cloud Function delete-user :
   │    1. désassocie reporterUid des reports → reporterUid='deleted'
   │    2. supprime users/{uid}, apeMembershipRequests/{uid}
   │    3. supprime auth user
   │    4. log dans auditLog
   │
   ▼
   Écran de fin (« Compte supprimé »), retour vers E.01
```

---

## Diagramme synthétique des états d'un signalement

```
[brouillon local]   ─envoi─▶   pending
                                  │
                  ┌───────────────┼─────────────┐
                  ▼               ▼             ▼
              validated       rejected      duplicate
                  │               │             │
                  └──── stats publiques ────────┘
                  (validated et duplicate-master uniquement)
```

---

## Diagramme synthétique des états d'une demande d'adhésion APE

```
pending  ──▶  mail_sent (optionnel)  ──▶  mail_verified (optionnel)
   │                                                │
   │                                                ▼
   └────────────────────▶  approved   ──▶  user.role = 'ape'
                                  │
                                  ▼
                              rejected (motif)
```
