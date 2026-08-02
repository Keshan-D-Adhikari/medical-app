import '../models/auth_user.dart';
import 'api_client.dart';

/// Typed access to the Express backend.
///
/// Every path here is prefixed with `/api` to match how server.js mounts its
/// routers — an earlier version of this file called `/patients`, which the
/// server answers with 404.
class BackendApi {
  BackendApi({ApiClient? client}) : _client = client ?? ApiClient.instance;

  final ApiClient _client;

  AuthUser? _currentUser;
  AuthUser? get currentUser => _currentUser;

  // ---------------------------------------------------------------- auth

  Future<AuthResult> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phone,
    String role = 'patient',
  }) async {
    final body = await _client.post('/api/auth/register', {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
      'role': role,
    });

    return _consumeAuthResponse(body);
  }

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final body = await _client.post('/api/auth/login', {
      'email': email,
      'password': password,
    });

    return _consumeAuthResponse(body);
  }

  Future<AuthUser> me() async {
    final body = await _client.get('/api/auth/me');
    final user = AuthUser.fromJson(body['user'] as Map<String, dynamic>);
    _currentUser = user;
    return user;
  }

  void logout() {
    _client.clearToken();
    _currentUser = null;
  }

  AuthResult _consumeAuthResponse(Map<String, dynamic> body) {
    final token = body['token'];
    final user = body['user'];

    if (token is! String || user is! Map<String, dynamic>) {
      throw ApiException('Unexpected authentication response from the server.');
    }

    _client.setToken(token);
    _currentUser = AuthUser.fromJson(user);

    return AuthResult(token: token, user: _currentUser!);
  }

  // ------------------------------------------------------------- doctors

  /// Public doctor directory, optionally narrowed to one specialty.
  Future<List<Map<String, dynamic>>> fetchDoctors({
    String? specialization,
    int page = 1,
    int limit = 25,
  }) async {
    final body = await _client.get('/api/doctors', query: {
      if (specialization != null && specialization.isNotEmpty)
        'specialization': specialization,
      'page': '$page',
      'limit': '$limit',
    });

    return _asList(body['doctors']);
  }

  Future<Map<String, dynamic>> fetchDoctorById(String id) async {
    final body = await _client.get('/api/doctors/$id');
    return body['doctor'] as Map<String, dynamic>;
  }

  // ------------------------------------------------------------ patients

  /// Requires a doctor or admin token — patient records are PHI.
  Future<List<Map<String, dynamic>>> fetchPatients({
    int page = 1,
    int limit = 25,
  }) async {
    final body = await _client.get('/api/patients', query: {
      'page': '$page',
      'limit': '$limit',
    });

    return _asList(body['patients']);
  }

  Future<Map<String, dynamic>> fetchMyPatientProfile() async {
    final body = await _client.get('/api/patients/profile');
    return body['patient'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateMyPatientProfile(
    Map<String, dynamic> changes,
  ) async {
    final body = await _client.put('/api/patients/profile', changes);
    return body['patient'] as Map<String, dynamic>;
  }

  List<Map<String, dynamic>> _asList(Object? value) {
    if (value is! List) return const [];
    return value.whereType<Map<String, dynamic>>().toList();
  }
}
