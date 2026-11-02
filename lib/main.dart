import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

// Colours taken from the Waste Pulse logo
const green = Color(0xFF005400);
const yellow = Color(0xFFE8BE10);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Waste Pulse',
      theme: ThemeData(colorSchemeSeed: green, useMaterial3: true),
      home: const LoginPage(),
    );
  }
}

// ---------- Small helpers used by both pages ----------

// Page layout (centred, scrollable)
Widget shell(Widget child, {bool back = false}) {
  return Scaffold(
    backgroundColor: const Color(0xFFF3F7EE),
    appBar: back
        ? AppBar(backgroundColor: Colors.transparent, foregroundColor: green)
        : null,
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: child,
          ),
        ),
      ),
    ),
  );
}

// Title with the small yellow bar and a short description
Widget heading(String title, String subtitle) {
  return Column(
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: green,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        width: 44,
        height: 4,
        decoration: BoxDecoration(
          color: yellow,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      const SizedBox(height: 12),
      Text(
        subtitle,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.black54),
      ),
      const SizedBox(height: 24),
    ],
  );
}

// Rounded input box
Widget field(
  TextEditingController controller,
  String label,
  IconData icon,
  String? Function(String?) validator, {
  bool obscure = false,
  Widget? suffix,
  TextInputType? type,
}) {
  return TextFormField(
    controller: controller,
    obscureText: obscure,
    keyboardType: type,
    validator: validator,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: green),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    ),
  );
}

// Green button
Widget greenButton(String text, VoidCallback onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: green,
      foregroundColor: Colors.white,
      minimumSize: const Size.fromHeight(52),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    child: Text(text, style: const TextStyle(fontSize: 16)),
  );
}

// Pop-up message at the bottom
void say(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(behavior: SnackBarBehavior.floating, content: Text(text)),
  );
}

// Validation rules
String? checkEmail(String? v) {
  if (v == null || v.trim().isEmpty) return 'Please enter your email';
  if (!v.contains('@') || !v.contains('.')) return 'Enter a valid email';
  return null;
}

String? checkPassword(String? v) {
  if (v == null || v.isEmpty) return 'Please enter your password';
  if (v.length < 6) return 'Password must be at least 6 characters';
  return null;
}

// ======================================================
// LOGIN PAGE
// ======================================================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _hide = true;

  void _login() {
    if (_formKey.currentState!.validate()) {
      say(context, 'Details look good. No backend connected yet.');
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return shell(
      Form(
        key: _formKey,
        child: Column(
          children: [
            Center(
              child: Container(
                width: 190,
                height: 190,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: green,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Image.asset(
                  'assets/images/logo.webp',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 16),
            heading(
              'Welcome Back',
              'Log in to report waste and track your reports.',
            ),
            field(
              _email,
              'Email',
              Icons.email_outlined,
              checkEmail,
              type: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            field(
              _password,
              'Password',
              Icons.lock_outline,
              checkPassword,
              obscure: _hide,
              suffix: IconButton(
                icon: Icon(_hide ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _hide = !_hide),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => say(context, 'Forgot password coming soon'),
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(color: green),
                ),
              ),
            ),
            greenButton('Log In', _login),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignUpPage()),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(color: green, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// SIGN UP PAGE
// ======================================================
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _hide = true;

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      say(context, 'Details look good. No backend connected yet.');
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return shell(
      back: true,
      Form(
        key: _formKey,
        child: Column(
          children: [
            heading(
              'Create Account',
              'Join Waste Pulse and help keep your community clean.',
            ),
            field(
              _name,
              'Full name',
              Icons.person_outline,
              (v) => (v == null || v.trim().isEmpty)
                  ? 'Please enter your full name'
                  : null,
            ),
            const SizedBox(height: 16),
            field(
              _email,
              'Email',
              Icons.email_outlined,
              checkEmail,
              type: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            field(
              _password,
              'Password',
              Icons.lock_outline,
              checkPassword,
              obscure: _hide,
              suffix: IconButton(
                icon: Icon(_hide ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _hide = !_hide),
              ),
            ),
            const SizedBox(height: 16),
            field(
              _confirm,
              'Confirm password',
              Icons.lock_outline,
              (v) => v != _password.text ? 'Passwords do not match' : null,
              obscure: _hide,
            ),
            const SizedBox(height: 24),
            greenButton('Create Account', _signUp),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account?'),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Log In',
                    style: TextStyle(color: green, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
