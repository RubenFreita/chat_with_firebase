import 'package:chat_with_firebase/components/auth_form.dart';
import 'package:chat_with_firebase/core/models/auth_form_data.dart';
import 'package:chat_with_firebase/core/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  var isLoading = false;

  void _handleSubmit(AuthFormData formData) async {
    try {
      if (!mounted) return;
      setState(() {
        isLoading = true;
      });
      if (formData.isLogin) {
        await AuthService().login(formData.email, formData.password);
      } else {
        AuthService().signup(
          formData.name,
          formData.email,
          formData.password,
          formData.image,
        );
      }
    } catch (erro) {
      //tratar erro
    } finally {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: Center(
            child: SingleChildScrollView(
              child: AuthForm(
                onSubmit: _handleSubmit,
              ),
            ),
          ),
        ),
        if (isLoading)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration:
                const BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.5)),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
