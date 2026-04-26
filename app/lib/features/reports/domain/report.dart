/// Cf. docs/architecture/firestore-schema.md (collection `reports`).

enum AgentType { teacher, aesh, atsem, animator, aed, cpe, cantine, garderie, etude }

enum SchoolStage { maternelle, elementaire, college, lycee }

enum ReportStatus { pending, validated, rejected, duplicate }

enum ReportContext { absence, greve, formation, inconnu }

/// Codes de rejet, partagés entre la modération auto serveur et la
/// validation manuelle par l'APE / l'admin.
/// Cf. backend/functions/src/moderation.ts et docs/specs/etats-et-messages.md.
enum RejectCode {
  outOfWindow,
  invalidDuration,
  missingLevel,
  missingDiscipline,
  duplicate,
  wrongSchool,
  nominative,
  incoherent,
  other,
}

/// Niveaux scolaires reconnus par la plateforme (1er + 2nd degré).
enum SchoolLevel {
  ps,
  ms,
  gs,
  cp,
  ce1,
  ce2,
  cm1,
  cm2,
  sixieme,
  cinquieme,
  quatrieme,
  troisieme,
  seconde,
  premiere,
  terminale,
}

extension SchoolLevelStage on SchoolLevel {
  SchoolStage get stage {
    switch (this) {
      case SchoolLevel.ps:
      case SchoolLevel.ms:
      case SchoolLevel.gs:
        return SchoolStage.maternelle;
      case SchoolLevel.cp:
      case SchoolLevel.ce1:
      case SchoolLevel.ce2:
      case SchoolLevel.cm1:
      case SchoolLevel.cm2:
        return SchoolStage.elementaire;
      case SchoolLevel.sixieme:
      case SchoolLevel.cinquieme:
      case SchoolLevel.quatrieme:
      case SchoolLevel.troisieme:
        return SchoolStage.college;
      case SchoolLevel.seconde:
      case SchoolLevel.premiere:
      case SchoolLevel.terminale:
        return SchoolStage.lycee;
    }
  }
}

/// Liste de disciplines codifiées (sera enrichie). Texte libre interdit.
abstract class Disciplines {
  static const String maths = 'maths';
  static const String francais = 'francais';
  static const String anglais = 'anglais';
  static const String svt = 'svt';
  static const String physiqueChimie = 'physique_chimie';
  static const String histoireGeo = 'histoire_geo';
  static const String eps = 'eps';
  static const String technologie = 'technologie';
  static const String artsPlastiques = 'arts_plastiques';
  static const String musique = 'musique';

  static const List<String> all = <String>[
    maths,
    francais,
    anglais,
    svt,
    physiqueChimie,
    histoireGeo,
    eps,
    technologie,
    artsPlastiques,
    musique,
  ];
}

class Report {
  const Report({
    required this.id,
    required this.schoolId,
    required this.reporterUid,
    required this.agentType,
    required this.schoolStage,
    required this.date,
    required this.durationHours,
    required this.context,
    required this.status,
    this.level,
    this.discipline,
    this.replaced,
    this.rejectCode,
    this.duplicateOf,
    this.validatedAt,
    this.validatedByUid,
    this.validatedByRole,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String schoolId;
  final String reporterUid;
  final AgentType agentType;
  final SchoolStage schoolStage;
  final SchoolLevel? level;
  final String? discipline;
  final DateTime date;
  final double durationHours;
  final bool? replaced;
  final ReportContext context;
  final ReportStatus status;
  final RejectCode? rejectCode;
  final String? duplicateOf;
  final DateTime? validatedAt;
  final String? validatedByUid;
  final String? validatedByRole;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Vrai si la discipline est obligatoire pour ce signalement.
  bool get requiresDiscipline =>
      agentType == AgentType.teacher &&
      (schoolStage == SchoolStage.college || schoolStage == SchoolStage.lycee);

  /// Vrai si le niveau est obligatoire pour ce signalement.
  bool get requiresLevel => agentType == AgentType.teacher;
}
