class Conta {
  final int? id;
  final int usuarioId;
  final String nome;
  final String? descricao;
  final double valor;
  final DateTime dataVencimento;
  final String? horaVencimento;
  final String? categoria;
  final String status; // 'Pendente', 'Pago', 'Vencida'
  final DateTime? dataCriacao;
  final DateTime? dataAtualizacao;

  Conta({
    this.id,
    required this.usuarioId,
    required this.nome,
    this.descricao,
    required this.valor,
    required this.dataVencimento,
    this.horaVencimento,
    this.categoria,
    this.status = 'Pendente',
    this.dataCriacao,
    this.dataAtualizacao,
  });

  // Converter do banco para objeto
  factory Conta.fromMap(Map<String, dynamic> map) {
    return Conta(
      id: map['id'] as int?,
      usuarioId: map['usuario_id'] as int,
      nome: map['nome'] as String,
      descricao: map['descricao'] as String?,
      valor: (map['valor'] as num).toDouble(),
      dataVencimento: DateTime.parse(map['data_vencimento'].toString()),
      horaVencimento: map['hora_vencimento']?.toString(),
      categoria: map['categoria'] as String?,
      status: map['status'] as String,
      dataCriacao: map['data_criacao'] != null
          ? DateTime.parse(map['data_criacao'].toString())
          : null,
      dataAtualizacao: map['data_atualizacao'] != null
          ? DateTime.parse(map['data_atualizacao'].toString())
          : null,
    );
  }

  // Converter objeto para mapa
  Map<String, dynamic> toMap() {
    return {
      'usuario_id': usuarioId,
      'nome': nome,
      'descricao': descricao,
      'valor': valor,
      'data_vencimento': dataVencimento.toIso8601String().split('T')[0],
      'hora_vencimento': horaVencimento,
      'categoria': categoria,
      'status': status,
    };
  }

  @override
  String toString() {
    return 'Conta(id: $id, nome: $nome, valor: R\$ $valor, status: $status)';
  }
}