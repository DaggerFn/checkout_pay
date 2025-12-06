import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'screens/login_screen.dart';
import 'screens/cadastro_screen.dart';
import 'screens/recuperacao_senha_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/listagem_contas_screen.dart';
import 'screens/cadastro_edicao_conta_screen.dart';
import 'screens/configuracoes_screen.dart';
import 'models/conta.dart';

void main() {
  runApp(const ContasEmDiaApp());
}

class ContasEmDiaApp extends StatelessWidget {
  const ContasEmDiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contas em Dia',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(
              builder: (context) => const LoginScreen(),
              settings: settings,
            );
          case '/cadastro':
            return MaterialPageRoute(
              builder: (context) => const CadastroScreen(),
              settings: settings,
            );
          case '/recuperacao_senha':
            return MaterialPageRoute(
              builder: (context) => const RecuperacaoSenhaScreen(),
              settings: settings,
            );
          case '/dashboard':
            return MaterialPageRoute(
              builder: (context) => const DashboardScreen(),
              settings: settings,
            );
          case '/listagem_contas':
            return MaterialPageRoute(
              builder: (context) => const ListagemContasScreen(),
              settings: settings,
            );
          case '/cadastro_edicao_conta':
            print('--- ROTA: /cadastro_edicao_conta ---');
            print('ARGUMENTOS RECEBIDOS: ${settings.arguments}');

            final args = settings.arguments as Map<String, dynamic>?;
            final contaArg = args != null && args['conta'] is Conta ? args['conta'] as Conta : null;
            
            print('CONTA EXTRAÍDA (ID): ${contaArg?.id}');
            print('------------------------------------');

            return MaterialPageRoute(
              builder: (context) => CadastroEdicaoContaScreen(conta: contaArg),
              settings: settings,
            );
          case '/configuracoes':
            return MaterialPageRoute(
              builder: (context) => const ConfiguracoesScreen(),
              settings: settings,
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const LoginScreen(),
              settings: settings,
            );
        }
      },
    );
  }
}