import 'package:crypto/crypto.dart';
import 'dart:convert';

/// Service para hash e verificação de senhas
class PasswordService {
  /// Faz hash da senha usando SHA256
  /// Adiciona um salt fixo para melhor segurança
  static String hashPassword(String password) {
    const salt = 'checkout_pay_2025_secure_salt';
    return sha256.convert(utf8.encode('$password$salt')).toString();
  }

  /// Verifica se a senha informada corresponde ao hash armazenado
  static bool verifyPassword(String password, String hash) {
    final hashFromPassword = hashPassword(password);
    return hashFromPassword == hash;
  }

  /// Valida força da senha (mínimo 6 caracteres)
  static bool isPasswordValid(String password) {
    return password.length >= 6;
  }

  /// Retorna mensagem de erro se senha for fraca
  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Senha é obrigatória';
    }
    if (!isPasswordValid(password)) {
      return 'Senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }
}
