/// The user payload returned by /api/auth/register, /login and /me.
class AuthUser {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String role;

  const AuthUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    this.phone,
  });

  String get fullName => '$firstName $lastName'.trim();
  bool get isDoctor => role == 'doctor';
  bool get isAdmin => role == 'admin';

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      // /auth/me returns the raw Mongo document (_id); the auth endpoints
      // return a mapped object (id).
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      firstName: (json['firstName'] ?? '') as String,
      lastName: (json['lastName'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      phone: json['phone'] as String?,
      role: (json['role'] ?? 'patient') as String,
    );
  }
}

/// A successful authentication: the token plus the account it belongs to.
class AuthResult {
  final String token;
  final AuthUser user;

  const AuthResult({required this.token, required this.user});
}
