import 'package:brew_crew/services/auth_service.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  late String _email;
  late String _pass;
  late bool _hidePassword;

  @override
  void initState() {
    _email = '';
    _pass = '';
    _hidePassword = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: const Text("Sign in to Brew crew"),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/signup');
            },
            icon: const Icon(Icons.person),
            label: const Text("Register"),
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.black)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildEmailFormField(),
              const SizedBox(height: 20),
              _buildPasswordFormField(hintText: "Password"),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: _signInButton(),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: _signInAnonButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildEmailFormField() {
    return TextFormField(
      onChanged: (val) {
        setState(() => _email = val);
      },
      decoration: const InputDecoration(
        hintText: "Email",
      ),
    );
  }

  TextFormField _buildPasswordFormField({required String hintText}) {
    return TextFormField(
      onChanged: (val) {
        setState(() => _pass = val);
      },
      decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: IconButton(
            onPressed: () {
              setState(() => _hidePassword = !_hidePassword);
            },
            icon: Icon(_hidePassword ? Icons.visibility_off : Icons.visibility),
          )),
      obscureText: _hidePassword,
    );
  }

  ElevatedButton _signInButton() {
    return ElevatedButton(
      style:
          ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
      onPressed: () async {
        dynamic result = await _auth.signIn(_email, _pass);
        print("email : $_email");
        print("pass : $_pass");
        if (result != null) {
          Navigator.pushReplacementNamed(context, '/home_page');
          print("$result, Signed-in with email & password");
          print(result.userId);
        } else {
          print("Error signing in");
        }
      },
      child: const Text(
        "Sign-in",
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  ElevatedButton _signInAnonButton() {
    return ElevatedButton(
      style:
          ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
      onPressed: () async {
        dynamic result = await _auth.signInAnon();
        if (result != null) {
          print("$result, Signed-in anonymously");
          print(result.userId);
        } else {
          print("Error signing in");
        }
      },
      child: const Text(
        "Sign-in anonymously",
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
