# 05 — États, messages, copywriting FR

## États génériques

### Chargement
- **< 200 ms** : aucun indicateur (le rendu suffit).
- **200 ms – 1 s** : spinner indéterminé (`CircularProgressIndicator` M3, taille 24).
- **> 1 s** : skeletons sur les zones de contenu.
- **Bouton** en cours : libellé remplacé par spinner inline, état `disabled`.

### Vide
Toujours un visuel discret + un message + une action si pertinent.

| Écran | Vide | Texte | Action |
|---|---|---|---|
| Mes signalements | jamais signalé | « Aucun signalement pour l'instant. » | « Signaler une absence » |
| File de validation APE | rien à valider | « Tout est à jour. » | — |
| Recherche école | 0 résultat | « Aucun établissement trouvé pour cette recherche. » | « Élargir la recherche » |
| Stats école | 0 donnée | « Données insuffisantes pour cet établissement. » | « En savoir plus » |
| Demandes APE (admin) | rien en file | « Aucune demande en attente. » | — |

### Erreur réseau
Bandeau persistant en haut, fond `error` 10 %, label `error`.
Texte : « Pas de connexion. Vos signalements seront envoyés au retour du réseau. »

### Erreur serveur (5xx)
Modale unique :
- Titre : « Une erreur est survenue »
- Corps : « Réessayez dans un instant. Si le problème persiste, contactez-nous. »
- Boutons : `RÉESSAYER` (primaire) · `Fermer`

### Erreur d'autorisation (signalement refusé par règle Firestore)
Modale :
- Titre : « Action impossible »
- Corps : varie selon le code remonté par la Cloud Function.

## Messages d'erreur de validation (saisie)

| Champ | Cas | Message |
|---|---|---|
| Email | format invalide | « Cette adresse e-mail n'a pas le bon format. » |
| Mot de passe | < 8 car. | « Le mot de passe doit contenir au moins 8 caractères. » |
| École | aucune sélectionnée | « Sélectionnez au moins un établissement. » |
| Date | futur | « La date ne peut pas être dans le futur. » |
| Date | > 30 j | « Vous ne pouvez signaler que les 30 derniers jours. » |
| Discipline | manquante (2nd degré) | « Précisez la discipline concernée. » |
| Durée | non choisie | « Indiquez la durée de l'absence. » |
| Pièce jointe | > 5 Mo | « Le fichier dépasse 5 Mo. » |
| Pièce jointe | format | « Seuls les PDF, JPG et PNG sont acceptés. » |

## Notifications push (FCM)

| Événement | Cible | Titre | Corps |
|---|---|---|---|
| Signalement validé | parent | « Signalement validé » | « Votre signalement du {date} a été validé par votre APE. » |
| Signalement rejeté | parent | « Signalement non retenu » | « Motif : {motif}. » |
| Demande APE approuvée | utilisateur | « Vous êtes validateur·ice » | « Vous pouvez maintenant valider les signalements de {école}. » |
| Demande APE rejetée | utilisateur | « Demande APE non retenue » | « Motif : {motif}. Vous pouvez en soumettre une nouvelle. » |
| Nouveaux signalements à valider | APE | « {n} nouveaux signalements » | « À valider pour {école}. » |

## Codes de motif de rejet

Liste codifiée commune à la **modération automatique serveur** et à la **validation manuelle APE/admin**. Pas de texte libre côté parent.

### Codes générés automatiquement par `onReportCreate` (serveur)

| Code | Libellé court | Libellé long |
|---|---|---|
| `out_of_window` | hors fenêtre | Date hors de la fenêtre de 30 jours. |
| `invalid_duration` | durée invalide | Durée nulle, négative ou > 8 h. |
| `missing_level` | niveau manquant | Le niveau est requis pour ce type d'agent. |
| `missing_discipline` | discipline manquante | La discipline est requise au collège ou au lycée. |
| `nominative` | mention nominative | Une mention nominative a été détectée. |

### Codes utilisés à la validation manuelle (APE / admin)

| Code | Libellé court | Libellé long |
|---|---|---|
| `duplicate` | doublon | Déjà signalé pour cette école/date. |
| `wrong_school` | mauvais établissement | Le signalement ne concerne pas notre école. |
| `nominative` | mention nominative | Le commentaire mentionne une personne. |
| `incoherent` | incohérent | Les informations ne correspondent à rien de connu. |
| `out_of_window` | hors fenêtre | Date hors de la fenêtre de 30 jours. |
| `other` | autre | Motif libre (visible APE/admin uniquement). |

## Copywriting RGPD

### Bandeau onboarding
> « école-asso ne demande aucune information nominative sur le personnel des écoles. Les signalements sont rendus publics seulement après validation par votre APE et de manière agrégée. »

### Avant chaque déclaration (rappel discret)
> « Aucune information nominative n'est demandée. »

### Confirmation suppression de compte
> « En supprimant votre compte, vos données personnelles sont effacées sous 30 jours.
> Vos signalements **validés** sont conservés sous forme **anonyme** dans les statistiques publiques (cohérence des séries temporelles).
> Vos signalements en attente sont supprimés. »

## Vocabulaire à éviter / privilégier

| À éviter | À utiliser |
|---|---|
| « prof » | « enseignant » (formulaire) / « cours non assuré » (stats) |
| « grève sauvage » | « grève » / « mouvement social » |
| « absence injustifiée » | « absence non remplacée » |
| « note de l'établissement » | « heures perdues » / « taux de remplacement » |
| « parent vérificateur » | « membre d'APE validateur » |
