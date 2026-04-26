import 'package:ecole_asso/features/reports/domain/report.dart';
import 'package:ecole_asso/features/reports/domain/report_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const ReportValidator validator = ReportValidator();
  final DateTime now = DateTime(2026, 4, 25, 9);

  group('ReportValidator', () {
    test('rejects future dates', () {
      final ReportDraft draft = ReportDraft(
        schoolId: '0750001A',
        agentType: AgentType.aesh,
        date: now.add(const Duration(days: 1)),
        durationHours: 2,
        context: ReportContext.absence,
      );
      final ValidationResult result = validator.validate(draft, now: now);
      expect(result.isValid, isFalse);
    });

    test('rejects dates older than the window', () {
      final ReportDraft draft = ReportDraft(
        schoolId: '0750001A',
        agentType: AgentType.aesh,
        date: now.subtract(const Duration(days: 31)),
        durationHours: 2,
        context: ReportContext.absence,
      );
      final ValidationResult result = validator.validate(draft, now: now);
      expect(result.isValid, isFalse);
    });

    test('requires discipline for secondary teachers', () {
      final ReportDraft draft = ReportDraft(
        schoolId: '0750001A',
        agentType: AgentType.teacher,
        level: SchoolLevel.quatrieme,
        date: now.subtract(const Duration(days: 1)),
        durationHours: 1,
        context: ReportContext.absence,
      );
      final ValidationResult result = validator.validate(draft, now: now);
      expect(result.isValid, isFalse);
      expect(result.message, contains('discipline'));
    });

    test('accepts a primary teacher report without discipline', () {
      final ReportDraft draft = ReportDraft(
        schoolId: '0750001A',
        agentType: AgentType.teacher,
        level: SchoolLevel.cm2,
        date: now.subtract(const Duration(days: 1)),
        durationHours: 4,
        context: ReportContext.absence,
      );
      final ValidationResult result = validator.validate(draft, now: now);
      expect(result.isValid, isTrue);
    });

    test('accepts a secondary teacher with discipline', () {
      final ReportDraft draft = ReportDraft(
        schoolId: '0750001A',
        agentType: AgentType.teacher,
        level: SchoolLevel.quatrieme,
        discipline: Disciplines.maths,
        date: now.subtract(const Duration(days: 1)),
        durationHours: 1,
        context: ReportContext.absence,
      );
      final ValidationResult result = validator.validate(draft, now: now);
      expect(result.isValid, isTrue);
    });
  });
}
