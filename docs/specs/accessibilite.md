# 06 — Accessibilité

Objectif : **WCAG 2.2 niveau AA** sur toutes les interfaces (mobile + Web).

## Contrastes
- Texte courant ≥ **4,5:1** sur le fond.
- Texte large (≥ 18 pt ou 14 pt gras) ≥ **3:1**.
- Composants UI (icônes, bordures interactives) ≥ **3:1**.
- Vérifié manuellement sur la palette définie dans `design-system.md`. CI : règle de lint optionnelle (`pa11y` sur version Web).

## Cibles tactiles
- ≥ **48 × 48 dp** (WCAG 2.5.5 niveau AAA visé pour mobile).
- Espacement entre cibles ≥ 8 dp.
- Boutons en footer fixe pour usage à une main.

## Lecteur d'écran
- Tous les `IconButton` ont un `tooltip` ou `Semantics(label: ...)`.
- Les images décoratives sont marquées `Semantics(excludeSemantics: true)`.
- Les écrans annoncent leur titre à l'arrivée (`Semantics(header: true)`).
- Ordre de focus logique (de haut en bas, gauche à droite).
- Les états (validé / rejeté / en attente) sont annoncés en plus de la couleur, jamais par couleur seule.

## Taille dynamique du texte
- L'app respecte le `MediaQuery.textScaler` jusqu'à **2.0×** sans tronquer.
- Pas de hauteur fixe sur des conteneurs de texte.
- Tests : `flutter test` avec `MediaQuery(textScaler: TextScaler.linear(1.5))`.

## Mouvements et animations
- Respecter `MediaQuery.disableAnimations` (système iOS / Android `Reduce motion`).
- Pas d'auto-play vidéo. Pas de parallaxe. Pas de clignotement.
- Transitions ≤ 250 ms.

## Saisie clavier (Web et tablette avec clavier)
- Tous les éléments interactifs sont `Focusable`.
- Anneau de focus visible (M3 par défaut).
- `Tab` parcourt dans l'ordre logique.
- `Esc` ferme les modales et bottom sheets.
- `Enter` valide les formulaires.

## Couleur jamais seule porteuse d'information
- Statuts : pastille de couleur **+ libellé textuel**.
- Graphes : motifs ou icônes en complément des couleurs.

## Erreurs et messages
- Toujours un texte (pas seulement une couleur de bordure).
- Le message est **associé** au champ via `Semantics.label` + `Field.errorText`.

## Internationalisation
- Tout le texte passe par `intl` (clés FR pour la v1).
- Pas de texte hardcodé dans les widgets.
- Les dates et durées via `intl.DateFormat.yMMMMd('fr_FR')`.

## Tests d'accessibilité minimum (CI)
- Test widget `AccessibilityGuideline.androidTapTargetGuideline`.
- Test widget `AccessibilityGuideline.textContrastGuideline`.
- Test widget `AccessibilityGuideline.labeledTapTargetGuideline`.

```dart
testWidgets('home screen meets a11y guidelines', (tester) async {
  await tester.pumpWidget(const MyApp());
  final handle = tester.ensureSemantics();
  await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  await expectLater(tester, meetsGuideline(textContrastGuideline));
  handle.dispose();
});
```
