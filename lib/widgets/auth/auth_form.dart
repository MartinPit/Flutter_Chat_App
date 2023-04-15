import 'dart:io';

import 'package:flutter/material.dart';
import '../pickers/image_picker.dart' show UserImagePicker;

class AuthForm extends StatefulWidget {
  final Future<void> Function(
    String email,
    String suername,
    String password,
    File? image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  const AuthForm({Key? key, required this.submitFn}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email = '';
  String _name = '';
  String _password = '';
  bool _isLoading = false;
  File? _userPfp;

  void _pickedImage(File image) {
    _userPfp = image;
  }

  void _trySubmit() async {
    if (!_isLogin && _userPfp == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please pick an image')));
      return;
    }


    if (!_formKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    _formKey.currentState!.save();

    setState(() => _isLoading = true);
    await widget.submitFn(
      _email.trim(),
      _name.trim(),
      _password.trim(),
      _userPfp,
      _isLogin,
      context,
    );
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin)
                    UserImagePicker(imagePickFn: _pickedImage,),
                  TextFormField(
                    key: const ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(labelText: 'Email Address'),
                    validator: (val) {
                      if (val == null || val.isEmpty || !val.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onSaved: (val) => _email = val!,
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('username'),
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty || val.length < 4) {
                          return 'Please enter at least 4 characters';
                        }
                        return null;
                      },
                      onSaved: (val) => _name = val!,
                    ),
                  TextFormField(
                    key: const ValueKey('password'),
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (val) {
                      if (val == null || val.isEmpty || val.length < 7) {
                        return 'Password must be at least 7 characters long';
                      }
                      return null;
                    },
                    onSaved: (val) => _password = val!,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  else
                    ElevatedButton(
                      onPressed: _trySubmit,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).colorScheme.primaryContainer),
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).colorScheme.onPrimaryContainer),
                      ),
                      child: Text(_isLogin ? 'Login' : 'Sign up'),
                    ),
                  TextButton(
                      onPressed: () => setState(() => _isLogin = !_isLogin),
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have an account'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
