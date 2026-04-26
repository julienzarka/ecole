enum ApeRequestStatus { pending, approved, rejected }

enum ApeClaimedRole { president, tresorier, secretaire, membre }

class ApeMembershipRequest {
  const ApeMembershipRequest({
    required this.id,
    required this.uid,
    required this.schoolId,
    required this.claimedRole,
    required this.status,
    required this.mailVerified,
    required this.createdAt,
    this.evidenceStoragePath,
    this.publicEmail,
    this.rejectReason,
    this.reviewedBy,
    this.reviewedAt,
  });

  final String id;
  final String uid;
  final String schoolId;
  final ApeClaimedRole claimedRole;
  final ApeRequestStatus status;
  final bool mailVerified;
  final String? evidenceStoragePath;
  final String? publicEmail;
  final String? rejectReason;
  final String? reviewedBy;
  final DateTime? reviewedAt;
  final DateTime createdAt;
}
