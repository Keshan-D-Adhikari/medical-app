import 'package:flutter/material.dart';
import 'package:medical_app/pages/index.dart';
import 'package:medical_app/pages/login_page.dart';
import 'package:medical_app/pages/widgets/signup_input.dart';
import 'package:medical_app/services/api_client.dart';
import 'package:medical_app/services/backend_api.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _api = BackendApi();

  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    if (_submitting) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();
    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      await _api.register(
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        email: _email.text.trim(),
        password: _password.text,
        phone: _phone.text.trim(),
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Index()),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String? _required(String? value, String label) =>
      (value == null || value.trim().isEmpty) ? '$label is required' : null;

  @override
  Widget build(BuildContext context) {
    const labelColor = Color.fromARGB(255, 79, 79, 79);

    return Scaffold(
      body: Container(
        // The background fills the viewport instead of a hardcoded 780px, which
        // used to overflow on short screens.
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assests/signup.jpg'), fit: BoxFit.cover)),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(10, 40, 10, 40),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Welcome Doct App",
                    style: TextStyle(
                        fontFamily: "Poppin",
                        fontSize: 28,
                        color: labelColor,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Sign up to book appointments and\n manage your health easily",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Poppin',
                        fontSize: 15,
                        color: labelColor,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  SignupInput(
                    hintText: "First Name",
                    inputIcon: Icons.person,
                    controller: _firstName,
                    enabled: !_submitting,
                    validator: (v) => _required(v, 'First name'),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  SignupInput(
                    hintText: "Last Name",
                    inputIcon: Icons.person,
                    controller: _lastName,
                    enabled: !_submitting,
                    validator: (v) => _required(v, 'Last name'),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  SignupInput(
                    hintText: "Email",
                    inputIcon: Icons.email,
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    enabled: !_submitting,
                    validator: (value) {
                      final email = value?.trim() ?? '';
                      if (email.isEmpty) return 'Email is required';
                      if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  SignupInput(
                    hintText: "Phone Number",
                    inputIcon: Icons.phone,
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    enabled: !_submitting,
                    validator: (value) {
                      final phone = value?.trim() ?? '';
                      // Optional on the backend, so only validate when filled.
                      if (phone.isEmpty) return null;
                      if (phone.length < 7 || phone.length > 20) {
                        return 'Enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  // The backend requires a password to register; the form used
                  // to collect a date of birth instead, which had nowhere to go.
                  SignupInput(
                    hintText: "Password",
                    inputIcon: Icons.lock,
                    controller: _password,
                    obscureText: true,
                    enabled: !_submitting,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 6) {
                        return 'Use at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  SignupInput(
                    hintText: "Confirm Password",
                    inputIcon: Icons.lock_outline,
                    controller: _confirmPassword,
                    obscureText: true,
                    enabled: !_submitting,
                    textInputAction: TextInputAction.done,
                    validator: (value) =>
                        value == _password.text ? null : 'Passwords do not match',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Creating an account means you\n agree with our Terms and Services",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppin',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: labelColor,
                    ),
                  ),
                  if (_error != null) ...[
                    SizedBox(height: 16),
                    Container(
                      width: 280,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppin',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xffb00020),
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 24),
                  GestureDetector(
                    onTap: _submitting ? null : _createAccount,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      width: 250,
                      decoration: BoxDecoration(
                        color: _submitting ? Color(0xffbdeef2) : Color(0xff7de2ea),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color: Color.fromARGB(255, 0, 0, 0), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 42, 42, 42)
                                .withValues(alpha: 0.5),
                            spreadRadius: 5,
                            blurRadius: 4,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: _submitting
                            ? SizedBox(
                                height: 26,
                                width: 26,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: labelColor,
                                ),
                              )
                            : Text(
                                "Create an account",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Poppin',
                                  fontWeight: FontWeight.w800,
                                  color: labelColor,
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: _submitting
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          },
                    child: Text(
                      "Already have an account ? Sign in",
                      style: TextStyle(
                          fontFamily: 'Poppin',
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: labelColor),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
