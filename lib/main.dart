// IMPORTANTE: Este é o código MVP (Produto Mínimo Viável) das Telas.
// As telas possuem a UI final, mas a lógica de estado e integração com Backend
// deve ser implementada na etapa N3.

import 'package:flutter/material.dart';

// --- PALETA DE CORES (Baseada nos designs e documento técnico) ---
// Cores principais inspiradas nos designs fornecidos
const Color primaryDarkColor = Color(0xFF1E1E1E); // Fundo escuro geral
const Color accentPurple = Color(
  0xFF6A1B9A,
); // Roxo de destaque (bordas, botões)
const Color textColorLight = Colors.white; // Cor do texto em fundos escuros
const Color textColorDark = Colors.black; // Cor do texto em fundos claros
const Color inputFieldBackground = Color(
  0xFF333333,
); // Fundo dos campos de input
const Color inputFieldBorder = Color(
  0xFF8E24AA,
); // Borda dos campos de input (roxo mais claro)
const Color successColor = Color(0xFF4CAF50); // Verde para "Pago"
const Color warningColor = Color(
  0xFFFFC107,
); // Amarelo para "Pendentes" / "A vencer"
const Color dangerColor = Color(
  0xFFD32F2F,
); // Vermelho para "Vencidas" / Exclusão

void main() {
  runApp(const ContasEmDiaApp());
}

// ====================================================================
// 1. TELA PRINCIPAL (APLICAÇÃO)
// ====================================================================

class ContasEmDiaApp extends StatelessWidget {
  const ContasEmDiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contas em Dia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: accentPurple,
        scaffoldBackgroundColor: primaryDarkColor,
        // Define o esquema de cores para o Material Design
        colorScheme: ColorScheme.fromSeed(
          seedColor: accentPurple,
          brightness: Brightness.dark, // Define um tema escuro
          primary: accentPurple,
          onPrimary: textColorLight,
          secondary: warningColor,
          onSecondary: textColorDark,
          surface: inputFieldBackground,
          onSurface: textColorLight,
          background: primaryDarkColor,
          onBackground: textColorLight,
          error: dangerColor,
          onError: textColorLight,
        ),
        appBarTheme: const AppBarTheme(
          color: primaryDarkColor,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: textColorLight,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: textColorLight),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: inputFieldBackground,
          labelStyle: const TextStyle(color: textColorLight),
          hintStyle: TextStyle(color: textColorLight.withOpacity(0.6)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: inputFieldBorder, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: inputFieldBorder, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: accentPurple, width: 2),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: accentPurple,
            foregroundColor: textColorLight,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: accentPurple,
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
        // CORREÇÃO: Usando CardThemeData() ou CardTheme() (que retorna CardThemeData)
        // O erro indica um problema de tipagem na sua versão/IDE,
        // forçamos o uso do construtor CardTheme() que é o tipo correto.
        cardTheme: CardTheme(
          color: inputFieldBackground, // Para cards de lista e resumo
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      initialRoute: '/login', // Define a Tela de Login como inicial
      routes: {
        '/login': (context) => const LoginScreen(),
        '/cadastro': (context) => const CadastroScreen(),
        '/recuperacao_senha': (context) => const RecuperacaoSenhaScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/listagem_contas': (context) => const ListagemContasScreen(),
        '/cadastro_edicao_conta': (context) =>
            const CadastroEdicaoContaScreen(),
        '/configuracoes': (context) => const ConfiguracoesScreen(),
      },
    );
  }
}

// ====================================================================
// 2. WIDGETS DE COMPONENTES REUTILIZÁVEIS
// ====================================================================

// Card simples para exibir o resumo de valores
class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColorLight.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ====================================================================
// 3. TELAS DE AUTENTICAÇÃO (1, 2, 3) - Baseadas nos seus designs
// ====================================================================

// 1. TELA DE LOGIN/ACESSO (DESIGN IMAGE 2)
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                'Contas a pagar',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textColorLight,
                ),
              ),
              const SizedBox(height: 40),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome de usuário/email'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Senha'),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/recuperacao_senha');
                  },
                  child: const Text('Recuperar Senha'),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Simulação de login bem-sucedido
                  Navigator.of(context).pushReplacementNamed('/dashboard');
                },
                child: const Text('LOGIN'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
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

// 2. TELA DE CADASTRO (DESIGN IMAGE 2)
class CadastroScreen extends StatelessWidget {
  const CadastroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CADASTRO'),
        backgroundColor: primaryDarkColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            const Text(
              'Contas a pagar',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: textColorLight,
              ),
            ),
            const SizedBox(height: 40),
            TextFormField(
              decoration: InputDecoration(labelText: 'Nome de usuário'),
            ),
            const SizedBox(height: 20),
            TextFormField(decoration: InputDecoration(labelText: 'Email')),
            const SizedBox(height: 20),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Senha'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirmar senha'),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Simulação de cadastro e redirecionamento para o Dashboard
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/dashboard',
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}

// 3. TELA DE RECUPERAÇÃO DE SENHA (DESIGN IMAGE 2)
class RecuperacaoSenhaScreen extends StatefulWidget {
  const RecuperacaoSenhaScreen({super.key});

  @override
  State<RecuperacaoSenhaScreen> createState() => _RecuperacaoSenhaScreenState();
}

class _RecuperacaoSenhaScreenState extends State<RecuperacaoSenhaScreen> {
  int _step = 1; // 1: Digitar Email, 2: Digitar Código, 3: Nova Senha

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RECUPERAÇÃO DE SENHA'),
        backgroundColor: primaryDarkColor,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_step == 1) ...[
                TextFormField(decoration: InputDecoration(labelText: 'Email')),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _step = 2; // Avança para a etapa de código
                    });
                  },
                  child: const Text('Continuar'),
                ),
              ] else if (_step == 2) ...[
                const Text(
                  'Digite o Código que enviamos para seu email',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textColorLight, fontSize: 16),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Código'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    // Simular reenvio do código
                  },
                  child: const Text(
                    'Reenviar 30 segundos',
                    style: TextStyle(color: accentPurple),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _step = 3; // Avança para a etapa de nova senha
                    });
                  },
                  child: const Text('Continuar'),
                ),
              ] else if (_step == 3) ...[
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Nova Senha'),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirmar Nova Senha',
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    // Simulação de redefinição de senha e volta para o login
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login',
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: const Text('Continuar'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ====================================================================
// 4. TELAS PRINCIPAIS (4, 5, 6, 7)
// ====================================================================

// 4. DASHBOARD (RESUMO MENSAL) - Mantido genérico
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard - Contas em Dia'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed('/configuracoes');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Simulação de Logout
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumo do Mês',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColorLight,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'A Pagar',
                    value: 'R\$ 1.250,00',
                    color: dangerColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SummaryCard(
                    title: 'Pagos',
                    value: 'R\$ 4.500,00',
                    color: successColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Contas Pendentes (Próximas)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: textColorLight,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/listagem_contas');
                  },
                  child: const Text('Ver Todas'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Simulação de Lista de Contas (apenas UI)
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                AccountListItem(
                  name: 'Aluguel',
                  value: 'R\$ 1.000,00',
                  date: '05/10/2025',
                  status: 'Vencida',
                ),
                AccountListItem(
                  name: 'Cartão de Crédito',
                  value: 'R\$ 800,00',
                  date: '15/10/2025',
                  status: 'Pendente',
                ),
                AccountListItem(
                  name: 'Internet',
                  value: 'R\$ 100,00',
                  date: '20/10/2025',
                  status: 'Pendente',
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/cadastro_edicao_conta');
        },
        backgroundColor: accentPurple,
        child: const Icon(Icons.add, color: textColorLight),
      ),
    );
  }
}

// 5. LISTAGEM DE CONTAS (DESIGN IMAGE 1)
class ListagemContasScreen extends StatefulWidget {
  const ListagemContasScreen({super.key});

  @override
  State<ListagemContasScreen> createState() => _ListagemContasScreenState();
}

class _ListagemContasScreenState extends State<ListagemContasScreen> {
  String _selectedFilter = 'Todas'; // "Todas", "Pendentes", "Pagas", "Vencidas"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TELA LISTAGEM DE CONTAS'),
        backgroundColor: primaryDarkColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filtros
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterButton('Todas'),
                _buildFilterButton('Pendentes'),
                _buildFilterButton('Pagas'),
                _buildFilterButton('Vencidas'),
              ],
            ),
            const SizedBox(height: 24),
            // Buscar Conta
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Buscar Conta',
                suffixIcon: Icon(
                  Icons.search,
                  color: textColorLight.withOpacity(0.6),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Exemplo de listas (simulação)
            if (_selectedFilter == 'Todas' ||
                _selectedFilter == 'Pendentes') ...[
              const Text(
                'Pendentes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: warningColor,
                ),
              ),
              const SizedBox(height: 8),
              AccountListItem(
                name: 'Nome da Conta',
                value: 'R\$ 100,00',
                date: '10/12/2025',
                time: '10:00',
                status: 'Pendente',
              ),
              AccountListItem(
                name: 'Outra Conta',
                value: 'R\$ 50,00',
                date: '15/12/2025',
                time: '14:30',
                status: 'Pendente',
              ),
              const SizedBox(height: 24),
            ],

            if (_selectedFilter == 'Todas' ||
                _selectedFilter == 'Vencidas') ...[
              const Text(
                'Vencidas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: dangerColor,
                ),
              ),
              const SizedBox(height: 8),
              AccountListItem(
                name: 'Nome da Conta',
                value: 'R\$ 200,00',
                date: '01/12/2025',
                time: '09:00',
                status: 'Vencida',
              ),
              const SizedBox(height: 24),
            ],

            if (_selectedFilter == 'Todas' || _selectedFilter == 'Pagas') ...[
              const Text(
                'Pagas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: successColor,
                ),
              ),
              const SizedBox(height: 8),
              AccountListItem(
                name: 'Nome da Conta',
                value: 'R\$ 300,00',
                date: '08/11/2025',
                time: '11:00',
                status: 'Pago',
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/cadastro_edicao_conta');
        },
        backgroundColor: accentPurple,
        child: const Icon(Icons.add, color: textColorLight),
      ),
    );
  }

  Widget _buildFilterButton(String text) {
    bool isSelected = _selectedFilter == text;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedFilter = text;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? accentPurple : inputFieldBackground,
        foregroundColor:
            isSelected ? textColorLight : textColorLight.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected ? accentPurple : inputFieldBorder,
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(fontSize: 14),
      ),
      child: Text(text),
    );
  }
}

// Item da lista de contas (refinado para o design)
class AccountListItem extends StatelessWidget {
  final String name;
  final String value;
  final String date;
  final String? time;
  final String status; // "Pendente", "Vencida", "Pago"

  const AccountListItem({
    super.key,
    required this.name,
    required this.value,
    required this.date,
    this.time,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color itemColor;
    IconData itemIcon;
    bool isStrikethrough = false;

    if (status == 'Vencida') {
      itemColor = dangerColor;
      itemIcon = Icons.cancel;
      isStrikethrough = true;
    } else if (status == 'Pendente') {
      itemColor = warningColor;
      itemIcon = Icons.check_box_outline_blank;
    } else {
      // Pago
      itemColor = successColor;
      itemIcon = Icons.check_box;
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/cadastro_edicao_conta',
          arguments: {
            'id': 'someId',
            'name': name,
            'value': value,
            'date': date,
            'time': time,
            'status': status,
          },
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: itemColor.withOpacity(0.7), width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(itemIcon, color: itemColor, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColorLight,
                        decoration: isStrikethrough
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: itemColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Vencimento: $date ${time != null ? 'às $time' : ''}',
                      style: TextStyle(
                        color: textColorLight.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: itemColor,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 6. CADASTRO/EDIÇÃO DE CONTA (DESIGN IMAGE 1 - parte direita)
class CadastroEdicaoContaScreen extends StatefulWidget {
  const CadastroEdicaoContaScreen({super.key});

  @override
  State<CadastroEdicaoContaScreen> createState() =>
      _CadastroEdicaoContaScreenState();
}

class _CadastroEdicaoContaScreenState extends State<CadastroEdicaoContaScreen> {
  String _selectedStatus = 'Pendente'; // Default status
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      _selectedStatus = arguments['status'] ?? 'Pendente';
      _dateController.text = arguments['date'] ?? '';
      _timeController.text = arguments['time'] ?? '';
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: accentPurple, // Cor principal do picker
              onPrimary: textColorLight,
              surface: primaryDarkColor, // Cor de fundo do picker
              onSurface: textColorLight,
            ),
            dialogBackgroundColor: inputFieldBackground,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: accentPurple, // Cor principal do picker
              onPrimary: textColorLight,
              surface: primaryDarkColor, // Cor de fundo do picker
              onSurface: textColorLight,
            ),
            dialogBackgroundColor: inputFieldBackground,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final isEditing = arguments != null && arguments['id'] != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Nome da Conta' : 'Nova Conta',
        ), // Conforme o design
        backgroundColor: primaryDarkColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              initialValue: arguments?['name'] ?? '',
              decoration: InputDecoration(labelText: 'Nome da Conta'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: 'Descrição da conta...',
              maxLines: 3,
              decoration: InputDecoration(labelText: 'Descrição'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: InputDecoration(labelText: 'Vencimento:'),
                      child: Text(
                        _dateController.text.isEmpty
                            ? 'Data'
                            : _dateController.text,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectTime(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: '', // Label está na data
                        hintText: 'Horário',
                      ),
                      child: Text(
                        _timeController.text.isEmpty
                            ? 'Horário'
                            : _timeController.text,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Alterar Status:',
              style: TextStyle(
                color: textColorLight.withOpacity(0.8),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildStatusButton('Pendente', warningColor),
                const SizedBox(width: 8),
                _buildStatusButton('Vencida', dangerColor),
                const SizedBox(width: 8),
                _buildStatusButton('Paga', successColor),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Simulação de salvamento/edição
                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
            ),
            if (isEditing) ...[
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Simulação de exclusão (N3 - com modal de confirmação)
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Deletar Conta',
                  style: TextStyle(
                    color: dangerColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButton(String status, Color color) {
    bool isSelected = _selectedStatus == status;
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedStatus = status;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? color : inputFieldBackground,
          foregroundColor:
              isSelected ? textColorLight : textColorLight.withOpacity(0.7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: isSelected ? color : inputFieldBorder,
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          textStyle: const TextStyle(fontSize: 14),
        ),
        child: Text(status),
      ),
    );
  }
}

// 7. CONFIGURAÇÕES/GERENCIAMENTO DE CATEGORIAS - Mantido genérico
class ConfiguracoesScreen extends StatelessWidget {
  const ConfiguracoesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações e Categorias'),
        backgroundColor: primaryDarkColor,
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildSettingsHeader('Gerenciamento de Dados'),
          ListTile(
            leading: const Icon(Icons.category, color: accentPurple),
            title: const Text(
              'Gerenciar Categorias',
              style: TextStyle(color: textColorLight),
            ),
            subtitle: const Text(
              'Adicione, edite ou remova tipos de despesa.',
              style: TextStyle(color: textColorLight),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: textColorLight,
            ),
            onTap: () {
              // Simulação: Na N3 esta tela teria um sub-fluxo para CRUD de categorias
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock, color: accentPurple),
            title: const Text(
              'Alterar Senha',
              style: TextStyle(color: textColorLight),
            ),
            subtitle: const Text(
              'Redefina sua senha de acesso ao app.',
              style: TextStyle(color: textColorLight),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: textColorLight,
            ),
            onTap: () {
              // Simulação de tela de alteração de senha
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications, color: accentPurple),
            title: const Text(
              'Configurar Notificações',
              style: TextStyle(color: textColorLight),
            ),
            subtitle: const Text(
              'Defina o horário de alertas de vencimento.',
              style: TextStyle(color: textColorLight),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: textColorLight,
            ),
            onTap: () {
              // Simulação de tela de configuração de notificações
            },
          ),
          _buildSettingsHeader('Informações e Suporte'),
          ListTile(
            leading: const Icon(Icons.info, color: accentPurple),
            title: const Text(
              'Sobre o App',
              style: TextStyle(color: textColorLight),
            ),
            subtitle: const Text(
              'Versão 1.0.0 - Projeto N2/N3',
              style: TextStyle(color: textColorLight),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: dangerColor),
            title: const Text(
              'Sair da Conta',
              style: TextStyle(color: dangerColor),
            ),
            onTap: () {
              // Simulação de Logout
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  // Widget de cabeçalho para as seções de configurações
  Widget _buildSettingsHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 24.0,
        left: 16.0,
        right: 16.0,
        bottom: 8.0,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: accentPurple,
        ),
      ),
    );
  }
}
