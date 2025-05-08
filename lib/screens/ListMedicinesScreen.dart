// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:timecare/shared/dao/remedio_dao.dart';
import 'package:timecare/shared/models/remedio_model.dart';
import 'editMedicineScreen.dart';

class ListMedicinesScreen extends StatefulWidget {
  const ListMedicinesScreen({super.key});

  @override
  State<ListMedicinesScreen> createState() => _ListMedicinesScreenState();
}

class _ListMedicinesScreenState extends State<ListMedicinesScreen> {
  final RemedioDao _remedioDao = RemedioDao();
  List<Remedio> _remedios = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarRemedios();
  }

  Future<void> _carregarRemedios() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final remedios = await _remedioDao.selecionarTodos();
      setState(() {
        _remedios = remedios;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao carregar remédios: $e')));
    }
  }

  Future<void> _excluirRemedio(Remedio remedio) async {
    try {
      await _remedioDao.deletar(remedio);
      await _carregarRemedios();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Remédio excluído com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao excluir remédio: $e')));
    }
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
              children: [
                const Text(
                  'Meus Remédios',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.cleaning_services,
                        color: Colors.redAccent,
                      ),
                      onPressed: () async {
                        try {
                          await _remedioDao.deletarFrequenciaInvalida();
                          await _carregarRemedios();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Dados inválidos removidos com sucesso!',
                              ),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erro ao limpar dados: $e')),
                          );
                        }
                      },
                      tooltip: 'Remover dados inválidos',
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.blueAccent),
                      onPressed: _carregarRemedios,
                      tooltip: 'Atualizar lista',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _remedios.isEmpty
                      ? const Center(child: Text("Nenhum remédio cadastrado."))
                      : ListView.builder(
                        itemCount: _remedios.length,
                        itemBuilder: (context, index) {
                          final remedio = _remedios[index];
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
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        remedio.nome,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Tipo: ${remedio.tipo}',
                                        style: const TextStyle(
                                          color: Colors.black45,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        'Horário: ${remedio.horario}',
                                        style: const TextStyle(
                                          color: Colors.black45,
                                          fontSize: 12,
                                        ),
                                      ),
                                      if (remedio.dosagem != null &&
                                          remedio.dosagem.isNotEmpty)
                                        Text(
                                          'Dosagem: ${remedio.dosagem}',
                                          style: const TextStyle(
                                            color: Colors.black45,
                                            fontSize: 12,
                                          ),
                                        ),
                                      if (remedio.frequencia != null)
                                        Text(
                                          'Frequência: ${remedio.frequencia} vezes ao dia',
                                          style: const TextStyle(
                                            color: Colors.black45,
                                            fontSize: 12,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blueAccent,
                                      ),
                                      onPressed: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => EditMedicineScreen(
                                                  id: remedio.id,
                                                  nome: remedio.nome,
                                                  tipo: remedio.tipo,
                                                  horario: remedio.horario,
                                                  dosagem: remedio.dosagem,
                                                  frequencia:
                                                      remedio.frequencia,
                                                ),
                                          ),
                                        );

                                        if (result != null) {
                                          await _carregarRemedios();
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.redAccent,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder:
                                              (ctx) => AlertDialog(
                                                title: const Text(
                                                  'Confirmar exclusão',
                                                ),
                                                content: Text(
                                                  'Deseja excluir o remédio "${remedio.nome}"?',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed:
                                                        () =>
                                                            Navigator.of(
                                                              ctx,
                                                            ).pop(),
                                                    child: const Text(
                                                      'Cancelar',
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(ctx).pop();
                                                      _excluirRemedio(remedio);
                                                    },
                                                    child: const Text(
                                                      'Excluir',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        );
                                      },
                                    ),
                                  ],
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
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditMedicineScreen()),
          );

          if (result != null) {
            await _carregarRemedios();
          }
        },
      ),
    );
  }
}
