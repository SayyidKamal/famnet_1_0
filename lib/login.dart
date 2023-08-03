import 'dart:io';

import 'package:famnet_1_0/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: IntroPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class IntroPage extends StatelessWidget {
  void navigateToLoginPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage(title: 'sign')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const FlutterLogo(
              size: 150.0,
            ),
            const SizedBox(height: 50.0),
            const Text(
              'Famnet',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            const Text(
              'A platform built to connect with family',
              style: TextStyle(
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 80.0),
            ElevatedButton(
              onPressed: () {
                navigateToLoginPage(context);
              },
              child: const Row(
                children: <Widget>[
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Get Started', // Replace with your desired button text
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios),
                  // Replace with the desired icon
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String? errorMessage = '';
  bool isLogin = true;

  Future<void> signInWithEmailAndPAssword() async {
    try {
      await Auth()
          .signInWithEmailAndPassword(email: _email, password: _password);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createInWithEmailAndPAssword() async {
    try {
      await Auth()
          .createUserWithEmailAndPassword(email: _email, password: _password);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title() {
    return const Text('Firebase Auth');
  }

  Widget _entryField(String title, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: title),
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage');
  }

  Widget _submitBotton() {
    return ElevatedButton(
        onPressed:
            isLogin ? signInWithEmailAndPAssword : createInWithEmailAndPAssword,
        child: Text(isLogin ? 'Login' : 'Register'));
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
        onPressed: () {
          setState(() {
            isLogin = !isLogin;
          });
        },
        child: Text(isLogin ? 'Register instead' : 'Login instead'));
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Perform signup functionality with validated email and password
      stdout.writeln('Signup successful!');
      stdout.writeln('Email: $_email');
      stdout.writeln('Password: $_password');
    }
  }

  void navigateToMainPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
    );
  }

  void _togglePasswordVisibility() {
    stdout.writeln('hi $_password');
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20.0, 8, 20.0, 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 80),
                const Text(
                  'Famnet',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12.0),
                const Text(
                  'Family at your fingertips',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 70.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter an email';
                    } else if (!RegExp(r'^.+@.+\..+$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _email = value!;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a password';
                    } else if (value.length < 8) {
                      return 'Password must be at least 8 characters long';
                    } else if (!RegExp(
                            r'^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                        .hasMatch(value)) {
                      return 'Password must contain at least one capital letter, \none number, and one special character';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _password = value!;
                  },
                  obscureText: _obscureText,
                ),
                const SizedBox(height: 30.0),
                ElevatedButton(
                  onPressed: /*isLogin
                      ? signInWithEmailAndPAssword
                      : createInWithEmailAndPAssword,*/
                      () {
                    //navigateToMainPage(context);
                    _submitForm();
                  },
                  child: const Row(
                    children: [
                      Expanded(
                          child: Align(
                        child: Text('Continue'),
                      )),
                      Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                  style: const ButtonStyle(),
                ),
                const SizedBox(height: 15.0),
                const Text(
                  'or',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15.0),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          fit: BoxFit.cover,
                          height: 15,
                          image: AssetImage("images/google_logo.png"),
                        ),
                        SizedBox(width: 7.0),
                        Text('Continue with Google'),
                      ],
                    ),
                    style: const ButtonStyle(),
                  ),
                ),
                const SizedBox(height: 15.0),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          fit: BoxFit.cover,
                          height: 15,
                          image: AssetImage("images/apple_logo.png"),
                        ),
                        SizedBox(width: 7.0),
                        Text('Continue with Apple'),
                      ],
                    ),
                    style: const ButtonStyle(),
                  ),
                ),
                const SizedBox(height: 20.0),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account? '),
                    Text(
                      'Register',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
      ),
      body: Container(
        child: const Center(
          child: Text(
            'Welcome to the Main Page',
            style: TextStyle(fontSize: 24.0),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepOrange,
        fixedColor: Colors.lightBlue,
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.update),
            label: 'Updates',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.family_restroom),
            label: 'Family Tree',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
