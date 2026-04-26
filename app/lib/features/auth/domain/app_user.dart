enum UserRole { parent, ape, admin }

class AppUser {
  const AppUser({
    required this.uid,
    required this.email,
    required this.role,
    required this.schoolIds,
    this.displayName,
  });

  final String uid;
  final String email;
  final String? displayName;
  final UserRole role;
  final List<String> schoolIds;
}
