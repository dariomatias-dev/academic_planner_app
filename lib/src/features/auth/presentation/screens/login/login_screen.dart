import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/routes/app_routes.dart';
import 'package:academic_planner/src/core/validators.dart';
import 'package:academic_planner/src/features/auth/di/auth_providers.dart';
import 'package:academic_planner/src/features/auth/domain/entities/login_entity.dart';
import 'package:academic_planner/src/shared/widgets/buttons/buttons.dart';
import 'package:academic_planner/src/shared/widgets/forms/form_field_label_widget.dart';
import 'package:academic_planner/src/shared/widgets/inputs/input_widget.dart';
import 'package:academic_planner/src/shared/widgets/inputs/password_input_widget.dart';
import 'package:academic_planner/src/shared/widgets/states/loading_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logging/logging.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  static final _log = Logger('auth.LoginScreen');

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _onLoginPressed() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final auth = ref.read(authNotifierProvider.notifier);

    _log.info('Login attempt: ${_emailController.text.trim()}');

    await auth.signIn(
      LoginEntity(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authNotifierProvider, (previous, next) async {
      await next.whenOrNull(
        data: (user) async {
          if (!mounted) return;

          if (user != null) {
            _log.info('Login success: ${_emailController.text.trim()}');

            await Fluttertoast.showToast(msg: 'Login realizado com sucesso');

            if (!context.mounted) return;

            if (context.canPop()) {
              context.pop();
            } else {
              AppRoutes.goToHome(context);
            }
          }
        },
        error: (err, _) async {
          if (!mounted) return;

          final message = err is AppFailure ? err.message : err.toString();

          _log.severe('Login error', err);

          await Fluttertoast.showToast(msg: message);
        },
      );
    });

    final authState = ref.watch(authNotifierProvider);
    final colorScheme = Theme.of(context).colorScheme;

    if (authState.isLoading) {
      return const Scaffold(body: LoadingStateWidget(message: 'Entrando...'));
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
                          Icons.auto_stories_rounded,
                          color: colorScheme.primary,
                          size: 40.0,
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Text(
                        'Academic Planner',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 28.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Gestão Educacional Inteligente',
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
                const SizedBox(height: 24.0),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0, left: 4.0),
                  child: FormFieldLabelWidget(label: 'SENHA', fontSize: 11.0),
                ),
                PasswordInputWidget(
                  controller: _passwordController,
                  validator: (value) {
                    return Validators.required(
                      value,
                      message: 'A senha é obrigatória',
                    );
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButtonWidget(
                    onTap: () => AppRoutes.goToForgotPassword(context),
                    text: 'Esqueceu sua senha?',
                  ),
                ),
                const SizedBox(height: 16.0),
                ButtonWidget(
                  onPressed: _onLoginPressed,
                  label: 'Entrar',
                  isFullWidth: true,
                ),
                const SizedBox(height: 32.0),
                _buildDivider(context),
                const SizedBox(height: 32.0),
                _buildGoogleButton(context),
                const SizedBox(height: 48.0),
                Align(
                  child: Column(
                    children: [
                      Text(
                        'Não tem uma conta?',
                        style: GoogleFonts.plusJakartaSans(
                          color: colorScheme.onSurface.withAlpha(150),
                          fontSize: 14.0,
                        ),
                      ),
                      TextButtonWidget(
                        onTap: () async {
                          await AppRoutes.goToRegister(context, replace: true);
                        },
                        text: 'Cadastre-se',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(child: Divider(color: colorScheme.onSurface.withAlpha(30))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'ou entre com',
            style: GoogleFonts.plusJakartaSans(
              color: colorScheme.onSurface.withAlpha(100),
              fontSize: 12.0,
              fontWeight: FontWeight.w700,
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
      onPressed: null,
      style: OutlinedButton.styleFrom(
        fixedSize: const Size(double.maxFinite, 56.0),
        side: BorderSide(color: colorScheme.onSurface.withAlpha(30)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.g_mobiledata_rounded, size: 32.0, color: Colors.red),
          const SizedBox(width: 8.0),
          Text(
            'Continuar com Google',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15.0,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
