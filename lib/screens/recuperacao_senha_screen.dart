import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../repositories/usuario_repository.dart';
import '../services/password_service.dart';

class RecuperacaoSenhaScreen extends StatefulWidget {
  const RecuperacaoSenhaScreen({super.key});

  @override
  State<RecuperacaoSenhaScreen> createState() => _RecuperacaoSenhaScreenState();
}

class _RecuperacaoSenhaScreenState extends State<RecuperacaoSenhaScreen> {
  final _usuarioRepository = UsuarioRepository();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmaSenhaController = TextEditingController();

  int _step = 1; // 1: Digitar Email, 2: Nova Senha
  bool _carregando = false;
  String? _erro;
  String? _emailRecuperacao;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    _confirmaSenhaController.dispose();
    super.dispose();
  }

  Future<void> _validarEmail() async {
    setState(() => _erro = null);

    if (_emailController.text.isEmpty) {
      setState(() => _erro = 'Por favor, insira um email');
      return;
    }

    try {
      setState(() => _carregando = true);

      // Verificar se email existe no banco
      final usuario = await _usuarioRepository.buscarPorEmail(_emailController.text);

      if (usuario == null) {
        setState(() => _erro = 'Email não encontrado no sistema');
        return;
      }

      setState(() {
        _emailRecuperacao = _emailController.text;
        _step = 2;
      });
    } catch (e) {
      setState(() => _erro = 'Erro ao validar email: $e');
    } finally {
      setState(() => _carregando = false);
    }
  }

  Future<void> _redefinirSenha() async {
    setState(() => _erro = null);

    if (_senhaController.text.isEmpty || _confirmaSenhaController.text.isEmpty) {
      setState(() => _erro = 'Por favor, preencha todos os campos');
      return;
    }

    if (_senhaController.text != _confirmaSenhaController.text) {
      setState(() => _erro = 'As senhas não coincidem');
      return;
    }

    final validacaoErro = PasswordService.validatePassword(_senhaController.text);
    if (validacaoErro != null) {
      setState(() => _erro = validacaoErro);
      return;
    }

    try {
      setState(() => _carregando = true);

      // Hash da nova senha
      final novaSenha = PasswordService.hashPassword(_senhaController.text);

      // Atualizar senha do usuário no banco
      await _usuarioRepository.atualizarSenha(_emailRecuperacao!, novaSenha);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Senha alterada com sucesso!'),
            backgroundColor: AppColors.successColor,
          ),
        );
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      setState(() => _erro = 'Erro ao redefinir senha: $e');
    } finally {
      setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperação de Senha'),
        backgroundColor: AppColors.primaryDarkColor,
        elevation: 0,
      ),
      body: _carregando
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.accentPurple),
            )
          : Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_erro != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.dangerColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _erro!,
                          style: const TextStyle(color: AppColors.dangerColor),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (_step == 1) ...[
                      const Text(
                        'Digite seu email para recuperar a senha',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textColorLight,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: _validarEmail,
                        child: const Text('Continuar'),
                      ),
                    ] else if (_step == 2) ...[
                      const Text(
                        'Digite sua nova senha',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textColorLight,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _senhaController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Nova Senha',
                          prefixIcon: Icon(Icons.lock),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmaSenhaController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Confirmar Nova Senha',
                          prefixIcon: Icon(Icons.lock),
                        ),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: _redefinirSenha,
                        child: const Text('Redefinir Senha'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}
