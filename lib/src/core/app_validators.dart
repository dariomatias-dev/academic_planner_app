class AppValidators {
  static String? required(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? "Este campo é obrigatório";
    }

    return null;
  }

  static String? url(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) return null;

    final regex = RegExp(
      r'^(https?:\/\/)?([\w\d.-]+)\.([a-z.]{2,6})([\/\w\d.-]*)*\/?$',
    );
    if (!regex.hasMatch(value)) {
      return message ?? "Insira um link válido";
    }

    return null;
  }
}
