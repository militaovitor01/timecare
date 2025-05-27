// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:timecare/shared/dao/remedio_dao.dart';
import 'package:timecare/shared/models/remedio_model.dart';
import 'package:timecare/shared/dao/usuario_dao.dart';
import 'package:timecare/shared/models/usuario_model.dart';
import 'editMedicineScreen.dart';

class ListMedicinesScreen extends StatefulWidget {
  const ListMedicinesScreen({super.key});

  @override
  State<ListMedicinesScreen> createState() => _ListMedicinesScreenState();
}

class _ListMedicinesScreenState extends State<ListMedicinesScreen> {
  final RemedioDao _remedioDao = RemedioDao();
  final UsuarioDao _usuarioDao = UsuarioDao();
  List<Remedio> _remedios = [];
  Usuario? _usuario;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final usuarios = await _usuarioDao.selecionarTodos();
      final remedios = await _remedioDao.selecionarTodos();
      setState(() {
        _usuario = usuarios.isNotEmpty ? usuarios.first : null;
        _remedios = remedios;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar dados: $e'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  Future<void> _excluirRemedio(Remedio remedio) async {
    try {
      await _remedioDao.deletar(remedio);
      await _carregarDados();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Remédio excluído com sucesso!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao excluir remédio: $e'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, top: 16),
          child: CircleAvatar(
            backgroundColor: Colors.black12,
            backgroundImage:
                _usuario?.foto != null
                    ? NetworkImage(_usuario!.foto!)
                    : const AssetImage('assets/images/profile_placeholder.png')
                        as ImageProvider,
            child:
                _usuario?.foto == null
                    ? const Icon(Icons.person_outline, color: Colors.black87)
                    : null,
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _usuario?.nome ?? 'Usuário',
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _usuario?.idade != null
                    ? '${_usuario!.idade} anos'
                    : 'Idade não informada',
                style: const TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
              child: CircleAvatar(
                backgroundColor: const Color(0xFFFFA7A7),
                backgroundImage:
                    _usuario?.foto != null
                        ? NetworkImage(_usuario!.foto!)
                        : null,
                child:
                    _usuario?.foto == null
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
              ),
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
                        // Mostra diálogo de confirmação
                        final confirmar = await showDialog<bool>(
                          context: context,
                          builder:
                              (ctx) => AlertDialog(
                                title: const Text('Limpar dados inválidos'),
                                content: const Text(
                                  'Isso irá remover todos os remédios com dados inválidos, como:\n\n'
                                  '• Nome, tipo ou dosagem vazios\n'
                                  '• Frequência inválida\n'
                                  '• Horário em formato incorreto\n\n'
                                  'Deseja continuar?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(ctx).pop(false),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(ctx).pop(true),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                    child: const Text('Limpar'),
                                  ),
                                ],
                              ),
                        );

                        if (confirmar != true) return;

                        try {
                          await _remedioDao.deletarFrequenciaInvalida();
                          await _carregarDados();
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Dados inválidos removidos com sucesso!',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Erro ao limpar dados: $e'),
                              backgroundColor: Colors.redAccent,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.all(16),
                            ),
                          );
                        }
                      },
                      tooltip: 'Remover dados inválidos',
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.blueAccent),
                      onPressed: _carregarDados,
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
                          final bool isTaken = index == 0;

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
                                Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor:
                                        isTaken
                                            ? Colors.green
                                            : Colors.redAccent.withOpacity(0.2),
                                    child:
                                        isTaken
                                            ? const Icon(
                                              Icons.check,
                                              size: 20,
                                              color: Colors.white,
                                            )
                                            : const Icon(
                                              Icons.circle,
                                              size: 20,
                                              color: Colors.redAccent,
                                            ),
                                  ),
                                ),
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
                                IconButton(
                                  icon: const Icon(Icons.more_vert),
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SafeArea(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              ListTile(
                                                leading: const Icon(
                                                  Icons.edit,
                                                  color: Colors.blueAccent,
                                                ),
                                                title: const Text(
                                                  'Editar',
                                                  style: TextStyle(
                                                    color: Colors.blueAccent,
                                                  ),
                                                ),
                                                onTap: () async {
                                                  Navigator.pop(
                                                    context,
                                                  ); // Close the bottom sheet
                                                  final result = await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (
                                                            context,
                                                          ) => EditMedicineScreen(
                                                            id: remedio.id,
                                                            nome: remedio.nome,
                                                            tipo: remedio.tipo,
                                                            horario:
                                                                remedio.horario,
                                                            dosagem:
                                                                remedio.dosagem,
                                                            frequencia:
                                                                remedio
                                                                    .frequencia,
                                                          ),
                                                    ),
                                                  );
                                                  if (result != null) {
                                                    await _carregarDados();
                                                  }
                                                },
                                              ),
                                              ListTile(
                                                leading: const Icon(
                                                  Icons.delete,
                                                  color: Colors.redAccent,
                                                ),
                                                title: const Text(
                                                  'Excluir',
                                                  style: TextStyle(
                                                    color: Colors.redAccent,
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.pop(
                                                    context,
                                                  ); // Close the bottom sheet
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
                                                                Navigator.of(
                                                                  ctx,
                                                                ).pop();
                                                                _excluirRemedio(
                                                                  remedio,
                                                                );
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
                                        );
                                      },
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
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditMedicineScreen()),
          );

          if (result != null) {
            await _carregarDados();
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Remédio adicionado com sucesso!'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
          }
        },
      ),
    );
  }
}
