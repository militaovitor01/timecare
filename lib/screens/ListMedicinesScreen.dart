import 'package:flutter/material.dart';
import 'editMedicineScreen.dart';

class ListMedicinesScreen extends StatefulWidget {
  const ListMedicinesScreen({super.key});

  @override
  State<ListMedicinesScreen> createState() => _ListMedicinesScreenState();
}

class _ListMedicinesScreenState extends State<ListMedicinesScreen> {
  final List<Map<String, String>> _medicines = [];

  void _addMedicine(Map<String, String> newMedicine) {
    setState(() {
      _medicines.add(newMedicine);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16, top: 16),
          child: CircleAvatar(
            backgroundColor: Colors.black12,
            child: Icon(Icons.person_outline, color: Colors.black87),
          ),
        ),
        title: const Padding(
          padding: EdgeInsets.only(top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Usuário Aleatório',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Cupertino - Formula, 25',
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ],
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16, top: 16),
            child: CircleAvatar(
              backgroundColor: Color(0xFFFFA7A7),
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Pré-Definições',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.tune, color: Colors.blueAccent),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child:
                  _medicines.isEmpty
                      ? const Center(child: Text("Nenhum remédio adicionado."))
                      : ListView.builder(
                        itemCount: _medicines.length,
                        itemBuilder: (context, index) {
                          final med = _medicines[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      med['nome'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      med['horario'] ?? '',
                                      style: const TextStyle(
                                        color: Colors.black45,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.more_horiz,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => EditMedicineScreen(
                                              nome: med['nome']!,
                                              tipo: med['tipo']!,
                                              horario: med['horario']!,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final result = await Navigator.push<Map<String, String>>(
            context,
            MaterialPageRoute(builder: (context) => const EditMedicineScreen()),
          );

          if (result != null) {
            _addMedicine(result);
          }
        },
      ),
    );
  }
}
