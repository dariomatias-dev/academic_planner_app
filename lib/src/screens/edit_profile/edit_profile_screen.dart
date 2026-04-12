import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/validators.dart';

import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/forms/forms.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/inputs/input_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  void _onSavePressed() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pop(context);
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

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: 'Editar Perfil',
        actions: <Widget>[
          IconButtonWidget(
            icon: Icons.check_rounded,
            onPressed: _onSavePressed,
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
              FormFieldLabelWidget(label: "Nome completo"),
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
              FormFieldLabelWidget(label: "E-mail"),
              InputWidget(
                controller: _emailController,
                hint: "seu@email.com",
                readOnly: true,
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: colorScheme.primary,
                  size: 20.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
