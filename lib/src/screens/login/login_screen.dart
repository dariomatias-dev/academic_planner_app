import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/shared/widgets/buttons/button/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/inputs/input_widget.dart';
import 'package:academic_planner/src/shared/widgets/inputs/password_input_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  TextStyle _textStyle(
    BuildContext context, {
    double size = 14.0,
    Color? color,
    FontWeight weight = FontWeight.w500,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size,
      color: color ?? Theme.of(context).colorScheme.onSurface,
      fontWeight: weight,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 64.0),
              Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withAlpha(20),
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      child: Icon(
                        Icons.auto_stories_rounded,
                        color: colorScheme.primary,
                        size: 40.0,
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    Text(
                      "Academic Planner",
                      style: _textStyle(
                        context,
                        size: 28.0,
                        weight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      "Gestão Educacional Inteligente",
                      style: _textStyle(
                        context,
                        color: colorScheme.onSurface.withAlpha(150),
                        weight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48.0),
              _buildLabel(context, "E-MAIL"),
              InputWidget(
                controller: emailController,
                hint: "seu@email.com",
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: colorScheme.primary,
                  size: 20.0,
                ),
              ),
              const SizedBox(height: 24.0),
              _buildLabel(context, "SENHA"),
              PasswordInputWidget(controller: passwordController),
              const SizedBox(height: 32.0),
              ButtonWidget(
                onPressed: () {},
                label: "Entrar",
                isFullWidth: true,
              ),
              const SizedBox(height: 32.0),
              _buildDivider(context),
              const SizedBox(height: 32.0),
              _buildGoogleButton(context),
              const SizedBox(height: 48.0),
              Align(
                alignment: AlignmentGeometry.center,
                child: Column(
                  children: <Widget>[
                    Text(
                      "Não tem uma conta?",
                      style: _textStyle(
                        context,
                        color: colorScheme.onSurface.withAlpha(150),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Cadastre-se",
                        style: _textStyle(
                          context,
                          color: colorScheme.primary,
                          weight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        label,
        style: _textStyle(
          context,
          size: 11.0,
          weight: FontWeight.w900,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: <Widget>[
        Expanded(child: Divider(color: colorScheme.onSurface.withAlpha(30))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "ou entre com",
            style: _textStyle(
              context,
              size: 12.0,
              color: colorScheme.onSurface.withAlpha(100),
              weight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(child: Divider(color: colorScheme.onSurface.withAlpha(30))),
      ],
    );
  }

  Widget _buildGoogleButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        fixedSize: const Size(double.maxFinite, 56.0),
        side: BorderSide(color: colorScheme.onSurface.withAlpha(30)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.g_mobiledata_rounded, size: 32.0, color: Colors.red),
          const SizedBox(width: 8.0),
          Text(
            "Continuar com Google",
            style: _textStyle(context, weight: FontWeight.w800, size: 15.0),
          ),
        ],
      ),
    );
  }
}
