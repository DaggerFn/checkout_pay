import 'package:postgres/postgres.dart';
import '../config/database.dart';
import '../models/usuario.dart';

/// Repository responsável por todas as operações com a tabela 'usuarios'
class UsuarioRepository {
  // ============================================
  // CREATE - Cadastrar novo usuário
  // ============================================
  
  /// Cria um novo usuário no banco de dados
  /// Retorna o usuário criado com o ID gerado
  Future<Usuario?> criar(Usuario usuario) async {
    try {
      final conn = await DatabaseConfig.getConnection();
      
      final result = await conn.execute(
        Sql.named('''
          INSERT INTO usuarios (nome, email, senha_hash)
          VALUES (@nome, @email, @senha_hash)
          RETURNING id, nome, email, senha_hash, data_criacao, data_atualizacao
        '''),
        parameters: {
          'nome': usuario.nome,
          'email': usuario.email,
          'senha_hash': usuario.senhaHash,
        },
      );

      if (result.isNotEmpty) {
        final row = result.first;
        return Usuario(
          id: row[0] as int,
          nome: row[1] as String,
          email: row[2] as String,
          senhaHash: row[3] as String,
          dataCriacao: row[4] as DateTime?,
          dataAtualizacao: row[5] as DateTime?,
        );
      }
      
      return null;
    } catch (e) {

      return null;
    }
  }

  // ============================================
  // READ - Buscar usuários
  // ============================================
  
  /// Busca usuário por ID
  Future<Usuario?> buscarPorId(int id) async {
    try {
      final conn = await DatabaseConfig.getConnection();
      
      final result = await conn.execute(
        Sql.named('''
          SELECT id, nome, email, senha_hash, data_criacao, data_atualizacao
          FROM usuarios
          WHERE id = @id
        '''),
        parameters: {'id': id},
      );

      if (result.isNotEmpty) {
        final row = result.first;
        return Usuario(
          id: row[0] as int,
          nome: row[1] as String,
          email: row[2] as String,
          senhaHash: row[3] as String,
          dataCriacao: row[4] as DateTime?,
          dataAtualizacao: row[5] as DateTime?,
        );
      }
      
      return null;
    } catch (e) {

      return null;
    }
  }

  /// Busca usuário por email (usado no login)
  Future<Usuario?> buscarPorEmail(String email) async {
    try {
      final conn = await DatabaseConfig.getConnection();
      
      final result = await conn.execute(
        Sql.named('''
          SELECT id, nome, email, senha_hash, data_criacao, data_atualizacao
          FROM usuarios
          WHERE email = @email
        '''),
        parameters: {'email': email},
      );

      if (result.isNotEmpty) {
        final row = result.first;
        return Usuario(
          id: row[0] as int,
          nome: row[1] as String,
          email: row[2] as String,
          senhaHash: row[3] as String,
          dataCriacao: row[4] as DateTime?,
          dataAtualizacao: row[5] as DateTime?,
        );
      }
      
      return null;
    } catch (e) {

      return null;
    }
  }

  /// Busca todos os usuários (útil para admin)
  Future<List<Usuario>> buscarTodos() async {
    try {
      final conn = await DatabaseConfig.getConnection();
      
      final result = await conn.execute('''
        SELECT id, nome, email, senha_hash, data_criacao, data_atualizacao
        FROM usuarios
        ORDER BY nome
      ''');

      return result.map((row) {
        return Usuario(
          id: row[0] as int,
          nome: row[1] as String,
          email: row[2] as String,
          senhaHash: row[3] as String,
          dataCriacao: row[4] as DateTime?,
          dataAtualizacao: row[5] as DateTime?,
        );
      }).toList();
    } catch (e) {

      return [];
    }
  }

  /// Verifica se um email já existe no banco
  Future<bool> emailJaExiste(String email) async {
    try {
      final conn = await DatabaseConfig.getConnection();
      
      final result = await conn.execute(
        Sql.named('''
          SELECT COUNT(*) FROM usuarios WHERE email = @email
        '''),
        parameters: {'email': email},
      );

      final count = result.first[0] as int;
      return count > 0;
    } catch (e) {

      return false;
    }
  }

  // ============================================
  // UPDATE - Atualizar usuário
  // ============================================
  
  /// Atualiza os dados do usuário
  Future<bool> atualizar(Usuario usuario) async {
    try {
      final conn = await DatabaseConfig.getConnection();
      
      final result = await conn.execute(
        Sql.named('''
          UPDATE usuarios
          SET nome = @nome,
              email = @email
          WHERE id = @id
        '''),
        parameters: {
          'id': usuario.id,
          'nome': usuario.nome,
          'email': usuario.email,
        },
      );

      return result.affectedRows > 0;
    } catch (e) {

      return false;
    }
  }

  /// Altera a senha do usuário por ID
  Future<bool> alterarSenha(int id, String novaSenhaHash) async {
    try {
      final conn = await DatabaseConfig.getConnection();
      
      final result = await conn.execute(
        Sql.named('''
          UPDATE usuarios
          SET senha_hash = @senha_hash
          WHERE id = @id
        '''),
        parameters: {
          'id': id,
          'senha_hash': novaSenhaHash,
        },
      );

      return result.affectedRows > 0;
    } catch (e) {

      return false;
    }
  }

  /// Altera a senha do usuário por email (para recuperação de senha)
  Future<bool> atualizarSenha(String email, String novaSenhaHash) async {
    try {
      final conn = await DatabaseConfig.getConnection();
      
      final result = await conn.execute(
        Sql.named('''
          UPDATE usuarios
          SET senha_hash = @senha_hash
          WHERE email = @email
        '''),
        parameters: {
          'email': email,
          'senha_hash': novaSenhaHash,
        },
      );

      return result.affectedRows > 0;
    } catch (e) {

      return false;
    }
  }

  // ============================================
  // DELETE - Deletar usuário
  // ============================================
  
  /// Deleta um usuário (CASCADE deleta suas contas também)
  Future<bool> deletar(int id) async {
    try {
      final conn = await DatabaseConfig.getConnection();
      
      final result = await conn.execute(
        Sql.named('''
          DELETE FROM usuarios WHERE id = @id
        '''),
        parameters: {'id': id},
      );

      return result.affectedRows > 0;
    } catch (e) {

      return false;
    }
  }

  // ============================================
  // MÉTODOS AUXILIARES
  // ============================================
  
  /// Conta total de usuários cadastrados
  Future<int> contarUsuarios() async {
    try {
      final conn = await DatabaseConfig.getConnection();
      
      final result = await conn.execute('SELECT COUNT(*) FROM usuarios');
      return result.first[0] as int;
    } catch (e) {

      return 0;
    }
  }
}
