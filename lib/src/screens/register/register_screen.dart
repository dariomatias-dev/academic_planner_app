import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/routes/app_routes.dart';

import 'package:academic_planner/src/shared/widgets/buttons/button/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/inputs/input_widget.dart';
import 'package:academic_planner/src/shared/widgets/inputs/password_input_widget.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

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
                        Icons.person_add_rounded,
                        color: colorScheme.primary,
                        size: 40.0,
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    Text(
                      "Criar Conta",
                      style: _textStyle(
                        context,
                        size: 28.0,
                        weight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      "Junte-se à nossa plataforma acadêmica",
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
              _buildLabel(context, "NOME COMPLETO"),
              InputWidget(
                controller: nameController,
                hint: "Seu nome completo",
                prefixIcon: Icon(
                  Icons.person_outline_rounded,
                  color: colorScheme.primary,
                  size: 20.0,
                ),
              ),
              const SizedBox(height: 20.0),
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
              const SizedBox(height: 20.0),
              _buildLabel(context, "SENHA"),
              PasswordInputWidget(
                controller: passwordController,
                hint: "Mínimo 8 caracteres",
              ),
              const SizedBox(height: 20.0),
              _buildLabel(context, "CONFIRMAR SENHA"),
              PasswordInputWidget(
                controller: confirmPasswordController,
                hint: "Repita sua senha",
              ),
              const SizedBox(height: 40.0),
              ButtonWidget(
                onPressed: () {},
                label: "Cadastrar agora",
                isFullWidth: true,
              ),
              const SizedBox(height: 32.0),
              Align(
                alignment: AlignmentGeometry.center,
                child: Column(
                  children: <Widget>[
                    Text(
                      "Já possui uma conta?",
                      style: _textStyle(
                        context,
                        color: colorScheme.onSurface.withAlpha(150),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        AppRoutes.goToLogin(context, replace: true);
                      },
                      child: Text(
                        "Fazer Login",
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
              const SizedBox(height: 24.0),
              Center(
                child: Text(
                  "Ao se cadastrar, você concorda com nossos\nTermos e Condições de Uso",
                  textAlign: TextAlign.center,
                  style: _textStyle(
                    context,
                    size: 12.0,
                    color: colorScheme.onSurface.withAlpha(100),
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
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
}
