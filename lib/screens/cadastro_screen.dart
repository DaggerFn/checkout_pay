import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../services/auth_service.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  bool _carregando = false;
  String? _erro;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _fazerCadastro() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    final erro = await AuthService().registrar(
      _nomeController.text.trim(),
      _emailController.text.trim(),
      _senhaController.text,
      _confirmarSenhaController.text,
    );

    if (!mounted) return;

    setState(() {
      _carregando = false;
      _erro = erro;
    });

    if (erro == null) {
      // Cadastro bem-sucedido, ir para Dashboard
      Navigator.of(context).pushReplacementNamed('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CADASTRO'),
        backgroundColor: AppColors.primaryDarkColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            const Text(
              'Contas em Dia',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textColorLight,
              ),
            ),
            const SizedBox(height: 40),

            // Campo Nome
            TextFormField(
              controller: _nomeController,
              enabled: !_carregando,
              decoration: const InputDecoration(
                labelText: 'Nome completo',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 20),

            // Campo Email
            TextFormField(
              controller: _emailController,
              enabled: !_carregando,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email),
                errorText: _erro,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            // Campo Senha
            TextFormField(
              controller: _senhaController,
              enabled: !_carregando,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha (mínimo 6 caracteres)',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 20),

            // Campo Confirmar Senha
            TextFormField(
              controller: _confirmarSenhaController,
              enabled: !_carregando,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmar senha',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 40),

            // Botão Cadastro
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _carregando ? null : _fazerCadastro,
                child: _carregando
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('CRIAR CONTA'),
              ),
            ),
            const SizedBox(height: 20),

            // Link Voltar
            TextButton(
              onPressed: _carregando ? null : () => Navigator.of(context).pop(),
              child: const Text('Voltar ao Login'),
            ),
          ],
        ),
      ),
    );
  }
}