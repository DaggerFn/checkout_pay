import 'package:postgres/postgres.dart';
import '../config/database.dart';
import '../models/conta.dart';

/// Repository responsável por todas as operações com a tabela 'contas'
class ContaRepository {
  // ============================================
  // CREATE - Cadastrar nova conta
  // ============================================
  
  /// Cria uma nova conta no banco de dados
  /// Retorna a conta criada com o ID gerado
  Future<Conta?> criar(Conta conta) async {
    try {
      print('🔄 Tentando criar conta: ${conta.nome}');
      final conn = await DatabaseConfig.getConnection();
      print('✅ Conexão obtida');
      
      final result = await conn.execute(
        Sql.named('''
          INSERT INTO contas (
            usuario_id, nome, descricao, valor, data_vencimento,
            hora_vencimento, categoria, status
          )
          VALUES (
            @usuario_id, @nome, @descricao, @valor, @data_vencimento,
            @hora_vencimento, @categoria, @status
          )
          RETURNING id, usuario_id, nome, descricao, valor, data_vencimento,
                    hora_vencimento, categoria, status, data_criacao, data_atualizacao
        '''),
        parameters: {
          'usuario_id': conta.usuarioId,
          'nome': conta.nome,
          'descricao': conta.descricao,
          'valor': conta.valor,
          'data_vencimento': conta.dataVencimento.toIso8601String().split('T')[0],
          'hora_vencimento': conta.horaVencimento,
          'categoria': conta.categoria,
          'status': conta.status,
        },
      );

      if (result.isNotEmpty) {
        final row = result.first;
        print('✅ Conta criada com sucesso! ID: ${row[0]}');
        
        // Debug: ver os tipos de cada campo
        print('🔍 Tipos dos campos:');
        for (int i = 0; i < row.length; i++) {
          print('   [$i] ${row[i].runtimeType}: ${row[i]}');
        }
        
        return Conta(
          id: row[0] as int,
          usuarioId: row[1] as int,
          nome: row[2] as String,
          descricao: row[3] as String?,
          valor: _parseNumero(row[4]),
          dataVencimento: _parseData(row[5]),
          horaVencimento: row[6]?.toString(),
          categoria: row[7] as String?,
          status: row[8] as String,
          dataCriacao: row[9] != null ? _parseData(row[9]) : null,
          dataAtualizacao: row[10] != null ? _parseData(row[10]) : null,
        );
      }
      
      return null;
    } catch (e) {
      print('❌ Erro ao criar conta: $e');
      return null;
    }
  }

  // ============================================
  // READ - Buscar contas
  // ============================================
  
  /// Busca conta por ID
  Future<Conta?> buscarPorId(int id, int usuarioId) async {
    try {
      final conn = await DatabaseConfig.getConnection();
      
      final result = await conn.execute(
        Sql.named('''
          SELECT id, usuario_id, nome, descricao, valor, data_vencimento,
                 hora_vencimento, categoria, status, data_criacao, data_atualizacao
          FROM contas
          WHERE id = @id AND usuario_id = @usuario_id
        '''),
        parameters: {
          'id': id,
          'usuario_id': usuarioId,
        },
      );

      if (result.isNotEmpty) {
        final row = result.first;
        return Conta(
          id: row[0] as int,
          usuarioId: row[1] as int,
          nome: row[2] as String,
          descricao: row[3] as String?,
          valor: _parseNumero(row[4]),
          dataVencimento: _parseData(row[5]),
          horaVencimento: row[6]?.toString(),
          categoria: row[7] as String?,
          status: row[8] as String,
          dataCriacao: row[9] != null ? _parseData(row[9]) : null,
          dataAtualizacao: row[10] != null ? _parseData(row[10]) : null,
        );
      }
      
      return null;
    } catch (e) {
      print('❌ Erro ao buscar conta por ID: $e');
      return null;
    }
  }

  /// Busca todas as contas de um usuário
  Future<List<Conta>> buscarPorUsuario(int usuarioId) async {
    try {
      final conn = await DatabaseConfig.getConnection();
      
      final result = await conn.execute(
        Sql.named('''
          SELECT id, usuario_id, nome, descricao, valor, data_vencimento,
                 hora_vencimento, categoria, status, data_criacao, data_atualizacao
          FROM contas
          WHERE usuario_id = @usuario_id
          ORDER BY data_vencimento ASC
        '''),
        parameters: {'usuario_id': usuarioId},
      );

      return result.map((row) {
        return Conta(
          id: row[0] as int,
          usuarioId: row[1] as int,
          nome: row[2] as String,
          descricao: row[3] as String?,
          valor: _parseNumero(row[4]),
          dataVencimento: _parseData(row[5]),
          horaVencimento: row[6]?.toString(),
          categoria: row[7] as String?,
          status: row[8] as String,
          dataCriacao: row[9] != null ? _parseData(row[9]) : null,
          dataAtualizacao: row[10] != null ? _parseData(row[10]) : null,
        );
      }).toList();
    } catch (e) {
      print('❌ Erro ao buscar contas do usuário: $e');
      return [];
    }
  }

  /// Busca contas por status (Pendente, Pago, Vencida)
  Future<List<Conta>> buscarPorStatus(int usuarioId, String status) async {
    try {
      final conn = await DatabaseConfig.getConnection();
      
      final result = await conn.execute(
        Sql.named('''
          SELECT id, usuario_id, nome, descricao, valor, data_vencimento,
                 hora_vencimento, categoria, status, data_criacao, data_atualizacao
          FROM contas
          WHERE usuario_id = @usuario_id AND status = @status
          ORDER BY data_vencimento ASC
        '''),
        parameters: {
          'usuario_id': usuarioId,
          'status': status,
        },
      );

      return result.map((row) {
        return Conta(
          id: row[0] as int,
          usuarioId: row[1] as int,
          nome: row[2] as String,
          descricao: row[3] as String?,
          valor: (row[4] as num).toDouble(),
          dataVencimento: DateTime.parse(row[5].toString()),
          horaVencimento: row[6]?.toString(),
          categoria: row[7] as String?,
          status: row[8] as String,
          dataCriacao: row[9] as DateTime?,
          dataAtualizacao: row[10] as DateTime?,
        );
      }).toList();
    } catch (e) {
      print('❌ Erro ao buscar contas por status: $e');
      return [];
    }
  }

  /// Busca contas por categoria
  Future<List<Conta>> buscarPorCategoria(int usuarioId, String categoria) async {
    try {
      final conn = await DatabaseConfig.getConnection();
      
      final result = await conn.execute(
        Sql.named('''
          SELECT id, usuario_id, nome, descricao, valor, data_vencimento,
                 hora_vencimento, categoria, status, data_criacao, data_atualizacao
          FROM contas
          WHERE usuario_id = @usuario_id AND categoria = @categoria
          ORDER BY data_vencimento ASC
        '''),
        parameters: {
          'usuario_id': usuarioId,
          'categoria': categoria,
        },
      );

      return result.map((row) {
        return Conta(
          id: row[0] as int,
          usuarioId: row[1] as int,
          nome: row[2] as String,
          descricao: row[3] as String?,
          valor: (row[4] as num).toDouble(),
          dataVencimento: DateTime.parse(row[5].toString()),
          horaVencimento: row[6]?.toString(),
          categoria: row[7] as String?,
          status: row[8] as String,
          dataCriacao: row[9] as DateTime?,
          dataAtualizacao: row[10] as DateTime?,
        );
      }).toList();
    } catch (e) {
      print('❌ Erro ao buscar contas por categoria: $e');
      return [];
    }
  }

  /// Busca contas de um mês/ano específico
  Future<List<Conta>> buscarPorMes(int usuarioId, int mes, int ano) async {
    try {
      final conn = await DatabaseConfig.getConnection();
      
      final result = await conn.execute(
        Sql.named('''
          SELECT id, usuario_id, nome, descricao, valor, data_vencimento,
                 hora_vencimento, categoria, status, data_criacao, data_atualizacao
          FROM contas
          WHERE usuario_id = @usuario_id
            AND EXTRACT(MONTH FROM data_vencimento) = @mes
            AND EXTRACT(YEAR FROM data_vencimento) = @ano
          ORDER BY data_vencimento ASC
        '''),
        parameters: {
          'usuario_id': usuarioId,
          'mes': mes,
          'ano': ano,
        },
      );

      return result.map((row) {
        return Conta(
          id: row[0] as int,
          usuarioId: row[1] as int,
          nome: row[2] as String,
          descricao: row[3] as String?,
          valor: (row[4] as num).toDouble(),
          dataVencimento: DateTime.parse(row[5].toString()),
          horaVencimento: row[6]?.toString(),
          categoria: row[7] as String?,
          status: row[8] as String,
          dataCriacao: row[9] as DateTime?,
          dataAtualizacao: row[10] as DateTime?,
        );
      }).toList();
    } catch (e) {
      print('❌ Erro ao buscar contas por mês: $e');
      return [];
    }
  }

  /// Busca contas por termo de pesquisa (nome ou descrição)
  Future<List<Conta>> buscar(int usuarioId, String termo) async {
    try {
      final conn = await DatabaseConfig.getConnection();
      
      final result = await conn.execute(
        Sql.named('''
          SELECT id, usuario_id, nome, descricao, valor, data_vencimento,
                 hora_vencimento, categoria, status, data_criacao, data_atualizacao
          FROM contas
          WHERE usuario_id = @usuario_id
            AND (nome ILIKE @termo OR descricao ILIKE @termo)
          ORDER BY data_vencimento ASC
        '''),
        parameters: {
          'usuario_id': usuarioId,
          'termo': '%$termo%',
        },
      );

      return result.map((row) {
        return Conta(
          id: row[0] as int,
          usuarioId: row[1] as int,
          nome: row[2] as String,
          descricao: row[3] as String?,
          valor: (row[4] as num).toDouble(),
          dataVencimento: DateTime.parse(row[5].toString()),
          horaVencimento: row[6]?.toString(),
          categoria: row[7] as String?,
          status: row[8] as String,
          dataCriacao: row[9] as DateTime?,
          dataAtualizacao: row[10] as DateTime?,
        );
      }).toList();
    } catch (e) {
      print('❌ Erro ao buscar contas: $e');
      return [];
    }
  }

  // ============================================
  // UPDATE - Atualizar contas
  // ============================================
  
  /// Atualiza os dados de uma conta
  Future<bool> atualizar(Conta conta) async {
    try {
      final conn = await DatabaseConfig.getConnection();
      
      final result = await conn.execute(
        Sql.named('''
          UPDATE contas
          SET nome = @nome,
              descricao = @descricao,
              valor = @valor,
              data_vencimento = @data_vencimento,
              hora_vencimento = @hora_vencimento,
              categoria = @categoria,
              status = @status
          WHERE id = @id AND usuario_id = @usuario_id
        '''),
        parameters: {
          'id': conta.id,
          'usuario_id': conta.usuarioId,
          'nome': conta.nome,
          'descricao': conta.descricao,
          'valor': conta.valor,
          'data_vencimento': conta.dataVencimento.toIso8601String().split('T')[0],
          'hora_vencimento': conta.horaVencimento,
          'categoria': conta.categoria,
          'status': conta.status,
        },
      );

      return result.affectedRows > 0;
    } catch (e) {
      print('❌ Erro ao atualizar conta: $e');
      return false;
    }
  }

  /// Marca uma conta como paga
  Future<bool> marcarComoPago(int id, int usuarioId) async {
    try {
      final conn = await DatabaseConfig.getConnection();
      
      final result = await conn.execute(
        Sql.named('''
          UPDATE contas
          SET status = 'Pago'
          WHERE id = @id AND usuario_id = @usuario_id
        '''),
        parameters: {
          'id': id,
          'usuario_id': usuarioId,
        },
      );

      return result.affectedRows > 0;
    } catch (e) {
      print('❌ Erro ao marcar conta como paga: $e');
      return false;
    }
  }

  /// Altera o status de uma conta
  Future<bool> alterarStatus(int id, int usuarioId, String novoStatus) async {
    try {
      final conn = await DatabaseConfig.getConnection();
      
      final result = await conn.execute(
        Sql.named('''
          UPDATE contas
          SET status = @status
          WHERE id = @id AND usuario_id = @usuario_id
        '''),
        parameters: {
          'id': id,
          'usuario_id': usuarioId,
          'status': novoStatus,
        },
      );

      return result.affectedRows > 0;
    } catch (e) {
      print('❌ Erro ao alterar status: $e');
      return false;
    }
  }

  // ============================================
  // DELETE - Deletar conta
  // ============================================
  
  /// Deleta uma conta
  Future<bool> deletar(int id, int usuarioId) async {
    try {
      final conn = await DatabaseConfig.getConnection();
      
      final result = await conn.execute(
        Sql.named('''
          DELETE FROM contas
          WHERE id = @id AND usuario_id = @usuario_id
        '''),
        parameters: {
          'id': id,
          'usuario_id': usuarioId,
        },
      );

      return result.affectedRows > 0;
    } catch (e) {
      print('❌ Erro ao deletar conta: $e');
      return false;
    }
  }

  // ============================================
  // RELATÓRIOS E ESTATÍSTICAS
  // ============================================
  
  /// Obtém resumo mensal (total pendente, pago, vencido)
  Future<Map<String, double>> obterResumoMensal(int usuarioId) async {
    try {
      final conn = await DatabaseConfig.getConnection();
      final agora = DateTime.now();
      
      final result = await conn.execute(
        Sql.named('''
          SELECT 
            SUM(CASE WHEN status = 'Pendente' THEN valor ELSE 0 END) as total_pendente,
            SUM(CASE WHEN status = 'Pago' THEN valor ELSE 0 END) as total_pago,
            SUM(CASE WHEN status = 'Vencida' THEN valor ELSE 0 END) as total_vencido
          FROM contas
          WHERE usuario_id = @usuario_id
            AND EXTRACT(MONTH FROM data_vencimento) = @mes
            AND EXTRACT(YEAR FROM data_vencimento) = @ano
        '''),
        parameters: {
          'usuario_id': usuarioId,
          'mes': agora.month,
          'ano': agora.year,
        },
      );

      if (result.isNotEmpty) {
        final row = result.first;
        return {
          'pendente': _parseNumero(row[0]),
          'pago': _parseNumero(row[1]),
          'vencido': _parseNumero(row[2]),
        };
      }
      
      return {'pendente': 0.0, 'pago': 0.0, 'vencido': 0.0};
    } catch (e) {
      print('❌ Erro ao obter resumo mensal: $e');
      return {'pendente': 0.0, 'pago': 0.0, 'vencido': 0.0};
    }
  }

  /// Calcula total de contas pendentes
  Future<double> calcularTotalPendente(int usuarioId) async {
    try {
      final conn = await DatabaseConfig.getConnection();
      
      final result = await conn.execute(
        Sql.named('''
          SELECT COALESCE(SUM(valor), 0) as total
          FROM contas
          WHERE usuario_id = @usuario_id AND status = 'Pendente'
        '''),
        parameters: {'usuario_id': usuarioId},
      );

      return _parseNumero(result.first[0]);
    } catch (e) {
      print('❌ Erro ao calcular total pendente: $e');
      return 0.0;
    }
  }

  /// Calcula total de contas pagas
  Future<double> calcularTotalPago(int usuarioId) async {
    try {
      final conn = await DatabaseConfig.getConnection();
      
      final result = await conn.execute(
        Sql.named('''
          SELECT COALESCE(SUM(valor), 0) as total
          FROM contas
          WHERE usuario_id = @usuario_id AND status = 'Pago'
        '''),
        parameters: {'usuario_id': usuarioId},
      );

      return _parseNumero(result.first[0]);
    } catch (e) {
      print('❌ Erro ao calcular total pago: $e');
      return 0.0;
    }
  }

  /// Conta total de contas do usuário
  Future<int> contarContas(int usuarioId) async {
    try {
      final conn = await DatabaseConfig.getConnection();
      
      final result = await conn.execute(
        Sql.named('''
          SELECT COUNT(*) FROM contas WHERE usuario_id = @usuario_id
        '''),
        parameters: {'usuario_id': usuarioId},
      );

      return result.first[0] as int;
    } catch (e) {
      print('❌ Erro ao contar contas: $e');
      return 0;
    }
  }

  /// Lista todas as categorias únicas do usuário
  Future<List<String>> listarCategorias(int usuarioId) async {
    try {
      final conn = await DatabaseConfig.getConnection();
      
      final result = await conn.execute(
        Sql.named('''
          SELECT DISTINCT categoria
          FROM contas
          WHERE usuario_id = @usuario_id AND categoria IS NOT NULL
          ORDER BY categoria
        '''),
        parameters: {'usuario_id': usuarioId},
      );

      return result.map((row) => row[0] as String).toList();
    } catch (e) {
      print('❌ Erro ao listar categorias: $e');
      return [];
    }
  }

  // ============================================
  // FUNÇÕES AUXILIARES DE PARSING
  // ============================================

  /// Converte um valor numérico para double de forma segura
  double _parseNumero(dynamic valor) {
    if (valor == null) return 0.0;
    if (valor is double) return valor;
    if (valor is int) return valor.toDouble();
    if (valor is num) return valor.toDouble();
    try {
      return double.parse(valor.toString());
    } catch (e) {
      print('⚠️ Erro ao parsear número: $valor -> $e');
      return 0.0;
    }
  }

  /// Converte uma data de forma segura
  DateTime _parseData(dynamic data) {
    if (data == null) return DateTime.now();
    if (data is DateTime) return data;
    try {
      return DateTime.parse(data.toString());
    } catch (e) {
      print('⚠️ Erro ao parsear data: $data -> $e');
      return DateTime.now();
    }
  }
}