# timecare

Um aplicativo Flutter para ajudar usuários a gerenciar lembretes de medicamentos e acompanhar relatórios básicos de uso. O aplicativo também inclui um perfil de usuário básico com funcionalidades de CRUD local.

## Descrição do Projeto

timecare é um aplicativo mobile desenvolvido em Flutter com persistência local utilizando SQLite. Ele permite que os usuários cadastrem seus medicamentos, definam horários e frequências, visualizem uma lista organizada de remédios e mantenham um perfil pessoal.

## Funcionalidades

- Cadastro, edição e exclusão de medicamentos (CRUD).
- Visualização da lista de medicamentos com informações detalhadas.
- Funcionalidade para limpar dados de medicamentos inválidos.
- Cadastro e edição de um perfil de usuário (CRUD básico).
- Visualização dos dados do perfil do usuário.
- Navegação entre telas principais (Lista de Medicamentos, Estatísticas, Perfil).
- Persistência de dados local com SQLite.

## Tecnologias Utilizadas

- **Flutter:** Framework UI para desenvolvimento nativo.
- **SQLite:** Banco de dados local para persistência de dados.
- **sqflite:** Plugin Flutter para interagir com SQLite.
- **path:** Plugin Flutter para manipulação de caminhos de arquivos.
- **google_fonts:** Para tipografia personalizada.
- **stylish_bottom_bar:** Para a barra de navegação inferior animada.
- **firebase_core (opcional):** Configuração inicial do Firebase (embora as funcionalidades de banco de dados atuais sejam SQLite).
- **firebase_database (opcional):** Integração com Realtime Database (embora as funcionalidades de banco de dados atuais sejam SQLite).
- **intl:** Para formatação de datas/horas.

## Pré-requisitos

Antes de começar, certifique-se de ter instalado:

- Flutter SDK: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
- Um editor de código (como VS Code, Android Studio, IntelliJ IDEA) com o plugin Flutter instalado.
- Um emulador ou dispositivo físico para executar o aplicativo.

## Como Começar

1.  Clone o repositório:
    ```bash
    git clone <URL_DO_SEU_REPOSITORIO>
    cd timecare
    ```
2.  Instale as dependências do projeto:
    ```bash
    flutter pub get
    ```
3.  Execute o aplicativo em um dispositivo ou emulador:
    ```bash
    flutter run
    ```

## Estrutura do Projeto

A estrutura principal do projeto é organizada da seguinte forma:

```
lib/
├── main.dart             # Ponto de entrada do aplicativo e definição de rotas
├── screens/              # Telas principais e secundárias
│   ├── EditMedicineScreen.dart # Tela para adicionar/editar medicamentos
│   ├── EditUserScreen.dart     # Tela para adicionar/editar perfil do usuário
│   ├── ListMedicinesScreen.dart # Tela principal com a lista de medicamentos
│   ├── Medicine_screen.dart    # (Possivelmente uma tela antiga de medicamentos - verificar uso)
│   ├── ProfileScreen.dart      # Tela de perfil do usuário
│   └── StatisticsScreen.dart   # Tela de estatísticas (placeholder)
└── shared/               # Código compartilhado (modelos, DAOs, serviços)
    ├── dao/              # Objetos de acesso a dados (interação com o BD)
    │   ├── remedio_dao.dart
    │   ├── sql.dart
    │   └── usuario_dao.dart
    ├── models/           # Modelos de dados (classes Remedio, Usuario)
    │   ├── remedio_model.dart
    │   └── usuario_model.dart
    └── services/         # Serviços diversos (ex: conexão com SQLite)
        └── connection_sqlite_service.dart
```

## Banco de Dados (SQLite)

O aplicativo utiliza um banco de dados SQLite local (`MedAlertDB.db`).

-   **Tabelas:**
    -   `remedios`: Armazena informações sobre os medicamentos.
        -   `id`: INTEGER PRIMARY KEY AUTOINCREMENT
        -   `nome`: TEXT NOT NULL
        -   `tipo`: TEXT NOT NULL
        -   `dosagem`: TEXT NOT NULL
        -   `instrucoes`: TEXT
        -   `frequencia`: INTEGER
        -   `horario`: TEXT
    -   `usuarios`: Armazena informações do perfil do usuário.
        -   `id`: INTEGER PRIMARY KEY AUTOINCREMENT
        -   `nome`: TEXT NOT NULL
        -   `email`: TEXT NOT NULL
        -   `telefone`: TEXT
        -   `endereco`: TEXT
        -   `idade`: INTEGER
        -   `foto`: TEXT (Armazena a URL ou caminho da imagem)

-   **Migrações:** O aplicativo utiliza um mecanismo simples de `onUpgrade` para lidar com alterações no esquema do banco de dados (veja `lib/shared/services/connection_sqlite_service.dart`). Em caso de problemas de compatibilidade com o banco, você pode usar a opção "Recriar Banco de Dados" na tela de perfil (isso apagará todos os dados existentes).

## Telas do Aplicativo

-   **HomeScreen (Main):** A tela principal que contém a barra de navegação inferior e gerencia a exibição das telas `ListMedicinesScreen`, `StatisticsScreen`, e `ProfileScreen`.
-   **ListMedicinesScreen:** Exibe a lista de medicamentos cadastrados. Permite adicionar novos medicamentos (via FAB) e editar/excluir itens existentes.
-   **EditMedicineScreen:** Formulário para adicionar ou editar os detalhes de um medicamento.
-   **StatisticsScreen:** Tela placeholder para futuras funcionalidades de relatórios/estatísticas.
-   **ProfileScreen:** Exibe as informações do perfil do usuário. Permite editar o perfil e inclui um botão para recriar o banco de dados (útil para debug/reset).
-   **EditUserScreen:** Formulário para criar ou editar os detalhes do perfil do usuário.

## Funcionalidades CRUD

-   **Medicamentos:**
    -   Adicionar: Botão "+" na `ListMedicinesScreen`.
    -   Editar: Ícone de lápis em cada item da lista.
    -   Excluir: Ícone de lixeira em cada item da lista (com confirmação).
    -   Limpar Dados Inválidos: Ícone de limpeza na `ListMedicinesScreen` (remove remédios com dados inconsistentes no BD).
-   **Usuário:**
    -   Criar/Editar: Botão "Criar Perfil" ou "Editar Perfil" na `ProfileScreen`. Atualmente, gerencia um único perfil (o primeiro encontrado no BD).

## Próximos Passos / Melhorias Futuras

-   Implementar a tela de Estatísticas (`StatisticsScreen`).
-   Expandir as funcionalidades do perfil (upload de foto, mais campos).
-   Implementar um sistema de autenticação (Firebase Auth, etc.) para gerenciar múltiplos usuários e sincronização de dados.
-   Adicionar notificações push para os lembretes de medicamentos.
-   Melhorar a interface do usuário e a experiência do usuário.
-   Implementar testes unitários e de widget.
-   Adicionar tradução/internacionalização.

## Contribuindo

(Se este for um projeto de código aberto, adicione informações sobre como outros podem contribuir)

## Licença

(Adicione as informações de licença do seu projeto)
