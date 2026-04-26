import 'report.dart';

/// Vérifications faites côté client avant l'envoi au serveur.
/// Le serveur (Cloud Function `onReportCreate`) refera ces checks.
class ReportValidator {
  const ReportValidator({this.windowDays = 30, this.maxDurationHours = 8});

  final int windowDays;
  final double maxDurationHours;

  ValidationResult validate(ReportDraft draft, {DateTime? now}) {
    final DateTime reference = now ?? DateTime.now();
    if (draft.date.isAfter(reference)) {
      return const ValidationResult.invalid('La date ne peut pas être dans le futur.');
    }
    final Duration delta = reference.difference(draft.date);
    if (delta.inDays > windowDays) {
      return ValidationResult.invalid(
        'Vous ne pouvez signaler que les $windowDays derniers jours.',
      );
    }
    if (draft.durationHours <= 0 || draft.durationHours > maxDurationHours) {
      return const ValidationResult.invalid('Indiquez une durée valide.');
    }
    if (_requiresLevel(draft.agentType) && draft.level == null) {
      return const ValidationResult.invalid('Le niveau est requis pour ce type d\'agent.');
    }
    if (_requiresDiscipline(draft) && (draft.discipline == null || draft.discipline!.isEmpty)) {
      return const ValidationResult.invalid('La discipline est requise au collège et au lycée.');
    }
    return const ValidationResult.ok();
  }

  bool _requiresLevel(AgentType type) => type == AgentType.teacher;

  bool _requiresDiscipline(ReportDraft draft) {
    if (draft.agentType != AgentType.teacher) return false;
    final SchoolStage? stage = draft.level?.stage;
    return stage == SchoolStage.college || stage == SchoolStage.lycee;
  }
}

class ReportDraft {
  const ReportDraft({
    required this.schoolId,
    required this.agentType,
    required this.date,
    required this.durationHours,
    required this.context,
    this.level,
    this.discipline,
    this.replaced,
  });

  final String schoolId;
  final AgentType agentType;
  final SchoolLevel? level;
  final String? discipline;
  final DateTime date;
  final double durationHours;
  final bool? replaced;
  final ReportContext context;
}

class ValidationResult {
  const ValidationResult.ok()
      : isValid = true,
        message = null;
  const ValidationResult.invalid(this.message) : isValid = false;

  final bool isValid;
  final String? message;
}
