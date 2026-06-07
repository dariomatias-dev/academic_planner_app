import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/routes/app_routes.dart';
import 'package:academic_planner/src/core/validators.dart';
import 'package:academic_planner/src/features/auth/di/auth_providers.dart';
import 'package:academic_planner/src/features/auth/domain/entities/register_entity.dart';
import 'package:academic_planner/src/shared/widgets/buttons/buttons.dart';
import 'package:academic_planner/src/shared/widgets/forms/form_field_label_widget.dart';
import 'package:academic_planner/src/shared/widgets/inputs/input_widget.dart';
import 'package:academic_planner/src/shared/widgets/inputs/password_input_widget.dart';
import 'package:academic_planner/src/shared/widgets/states/loading_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logging/logging.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  static final _log = Logger('auth.RegisterScreen');

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _onRegisterPressed() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final auth = ref.read(authNotifierProvider.notifier);

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    _log.info('Register attempt: $email');

    await auth.register(
      RegisterEntity(name: name, email: email, password: password),
    );
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
    ref.listen(authNotifierProvider, (previous, next) async {
      await next.whenOrNull(
        data: (_) async {
          if (!mounted) return;

          await Fluttertoast.showToast(
            msg: 'Conta criada! Verifique seu email antes de fazer login.',
          );

          if (!context.mounted) return;

          await AppRoutes.goToLogin(context, replace: true);
        },
        error: (err, _) async {
          if (!mounted) return;

          final message = err is AppFailure ? err.message : err.toString();

          _log.severe('Register error', err);

          await Fluttertoast.showToast(msg: message);
        },
      );
    });

    final colorScheme = Theme.of(context).colorScheme;
    final auth = ref.watch(authNotifierProvider);

    if (auth.isLoading) {
      return const Scaffold(
        body: LoadingStateWidget(message: 'Criando conta...'),
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
              children: [
                const SizedBox(height: 64.0),
                Center(
                  child: Column(
                    children: [
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
                        'Criar Conta',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 28.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Junte-se à nossa plataforma acadêmica',
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
                    label: 'NOME COMPLETO',
                    fontSize: 11.0,
                  ),
                ),
                InputWidget(
                  controller: _nameController,
                  hint: 'Seu nome completo',
                  validator: Validators.required,
                  prefixIcon: Icon(
                    Icons.person_outline_rounded,
                    color: colorScheme.primary,
                    size: 20.0,
                  ),
                ),
                const SizedBox(height: 20.0),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0, left: 4.0),
                  child: FormFieldLabelWidget(label: 'E-MAIL', fontSize: 11.0),
                ),
                InputWidget(
                  controller: _emailController,
                  hint: 'seu@email.com',
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
                  child: FormFieldLabelWidget(label: 'SENHA', fontSize: 11.0),
                ),
                PasswordInputWidget(
                  controller: _passwordController,
                  hint: 'Mínimo 8 caracteres',
                  validator: Validators.required,
                ),
                const SizedBox(height: 20.0),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0, left: 4.0),
                  child: FormFieldLabelWidget(
                    label: 'CONFIRMAR SENHA',
                    fontSize: 11.0,
                  ),
                ),
                PasswordInputWidget(
                  controller: _confirmPasswordController,
                  hint: 'Repita sua senha',
                  validator: (value) {
                    return Validators.compare(
                      value,
                      _passwordController.text,
                      message: 'As senhas não conferem',
                    );
                  },
                ),
                const SizedBox(height: 40.0),
                ButtonWidget(
                  onPressed: _onRegisterPressed,
                  label: 'Cadastrar agora',
                  isFullWidth: true,
                ),
                const SizedBox(height: 32.0),
                Align(
                  child: Column(
                    children: [
                      Text(
                        'Já possui uma conta?',
                        style: GoogleFonts.plusJakartaSans(
                          color: colorScheme.onSurface.withAlpha(150),
                          fontSize: 14.0,
                        ),
                      ),
                      TextButtonWidget(
                        onTap: () async {
                          await AppRoutes.goToLogin(context, replace: true);
                        },
                        text: 'Fazer Login',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),
                Center(
                  child: Text(
                    'Ao se cadastrar, você concorda com nossos '
                    'Termos e Condições de Uso',
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
