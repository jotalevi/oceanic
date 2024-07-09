import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oceanic_teachers/pages/account/login_page.dart';
import 'package:oceanic_teachers/pages/account/signup_page.dart';
import 'package:oceanic_teachers/utils/colors.dart';
import 'package:oceanic_teachers/widgets/fancy_container.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // ignore: unused_field
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = min(page, 1);
    });
  }

  void navigationTapped(int page) {
    pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: FancyContainer(
          cycle: const Duration(seconds: 40),
          colors: defaultThemeGradient,
          child: PageView(
            controller: pageController,
            onPageChanged: onPageChanged,
            children: [
              LoginPage(
                pageSiwtchCallback: () {
                  navigationTapped(1);
                },
              ),
              SignupPage(
                pageSiwtchCallback: () {
                  navigationTapped(0);
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: CupertinoNavigationBar(
          backgroundColor: Colors.transparent,
          middle: Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Al acceder y usar esta app acceptas nuestros",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Colors.white.withOpacity(0.75)),
                ),
                const Text("Terminos Y Condiciones de Uso.")
              ],
            ),
          ),
        ));
  }
}
