import 'dart:io';

import 'package:chat_with_firebase/components/user_image_picker.dart';
import 'package:chat_with_firebase/core/models/auth_form_data.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key, required this.onSubmit});

  final void Function(AuthFormData) onSubmit;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formData = AuthFormData();
  final _formKey = GlobalKey<FormState>();

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    if (_formData.image == null && _formData.isSinup) {
      return _showError("Imagem não selecionada!");
    }
    widget.onSubmit(_formData);
  }

  void _handleImagePicker(File image) {
    _formData.image = image;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                if (_formData.isSinup)
                  UserImagePicker(onImagePicker: _handleImagePicker),
                if (_formData.isSinup)
                  TextFormField(
                    initialValue: _formData.name,
                    onChanged: (name) {
                      _formData.name = name;
                    },
                    key: const ValueKey("name"),
                    decoration: const InputDecoration(
                      labelText: "Nome",
                    ),
                    validator: (value) {
                      final name = value ?? "";
                      if (name.trim().length < 5) {
                        return "Nome deve ter no mínimo 5 caracteres.";
                      }
                      return null;
                    },
                  ),
                TextFormField(
                  initialValue: _formData.email,
                  onChanged: (email) {
                    _formData.email = email;
                  },
                  key: const ValueKey("email"),
                  decoration: const InputDecoration(
                    labelText: "E-mail",
                  ),
                  validator: (value) {
                    final email = value ?? "";
                    if (!email.contains("@")) {
                      return "E-mail Inválido.";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: _formData.password,
                  onChanged: (password) {
                    _formData.password = password;
                  },
                  key: const ValueKey("senha"),
                  decoration: const InputDecoration(
                    labelText: "Senha",
                  ),
                  obscureText: true,
                  validator: (value) {
                    final password = value ?? "";
                    if (password.length < 5) {
                      return "Senha deve ter no mínimo 6 caracteres.";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  onPressed: _submit,
                  child: Text(
                    _formData.isLogin ? "Entrar" : "Cadastrar",
                    style: TextStyle(
                        color: Theme.of(context)
                            .primaryTextTheme
                            .displayMedium
                            ?.color),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _formData.toggleAuthMode();
                    });
                  },
                  child: Text(
                    _formData.isLogin
                        ? "Criar uma nova Conta?"
                        : "Já possui uma Conta?",
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
