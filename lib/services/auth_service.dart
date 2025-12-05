import '../models/usuario.dart';
import '../repositories/usuario_repository.dart';
import 'password_service.dart';

/// Service para gerenciar autenticação
class AuthService {
  static final AuthService _instance = AuthService._internal();
  
  Usuario? _usuarioLogado;
  final _usuarioRepository = UsuarioRepository();

  AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  /// Retorna o usuário atualmente logado
  Usuario? get usuarioLogado => _usuarioLogado;

  /// Verifica se existe usuário logado
  bool get isLogado => _usuarioLogado != null;

  /// Faz login do usuário
  /// Retorna null se sucesso, ou mensagem de erro se falhar
  Future<String?> login(String email, String senha) async {
    try {
      if (email.isEmpty || senha.isEmpty) {
        return 'Email e senha são obrigatórios';
      }

      // Busca usuário pelo email
      final usuario = await _usuarioRepository.buscarPorEmail(email);

      if (usuario == null) {
        return 'Usuário não encontrado';
      }

      // Verifica a senha
      if (!PasswordService.verifyPassword(senha, usuario.senhaHash)) {
        return 'Senha incorreta';
      }

      // Armazena usuário logado
      _usuarioLogado = usuario;
      return null; // Sucesso
    } catch (e) {
      return 'Erro ao fazer login: $e';
    }
  }

  /// Registra novo usuário
  /// Retorna null se sucesso, ou mensagem de erro se falhar
  Future<String?> registrar(String nome, String email, String senha, String senhaConfirm) async {
    try {
      // Valida campos
      if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
        return 'Todos os campos são obrigatórios';
      }

      if (senha != senhaConfirm) {
        return 'As senhas não conferem';
      }

      final senhaError = PasswordService.validatePassword(senha);
      if (senhaError != null) {
        return senhaError;
      }

      // Verifica se email já existe
      final usuarioExistente = await _usuarioRepository.buscarPorEmail(email);
      if (usuarioExistente != null) {
        return 'Este email já está cadastrado';
      }

      // Cria novo usuário
      final senhaHash = PasswordService.hashPassword(senha);
      final novoUsuario = Usuario(
        nome: nome,
        email: email,
        senhaHash: senhaHash,
      );

      final usuarioCriado = await _usuarioRepository.criar(novoUsuario);

      if (usuarioCriado == null) {
        return 'Erro ao criar usuário';
      }

      // Faz login automático
      _usuarioLogado = usuarioCriado;
      return null; // Sucesso
    } catch (e) {
      return 'Erro ao registrar: $e';
    }
  }

  /// Faz logout do usuário
  void logout() {
    _usuarioLogado = null;
  }

  /// Atualiza dados do usuário logado
  void atualizarUsuarioLogado(Usuario usuario) {
    _usuarioLogado = usuario;
  }
}
