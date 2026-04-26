# 03 — Wireframes ASCII

Largeur de référence : 40 colonnes (mental model mobile portrait). En-tête `┌──┐`, contenu, footer `└──┘`. Les CTA primaires sont en MAJUSCULES.

---

## E.01 Onboarding (slide 2/3)

```
┌──────────────────────────────────────┐
│                                  ⨯   │
│                                      │
│         [illustration sobre]         │
│                                      │
│                                      │
│   Votre APE valide                   │
│   les signalements                   │
│                                      │
│   Seuls les membres validés          │
│   d'une APE rattachée à votre        │
│   école peuvent confirmer un         │
│   signalement. Les chiffres          │
│   publics ne montrent que les        │
│   signalements validés.              │
│                                      │
│        ●  ●  ○                       │
│                                      │
│   ┌──────────────────────────────┐  │
│   │          SUIVANT             │  │
│   └──────────────────────────────┘  │
│   Passer                             │
└──────────────────────────────────────┘
```

---

## E.02 Login / Signup

```
┌──────────────────────────────────────┐
│                                      │
│              [logo 64px]             │
│                                      │
│            école-asso                │
│   Signaler les absences non          │
│        remplacées                    │
│                                      │
│   ┌──────────────────────────────┐  │
│   │  G  Continuer avec Google    │  │
│   └──────────────────────────────┘  │
│   ┌──────────────────────────────┐  │
│   │     Continuer avec Apple     │  │
│   └──────────────────────────────┘  │
│                                      │
│   ─────────  ou  ──────────          │
│                                      │
│   E-mail                             │
│   ┌──────────────────────────────┐  │
│   │ vous@exemple.fr              │  │
│   └──────────────────────────────┘  │
│   Mot de passe                       │
│   ┌──────────────────────────────┐  │
│   │ ••••••••                  👁  │  │
│   └──────────────────────────────┘  │
│                                      │
│   ┌──────────────────────────────┐  │
│   │           CONTINUER          │  │
│   └──────────────────────────────┘  │
│                                      │
│   Mot de passe oublié ?              │
│                                      │
│   En continuant, j'accepte les       │
│   CGU et la politique de             │
│   confidentialité.                   │
└──────────────────────────────────────┘
```

---

## E.03 Choix du rôle

```
┌──────────────────────────────────────┐
│  ←  Bienvenue                        │
│                                      │
│  Comment souhaitez-vous              │
│  utiliser l'application ?            │
│                                      │
│  ┌────────────────────────────────┐ │
│  │  👨‍👩‍👧  Je suis parent           │ │
│  │                                │ │
│  │  Je signale les absences       │ │
│  │  observées dans l'école de     │ │
│  │  mon enfant.                   │ │
│  │                          ›     │ │
│  └────────────────────────────────┘ │
│                                      │
│  ┌────────────────────────────────┐ │
│  │  🏛  Je suis membre d'une APE  │ │
│  │                                │ │
│  │  Je peux valider les           │ │
│  │  signalements de l'école       │ │
│  │  rattachée à mon APE.          │ │
│  │  Validation manuelle requise.  │ │
│  │                          ›     │ │
│  └────────────────────────────────┘ │
└──────────────────────────────────────┘
```

---

## E.04 Recherche école

```
┌──────────────────────────────────────┐
│  ←  Mon ou mes établissements        │
│                                      │
│  ┌──────────────────────────────┐   │
│  │ 🔍 Nom, ville, code postal   │   │
│  └──────────────────────────────┘   │
│                                      │
│  📍 Utiliser ma position             │
│                                      │
│  Résultats                           │
│                                      │
│  ┌──────────────────────────────┐   │
│  │ Collège Jean Moulin          │   │
│  │ 75011 Paris  ·  Public       │   │
│  │ UAI 0750001A             [+] │   │
│  └──────────────────────────────┘   │
│                                      │
│  ┌──────────────────────────────┐   │
│  │ École élém. Boulets          │   │
│  │ 75011 Paris  ·  Public       │   │
│  │ UAI 0750014X             [+] │   │
│  └──────────────────────────────┘   │
│                                      │
│  Sélectionnés (1)                    │
│  • Collège Jean Moulin     [×]       │
│                                      │
│  ┌──────────────────────────────┐   │
│  │           CONTINUER          │   │
│  └──────────────────────────────┘   │
└──────────────────────────────────────┘
```

---

## E.10 Home parent (état nominal)

```
┌──────────────────────────────────────┐
│  école-asso                    👤    │
│                                      │
│  Collège Jean Moulin                 │
│  Paris 11e  ·  Public                │
│                                      │
│  ┌────────────────────────────────┐ │
│  │                                │ │
│  │   ⊕  SIGNALER UNE ABSENCE     │ │
│  │                                │ │
│  └────────────────────────────────┘ │
│                                      │
│  Mes signalements                    │
│                                      │
│  ┌──────────────────────────────┐   │
│  │ 🟡 En attente de validation  │   │
│  │ Maths · 4e · 22 avril · 1 h  │   │
│  └──────────────────────────────┘   │
│  ┌──────────────────────────────┐   │
│  │ 🟢 Validé                    │   │
│  │ AESH · 6e · 18 avril · 1 j   │   │
│  └──────────────────────────────┘   │
│  ┌──────────────────────────────┐   │
│  │ 🔴 Rejeté · doublon          │   │
│  │ Anglais · 4e · 15 avril      │   │
│  └──────────────────────────────┘   │
│                                      │
│  Voir tout (12) ›                    │
│                                      │
│  ─────────────────────                │
│  Stats publiques de mon établissement│
│  Heures perdues ce mois : 47 h       │
│  Voir le détail ›                    │
└──────────────────────────────────────┘
```

---

## E.21 Type d'agent (déclaration, étape 2/6)

```
┌──────────────────────────────────────┐
│  ←  Signaler · 2/6                   │
│  ████░░░░░░░░░░░░░░░░░░░             │
│                                      │
│  Quel type d'agent ?                 │
│                                      │
│  ┌─────────────┐  ┌─────────────┐   │
│  │             │  │             │   │
│  │  Enseignant │  │    AESH     │   │
│  │             │  │             │   │
│  └─────────────┘  └─────────────┘   │
│  ┌─────────────┐  ┌─────────────┐   │
│  │             │  │             │   │
│  │   ATSEM     │  │  Animateur  │   │
│  │ (maternelle)│  │   ALSH      │   │
│  └─────────────┘  └─────────────┘   │
│  ┌─────────────┐  ┌─────────────┐   │
│  │             │  │             │   │
│  │     AED     │  │     CPE     │   │
│  │ (surveillant│  │             │   │
│  └─────────────┘  └─────────────┘   │
│  ┌─────────────┐  ┌─────────────┐   │
│  │             │  │             │   │
│  │   Cantine   │  │  Garderie   │   │
│  │             │  │  / Étude    │   │
│  └─────────────┘  └─────────────┘   │
└──────────────────────────────────────┘
```

---

## E.24 Date et durée (étape 4/6)

```
┌──────────────────────────────────────┐
│  ←  Signaler · 4/6                   │
│  ██████████████░░░░░░░░░             │
│                                      │
│  Quand et combien de temps ?         │
│                                      │
│  Date                                │
│  ┌──────────────────────────────┐   │
│  │ Aujourd'hui · 25 avril 2026  │   │
│  │                          📅  │   │
│  └──────────────────────────────┘   │
│                                      │
│  Durée                               │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐        │
│  │ 1h │ │ 2h │ │ 3h │ │ 4h │        │
│  └────┘ └────┘ └────┘ └────┘        │
│  ┌────┐ ┌────┐ ┌──────────┐         │
│  │ 5h │ │ 6h │ │  ≥7 h    │         │
│  └────┘ └────┘ └──────────┘         │
│                                      │
│                                      │
│  ┌──────────────────────────────┐   │
│  │           CONTINUER          │   │
│  └──────────────────────────────┘   │
└──────────────────────────────────────┘
```

---

## E.27 Récap (étape 6/6)

```
┌──────────────────────────────────────┐
│  ←  Signaler · 6/6                   │
│  █████████████████████████           │
│                                      │
│  Vérifiez et envoyez                 │
│                                      │
│  École                               │
│  Collège Jean Moulin · Paris 11e     │
│                                      │
│  Type d'agent                        │
│  Enseignant                          │
│                                      │
│  Niveau                              │
│  4e                                  │
│                                      │
│  Discipline                          │
│  Mathématiques                       │
│                                      │
│  Date · Durée                        │
│  25 avril 2026 · 1 h                 │
│                                      │
│  Remplacé ?                          │
│  Non                                 │
│                                      │
│  Contexte                            │
│  Absence                             │
│                                      │
│  ⓘ Aucune information nominative     │
│    n'est demandée ni transmise.      │
│                                      │
│  ┌──────────────────────────────┐   │
│  │           ENVOYER            │   │
│  └──────────────────────────────┘   │
│  Modifier                            │
└──────────────────────────────────────┘
```

---

## E.28 Confirmation

```
┌──────────────────────────────────────┐
│                                      │
│              ✓                       │
│         (cercle vert 64)             │
│                                      │
│        Signalement envoyé            │
│                                      │
│   Il sera publié dans les            │
│   statistiques après validation      │
│   par votre APE.                     │
│                                      │
│   Délai habituel : 48 h.             │
│                                      │
│                                      │
│   ┌──────────────────────────────┐  │
│   │          RETOUR              │  │
│   └──────────────────────────────┘  │
│   Signaler une autre absence         │
└──────────────────────────────────────┘
```

---

## E.40 File de validation (APE)

```
┌──────────────────────────────────────┐
│  À valider · Collège Jean Moulin     │
│                              ⚙       │
│  12 en attente                       │
│                                      │
│  [ Tous ▾ ] [ 7 jours ▾ ]   ⤓       │
│                                      │
│  ┌──────────────────────────────┐   │
│  │ ☐  Maths · 4e                │   │
│  │    25 avr · 1 h · non rempl. │   │
│  │    par anonyme #2841          │   │
│  └──────────────────────────────┘   │
│  ┌──────────────────────────────┐   │
│  │ ☐  AESH · 6e                 │   │
│  │    24 avr · 1 j · non rempl. │   │
│  │    par anonyme #2812          │   │
│  └──────────────────────────────┘   │
│  ┌──────────────────────────────┐   │
│  │ ☐  Anglais · 3e              │   │
│  │    24 avr · 2 h · oui rempl. │   │
│  │    par anonyme #2799          │   │
│  └──────────────────────────────┘   │
│                                      │
│  [Long-press pour sélection multiple]│
│                                      │
│ ┌─────────┬─────────┬──────────────┐ │
│ │ HOME    │ VALIDER │ MES STATS    │ │
│ └─────────┴─────────┴──────────────┘ │
└──────────────────────────────────────┘
```

---

## E.41 Détail signalement (validation)

```
┌──────────────────────────────────────┐
│  ←  Signalement #2841                │
│                                      │
│  Collège Jean Moulin                 │
│                                      │
│  Type d'agent : Enseignant           │
│  Niveau       : 4e                   │
│  Discipline   : Mathématiques        │
│  Date         : 25 avril 2026        │
│  Durée        : 1 h                  │
│  Remplacé     : Non                  │
│  Contexte     : Absence              │
│                                      │
│  Reçu il y a 2 h                     │
│                                      │
│  Aucune information nominative       │
│  n'a été transmise par le déclarant. │
│                                      │
│                                      │
│ ┌────────────┬─────────┬──────────┐  │
│ │  REJETER   │ DOUBLON │ VALIDER  │  │
│ │   (rouge)  │ (ambre) │  (vert)  │  │
│ └────────────┴─────────┴──────────┘  │
└──────────────────────────────────────┘
```

---

## E.50 Home admin (vue mobile, identique sur Web)

```
┌──────────────────────────────────────┐
│  Admin · école-asso                  │
│                                      │
│  ⚠  À traiter                        │
│                                      │
│  ┌──────────────────────────────┐   │
│  │ 📋 Adhésions APE en attente  │   │
│  │     7 demandes              › │   │
│  └──────────────────────────────┘   │
│  ┌──────────────────────────────┐   │
│  │ ⚠  Conflits APE              │   │
│  │     2 écoles                › │   │
│  └──────────────────────────────┘   │
│  ┌──────────────────────────────┐   │
│  │ 🏫 Signalements orphelins    │   │
│  │     14 sans APE rattachée   › │   │
│  └──────────────────────────────┘   │
│  ┌──────────────────────────────┐   │
│  │ 📜 Journal d'audit           │   │
│  │     Voir les actions        › │   │
│  └──────────────────────────────┘   │
└──────────────────────────────────────┘
```

---

## E.61 Page maille publique (commune)

```
┌──────────────────────────────────────┐
│  ←  Paris 11e arrondissement         │
│                                      │
│  Avril 2026                          │
│                                      │
│  ┌────────┬────────┬────────┐        │
│  │ 412 h  │  18 %  │   23   │        │
│  │ perdues│ rempl. │ écoles │        │
│  └────────┴────────┴────────┘        │
│                                      │
│  Évolution sur 12 mois               │
│  ┌────────────────────────────────┐ │
│  │     ▁▃▅▆█▇▅▄▃▂▃▆               │ │
│  │ Mai            ──→         Avr │ │
│  └────────────────────────────────┘ │
│                                      │
│  Top 5 établissements impactés       │
│  1. Collège Jean Moulin   · 87 h     │
│  2. Lycée Voltaire        · 64 h     │
│  3. École élém. Boulets   · 52 h     │
│  4. Collège Beaumarchais  · 48 h     │
│  5. École mat. Charonne   · 31 h     │
│                                      │
│  ⤓  Exporter (CSV) · CC-BY           │
└──────────────────────────────────────┘
```

---

## E.70 Profil

```
┌──────────────────────────────────────┐
│  ←  Profil                           │
│                                      │
│  vous@exemple.fr                     │
│  Compte parent · membre depuis avr.  │
│                                      │
│  Mes écoles                          │
│  • Collège Jean Moulin       [×]     │
│  • École élém. Boulets       [×]     │
│  + Ajouter une école                 │
│                                      │
│  Notifications                       │
│  ◯ Validation de mes signalements ✓ │
│  ◯ Rappel quotidien (8 h 30)      ✗ │
│                                      │
│  ─────────────────────                │
│  RGPD                                │
│  ⤓ Exporter mes données              │
│  🗑 Supprimer mon compte             │
│                                      │
│  ─────────────────────                │
│  À propos                            │
│  CGU                                 │
│  Politique de confidentialité        │
│  Code source (GitHub)                │
│  Version 1.0.0                       │
│                                      │
│  Se déconnecter                      │
└──────────────────────────────────────┘
```

---

## Liste complète des écrans v1

| ID | Écran | Rôle requis |
|---|---|---|
| E.01 | Onboarding (3 slides) | aucun |
| E.02 | Login / Signup | aucun |
| E.03 | Choix du rôle | utilisateur authentifié |
| E.04 | Recherche école | utilisateur |
| E.05 | Confirmation rattachement | utilisateur |
| E.06 | Opt-in notifications | utilisateur |
| E.07 | Upload preuve APE | utilisateur APE candidat |
| E.08 | État de la demande APE | utilisateur APE candidat |
| E.10 | Home parent | parent |
| E.11 | Home APE | ape |
| E.12 | Mes signalements | parent / ape |
| E.20 | Choix école (déclaration) | parent |
| E.21 | Type d'agent | parent |
| E.22 | Niveau | parent |
| E.23 | Discipline | parent |
| E.24 | Date + durée | parent |
| E.25 | Remplacé ? | parent |
| E.26 | Contexte | parent |
| E.27 | Récap | parent |
| E.28 | Confirmation | parent |
| E.40 | File de validation | ape |
| E.41 | Détail signalement | ape |
| E.50 | Home admin | admin |
| E.51 | File adhésions APE | admin |
| E.52 | Détail demande APE | admin |
| E.60 | Carte de France stats | aucun |
| E.61 | Page maille (commune/agglo/dep/national) | aucun |
| E.62 | Page école | aucun |
| E.70 | Profil | utilisateur |
| E.71 | Confirmation suppression | utilisateur |
