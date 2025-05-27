import 'package:timecare/shared/models/remedio_model.dart';

class ConnectionSQL {
  static const String CREATE_TABLE_REMEDIO = '''
  CREATE TABLE remedios (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    tipo TEXT NOT NULL,
    dosagem TEXT NOT NULL,
    instrucoes TEXT,
    frequencia INTEGER,
    horario TEXT
  );
  ''';

  static String selecionarTodosOsRemedios() {
    return 'SELECT * FROM remedios;';
  }

  static String adicionarRemedio(Remedio remedio) {
    return '''
      INSERT INTO remedios (nome, tipo, dosagem, instrucoes, frequencia, horario)
      VALUES (?, ?, ?, ?, ?, ?)
    ''';
  }

  static String atualizarRemedio(Remedio remedio) {
    return '''
    UPDATE remedios SET 
      nome = ?, 
      tipo = ?, 
      dosagem = ?, 
      instrucoes = ?,
      frequencia = ?, 
      horario = ? 
    WHERE id = ?
  ''';
  }

  static String deletarRemedio(Remedio remedio) {
    return 'DELETE from remedios WHERE id = ?';
  }

  // Queries para Usuário
  static String adicionarUsuario(usuario) {
    return '''
      INSERT INTO usuarios (
        nome,
        email,
        telefone,
        endereco,
        idade,
        foto
      ) VALUES (?, ?, ?, ?, ?, ?)
    ''';
  }

  static String atualizarUsuario(usuario) {
    return '''
      UPDATE usuarios SET
        nome = ?,
        email = ?,
        telefone = ?,
        endereco = ?,
        idade = ?,
        foto = ?
      WHERE id = ?
    ''';
  }

  static String selecionarUsuarioPorId() {
    return '''
      SELECT * FROM usuarios WHERE id = ?
    ''';
  }

  static String selecionarTodosOsUsuarios() {
    return '''
      SELECT * FROM usuarios ORDER BY nome
    ''';
  }

  static String deletarUsuario(usuario) {
    return '''
      DELETE FROM usuarios WHERE id = ?
    ''';
  }
}
