import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../services/auth_service.dart';

class ConfiguracoesScreen extends StatefulWidget {
  const ConfiguracoesScreen({super.key});

  @override
  State<ConfiguracoesScreen> createState() => _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends State<ConfiguracoesScreen> {

  void _confirmarLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Saída'),
        content: const Text('Deseja realmente sair de sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              AuthService().logout();
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (Route<dynamic> route) => false,
              );
            },
            child: const Text(
              'Sair',
              style: TextStyle(color: AppColors.dangerColor),
            ),
          ),
        ],
      ),
    );
  }

  void _abrirTrocarSenha() {
    Navigator.of(context).pushNamed('/recuperacao_senha');
  }

  @override
  Widget build(BuildContext context) {
    final usuario = AuthService().usuarioLogado;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        backgroundColor: AppColors.primaryDarkColor,
        elevation: 0,
      ),
      body: ListView(
        children: [
          // Seção de Perfil
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.inputFieldBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Perfil',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.accentPurple,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  const Icon(
                    Icons.account_circle,
                    size: 48,
                    color: AppColors.accentPurple,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    usuario?.nome ?? 'Usuário',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColorLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    usuario?.email ?? 'email@example.com',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textColorLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.lock, color: AppColors.accentPurple),
            title: const Text(
              'Alterar Senha',
              style: TextStyle(color: AppColors.textColorLight),
            ),
            subtitle: const Text(
              'Redefina sua senha de acesso ao app.',
              style: TextStyle(color: AppColors.textColorLight),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textColorLight,
            ),
            onTap: _abrirTrocarSenha,
          ),
          _buildSettingsHeader('Informações e Suporte'),
          ListTile(
            leading: const Icon(Icons.info, color: AppColors.accentPurple),
            title: const Text(
              'Sobre o App',
              style: TextStyle(color: AppColors.textColorLight),
            ),
            subtitle: const Text(
              'Versão 1.0.0 - Checkout Pay',
              style: TextStyle(color: AppColors.textColorLight),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.dangerColor),
            title: const Text(
              'Sair da Conta',
              style: TextStyle(color: AppColors.dangerColor),
            ),
            onTap: _confirmarLogout,
          ),
        ],
      ),
    );
  }

  // Widget de cabeçalho para as seções de configurações
  Widget _buildSettingsHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 24.0,
        left: 16.0,
        right: 16.0,
        bottom: 8.0,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.accentPurple,
        ),
      ),
    );
  }
}
