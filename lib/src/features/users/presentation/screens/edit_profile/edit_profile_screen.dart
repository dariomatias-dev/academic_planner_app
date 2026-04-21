import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/core/extensions/user_role_extension.dart';
import 'package:academic_planner/src/core/validators.dart';

import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:academic_planner/src/features/users/di/user_providers.dart';

import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/forms/forms.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/inputs/input_widget.dart';
import 'package:academic_planner/src/shared/widgets/states/states.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  UserRole? _selectedRole;

  bool _initialized = false;

  void _initFields(UserEntity user) {
    if (_initialized) return;

    _nameController.text = user.name;
    _emailController.text = user.email;
    _selectedRole = user.role;
    _initialized = true;
  }

  Future<void> _onSavePressed(UserEntity currentUser) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final updatedUser = UserEntity(
      id: currentUser.id,
      email: currentUser.email,
      name: _nameController.text.trim(),
      role: _selectedRole ?? currentUser.role,
      createdAt: currentUser.createdAt,
      updatedAt: DateTime.now(),
    );

    try {
      await ref.read(userNotifierProvider.notifier).updateProfile(updatedUser);

      if (!mounted) return;

      Fluttertoast.showToast(msg: "Perfil atualizado com sucesso!");
      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(msg: "Erro ao atualizar perfil");
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final userState = ref.watch(userNotifierProvider);

    return userState.when(
      loading: () => const Scaffold(
        appBar: AppBarWidget(title: 'Editar Perfil'),
        body: LoadingStateWidget(message: "Carregando perfil..."),
      ),
      error: (err, stack) => Scaffold(
        appBar: const AppBarWidget(title: 'Editar Perfil'),
        body: ErrorStateWidget(description: 'Erro ao carregar dados: $err'),
      ),
      data: (user) {
        if (user == null) return const SizedBox.shrink();

        _initFields(user);

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBarWidget(
            title: 'Editar Perfil',
            actions: <Widget>[
              IconButtonWidget(
                icon: Icons.check_rounded,
                onPressed: () => _onSavePressed(user),
                style: IconButtonStyle.primary,
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 16.0),
                  const FormFieldLabelWidget(label: "Nome completo"),
                  InputWidget(
                    controller: _nameController,
                    hint: "Seu nome",
                    validator: Validators.required,
                    prefixIcon: Icon(
                      Icons.person_outline_rounded,
                      color: colorScheme.primary,
                      size: 20.0,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  const FormFieldLabelWidget(label: "E-MAIL"),
                  InputWidget(
                    controller: _emailController,
                    hint: "email@gmail.com",
                    readOnly: true,
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: colorScheme.primary,
                      size: 20.0,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  const FormFieldLabelWidget(label: "CARGO"),
                  DropdownFieldWidget<UserRole>(
                    value: _selectedRole,
                    onChanged: (role) => setState(() => _selectedRole = role),
                    prefixIcon: Icon(
                      Icons.badge_outlined,
                      color: colorScheme.primary,
                      size: 20.0,
                    ),
                    items: UserRole.values.builder((role, index) {
                      return DropdownMenuItem(
                        value: role,
                        child: Text(role.label.toUpperCase()),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
