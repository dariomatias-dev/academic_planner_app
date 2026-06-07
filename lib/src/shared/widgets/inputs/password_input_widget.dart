import 'package:academic_planner/src/shared/widgets/inputs/input_widget.dart';
import 'package:flutter/material.dart';

class PasswordInputWidget extends StatefulWidget {
  const PasswordInputWidget({
    required this.controller,
    super.key,
    this.hint = '••••••••',
    this.validator,
    this.style = InputStyle.primary,
  });

  final TextEditingController controller;
  final String hint;
  final String? Function(String? value)? validator;
  final InputStyle style;

  @override
  State<PasswordInputWidget> createState() => _PasswordInputWidgetState();
}

class _PasswordInputWidgetState extends State<PasswordInputWidget> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return InputWidget(
      controller: widget.controller,
      hint: widget.hint,
      validator: widget.validator,
      style: widget.style,
      obscureText: _isObscured,
      prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20.0),
      suffix: IconButton(
        onPressed: () {
          setState(() => _isObscured = !_isObscured);
        },
        icon: Icon(
          _isObscured
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          size: 20.0,
        ),
      ),
    );
  }
}
