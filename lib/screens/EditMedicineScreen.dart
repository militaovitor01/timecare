// edit_medicine_screen.dart
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:timecare/shared/dao/remedio_dao.dart';
import 'package:timecare/shared/models/remedio_model.dart';

class EditMedicineScreen extends StatefulWidget {
  final int? id;
  final String? nome;
  final String? tipo;
  final String? horario;
  final String? instrucoes;
  final String? dosagem;
  final int? frequencia;

  const EditMedicineScreen({
    super.key,
    this.id,
    this.nome,
    this.tipo,
    this.horario,
    this.instrucoes,
    this.dosagem,
    this.frequencia,
  });

  @override
  State<EditMedicineScreen> createState() => _EditMedicineScreenState();
}

class _EditMedicineScreenState extends State<EditMedicineScreen> {
  late TextEditingController nomeController;
  late TextEditingController tipoController;
  late TextEditingController horarioController;
  late TextEditingController instrucoesController;
  late TextEditingController dosagemController;
  late TextEditingController frequenciaController;

  final RemedioDao _remedioDao = RemedioDao();

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.nome ?? '');
    tipoController = TextEditingController(text: widget.tipo ?? '');
    horarioController = TextEditingController(text: widget.horario ?? '');
    dosagemController = TextEditingController(text: widget.dosagem ?? '');
    instrucoesController = TextEditingController(text: widget.instrucoes ?? '');
    frequenciaController = TextEditingController(
      text: widget.frequencia?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    nomeController.dispose();
    tipoController.dispose();
    horarioController.dispose();
    dosagemController.dispose();
    instrucoesController.dispose();
    frequenciaController.dispose();
    super.dispose();
  }

  void _salvarRemedio() async {
    // Debug logs
    print('Nome: "${nomeController.text}"');
    print('Tipo: "${tipoController.text}"');
    print('Dosagem: "${dosagemController.text}"');
    print('Horário: "${horarioController.text}"');
    print('Instruções: "${instrucoesController.text}"');
    print('Frequência: "${frequenciaController.text}"');

    // Validação dos campos obrigatórios com trim
    final nome = nomeController.text.trim();
    final tipo = tipoController.text.trim();
    final dosagem = dosagemController.text.trim();

    print('Nome após trim: "$nome"');
    print('Tipo após trim: "$tipo"');
    print('Dosagem após trim: "$dosagem"');

    if (nome.isEmpty) {
      print('Erro: Nome está vazio');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('O nome do remédio é obrigatório'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (tipo.isEmpty) {
      print('Erro: Tipo está vazio');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('O tipo do remédio é obrigatório'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (dosagem.isEmpty) {
      print('Erro: Dosagem está vazia');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A dosagem é obrigatória'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final remedioAtualizado = Remedio(
      id: widget.id,
      nome: nome,
      tipo: tipo,
      horario:
          horarioController.text.trim().isEmpty
              ? null
              : horarioController.text.trim(),
      dosagem: dosagem,
      instrucoes:
          instrucoesController.text.trim().isEmpty
              ? null
              : instrucoesController.text.trim(),
      frequencia:
          frequenciaController.text.trim().isEmpty
              ? null
              : int.tryParse(frequenciaController.text.trim()),
    );

    print('Tentando salvar remédio: ${remedioAtualizado.toMap()}');

    try {
      if (widget.id != null) {
        // Se tiver ID, é uma atualização
        print('Atualizando remédio com ID: ${widget.id}');
        final sucesso = await _remedioDao.atualizar(remedioAtualizado);
        if (!sucesso) {
          throw Exception('Não foi possível atualizar o remédio');
        }
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Remédio atualizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Se não tiver ID, é uma inclusão
        print('Adicionando novo remédio');
        final remedioSalvo = await _remedioDao.adicionar(remedioAtualizado);
        print('Remédio salvo: ${remedioSalvo.toMap()}');
        if (remedioSalvo.id == null) {
          throw Exception('Não foi possível adicionar o remédio');
        }
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Remédio adicionado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
      Navigator.pop(context, remedioAtualizado);
    } catch (e) {
      print('Erro ao salvar remédio: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar o remédio: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Remédio'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Remédio *',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: tipoController,
                decoration: const InputDecoration(
                  labelText: 'Tipo *',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: dosagemController,
                decoration: const InputDecoration(
                  labelText: 'Dosagem *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: horarioController,
                decoration: const InputDecoration(
                  labelText: 'Horário',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: instrucoesController,
                decoration: const InputDecoration(
                  labelText: 'Instruções',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: frequenciaController,
                decoration: const InputDecoration(
                  labelText: 'Frequência (vezes ao dia)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _salvarRemedio,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Salvar', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
