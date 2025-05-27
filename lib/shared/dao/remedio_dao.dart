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
      if (remedio.nome.isEmpty ||
          remedio.tipo.isEmpty ||
          remedio.dosagem.isEmpty) {
        throw Exception('Nome, tipo e dosagem são campos obrigatórios');
      }

      Database db = await _getDatabase();
      int idRetornado = await db
          .rawInsert(ConnectionSQL.adicionarRemedio(remedio), [
            remedio.nome,
            remedio.tipo,
            remedio.dosagem,
            remedio.instrucoes,
            remedio.frequencia,
            remedio.horario,
          ]);
      remedio.id = idRetornado;
      return remedio;
    } catch (error) {
      print('Erro ao adicionar remédio: $error');
      throw Exception('Erro ao adicionar remédio: $error');
    }
  }

  Future<bool> atualizar(Remedio remedio) async {
    try {
      if (remedio.id == null) {
        throw Exception('ID do remédio é obrigatório para atualização');
      }
      if (remedio.nome.isEmpty ||
          remedio.tipo.isEmpty ||
          remedio.dosagem.isEmpty) {
        throw Exception('Nome, tipo e dosagem são campos obrigatórios');
      }

      Database db = await _getDatabase();
      int linhasAfetadas = await db
          .rawUpdate(ConnectionSQL.atualizarRemedio(remedio), [
            remedio.nome,
            remedio.tipo,
            remedio.dosagem,
            remedio.instrucoes,
            remedio.frequencia,
            remedio.horario,
            remedio.id,
          ]);
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

      if (linhas.isEmpty) {
        print('Nenhum remédio encontrado no banco de dados');
        return [];
      }

      List<Remedio> remedios = [];
      for (var linha in linhas) {
        try {
          remedios.add(Remedio.fromSQLite(linha));
        } catch (e) {
          print('Erro ao converter linha do banco: $linha');
          print('Erro: $e');
        }
      }
      return remedios;
    } catch (error) {
      print('Erro ao selecionar remédios: $error');
      throw Exception('Erro ao selecionar remédios: $error');
    }
  }

  Future<bool> deletar(Remedio remedio) async {
    try {
      if (remedio.id == null) {
        throw Exception('ID do remédio é obrigatório para exclusão');
      }

      Database db = await _getDatabase();
      int linhasAfetadas = await db.rawDelete(
        ConnectionSQL.deletarRemedio(remedio),
        [remedio.id],
      );
      return linhasAfetadas > 0;
    } catch (error) {
      print('Erro ao deletar remédio: $error');
      throw Exception('Erro ao deletar remédio: $error');
    }
  }

  Future<void> deletarFrequenciaInvalida() async {
    try {
      Database db = await _getDatabase();

      // Lista de condições para dados inválidos
      final conditions = [
        "typeof(frequencia) != 'integer'", // Frequência não é número
        "nome IS NULL OR nome = ''", // Nome vazio
        "tipo IS NULL OR tipo = ''", // Tipo vazio
        "dosagem IS NULL OR dosagem = ''", // Dosagem vazia
        "frequencia < 0", // Frequência negativa
        "horario IS NOT NULL AND horario != '' AND horario NOT LIKE '__:__'", // Horário inválido
      ];

      // Constrói a query com todas as condições
      final whereClause = conditions.join(' OR ');
      final query = "DELETE FROM remedios WHERE $whereClause";

      print('Executando limpeza com query: $query');

      int linhasAfetadas = await db.rawDelete(query);
      print('$linhasAfetadas linhas deletadas com dados inválidos.');

      if (linhasAfetadas > 0) {
        // Limpa o cache do banco de dados
        await db.execute('VACUUM');
      }
    } catch (error) {
      print('Erro ao limpar dados inválidos: $error');
      throw Exception('Erro ao limpar dados inválidos: $error');
    }
  }
}
