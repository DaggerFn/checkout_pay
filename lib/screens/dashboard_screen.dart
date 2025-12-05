import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../widgets/summary_card.dart';
import '../widgets/account_list_item.dart';
import '../services/auth_service.dart';
import '../repositories/conta_repository.dart';
import '../models/conta.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final AuthService _authService;
  late final ContaRepository _contaRepository;
  
  bool _carregando = true;
  String? _erro;
  List<Conta> _contasPendentes = [];
  double _totalPendente = 0.0;
  double _totalPago = 0.0;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _contaRepository = ContaRepository();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    if (_authService.usuarioLogado == null) {
      Navigator.of(context).pushReplacementNamed('/login');
      return;
    }

    try {
      setState(() => _carregando = true);

      final usuarioId = _authService.usuarioLogado!.id!;

      // Buscar totais
      _totalPendente = await _contaRepository.calcularTotalPendente(usuarioId);
      _totalPago = await _contaRepository.calcularTotalPago(usuarioId);

      // Buscar contas pendentes/próximas (primeiras 5)
      final todasContas = await _contaRepository.buscarPorUsuario(usuarioId);
      _contasPendentes = todasContas
          .where((c) => c.status == 'Pendente' || c.status == 'Vencida')
          .take(5)
          .toList();

      setState(() {
        _carregando = false;
        _erro = null;
      });
    } catch (e) {
      setState(() {
        _carregando = false;
        _erro = 'Erro ao carregar dados: $e';
      });
    }
  }

  void _fazerLogout() {
    _authService.logout();
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/login',
      (Route<dynamic> route) => false,
    );
  }

  String _formatarMoeda(double valor) {
    return 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard - Contas em Dia'),
        backgroundColor: AppColors.primaryDarkColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed('/configuracoes');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _fazerLogout,
          ),
        ],
      ),
      body: _carregando
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.accentPurple,
              ),
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
                        onPressed: _carregarDados,
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
                      // Saudação
                      Text(
                        'Olá, ${_authService.usuarioLogado?.nome}!',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColorLight,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Resumo
                      const Text(
                        'Resumo do Mês',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColorLight,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: SummaryCard(
                              title: 'A Pagar',
                              value: _formatarMoeda(_totalPendente),
                              color: AppColors.dangerColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: SummaryCard(
                              title: 'Pagos',
                              value: _formatarMoeda(_totalPago),
                              color: AppColors.successColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Contas Pendentes
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Contas Pendentes',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColorLight,
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              final resultado = await Navigator.of(context).pushNamed('/listagem_contas');
                              // Se editou/deletou uma conta, recarrega os dados
                              if (resultado == true) {
                                _carregarDados();
                              }
                            },
                            child: const Text('Ver Todas'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Lista de Contas ou Mensagem Vazia
                      if (_contasPendentes.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.inputFieldBackground,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              '✅ Parabéns! Não há contas pendentes.',
                              style: TextStyle(
                                color: AppColors.successColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _contasPendentes.length,
                          itemBuilder: (context, index) {
                            final conta = _contasPendentes[index];
                            return AccountListItem(
                              name: conta.nome,
                              value: _formatarMoeda(conta.valor),
                              date: conta.dataVencimento.toLocal().toString().split(' ')[0],
                              status: conta.status,
                            );
                          },
                        ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final resultado = await Navigator.of(context).pushNamed('/cadastro_edicao_conta');
          // Se criou/editou uma conta, recarrega os dados
          if (resultado == true) {
            _carregarDados();
          }
        },
        backgroundColor: AppColors.accentPurple,
        child: const Icon(Icons.add, color: AppColors.textColorLight),
      ),
    );
  }
}