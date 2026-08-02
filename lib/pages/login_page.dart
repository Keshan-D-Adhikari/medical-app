import 'package:flutter/material.dart';
import 'package:medical_app/pages/index.dart';
import 'package:medical_app/pages/signup_page.dart';
import 'package:medical_app/services/api_client.dart';
import 'package:medical_app/services/backend_api.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _api = BackendApi();

  bool _submitting = false;
  bool _obscurePassword = true;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_submitting) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();
    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      await _api.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffecfbff),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 80),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Image.asset(
                      'assests/logo.png',
                      width: 170,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "DoctApp",
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Poppin',
                        color: Color(0xff000000),
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  _field(
                    icon: Icons.email,
                    hintText: "Email Address",
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
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
                    height: 15,
                  ),
                  _field(
                    icon: Icons.lock,
                    hintText: "Password",
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _signIn(),
                    validator: (value) =>
                        (value == null || value.isEmpty) ? 'Password is required' : null,
                    suffix: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Forgot password ?",
                    style: TextStyle(
                        fontFamily: 'Poppin',
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                  if (_error != null) ...[
                    SizedBox(height: 16),
                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppin',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xffb00020),
                      ),
                    ),
                  ],
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: _submitting ? null : _signIn,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: 150,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 0, 0, 0)
                                  .withValues(alpha: 0.5),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          color: _submitting
                              ? Color(0xffd4f2f7)
                              : Color(0xffaaeaf4),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                              color: Color.fromARGB(255, 181, 181, 181))),
                      child: Center(
                        child: _submitting
                            ? SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Color(0xff3f979e),
                                ),
                              )
                            : Text(
                                "Sign in",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Poppin',
                                    fontWeight: FontWeight.w600),
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
                                builder: (context) => SignupPage(),
                              ),
                            );
                          },
                    child: Text(
                      "Need an Account ? Sign up",
                      style: TextStyle(
                          fontFamily: 'Poppin',
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field({
    required IconData icon,
    required String hintText,
    required TextEditingController controller,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    void Function(String)? onFieldSubmitted,
    bool obscureText = false,
    Widget? suffix,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: Color(0xffD9F5F3),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Color.fromARGB(255, 181, 181, 181))),
      width: double.infinity,
      child: Row(
        children: [
          Icon(icon),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              validator: validator,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              onFieldSubmitted: onFieldSubmitted,
              obscureText: obscureText,
              enabled: !_submitting,
              decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(fontFamily: 'Poppin'),
                  errorStyle: TextStyle(
                    fontFamily: 'Poppin',
                    color: Color(0xffb00020),
                    fontWeight: FontWeight.w600,
                  ),
                  border: InputBorder.none),
            ),
          ),
          if (suffix != null) suffix,
        ],
      ),
    );
  }
}
