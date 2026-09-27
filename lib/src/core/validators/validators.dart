class Validators {
  static String? Function(String? value) multiple(
    List<String? Function(String? value)> validators,
  ) {
    return (value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }

      return null;
    };
  }

  static String? required(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'Este campo é obrigatório';
    }

    return null;
  }

  static String? email(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) return null;

    final regex = RegExp(r'^[\w\-.+]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value)) {
      return message ?? 'Insira um e-mail válido';
    }

    return null;
  }

  static String? compare(String? value, String? target, {String? message}) {
    if (value != target) {
      return message ?? 'Os campos não coincidem';
    }

    return null;
  }

  static String? url(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) return null;

    final regex = RegExp(
      r'^(https?:\/\/)?([\w\d.-]+)\.([a-z.]{2,6})([\/\w\d.-]*)*\/?$',
    );
    if (!regex.hasMatch(value)) {
      return message ?? 'Insira um link válido';
    }

    return null;
  }
}
