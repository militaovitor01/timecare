// edit_medicine_screen.dart
import 'package:flutter/material.dart';

class EditMedicineScreen extends StatefulWidget {
  final String? nome;
  final String? tipo;
  final String? horario;

  const EditMedicineScreen({
    super.key,
    this.nome,
    this.tipo,
    this.horario,
  });

  @override
  State<EditMedicineScreen> createState() => _EditMedicineScreenState();
}

class _EditMedicineScreenState extends State<EditMedicineScreen> {
  late TextEditingController nomeController;
  late TextEditingController tipoController;
  late TextEditingController horarioController;

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.nome ?? '');
    tipoController = TextEditingController(text: widget.tipo ?? '');
    horarioController = TextEditingController(text: widget.horario ?? '');
  }

  @override
  void dispose() {
    nomeController.dispose();
    tipoController.dispose();
    horarioController.dispose();
    super.dispose();
  }

  void _salvarRemedio() {
    final novoRemedio = {
      'nome': nomeController.text.trim(),
      'tipo': tipoController.text.trim(),
      'horario': horarioController.text.trim(),
    };

    Navigator.pop(context, novoRemedio);
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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
