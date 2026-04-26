# 07 — RGPD

Document opérationnel. L'AIPD (analyse d'impact) complète est à produire avant l'ouverture publique.

## Responsable de traitement (v1)
- Personne physique : **{Nom Prénom}** (à renseigner dans `mentions-legales.md` au déploiement).
- Adresse de contact : `dpo@ecole-asso.fr` (alias).
- ⚠ Migration vers asso loi 1901 prévue (cf. `etat-de-lart.md`, section 7).

## Données traitées

### Utilisateur
| Donnée | Finalité | Base légale | Durée |
|---|---|---|---|
| e-mail | identification, communication transactionnelle | exécution du contrat (CGU) | tant que compte actif + 30 j après suppression |
| `displayName` (libre, optionnel) | UI | consentement | idem |
| Provider OAuth (Google/Apple) | authentification | exécution contrat | idem |
| Liste des écoles rattachées | fonctionnement | exécution contrat | idem |
| Rôle (parent / ape / admin) | contrôle d'accès | exécution contrat | idem |
| FCM token | notifications push | consentement | jusqu'à révocation |

### Demande d'adhésion APE
| Donnée | Finalité | Base légale | Durée |
|---|---|---|---|
| Pièce justificative uploadée | vérification de la qualité de membre | intérêt légitime + consentement | **24 mois** après validation puis purge automatique |
| Statut déclaré (président, trésorier...) | vérification | intérêt légitime | idem |
| E-mail public APE (si fourni) | double-vérif | consentement | idem |

### Signalement
| Donnée | Finalité | Base légale | Durée |
|---|---|---|---|
| École (UAI), niveau, agent type, date, durée, replaced, contexte | mission de la plateforme | intérêt légitime | **5 ans** (cohérence séries temporelles), puis purge |
| `reporterUid` | suivi par le parent, rejet, audit | exécution contrat | tant que compte actif, sinon `'deleted'` |
| Validation (uid APE, motif) | traçabilité | intérêt légitime | idem 5 ans |

### Audit
| Donnée | Finalité | Base légale | Durée |
|---|---|---|---|
| Actions admin (qui, quoi, quand, IP) | sécurité, redevabilité | obligation légale | 12 mois |

## Données **non** collectées (interdiction)
- Nom, prénom ou identifiant d'un agent (enseignant, AESH, ATSEM...).
- Nom, prénom ou identifiant d'un élève.
- Géolocalisation autre que la recherche d'école opt-in (jamais stockée).
- Photo d'identité, biométrie, données de santé.
- Texte libre côté parent (contournement du non-nominatif).

## Exercice des droits
| Droit | Mise en œuvre |
|---|---|
| Accès | bouton « Exporter mes données » → JSON par e-mail sous 24 h |
| Rectification | écran Profil + édition du compte |
| Effacement | bouton « Supprimer mon compte » (cf. P7) — instantané pour les données de compte |
| Limitation | sur demande à `dpo@ecole-asso.fr` |
| Opposition | sur demande |
| Portabilité | export JSON couvre cette obligation |
| Réclamation CNIL | mentionnée dans la politique de conf |

## Suppression de compte — détail technique
1. `delete-user` Cloud Function (callable, authentifiée) :
   1. désindexe `reporterUid` → `'deleted'` sur tous les `reports/*` du parent.
   2. supprime `users/{uid}`.
   3. supprime `apeMembershipRequests/*` du user.
   4. supprime le fichier Storage de la preuve si présent.
   5. supprime l'utilisateur Firebase Auth.
   6. écrit `auditLog/*` (action `account_deleted`).
2. Les **signalements validés** restent dans la base mais sans lien identifiant. C'est conforme RGPD (anonymisation), nécessaire à la cohérence des stats publiques.

## Sécurité

### Hébergement
- Région GCP `europe-west1` (Belgique) imposée. Pas de réplication US.

### Chiffrement
- TLS 1.3 partout (Firebase impose).
- Chiffrement au repos par défaut (Google managed encryption).

### Authentification
- Firebase Auth, MFA proposé (e-mail + Google = MFA implicite Google).
- Custom claims pour les rôles.

### App Check
- Play Integrity (Android), DeviceCheck (iOS), reCAPTCHA Enterprise (Web).
- Obligatoire pour toute écriture en prod.

### Règles Firestore
- Lecture publique uniquement sur `aggregates/*`.
- Écriture limitée à la propre donnée du `request.auth.uid`.
- Les `reports` ne sont jamais lisibles par d'autres utilisateurs sauf l'APE rattachée à la même école.

### Modération automatique côté serveur
- Cloud Function `onCreate(reports/*)` :
  - vérifie l'absence de mots interdits dans tout commentaire (regex + liste noire).
  - vérifie la fenêtre temporelle (≤ 30 j).
  - vérifie le rattachement parent → école.
  - rejette en `status='rejected'` avec code si KO.

## Cookies et trackers (Web)
- **Aucun cookie analytique** sans consentement explicite.
- Pas d'intégration GA / Hotjar / Sentry public sans IP truncation et bandeau conforme.

## Mentions légales (à publier)
- Identité du responsable de traitement.
- DPO (alias `dpo@`).
- Hébergeur : Google Cloud EMEA (Bruxelles, Belgique).
- Lien CNIL pour réclamation.
- Lien CGU + Politique de conf.
- Date de la dernière mise à jour.

## Liste des templates à rédiger en parallèle (hors-spec)
- `legal/cgu.md`
- `legal/politique-de-confidentialite.md`
- `legal/charte-ape.md` (signée par l'APE référente d'une école)
- `legal/aipd.md` (analyse d'impact RGPD)
