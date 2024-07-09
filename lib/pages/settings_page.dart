import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oceanic_teachers/models/teacher.dart';
import 'package:oceanic_teachers/widgets/inputs/text_field.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController fullnameController;
  late TextEditingController mailController;
  late TextEditingController phoneNumberController;

  _updateFields() {
    FirebaseFirestore.instance
        .collection('teachers')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({
      'fullname': fullnameController.text,
      'mail': mailController.text,
      'phoneNumber': phoneNumberController.text,
    });
  }

  @override
  void initState() {
    fullnameController = TextEditingController();
    mailController = TextEditingController();
    phoneNumberController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('teachers')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.hasData) {
            Teacher teacher =
                Teacher.fromJson(snapshot.data?.data() as Map<String, dynamic>);

            fullnameController.text = teacher.fullname;
            mailController.text = teacher.mail;
            phoneNumberController.text = teacher.phoneNumber;

            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFieldInput(
                          callback: (value) {
                            _updateFields();
                          },
                          textEditingController: fullnameController,
                          hintText: 'Full Name',
                          textInputType: TextInputType.name,
                        ),
                        const SizedBox(height: 16),
                        TextFieldInput(
                          callback: (value) {
                            _updateFields();
                          },
                          textEditingController: mailController,
                          hintText: 'mail',
                          textInputType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        TextFieldInput(
                          callback: (value) {
                            _updateFields();
                          },
                          textEditingController: phoneNumberController,
                          hintText: 'Phone Number',
                          textInputType: TextInputType.phone,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            FirebaseAuth.instance
                                .sendPasswordResetEmail(email: teacher.mail);
                          },
                          child: const Text(
                            'Cambiar Contraseña',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () async {
                            FirebaseAuth.instance.signOut();
                          },
                          child: const Text(
                            'Cerrar Sesión',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () async {
                            FirebaseAuth.instance.currentUser?.delete();
                          },
                          child: const Text(
                            'Borrar Cuenta',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }

          return const Center(
            child: CupertinoActivityIndicator(),
          );
        });
  }
}
