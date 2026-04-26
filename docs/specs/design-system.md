# 04 — Design system

Base : **Material 3** (Flutter `useMaterial3: true`). Sobre, institutionnel, accessible. Pas de gamification, pas de couleurs vives en dehors des états.

## Tokens

### Couleurs (mode clair)

| Token | Valeur | Usage |
|---|---|---|
| `primary` | `#1F3A93` | bleu nuit institutionnel — boutons primaires, focus, header |
| `onPrimary` | `#FFFFFF` | texte sur primary |
| `primaryContainer` | `#DCE3F8` | fond léger pour cartes en surbrillance |
| `secondary` | `#3B6E5C` | vert sapin pour stats positives, mais discret |
| `surface` | `#FFFFFF` | cartes, sheets |
| `surfaceContainer` | `#F4F4F6` | fond d'écran |
| `onSurface` | `#111827` | texte principal |
| `onSurfaceVariant` | `#4B5563` | texte secondaire |
| `outline` | `#D1D5DB` | bordures, séparateurs |
| `success` | `#16A34A` | signalement validé |
| `warning` | `#CA8A04` | en attente |
| `error` | `#B91C1C` | rejeté, suppression |
| `info` | `#2563EB` | tooltips, notes |

### Couleurs (mode sombre)
Inverser via `ColorScheme.fromSeed(brightness: Brightness.dark)` à partir du seed `#1F3A93`. Pas de palette manuelle pour la v1 — Flutter génère.

### Typographie
- Famille : **Inter** (fallback `system-ui`).
- Échelle (M3 Type Scale) :
  - `displayMedium` 28 / 36
  - `headlineMedium` 22 / 28
  - `titleMedium` 16 / 24 (CTA, en-têtes carte)
  - `bodyMedium` 14 / 20 (texte courant)
  - `labelLarge` 14 / 20 (boutons)
  - `labelSmall` 11 / 16 (légendes)
- Poids : 400 (regular), 500 (medium), 700 (bold).
- **Pas d'italique**, pas de souligné sauf liens.

### Espacements (4 px base)
`xxs 2`, `xs 4`, `sm 8`, `md 12`, `lg 16`, `xl 24`, `2xl 32`, `3xl 48`.

### Rayons
- Boutons : 24 (pill).
- Cartes : 12.
- Inputs : 8.
- Sheets : 16 (en haut).

### Élévations
- Surface plate par défaut (élévation 0).
- Carte sélectionnée : élévation 1 (M3 surface tint).
- Bottom sheet : élévation 3.
- Pas de drop-shadow profonde, on s'appuie sur les surface tints M3.

### Cibles tactiles
- Minimum **48 × 48 dp**.
- Espacement entre cibles : ≥ 8 dp.

### Iconographie
- **Material Symbols Outlined** (24 px par défaut, 20 dans listes denses).
- Pas d'emoji dans l'UI persistante (toléré dans onboarding pour humaniser).

## Composants

### Bouton primaire (`PrimaryButton`)
- Hauteur 56, padding horizontal 24, label `labelLarge`.
- Couleur fond `primary`, label `onPrimary`.
- État pressé : `primary` opacity 0.92.
- État disabled : `outline` 12 % alpha, label 38 %.

### Bouton secondaire (`SecondaryButton`)
- Outline `outline`, label `primary`.
- Mêmes dimensions que primaire.

### Bouton texte (`TextButton`)
- Pas de fond, label `primary` (M3 default).

### Carte cliquable (`AppCard`)
- Padding 16, rayon 12, fond `surface`.
- Bordure `outline` 1 px en mode clair pour la séparation (M3 ne met pas d'élévation par défaut).
- Variante `selected` : surface tint `primary` + bordure `primary` 1 px.

### Champ de saisie (`AppTextField`)
- M3 `OutlinedInputBorder` rayon 8.
- Label flottant.
- Helper text 12, error text 12 rouge.

### Chip (`AppChip`)
- M3 `FilterChip` ou `ChoiceChip`.
- Hauteur 36, label `labelLarge`.

### Badge de statut (`StatusBadge`)
- Pastille couleur + label.
- Variants : `pending` (jaune), `validated` (vert), `rejected` (rouge), `duplicate` (ambre), `pending_send` (bleu info).

### Barre de progression d'étape (`StepProgress`)
- 6 segments (déclaration), segment courant `primary`, autres `outline` 30 %.

### Bottom navigation (`AppBottomNav`)
- 3 onglets max : « Accueil », « À valider » (APE) ou « Stats » (parent), « Profil ».
- Hauteur 80, M3 `NavigationBar`.

### Modale et sheet
- Confirmations destructives → `AlertDialog` M3 avec bouton primaire `error`.
- Choix multi-options → `BottomSheet`.

## Pattern d'écran

### Layout par défaut
```
┌──────────────────────────────────────┐
│ AppBar (titre + back ou logo)        │
├──────────────────────────────────────┤
│                                      │
│ Contenu scrollable                   │
│ Padding horizontal 16                │
│ Espacement vertical entre blocs : 24 │
│                                      │
├──────────────────────────────────────┤
│ Footer fixe (CTA primaire si flux)   │
└──────────────────────────────────────┘
```

### Écran de saisie multi-étape
- AppBar minimaliste (back + « Étape n/N »).
- `StepProgress` directement sous l'AppBar.
- Une question par écran. Verbe à l'impératif.
- Footer collant avec CTA primaire.

### Écran de liste
- En-tête : titre + compteur.
- Filtres en barre horizontale (chips scrollables).
- Liste virtuelle (`ListView.builder`).
- Pull to refresh.

## Thème Flutter (extrait)

```dart
final ColorScheme schemeLight = ColorScheme.fromSeed(
  seedColor: const Color(0xFF1F3A93),
  brightness: Brightness.light,
);

ThemeData buildTheme(Brightness b) {
  final scheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF1F3A93),
    brightness: b,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: 'Inter',
    visualDensity: VisualDensity.standard,
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: scheme.outline.withValues(alpha: 0.5)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: false,
    ),
  );
}
```

## Voix et ton

- **Tutoiement bannit** par défaut : on vouvoie l'utilisateur (« Vous avez signalé… »).
- **Phrase active**, verbes simples.
- **Pas de jargon administratif** côté parent ; on tolère « APE », « UAI » côté APE/admin.
- **Sobriété** : pas de « Bravo ! », pas de « Merci pour votre contribution ! ». Le ton reste factuel — on traite un sujet sérieux.

Exemples :
- ✅ « Signalement envoyé »
- ❌ « Super, merci pour votre engagement citoyen ! »
- ✅ « Aucune information nominative n'est demandée. »
- ❌ « Pas d'inquiétude, on protège tout. »
