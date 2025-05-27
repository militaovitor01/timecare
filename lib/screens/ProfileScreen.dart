import 'package:flutter/material.dart';
import 'package:timecare/shared/dao/usuario_dao.dart';
import 'package:timecare/shared/models/usuario_model.dart';
import 'package:timecare/screens/EditUserScreen.dart';
import 'package:timecare/shared/services/connection_sqlite_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UsuarioDao _usuarioDao = UsuarioDao();
  final ConnectionSqliteService _connection = ConnectionSqliteService.instance;
  Usuario? _usuario;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarUsuario();
  }

  Future<void> _carregarUsuario() async {
    setState(() => _isLoading = true);
    try {
      final usuarios = await _usuarioDao.selecionarTodos();
      setState(() {
        _usuario = usuarios.isNotEmpty ? usuarios.first : null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao carregar perfil: $e')));
    }
  }

  Future<void> _editarPerfil() async {
    if (_usuario == null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EditUserScreen()),
      );
      if (result == true) {
        await _carregarUsuario();
      }
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => EditUserScreen(
              id: _usuario!.id,
              nome: _usuario!.nome,
              email: _usuario!.email,
              telefone: _usuario!.telefone,
              endereco: _usuario!.endereco,
              idade: _usuario!.idade,
              foto: _usuario!.foto,
            ),
      ),
    );
    if (result == true) {
      await _carregarUsuario();
    }
  }

  Future<void> _recriarBancoDados() async {
    try {
      setState(() => _isLoading = true);
      await _connection.deleteDatabase();
      await _carregarUsuario();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Banco de dados recriado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao recriar banco de dados: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Sair'),
            content: const Text('Tem certeza que deseja sair?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Sair'),
              ),
            ],
          ),
    );

    if (confirmar != true) return;

    try {
      setState(() => _isLoading = true);

      // Limpa os dados do usuário atual
      setState(() => _usuario = null);

      // Navega para a tela inicial (ListMedicinesScreen)
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao sair: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    _buildAvatar(),
                    const SizedBox(height: 16),
                    Text(
                      _usuario?.nome ?? 'Usuário',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _usuario?.email ?? 'email@exemplo.com',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    _buildStatsCard(),
                    const SizedBox(height: 16),
                    _buildSettingsCard(context),
                    const SizedBox(height: 16),
                    _buildLogoutButton(context),
                  ],
                ),
              ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey[300],
          backgroundImage:
              _usuario?.foto != null
                  ? NetworkImage(_usuario!.foto!)
                  : const AssetImage('assets/images/profile_placeholder.png')
                      as ImageProvider,
        ),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4),
            ],
          ),
          child: const Icon(Icons.edit, size: 20, color: Colors.blueAccent),
        ),
      ],
    );
  }

  Widget _buildStatsCard() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            _StatItem(label: 'Tomados', value: '12'),
            _StatItem(label: 'Pendentes', value: '2'),
            _StatItem(label: 'Meta', value: '14'),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Editar Perfil'),
            onTap: _editarPerfil,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notificações'),
            onTap: () {
              // Configurações de notificação
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Modo escuro'),
            trailing: Switch(value: false, onChanged: (val) {}),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : _logout,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      icon: const Icon(Icons.logout, color: Colors.white),
      label: const Text('Sair', style: TextStyle(color: Colors.white)),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
