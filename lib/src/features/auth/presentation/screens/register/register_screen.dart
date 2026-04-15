import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import 'package:academic_planner/src/core/validators.dart';
import 'package:academic_planner/src/core/routes/app_routes.dart';

import 'package:academic_planner/src/features/auth/providers/auth_providers.dart';

import 'package:academic_planner/src/shared/widgets/buttons/buttons.dart';
import 'package:academic_planner/src/shared/widgets/forms/form_field_label_widget.dart';
import 'package:academic_planner/src/shared/widgets/inputs/input_widget.dart';
import 'package:academic_planner/src/shared/widgets/states/loading_state_widget.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _logger = Logger();

  Future<void> _onRegisterPressed() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final auth = ref.read(authNotifierProvider.notifier);

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      _logger.i('Register attempt: $email');

      await auth.signUp(email, password);

      _logger.i('User created: $email');

      await auth.sendEmailVerification();

      _logger.i('Verification email sent: $email');

      await auth.signOut();

      _logger.i('User signed out after registration');

      if (!mounted) return;

      Fluttertoast.showToast(
        msg: 'Conta criada! Verifique seu email antes de fazer login.',
      );

      if (!mounted) return;

      AppRoutes.goToLogin(context, replace: true);
    } catch (err, stack) {
      _logger.e('Register error', error: err, stackTrace: stack);

      if (!mounted) return;

      Fluttertoast.showToast(msg: err.toString());
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final auth = ref.watch(authNotifierProvider);

    if (auth.isLoading) {
      return const Scaffold(
        body: LoadingStateWidget(message: "Criando conta..."),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
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
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 28.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        "Junte-se à nossa plataforma acadêmica",
                        style: GoogleFonts.plusJakartaSans(
                          color: colorScheme.onSurface.withAlpha(150),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48.0),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0, left: 4.0),
                  child: FormFieldLabelWidget(
                    label: "NOME COMPLETO",
                    fontSize: 11.0,
                  ),
                ),
                InputWidget(
                  controller: _nameController,
                  hint: "Seu nome completo",
                  validator: (value) => Validators.required(value),
                  prefixIcon: Icon(
                    Icons.person_outline_rounded,
                    color: colorScheme.primary,
                    size: 20.0,
                  ),
                ),
                const SizedBox(height: 20.0),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0, left: 4.0),
                  child: FormFieldLabelWidget(label: "E-MAIL", fontSize: 11.0),
                ),
                InputWidget(
                  controller: _emailController,
                  hint: "seu@email.com",
                  validator: Validators.multiple([
                    Validators.required,
                    Validators.email,
                  ]),
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: colorScheme.primary,
                    size: 20.0,
                  ),
                ),
                const SizedBox(height: 20.0),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0, left: 4.0),
                  child: FormFieldLabelWidget(label: "SENHA", fontSize: 11.0),
                ),
                InputWidget(
                  controller: _passwordController,
                  hint: "Mínimo 8 caracteres",
                  validator: Validators.required,
                  obscureText: true,
                ),
                const SizedBox(height: 20.0),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0, left: 4.0),
                  child: FormFieldLabelWidget(
                    label: "CONFIRMAR SENHA",
                    fontSize: 11.0,
                  ),
                ),
                InputWidget(
                  controller: _confirmPasswordController,
                  hint: "Repita sua senha",
                  obscureText: true,
                  validator: (value) {
                    return Validators.compare(
                      value,
                      _passwordController.text,
                      message: "As senhas não conferem",
                    );
                  },
                ),
                const SizedBox(height: 40.0),
                ButtonWidget(
                  onPressed: _onRegisterPressed,
                  label: "Cadastrar agora",
                  isFullWidth: true,
                ),
                const SizedBox(height: 32.0),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Já possui uma conta?",
                        style: GoogleFonts.plusJakartaSans(
                          color: colorScheme.onSurface.withAlpha(150),
                          fontSize: 14.0,
                        ),
                      ),
                      TextButtonWidget(
                        onTap: () {
                          AppRoutes.goToLogin(context, replace: true);
                        },
                        text: 'Fazer Login',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),
                Center(
                  child: Text(
                    "Ao se cadastrar, você concorda com nossos\nTermos e Condições de Uso",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      color: colorScheme.onSurface.withAlpha(100),
                      fontSize: 12.0,
                    ),
                  ),
                ),
                const SizedBox(height: 32.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
