import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        _isLoading = true;
      });
      try {
        await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
        Navigator.of(context).pushReplacementNamed('/home');
      } catch (e) {
        print(e);
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Screen'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value.isEmpty ? 'Email cannot be empty' : null,
                onSaved: (value) => _email = value.trim(),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) =>
                    value.isEmpty ? 'Password cannot be empty' : null,
                obscureText: true,
                onSaved: (value) => _password = value.trim(),
              ),
              SizedBox(
                height: 20.0,
              ),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : RaisedButton(
                      child: Text('Login'),
                      onPressed: _submit,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
