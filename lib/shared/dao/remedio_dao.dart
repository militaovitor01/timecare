import 'package:timecare/shared/dao/sql.dart';
import 'package:timecare/shared/models/remedio_model.dart';
import 'package:timecare/shared/services/connection_sqlite_service.dart';
import 'package:sqflite/sqflite.dart';

class RemedioDao {
  ConnectionSqliteService _connection = ConnectionSqliteService.instance;

  Future<Database> _getDatabase() async {
    return await _connection.db;
  }

  Future<Remedio> adicionar(Remedio remedio) async {
    try {
      Database db = await _getDatabase();
      int idRetornado = await db.rawInsert(
        ConnectionSQL.adicionarRemedio(remedio),
      );
      remedio.id = idRetornado;
      return remedio;
    } catch (error) {
      print('Erro ao adicionar remédio: $error');
      throw Exception('Erro ao adicionar remédio: $error');
    }
  }

  Future<bool> atualizar(Remedio remedio) async {
    try {
      Database db = await _getDatabase();
      int linhasAfetadas = await db.rawUpdate(
        ConnectionSQL.atualizarRemedio(remedio),
      );
      return linhasAfetadas > 0;
    } catch (error) {
      print('Erro ao atualizar remédio: $error');
      throw Exception('Erro ao atualizar remédio: $error');
    }
  }

  Future<List<Remedio>> selecionarTodos() async {
    try {
      Database db = await _getDatabase();
      List<Map<String, dynamic>> linhas = await db.rawQuery(
        ConnectionSQL.selecionarTodosOsRemedios(),
      );

      for (var linha in linhas) {
        print('Linha do banco de dados: $linha');
      }

      List<Remedio> remedios =
          linhas.map((linha) => Remedio.fromSQLite(linha)).toList();
      return remedios;
    } catch (error) {
      print('Erro ao selecionar remédios: $error');
      throw Exception('Erro ao selecionar remédios: $error');
    }
  }

  Future<bool> deletar(Remedio remedio) async {
    try {
      Database db = await _getDatabase();
      int linhasAfetadas = await db.rawDelete(
        ConnectionSQL.deletarRemedio(remedio),
      );
      return linhasAfetadas > 0;
    } catch (error) {
      print('Erro ao deletar remédio: $error');
      throw Exception('Erro ao deletar remédio: $error');
    }
  }

  // Função para deletar linhas com frequência incorreta
  Future<bool> deletarPorFrequenciaIncorreta() async {
    try {
      Database db = await _getDatabase();
      int linhasAfetadas = await db.delete(
        'remedios',
        where:
            "typeof(frequencia) = 'text'", // Filtra onde 'frequencia' é uma string
      );

      print('$linhasAfetadas linhas deletadas com frequência incorreta.');
      return linhasAfetadas > 0;
    } catch (error) {
      print('Erro ao deletar remédios com frequência incorreta: $error');
      throw Exception(
        'Erro ao deletar remédios com frequência incorreta: $error',
      );
    }
  }

  Future<void> deletarFrequenciaInvalida() async {
    try {
      Database db = await _getDatabase();
      int linhasAfetadas = await db.rawDelete(
        "DELETE FROM remedios WHERE typeof(frequencia) != 'integer'",
      );
      print('$linhasAfetadas linhas deletadas com frequência incorreta.');
    } catch (error) {
      print('Erro ao deletar remédios com frequência incorreta: $error');
      throw Exception(
        'Erro ao deletar remédios com frequência incorreta: $error',
      );
    }
  }
}
