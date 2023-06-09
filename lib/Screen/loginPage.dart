import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login Admin'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: const AssetImage("assets/images/wite.png"),
              // fit: BoxFit.cover,
              // height: 150,
              height: MediaQuery.of(context).size.width * 0.4,
              width: MediaQuery.of(context).size.width * 0.4,
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: TextFormField(
                  obscureText: _obscureText,
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor),
              onPressed: () {
                // try {
                //   FirebaseAuth.instance.signInWithEmailAndPassword(
                //       email: emailController.text.trim(),
                //       password: passwordController.text.trim());
                // } catch (e) {
                //   print("terjadi kesalahan : $e");
                // }
                signInWithEmailAndPassword(
                    emailController.text, passwordController.text, context);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                child: Text(
                  'Login',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> signInWithEmailAndPassword(
    String email, String password, context) async {
  // Validasi email dan password
  if (email.isEmpty || password.isEmpty) {
    print('Email dan password harus diisi.');
    return showLoginErrorNullDialog(context);
  }

  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;
    // Lakukan tindakan setelah pengguna berhasil masuk
  } catch (e) {
    print('Terjadi kesalahan saat login: $e');
    showLoginErrorDialog(context);
    // Tangani kesalahan saat login, misalnya menampilkan pesan kesalahan
  }
}

void showLoginErrorDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Login Gagal'),
        content: const Text('Email atau password salah. Silakan coba lagi.'),
        actions: [
          TextButton(
            child: const Text('Tutup'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showLoginErrorNullDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Login Gagal'),
        content: const Text('Email dan password harus diisi'),
        actions: [
          TextButton(
            child: const Text('Tutup'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
