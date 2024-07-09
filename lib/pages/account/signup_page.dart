import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:oceanic_teachers/models/teacher.dart';
import 'package:oceanic_teachers/widgets/inputs/text_field.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupPage extends StatefulWidget {
  final Function pageSiwtchCallback;
  const SignupPage({
    super.key,
    required this.pageSiwtchCallback,
  });

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  // ignore: prefer_final_fields

  // ignore: unused_field, prefer_final_fields
  bool _isLoading = false;
  bool _passwordVisible = false;

  bool canAcc() {
    return _fullNameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPassword.text.isNotEmpty &&
        _emailController.text.contains('@') &&
        _emailController.text.contains('.') &&
        _passwordController.text == _confirmPassword.text;
  }

  void acc() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text);

    await FirebaseAuth.instance.currentUser
        ?.updateDisplayName(_fullNameController.text);

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore
        .collection('teachers')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set(Teacher(
          id: FirebaseAuth.instance.currentUser?.uid ?? '',
          mail: _emailController.text,
          fullname: _fullNameController.text,
          phoneNumber: _phoneNumberController.text,
        ).toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/teachers_logo.svg',
                height: 92,
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              const SizedBox(
                height: 64,
              ),
              TextFieldInput(
                hintText: 'Nombre y apellido: (EJ: Juan Balmaceda)',
                textInputType: TextInputType.name,
                textEditingController: _fullNameController,
                validator: (value) {
                  return value.split(' ').length > 1;
                },
                callback: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'e-mail:',
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
                validator: (value) {
                  return value.contains('@') && value.contains('.');
                },
                callback: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Numero de telefono: (Opcional)',
                textInputType: TextInputType.phone,
                textEditingController: _phoneNumberController,
                validator: (value) {
                  return true;
                },
                callback: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 24,
              ),
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  TextFieldInput(
                    hintText: 'Contraseña:',
                    textInputType: TextInputType.visiblePassword,
                    textEditingController: _passwordController,
                    isPass: !_passwordVisible,
                    validator: (value) {
                      return value.length > 7;
                    },
                    callback: (value) {
                      setState(() {});
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                    icon: Icon(
                      _passwordVisible
                          ? CupertinoIcons.eye_slash
                          : CupertinoIcons.eye,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  TextFieldInput(
                    hintText: 'Confirmar Contraseña:',
                    textInputType: TextInputType.visiblePassword,
                    textEditingController: _confirmPassword,
                    isPass: !_passwordVisible,
                    validator: (value) {
                      return value.length > 7 &&
                          value == _passwordController.text;
                    },
                    callback: (value) {
                      setState(() {});
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                    icon: Icon(
                      _passwordVisible
                          ? CupertinoIcons.eye_slash
                          : CupertinoIcons.eye,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: acc,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: ShapeDecoration(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    color:
                        canAcc() ? Colors.white : Colors.white.withOpacity(0.5),
                  ),
                  child: Text(
                    'Crear Cuenta',
                    style: TextStyle(
                      color: canAcc()
                          ? Colors.black
                          : Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Al usar la app aceptas nuestros',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      launchUrl(Uri.parse(
                          'https://docs.google.com/document/d/1ghQa9UPOG2PJ2UiCWhfvwjAq5_lJFB1f7RoUJtU1A9I/edit?usp=sharing'));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: const Text(
                        'Terminos De Uso (EULA)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Ya tienes una cuenta?',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.pageSiwtchCallback();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        ' Entrar.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).viewInsets.bottom,
              )
            ],
          ),
        ),
      ),
    );
  }
}
