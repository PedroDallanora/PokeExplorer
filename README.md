# PokéExplorer

## Descrição Geral do Aplicativo

O PokéExplorer é um aplicativo desenvolvido com SwiftUI para iOS. Seu objetivo é permitir que usuários explorem os Pokémon da primeira geração (1 a 151), vejam detalhes de cada um (como tipos, habilidades, altura, peso e movimentos), e marquem seus favoritos em uma conta pessoal. O projeto possui autenticação, animações, arquitetura MVVM, persistência de dados com Core Data e layout adaptativo para diferentes dispositivos.

## Escolha da API

A PokéAPI (https://pokeapi.co/) foi a API escolhida por ser pública, gratuita, bem documentada e amplamente utilizada. Ela oferece endpoints robustos para listar Pokémon, buscar detalhes e acessar dados relacionados (como tipos e habilidades).

### Como é usada:

- Endpoint de listagem com paginação:
  https://pokeapi.co/api/v2/pokemon?limit=10&offset=0

- Endpoint para detalhes:
  https://pokeapi.co/api/v2/pokemon/{id}

### Dados utilizados:
- id
- name
- sprites.front_default
- types
- abilities
- height
- weight
- moves

## Arquitetura do Aplicativo

O projeto segue a arquitetura MVVM (Model-View-ViewModel), separando responsabilidade de forma clara entre:

- Model: Representações de dados e lógica de negócio, incluindo estruturas como `pokemonModel`, entidades Core Data (`Favorito`, `Usuario`).
- ViewModel: Contém estados e lógica de apresentação com `@Published`, como `ListaPokemonViewModel`, `DetalhesPokemonViewModel`, etc.
- View: Interface gráfica construída com SwiftUI, como `ListaPokemonView`, `FavoritosView`, `CadastroView`, entre outras.

## Implementação com Core Data

### Entidade Usuario:
- id: UUID
- nomeDeUsuario: String
- email: String
- senha: String (hash SHA-256)
- Relacionamento com vários Favorito

### Entidade Favorito:
- id: UUID
- nome: String
- spriteURL: String
- Relacionamento com um Usuario

### Autenticação:
- Implementada via AuthManager.
- Senhas são salvas como hash SHA-256.
- Sessões são controladas com UserDefaults.

### Persistência:
- Dados são salvos e lidos do Core Data usando NSManagedObjectContext.
- Favoritos são gerenciados pelo FavoritoManager.

## Design Tokens

Tokens centralizados para manter consistência visual:

### Cores (AppColors.swift)
```swift
enum AppColors {
    static let primary = Color("PrimaryColor")
    static let accent = Color("AccentColor")
    static let background = Color("BackgroundColor")
}
```

### Fontes (AppFonts.swift)
```swift
enum AppFonts {
    static let title = Font.system(size: 28, weight: .bold)
    static let subtitle = Font.system(size: 18, weight: .medium)
}
```

## Implementação de Criatividade

- Pagianação que atua de 10 em 10 até gerar os 150 pokemóns da primeira geração

## Checklist de Funcionalidades

- [x] Lista em grade de Pokémon com LazyVGrid
- [x] Página de detalhes com animação e botão de favorito
- [x] Login e cadastro com validação de senha
- [x] Persistência de usuário e favoritos com Core Data
- [x] Arquitetura MVVM completa
- [x] Design tokens para cor e fonte
- [x] Layout reativo para iPhone e iPad
- [x] Animações em interações e carregamentos
- [x] Scroll infinito com paginação

## Model

### Pokemon.swift (pokemonModel)
Define a estrutura de dados utilizada para representar um Pokémon, conforme o padrão da PokéAPI. Contém os seguintes atributos:
- `id`, `name`, `height`, `weight`
- `types`: tipos do Pokémon
- `abilities`: habilidades do Pokémon
- `moves`: movimentos
- `sprites`: imagens, incluindo a principal (frontal)

### PokemonCard.swift
Componente visual reutilizável que apresenta o Pokémon em um "card", com imagem e nome, utilizado nas listas da aplicação. Suporta destaque visual caso o Pokémon esteja marcado como favorito.

---

## ViewModels

### CadastroViewModel.swift
Gerencia os dados do formulário de cadastro de novos usuários. Realiza validações como:
- Todos os campos preenchidos
- Formato de e-mail válido
- Senha com força adequada
- Confirmação de senha coincidente

### LoginViewModel.swift
Controla os dados da tela de login e a tentativa de autenticação com base no e-mail e senha. Armazena erros de validação e login falho.

### ListaPokemonViewModel.swift
Gerencia a lista de Pokémon exibida na tela principal. Implementa lógica de paginação (de 10 em 10) e controla estados como:
- Lista de Pokémon carregados
- Indicador de carregamento
- Mensagem de erro, se necessário

### DetalhesPokemonViewModel.swift
Responsável por buscar os dados detalhados de um Pokémon selecionado. Exibe tipo, altura, peso, habilidades e movimentos.

### FavoritosViewModel.swift
Carrega os Pokémon favoritos do usuário logado a partir do Core Data. Controla a atualização da lista em tempo real.

---

## Views

### CadastroView.swift
Tela de registro de novo usuário com campos de entrada para nome, e-mail, senha e confirmação. Ao cadastrar com sucesso, redireciona para a tela de login.

### LoginView.swift
Tela de login com campos de e-mail e senha. Valida os dados e, se corretos, navega para a tela principal do aplicativo.

### ListaPokemonView.swift
Tela inicial da aplicação. Exibe os Pokémon da 1ª geração em grade, com carregamento incremental (scroll infinito). Suporta animações suaves, destaque de favoritos e adaptação a diferentes tamanhos de tela.

### DetalhesPokemonView.swift
Mostra informações detalhadas de um Pokémon com animações e layout organizado. Contém botão para adicionar/remover dos favoritos.

### FavoritosView.swift
Lista os Pokémon favoritos do usuário. Permite acessar os detalhes e desfavoritar.

### PokemonItemView.swift
Componente responsável por encapsular o card do Pokémon com lógica de exibição. Utilizado em `LazyVGrid` para detectar o último Pokémon exibido (usado na paginação infinita). Também define a navegação para a `DetalhesPokemonView`.

---

## Persistence

### PersistenceController.swift
Gerencia o container do Core Data utilizado por toda a aplicação. Inicializa o contexto de persistência e fornece acesso ao `viewContext`.

### PokeExplorerModel.xcdatamodeld
Modelo de dados do Core Data utilizado no projeto. Define as entidades:
- `Usuario`: representa um usuário cadastrado
- `Favorito`: representa os Pokémon favoritados por um usuário
Inclui relacionamentos, atributos e tipos de dados persistidos.

---

## Service

### PokemonAPIService.swift
Serviço responsável por consumir a PokéAPI. Possui métodos para:
- Buscar lista da 1ª geração de Pokémon com paginação (`limit` e `offset`)
- Buscar detalhes individuais por URL

### AuthManager.swift
Gerencia o sistema de autenticação local. Possui métodos para:
- Cadastro e login de usuários
- Geração de hash de senha
- Obtenção do usuário atual via `UserDefaults`

### FavoritoManager.swift
Responsável por gerenciar os Pokémon favoritos. Permite:
- Adicionar e remover Pokémon favoritos
- Listar favoritos do usuário atual
Utiliza o `viewContext` do Core Data para persistência.

---

## Resource

### AppColors.swift
Define design tokens para cores utilizadas de forma consistente no app, como cor primária, de fundo e destaque.

### AppFonts.swift
Design tokens para fontes utilizadas nas telas do aplicativo. Define estilos como `title`, `subtitle`, `body`, entre outros.

### HashString.swift
Extensão de `String` que gera um hash SHA256. Usado para criar identificadores únicos e seguros.

### String+Validacoes.swift
Extensão de `String` com métodos de validação:
- `isEmailValido()`: valida se o e-mail segue o formato correto
- `isSenhaValida()`: verifica se a senha tem pelo menos 8 caracteres, número, símbolo e letra maiúscula/minúscula

---

## Youtube Video

https://youtu.be/BV4kb_ua0sw
