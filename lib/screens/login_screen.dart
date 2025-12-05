import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _authService = AuthService();
  bool _carregando = false;
  String? _erro;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _fazerLogin() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    final erro = await _authService.login(
      _emailController.text.trim(),
      _senhaController.text,
    );

    if (!mounted) return;

    setState(() {
      _carregando = false;
      _erro = erro;
    });

    if (erro == null) {
      // Login bem-sucedido
      Navigator.of(context).pushReplacementNamed('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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

              // Campo Email
              TextFormField(
                controller: _emailController,
                enabled: !_carregando,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'seu@email.com',
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
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 10),

              // Link Recuperar Senha
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _carregando
                      ? null
                      : () {
                          Navigator.of(context).pushNamed('/recuperacao_senha');
                        },
                  child: const Text('Recuperar Senha?'),
                ),
              ),
              const SizedBox(height: 20),

              // Botão Login
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _carregando ? null : _fazerLogin,
                  child: _carregando
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('ENTRAR'),
                ),
              ),
              const SizedBox(height: 20),

              // Botão Cadastro
              TextButton(
                onPressed: _carregando
                    ? null
                    : () {
                        Navigator.of(context).pushNamed('/cadastro');
                      },
                child: const Text(
                  'Criar Nova Conta',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}