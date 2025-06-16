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

- Animações visuais ao favoritar Pokémon, transições suaves entre telas com `.transition()` e `.withAnimation`.
- Scroll infinito com paginação para carregar Pokémon em lotes de 10.
- Responsividade total com uso de LazyVGrid, GeometryReader, e `.adaptive(minimum:)`.
- Validações em tempo real de email e senha durante o cadastro com regex.

## Bibliotecas de Terceiros

O projeto não utiliza bibliotecas de terceiros. Toda implementação foi feita com ferramentas nativas da Apple, como:

- SwiftUI para UI e animações
- Core Data para persistência
- UserDefaults para controle de sessão
- CryptoKit para hash de senha

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

## Execução

1. Clone o projeto.
2. Abra com Xcode 15 ou superior.
3. Rode o projeto em um simulador.
4. Crie uma conta e explore os Pokémon!
