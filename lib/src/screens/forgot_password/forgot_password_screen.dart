import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/validators.dart';

import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/buttons/buttons.dart';
import 'package:academic_planner/src/shared/widgets/inputs/input_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  void _onSendPressed() {
    if (_formKey.currentState?.validate() ?? false) {}
  }

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
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBarWidget(backgroundColor: AppColors.transparent),
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   titleSpacing: 0.0,
      //   leading: SizedBox.shrink(),
      //   title: Padding(
      //     padding: const EdgeInsets.only(left: 16.0),
      //     child: BackIconButtonWidget(),
      //   ),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 32.0),
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
                          Icons.lock_reset_rounded,
                          color: colorScheme.primary,
                          size: 40.0,
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Text(
                        "Recuperar Senha",
                        style: _textStyle(
                          context,
                          size: 28.0,
                          weight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        "Insira seu e-mail abaixo para receber as instruções de redefinição de senha.",
                        textAlign: TextAlign.center,
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
                const SizedBox(height: 32.0),
                ButtonWidget(
                  onPressed: _onSendPressed,
                  label: "Enviar Instruções",
                  isFullWidth: true,
                ),
                const SizedBox(height: 32.0),
                Align(
                  alignment: Alignment.center,
                  child: TextButtonWidget(
                    onTap: () => Navigator.pop(context),
                    text: 'Voltar para o Login',
                  ),
                ),
              ],
            ),
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
