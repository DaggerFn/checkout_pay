# Guia de Teste de Conexão PostgreSQL

## Status da Conexão

### Problema: App não consegue conectar ao PostgreSQL no emulador

**Causa Identificada:** No emulador Android, `localhost` não funciona. Precisamos usar `10.0.2.2` (IP especial do emulador para acessar o host).

### Solução Implementada

O arquivo `lib/config/database.dart` foi atualizado para:

```dart
static final String host = Platform.isAndroid ? '10.0.2.2' : 'localhost';
```

Isso significa:
- ✅ **Em emulador Android**: Conecta em `10.0.2.2:5432`
- ✅ **Em Windows/Web**: Conecta em `localhost:5432`

## Como Testar

### 1. **Certifique-se que PostgreSQL está rodando**

No seu Windows, abra o Services e verifique se:
- PostgreSQL está em execução
- Porta 5432 está aberta
- Banco `checkout_pay` existe

**Teste via cmd:**
```powershell
psql -h localhost -U postgres -d checkout_pay -c "SELECT 1;"
```

### 2. **Verifique as Credenciais**

No arquivo `database.dart`:
```dart
static const String username = 'postgres';
static const String password = 'postgres';
static const String databaseName = 'checkout_pay';
```

Se suas credenciais forem diferentes, atualize estes valores.

### 3. **Rode o App com a Tela de Teste**

O app inicia automaticamente na tela de teste (`/test_connection`).

**Botões disponíveis:**
1. **🟢 Testar Conexão** - Executa `SELECT version()` no PostgreSQL
2. **🟡 Contar Usuários** - Conta linhas na tabela `usuarios`
3. **🟣 Listar Todos Usuários** - Lista todos os usuários

### 4. **Interprete os Resultados**

#### ✅ Sucesso:
```
✅ CONEXÃO BEM-SUCEDIDA!

Host: 10.0.2.2
Porta: 5432
Banco: checkout_pay
Usuário: postgres

🎉 PostgreSQL está respondendo normalmente!
```

#### ❌ Falha:
Se receber erro, provavelmente:
- PostgreSQL não está rodando
- Porta 5432 está bloqueada
- Banco de dados não existe
- Credenciais estão incorretas

## Instruções para Criar o Banco de Dados

Se o banco `checkout_pay` não existir, execute:

```sql
-- Criar banco
CREATE DATABASE checkout_pay;

-- Conectar ao banco
\c checkout_pay

-- Criar tabela usuarios (exemplo)
CREATE TABLE usuarios (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  senha_hash VARCHAR(255) NOT NULL,
  data_criacao TIMESTAMP DEFAULT NOW(),
  data_atualizacao TIMESTAMP DEFAULT NOW()
);

-- Criar tabela contas
CREATE TABLE contas (
  id SERIAL PRIMARY KEY,
  usuario_id INTEGER NOT NULL REFERENCES usuarios(id),
  nome VARCHAR(255) NOT NULL,
  descricao TEXT,
  valor DECIMAL(10,2) NOT NULL,
  data_vencimento DATE NOT NULL,
  hora_vencimento TIME,
  categoria VARCHAR(100),
  status VARCHAR(50) DEFAULT 'Pendente',
  data_criacao TIMESTAMP DEFAULT NOW(),
  data_atualizacao TIMESTAMP DEFAULT NOW()
);

-- Inserir dados de teste
INSERT INTO usuarios (nome, email, senha_hash) VALUES 
  ('Admin', 'admin@checkout.com', 'hashed_password_123'),
  ('João Silva', 'joao@checkout.com', 'hashed_password_456');

INSERT INTO contas (usuario_id, nome, valor, data_vencimento, status) VALUES
  (1, 'Conta de Luz', 150.00, '2025-12-15', 'Pendente'),
  (1, 'Internet', 80.00, '2025-12-10', 'Pago'),
  (2, 'Aluguel', 1500.00, '2025-12-01', 'Pago');
```

## Debugging

### Logs do Emulador
Durante o teste, verifique os logs com:
```powershell
flutter logs -d emulator-5554
```

### Testar Conexão via Terminal
```powershell
psql -h 10.0.2.2 -U postgres -d checkout_pay -c "SELECT version();"
```

> **Nota:** Isso vai falhar se PostgreSQL estiver apenas em localhost, pois `10.0.2.2` é um IP virtual do emulador.

## Próximos Passos

Depois que a conexão estiver funcionando:

1. ✅ Voltar a rota inicial para `/login`
2. ✅ Integrar autenticação com banco de dados
3. ✅ Testar CRUD de contas
4. ✅ Deploy

---

**Última atualização:** 2025-12-02
**Status:** Em Teste
