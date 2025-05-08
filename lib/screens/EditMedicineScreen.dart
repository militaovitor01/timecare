// edit_medicine_screen.dart
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:timecare/shared/dao/remedio_dao.dart';
import 'package:timecare/shared/models/remedio_model.dart';

class EditMedicineScreen extends StatefulWidget {
  final String? nome;
  final String? tipo;
  final String? horario;
  final int? id;
  final String? dosagem;
  final int? frequencia;

  const EditMedicineScreen({
    super.key,
    this.nome,
    this.tipo,
    this.horario,
    this.id,
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
    frequenciaController.dispose();
    super.dispose();
  }

  void _salvarRemedio() async {
    final remedioAtualizado = Remedio(
      id: widget.id,
      nome: nomeController.text.trim(),
      tipo: tipoController.text.trim(),
      horario: horarioController.text.trim(),
      dosagem: dosagemController.text.trim(),
      frequencia: int.tryParse(frequenciaController.text),
    );

    try {
      if (widget.id != null) {
        // Se tiver ID, é uma atualização
        await _remedioDao.atualizar(remedioAtualizado);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Remédio atualizado com sucesso!')),
        );
      } else {
        // Se não tiver ID, é uma inclusão
        await _remedioDao.adicionar(remedioAtualizado);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Remédio adicionado com sucesso!')),
        );
      }
      Navigator.pop(context, remedioAtualizado);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao salvar o remédio: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Remédio'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Nome do Remédio'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: tipoController,
              decoration: const InputDecoration(labelText: 'Tipo'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: horarioController,
              decoration: const InputDecoration(labelText: 'Horário'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _salvarRemedio,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
