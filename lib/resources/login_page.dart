import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'home_page.dart'; // Thay đổi đường dẫn nếu cần
import 'package:firebase_auth/firebase_auth.dart'; // Thêm import này

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Thay đổi phương thức để xử lý đăng nhập
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Sử dụng Firebase Authentication để đăng nhập
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Nếu đăng nhập thành công, điều hướng đến HomePage
        if (userCredential.user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      } catch (error) {
        // Xử lý lỗi đăng nhập
        print('Error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 180),
                Image.asset(
                  'assets/searching.png', // Đường dẫn đến logo
                  height: 100,
                  width: 100,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 6),
                  child: Text(
                    "Welcome Back!",
                    style: TextStyle(fontSize: 22, color: Color(0xff333333)),
                  ),
                ),
                Text(
                  "Login to continue using Search App",
                  style: TextStyle(fontSize: 16, color: Color(0xff606470)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: TextFormField(
                    controller: _emailController,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/email.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xffCED02D), width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),
                TextFormField(
                  controller: _passwordController,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(10),
                      child: Image.asset(
                        'assets/password.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xffCED02D), width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                Container(
                  constraints: BoxConstraints.loose(Size(double.infinity, 40)),
                  alignment: AlignmentDirectional.centerEnd,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(fontSize: 16, color: Color(0xff606470)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _login, // Gọi phương thức _login khi nhấn nút
                      child: Text(
                        "Log In",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff3277D8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 40),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(bottom: 80),
                    child: RichText(
                      text: TextSpan(
                        text: "New User? ",
                        style:
                            TextStyle(color: Color(0xff606470), fontSize: 16),
                        children: <TextSpan>[
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(context, '/register');
                              },
                            text: "Sign up for a new account",
                            style: TextStyle(
                                color: Color(0xff3277D8), fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
