import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../services/auth_service.dart';
import '../repositories/conta_repository.dart';
import '../models/conta.dart';

class CadastroEdicaoContaScreen extends StatefulWidget {
  final Conta? conta;

  const CadastroEdicaoContaScreen({super.key, this.conta});

  @override
  State<CadastroEdicaoContaScreen> createState() =>
      _CadastroEdicaoContaScreenState();
}

class _CadastroEdicaoContaScreenState extends State<CadastroEdicaoContaScreen> {
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  
  final _authService = AuthService();
  final _contaRepository = ContaRepository();

  String _selectedStatus = 'Pendente';
  bool _carregando = false;
  String? _erro;
  Conta? _contaEditando;
  bool _dadosCarregados = false;

  @override
  void initState() {
    super.initState();
    // Se a tela foi criada com uma conta (construtor), usa-a
    if (widget.conta != null) {
      _carregarDadosConta(widget.conta!);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Carrega apenas uma vez
    if (_dadosCarregados) return;
    
    // Se não veio pelo construtor, tenta pegar dos arguments da rota
    if (widget.conta == null) {
      final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      
      if (arguments != null && arguments['conta'] != null) {
        final conta = arguments['conta'] as Conta;
        _carregarDadosConta(conta);
      }
    }
    
    _dadosCarregados = true;
  }

  void _carregarDadosConta(Conta conta) {
    _contaEditando = conta;
    _nomeController.text = conta.nome;
    _descricaoController.text = conta.descricao ?? '';
    _valorController.text = conta.valor.toString();
    _dateController.text = conta.dataVencimento.toString().split(' ')[0];
    _timeController.text = conta.horaVencimento ?? '';
    _selectedStatus = conta.status;
    
    print('📝 Conta carregada para edição:');
    print('   ID: ${conta.id}');
    print('   Nome: ${conta.nome}');
    print('   Valor: ${conta.valor}');
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _valorController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateController.text.isEmpty
          ? DateTime.now()
          : DateTime.parse(_dateController.text),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.accentPurple,
              onPrimary: AppColors.textColorLight,
              surface: AppColors.primaryDarkColor,
              onSurface: AppColors.textColorLight,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: AppColors.inputFieldBackground,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text = picked.toString().split(' ')[0];
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
              primary: AppColors.accentPurple,
              onPrimary: AppColors.textColorLight,
              surface: AppColors.primaryDarkColor,
              onSurface: AppColors.textColorLight,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: AppColors.inputFieldBackground,
            ),
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

  Future<void> _salvarConta() async {
    // Validar campos
    if (_nomeController.text.isEmpty || 
        _valorController.text.isEmpty || 
        _dateController.text.isEmpty) {
      setState(() => _erro = 'Preencha todos os campos obrigatórios');
      return;
    }

    final usuarioId = _authService.usuarioLogado?.id;
    if (usuarioId == null) {
      setState(() => _erro = 'Usuário não encontrado');
      return;
    }

    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final valor = double.tryParse(_valorController.text);
      if (valor == null) {
        throw Exception('Valor inválido');
      }

      final dataVencimento = DateTime.parse(_dateController.text);

      if (_contaEditando == null) {
        // CRIAR NOVA CONTA
        print('➕ Criando nova conta...');
        
        final novaConta = Conta(
          usuarioId: usuarioId,
          nome: _nomeController.text,
          descricao: _descricaoController.text.isEmpty 
              ? null 
              : _descricaoController.text,
          valor: valor,
          dataVencimento: dataVencimento,
          horaVencimento: _timeController.text.isEmpty 
              ? null 
              : _timeController.text,
          status: _selectedStatus,
        );

        final contaCriada = await _contaRepository.criar(novaConta);
        
        if (contaCriada == null) {
          throw Exception('Erro ao salvar conta no banco de dados');
        }
        
        print('✅ Nova conta criada com ID: ${contaCriada.id}');
        
      } else {
        // ATUALIZAR CONTA EXISTENTE
        print('✏️ Atualizando conta ID: ${_contaEditando!.id}...');
        
        final contaAtualizada = Conta(
          id: _contaEditando!.id, // ← IMPORTANTE: mantém o ID original
          usuarioId: usuarioId,
          nome: _nomeController.text,
          descricao: _descricaoController.text.isEmpty 
              ? null 
              : _descricaoController.text,
          valor: valor,
          dataVencimento: dataVencimento,
          horaVencimento: _timeController.text.isEmpty 
              ? null 
              : _timeController.text,
          status: _selectedStatus,
        );

        final sucesso = await _contaRepository.atualizar(contaAtualizada);
        
        if (!sucesso) {
          throw Exception('Erro ao atualizar conta no banco de dados');
        }
        
        print('✅ Conta atualizada com sucesso!');
      }

      if (!mounted) return;

      // Voltar com sucesso
      Navigator.of(context).pop(true);
      
    } catch (e) {
      print('❌ Erro ao salvar conta: $e');
      setState(() {
        _carregando = false;
        _erro = 'Erro ao salvar conta: $e';
      });
    }
  }

  Future<void> _deletarConta() async {
    if (_contaEditando == null) return;

    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.inputFieldBackground,
        title: const Text(
          'Deletar Conta?',
          style: TextStyle(color: AppColors.textColorLight),
        ),
        content: Text(
          'Tem certeza que deseja deletar "${_contaEditando!.nome}"?\n\nEsta ação não pode ser desfeita.',
          style: const TextStyle(color: AppColors.textColorLight),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Deletar',
              style: TextStyle(color: AppColors.dangerColor),
            ),
          ),
        ],
      ),
    );

    if (confirmou != true) return;

    setState(() => _carregando = true);

    try {
      final usuarioId = _authService.usuarioLogado?.id;
      if (usuarioId != null && _contaEditando != null) {
        print('🗑️ Deletando conta ID: ${_contaEditando!.id}...');
        
        final sucesso = await _contaRepository.deletar(
          _contaEditando!.id!, 
          usuarioId,
        );

        if (!sucesso) {
          throw Exception('Erro ao deletar conta');
        }

        print('✅ Conta deletada com sucesso!');

        if (!mounted) return;
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      print('❌ Erro ao deletar conta: $e');
      setState(() {
        _carregando = false;
        _erro = 'Erro ao deletar conta: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _contaEditando != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Conta' : 'Nova Conta'),
        backgroundColor: AppColors.primaryDarkColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // DEBUG: Mostrar se está editando ou criando
            if (isEditing)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.accentPurple.withAlpha((0.2 * 255).round()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '✏️ Editando conta ID: ${_contaEditando!.id}',
                  style: const TextStyle(
                    color: AppColors.accentPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (isEditing) const SizedBox(height: 16),

            // Mensagem de erro
            if (_erro != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.dangerColor.withAlpha((0.2 * 255).round()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _erro!,
                  style: const TextStyle(color: AppColors.dangerColor),
                ),
              ),
            if (_erro != null) const SizedBox(height: 16),

            // Nome
            TextFormField(
              controller: _nomeController,
              enabled: !_carregando,
              decoration: const InputDecoration(
                labelText: 'Nome da Conta *',
                prefixIcon: Icon(Icons.label),
              ),
            ),
            const SizedBox(height: 16),

            // Descrição
            TextFormField(
              controller: _descricaoController,
              enabled: !_carregando,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                prefixIcon: Icon(Icons.description),
              ),
            ),
            const SizedBox(height: 16),

            // Valor
            TextFormField(
              controller: _valorController,
              enabled: !_carregando,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Valor *',
                prefixIcon: Icon(Icons.attach_money),
                hintText: '0.00',
              ),
            ),
            const SizedBox(height: 16),

            // Data e Hora
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _carregando ? null : () => _selectDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Vencimento *',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        _dateController.text.isEmpty 
                            ? 'Selecione' 
                            : _dateController.text,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: _carregando ? null : () => _selectTime(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Horário',
                        prefixIcon: Icon(Icons.access_time),
                      ),
                      child: Text(
                        _timeController.text.isEmpty 
                            ? 'Selecione' 
                            : _timeController.text,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Status
            Text(
              'Status:',
              style: TextStyle(
                color: AppColors.textColorLight.withAlpha((0.8 * 255).round()),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildStatusButton('Pendente', AppColors.warningColor),
                const SizedBox(width: 8),
                _buildStatusButton('Vencida', AppColors.dangerColor),
                const SizedBox(width: 8),
                _buildStatusButton('Pago', AppColors.successColor),
              ],
            ),
            const SizedBox(height: 40),

            // Botão Salvar
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _carregando ? null : _salvarConta,
                child: _carregando
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.textColorLight,
                        ),
                      )
                    : Text(isEditing ? 'ATUALIZAR' : 'SALVAR'),
              ),
            ),

            if (isEditing) ...[
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _carregando ? null : _deletarConta,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dangerColor.withAlpha(
                      (0.2 * 255).round(),
                    ),
                    foregroundColor: AppColors.dangerColor,
                  ),
                  child: const Text('DELETAR CONTA'),
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
        onPressed: _carregando ? null : () {
          setState(() {
            _selectedStatus = status;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? color : AppColors.inputFieldBackground,
          foregroundColor: isSelected
              ? AppColors.textColorLight
              : AppColors.textColorLight.withAlpha((0.7 * 255).round()),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: isSelected ? color : AppColors.inputFieldBorder,
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