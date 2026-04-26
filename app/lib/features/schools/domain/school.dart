import '../../reports/domain/report.dart';

class School {
  const School({
    required this.uai,
    required this.name,
    required this.stage,
    required this.sector,
    required this.city,
    required this.postalCode,
    required this.departement,
    this.apeId,
  });

  final String uai;
  final String name;
  final SchoolStage stage;
  final String sector; // 'public' | 'prive'
  final String city;
  final String postalCode;
  final String departement;
  final String? apeId;
}
