class Validators {
  static String? phone(String? val) {
    if (val == null || val.isEmpty) return 'Téléphone obligatoire';
    if (!RegExp(r'^[0-9]+$').hasMatch(val)) return 'Uniquement des chiffres';
    if (val.length < 8) return 'Minimum 8 chiffres';
    return null;
  }

  static String? name(String? val) {
    if (val == null || val.isEmpty) return 'Nom obligatoire';
    if (val.length < 3) return 'Minimum 3 caractères';
    return null;
  }

  static String? password(String? val) {
    if (val == null || val.isEmpty) return 'Mot de passe obligatoire';
    if (val.length < 6) return 'Minimum 6 caractères';
    return null;
  }

  static String? confirmPassword(String? val, String password) {
    if (val == null || val.isEmpty) return 'Confirmez le mot de passe';
    if (val != password) return 'Les mots de passe ne correspondent pas';
    return null;
  }

  static String? carModel(String? val) {
    if (val == null || val.isEmpty) return 'Modèle de voiture obligatoire';
    return null;
  }

  static String? licensePlate(String? val) {
    if (val == null || val.isEmpty) return 'Numéro de plaque obligatoire';
    return null;
  }
}
