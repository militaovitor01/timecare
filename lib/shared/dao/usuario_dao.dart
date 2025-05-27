import 'package:timecare/shared/dao/sql.dart';
import 'package:timecare/shared/models/usuario_model.dart';
import 'package:timecare/shared/services/connection_sqlite_service.dart';
import 'package:sqflite/sqflite.dart';

class UsuarioDao {
  ConnectionSqliteService _connection = ConnectionSqliteService.instance;

  Future<Database> _getDatabase() async {
    return await _connection.db;
  }

  Future<Usuario> adicionar(Usuario usuario) async {
    try {
      if (usuario.nome.isEmpty || usuario.email.isEmpty) {
        throw Exception('Nome e email são campos obrigatórios');
      }

      Database db = await _getDatabase();
      int idRetornado = await db
          .rawInsert(ConnectionSQL.adicionarUsuario(usuario), [
            usuario.nome,
            usuario.email,
            usuario.telefone,
            usuario.endereco,
            usuario.idade,
            usuario.foto,
          ]);
      usuario.id = idRetornado;
      return usuario;
    } catch (error) {
      print('Erro ao adicionar usuário: $error');
      throw Exception('Erro ao adicionar usuário: $error');
    }
  }

  Future<bool> atualizar(Usuario usuario) async {
    try {
      if (usuario.id == null) {
        throw Exception('ID do usuário é obrigatório para atualização');
      }
      if (usuario.nome.isEmpty || usuario.email.isEmpty) {
        throw Exception('Nome e email são campos obrigatórios');
      }

      Database db = await _getDatabase();
      int linhasAfetadas = await db
          .rawUpdate(ConnectionSQL.atualizarUsuario(usuario), [
            usuario.nome,
            usuario.email,
            usuario.telefone,
            usuario.endereco,
            usuario.idade,
            usuario.foto,
            usuario.id,
          ]);
      return linhasAfetadas > 0;
    } catch (error) {
      print('Erro ao atualizar usuário: $error');
      throw Exception('Erro ao atualizar usuário: $error');
    }
  }

  Future<Usuario?> selecionarPorId(int id) async {
    try {
      Database db = await _getDatabase();
      List<Map<String, dynamic>> linhas = await db.rawQuery(
        ConnectionSQL.selecionarUsuarioPorId(),
        [id],
      );

      if (linhas.isEmpty) {
        return null;
      }

      return Usuario.fromSQLite(linhas.first);
    } catch (error) {
      print('Erro ao selecionar usuário: $error');
      throw Exception('Erro ao selecionar usuário: $error');
    }
  }

  Future<List<Usuario>> selecionarTodos() async {
    try {
      Database db = await _getDatabase();
      List<Map<String, dynamic>> linhas = await db.rawQuery(
        ConnectionSQL.selecionarTodosOsUsuarios(),
      );

      if (linhas.isEmpty) {
        print('Nenhum usuário encontrado no banco de dados');
        return [];
      }

      return Usuario.fromSQLiteList(linhas);
    } catch (error) {
      print('Erro ao selecionar usuários: $error');
      throw Exception('Erro ao selecionar usuários: $error');
    }
  }

  Future<bool> deletar(Usuario usuario) async {
    try {
      if (usuario.id == null) {
        throw Exception('ID do usuário é obrigatório para exclusão');
      }

      Database db = await _getDatabase();
      int linhasAfetadas = await db.rawDelete(
        ConnectionSQL.deletarUsuario(usuario),
        [usuario.id],
      );
      return linhasAfetadas > 0;
    } catch (error) {
      print('Erro ao deletar usuário: $error');
      throw Exception('Erro ao deletar usuário: $error');
    }
  }
}
