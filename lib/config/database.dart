import 'package:postgres/postgres.dart';
import 'dart:io';

class DatabaseConfig {
  // Configurações de conexão
  // IMPORTANTE: No emulador Android, use 10.0.2.2 em vez de localhost
  // Na web, use localhost
  // No Windows/Linux, use localhost
  static final String host = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  static const int port = 5432;
  static const String databaseName = 'checkout_pay';
  static const String username = 'checkout_pay_app';
  static const String password = '12345678';

  // Singleton para evitar múltiplas conexões
  static Connection? _connection;

  // Obter conexão (reutiliza se já existir)
  static Future<Connection> getConnection() async {
    if (_connection != null && _connection!.isOpen) {
      return _connection!;
    }

    _connection = await Connection.open(
      Endpoint(
        host: host,
        database: databaseName,
        port: port,
        username: username,
        password: password,
      ),
      settings: const ConnectionSettings(
        sslMode: SslMode.disable,
        timeZone: 'America/Sao_Paulo',
      ),
    );

    // Debug: Conexão estabelecida
    return _connection!;
  }

  // Fechar conexão
  static Future<void> closeConnection() async {
    if (_connection != null && _connection!.isOpen) {
      await _connection!.close();
      _connection = null;
    }
  }

  // Testar conexão
  static Future<bool> testConnection() async {
    try {
      final conn = await getConnection();
      await conn.execute('SELECT version()');
      return true;
    } catch (e) {
      return false;
    }
  }
}
