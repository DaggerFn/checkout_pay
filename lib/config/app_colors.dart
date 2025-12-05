import 'package:flutter/material.dart';

// PALETA DE CORES (Baseada nos designs e documento técnico)
class AppColors {
  // Cores principais
  static const Color primaryDarkColor = Color(0xFF1E1E1E); // Fundo escuro geral
  static const Color accentPurple = Color(0xFF6A1B9A); // Roxo de destaque
  
  // Cores de texto
  static const Color textColorLight = Colors.white;
  static const Color textColorDark = Colors.black;
  
  // Cores de input
  static const Color inputFieldBackground = Color(0xFF333333);
  static const Color inputFieldBorder = Color(0xFF8E24AA);
  
  // Cores de status
  static const Color successColor = Color(0xFF4CAF50); // Verde para "Pago"
  static const Color warningColor = Color(0xFFFFC107); // Amarelo para "Pendentes"
  static const Color dangerColor = Color(0xFFD32F2F); // Vermelho para "Vencidas"
}