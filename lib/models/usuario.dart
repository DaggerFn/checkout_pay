class Usuario {
  final int? id;
  final String nome;
  final String email;
  final String senhaHash;
  final DateTime? dataCriacao;
  final DateTime? dataAtualizacao;

  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.senhaHash,
    this.dataCriacao,
    this.dataAtualizacao,
  });

  // Converter do banco para objeto
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      email: map['email'] as String,
      senhaHash: map['senha_hash'] as String,
      dataCriacao: map['data_criacao'] != null 
          ? DateTime.parse(map['data_criacao'].toString()) 
          : null,
      dataAtualizacao: map['data_atualizacao'] != null 
          ? DateTime.parse(map['data_atualizacao'].toString()) 
          : null,
    );
  }

  // Converter objeto para mapa (para INSERT/UPDATE)
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'email': email,
      'senha_hash': senhaHash,
    };
  }

  @override
  String toString() {
    return 'Usuario(id: $id, nome: $nome, email: $email)';
  }
}