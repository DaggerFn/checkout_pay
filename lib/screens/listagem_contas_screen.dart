import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../widgets/account_list_item.dart';
import '../services/auth_service.dart';
import '../repositories/conta_repository.dart';
import '../models/conta.dart';
import '../screens/cadastro_edicao_conta_screen.dart';
import 'cadastro_edicao_conta_screen.dart';

class ListagemContasScreen extends StatefulWidget {
  const ListagemContasScreen({super.key});

  @override
  State<ListagemContasScreen> createState() => _ListagemContasScreenState();
}

class _ListagemContasScreenState extends State<ListagemContasScreen> {
  final _authService = AuthService();
  final _contaRepository = ContaRepository();
  final _buscaController = TextEditingController();

  String _selectedFilter = 'Todas';
  bool _carregando = true;
  String? _erro;
  List<Conta> _todasContas = [];

  @override
  void initState() {
    super.initState();
    _carregarContas();
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _carregarContas() async {
    if (_authService.usuarioLogado == null) {
      Navigator.of(context).pushReplacementNamed('/login');
      return;
    }

    try {
      setState(() => _carregando = true);

      final usuarioId = _authService.usuarioLogado!.id!;
      _todasContas = await _contaRepository.buscarPorUsuario(usuarioId);

      setState(() {
        _carregando = false;
        _erro = null;
      });
    } catch (e) {
      setState(() {
        _carregando = false;
        _erro = 'Erro ao carregar contas: $e';
      });
    }
  }

  List<Conta> _getContasFiltradas() {
    var contas = _todasContas;

    // Aplicar filtro de status
    if (_selectedFilter != 'Todas') {
      contas = contas.where((c) => c.status == _selectedFilter).toList();
    }

    // Aplicar busca
    final busca = _buscaController.text.toLowerCase();
    if (busca.isNotEmpty) {
      contas = contas
          .where((c) =>
              (c.nome.toLowerCase().contains(busca) ||
              (c.descricao?.toLowerCase().contains(busca) ?? false)))
          .toList();
    }

    // Ordenar por data de vencimento
    contas.sort((a, b) => a.dataVencimento.compareTo(b.dataVencimento));

    return contas;
  }

  Map<String, List<Conta>> _agruparPorStatus(List<Conta> contas) {
    final agrupadas = <String, List<Conta>>{};
    for (var conta in contas) {
      if (!agrupadas.containsKey(conta.status)) {
        agrupadas[conta.status] = [];
      }
      agrupadas[conta.status]!.add(conta);
    }
    return agrupadas;
  }

  String _formatarMoeda(double valor) {
    return 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pendente':
        return AppColors.warningColor;
      case 'Vencida':
        return AppColors.dangerColor;
      case 'Pago':
        return AppColors.successColor;
      default:
        return AppColors.textColorLight;
    }
  }

  List<Widget> _buildContasAgrupadas() {
    final contas = _getContasFiltradas();
    final agrupadas = _agruparPorStatus(contas);
    final widgets = <Widget>[];

    // Ordenar status: Vencida, Pendente, Pago
    final statusOrder = ['Vencida', 'Pendente', 'Pago'];
    for (final status in statusOrder) {
      if (!agrupadas.containsKey(status) || agrupadas[status]!.isEmpty) {
        continue;
      }

      final contasStatus = agrupadas[status]!;

      // Título do Status
      widgets.add(
        Text(
          '$status (${contasStatus.length})',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _getStatusColor(status),
          ),
        ),
      );
      widgets.add(const SizedBox(height: 8));

      // Lista de Contas
      for (final conta in contasStatus) {
        widgets.add(
          AccountListItem(
            name: conta.nome,
            value: _formatarMoeda(conta.valor),
            date: conta.dataVencimento.toLocal().toString().split(' ')[0],
            status: conta.status,
            onTap: () async {
              final result = await Navigator.of(context).pushNamed(
                '/cadastro_edicao_conta',
                arguments: {'conta': conta},
              );
              if (result == true) {
                _carregarContas();
              }
            },
          ),
        );
      }

      widgets.add(const SizedBox(height: 20));
    }

    return widgets;
  }

  Widget _buildFilterButton(String label) {
    bool isSelected = _selectedFilter == label;
    return ElevatedButton(
      onPressed: () {
        setState(() => _selectedFilter = label);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected ? AppColors.accentPurple : AppColors.inputFieldBackground,
        foregroundColor: AppColors.textColorLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected
                ? AppColors.accentPurple
                : AppColors.inputFieldBorder,
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listagem de Contas'),
        backgroundColor: AppColors.primaryDarkColor,
        elevation: 0,
      ),
      body: _carregando
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.accentPurple),
            )
          : _erro != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _erro!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.dangerColor),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _carregarContas,
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Filtros de Status
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterButton('Todas'),
                            const SizedBox(width: 8),
                            _buildFilterButton('Pendente'),
                            const SizedBox(width: 8),
                            _buildFilterButton('Vencida'),
                            const SizedBox(width: 8),
                            _buildFilterButton('Pago'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Campo de Busca
                      TextFormField(
                        controller: _buscaController,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          labelText: 'Buscar por nome ou descrição',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _buscaController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _buscaController.clear();
                                    setState(() {});
                                  },
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Lista de Contas Agrupadas ou Mensagem Vazia
                      if (_getContasFiltradas().isEmpty)
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: AppColors.inputFieldBackground,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.inbox,
                                  size: 64,
                                  color: AppColors.textColorLight,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Nenhuma conta encontrada',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textColorLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ..._buildContasAgrupadas(),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).pushNamed('/cadastro_edicao_conta');
          if (result == true) {
            _carregarContas();
          }
        },
        backgroundColor: AppColors.accentPurple,
        child: const Icon(Icons.add, color: AppColors.textColorLight),
      ),
    );
  }
}
