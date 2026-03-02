
# MindEase Focus – TC5 FINAL 🚀

Projeto Flutter com setup profissional de Front-End Engineering,
focado em **Acessibilidade Cognitiva**, seguindo **Clean Architecture**,
boas práticas de **UI/UX**, qualidade de código e automação.

---

## 📦 Pré-requisitos

- Windows 10 ou superior
- Git
- Google Chrome (para Flutter Web)
- Android Studio (para Mobile Android)
- Node.js (apenas para Husky / Git Hooks)

---

## ⬇️ Download do Flutter (OFICIAL)

🔗 **Link oficial (archive):**  
https://docs.flutter.dev/install/archive

### ✅ Versão recomendada
- **Stable**
- Windows (zip)

---

## 📁 Onde descompactar o Flutter (IMPORTANTE)

1. Crie a pasta:
```
C:\flutter
```

2. Descompacte o conteúdo do ZIP **dentro dessa pasta**, ficando assim:
```
C:\flutter\bin
C:\flutter\packages
C:\flutter\version
```

⚠️ **Não descompacte dentro de `Program Files`**  
⚠️ Evite pastas com espaço no nome

---

## 🌱 Configurar Variável de Ambiente (Windows)

### 1️⃣ Abrir Variáveis de Ambiente
- Painel de Controle → Sistema → Configurações avançadas
- Variáveis de Ambiente

### 2️⃣ Editar a variável `Path`
Adicione **no Path do usuário ou do sistema**:

```
C:\flutter\bin
```

### 3️⃣ Salvar tudo e fechar

---

## ✅ Verificar instalação do Flutter

Abra um **novo terminal** (PowerShell ou Git Bash) e rode:

```bash
flutter doctor
```

Resultado esperado:
- Flutter reconhecido
- Dart reconhecido

## 🔑 Variáveis de Ambiente e Supabase

A arquitetura do projeto foi desenhada para facilitar o onboarding de novos Devs sem onerar a máquina local com a criação manual de diversos arquivos `.env`, seguindo as **Boas Práticas oficiais do Flutter para injeção nativa**.

Criamos um arquivo de repositório centralizado em `config/dev.json`. Ele carrega as chaves **públicas** relativas ao backend do projeto (Supabase Web/Mobile). 

> **Importante:** No Flutter, não se usa pacotes de `dotenv` como em Node.js. Toda variável do `dev.json` é injetada nativamente em "tempo de compilação" via flag `--dart-define-from-file`. 

---

## ▶️ Rodar o projeto Localmente

Nosso `package.json` já conta com os scripts nativos que abstraem todo esse comando de injeção automática para você de forma simples:

### 🌐 Web (Porta Fixada em 3000)
Para rodar a aplicação Web, utilizamos o gatilho NPM que irá injetar o `dev.json` no Dart e rodará o sistema cravado na porta 3000. Isso é crucial para evitar portas aleatórias do Flutter que poderiam causar problemas de CORS na comunicação com a API:

```bash
npm start
```
*(Atalho para: `flutter run -d chrome --web-port 3000 --dart-define-from-file=config/dev.json`)*

---

### 📱 Mobile (Android/iOS)
Para rodar a aplicação em emuladores ou dispositivos físicos conectados via USB, utilizamos o script focado no mobile que lê exatamente o mesmo arquivo, ativando as chaves no Dart:

```bash
npm run start:mobile
```
*(Atalho para: `flutter run --dart-define-from-file=config/dev.json`)*

---

### Comandos Auxiliares do Flutter

**flutter clean**
Limpa arquivos temporários e o cache de build.

```bash
flutter clean
```

---

**flutter pub get**
Instala as dependências definidas no `pubspec.yaml`.

```bash
flutter pub get
```

## ▶️ Rodar o projeto — iOS (macOS)

```bash
flutter pub get
flutter run
```

> Requer macOS + Xcode.

---

## 🧹 Lint (Qualidade de código)

```bash
flutter analyze
```

---

## 🧪 Testes

```bash
flutter test
```

---

## 🐶 Husky — Bloqueio de commit com erro

### Instalar (uma vez por máquina)
```bash
npm install
npm run prepare
```

### Pre-commit automático
Antes de cada commit:
- flutter analyze
- flutter test

❌ Erro → commit bloqueado  
✅ Sucesso → commit liberado

---

### 🔔 Notificações Push

O MindEase Focus agora conta com um sistema de notificações push nativas para Android e Web:

- **Android**: Utiliza o plugin `flutter_local_notifications` para exibir alertas do sistema quando o timer Pomodoro termina.
- **Web**: Utiliza a `Notification API` do navegador para garantir que você não perca o fim de uma sessão, mesmo se estiver em outra aba.
- **Configurável**: Os alertas podem ser ativados/desativados nas configurações de perfil (Alerta de Tempo da Tarefa e Notificações Push).
- **In-app**: Um contador de notificações (sininho) no cabeçalho permite acompanhar o histórico de alertas.

## ✍️ Padrão de Commit (Conventional Commits)

Exemplos válidos:
```bash
feat: add dashboard layout
fix: resolve lint issue
chore: setup flutter environment
```

---

## 🔁 CI/CD — GitHub Actions

Ao realizar **push** ou **pull request**, o GitHub executa automaticamente:

- flutter pub get
- flutter analyze
- flutter test

Arquivo:
```
.github/workflows/flutter_ci.yml
```

---

## 🧱 Arquitetura

- Clean Architecture
- Separação por features
- Barrel Files (`features.dart`) para imports limpos


## Clean Architecture adaptada para Flutter
```
lib/
 ├─ features/
 │   └─ auth/
 │       ├─ presentation/
 │       │   ├─ pages/
 │       │   ├─ widgets/
 │       │   └─ controllers/
 │       │
 │       ├─ domain/
 │       │   ├─ entities/
 │       │   ├─ usecases/
 │       │   ├─ repositories/
 │       │   └─ validators/
 │       │
 │       └─ data/
 │           ├─ models/
 │           ├─ datasources/
 │           └─ repositories/
 │
 ├─ shared/
 │   ├─ theme/
 │   ├─ tokens/
 │   ├─ widgets/
 │   └─ utils/
 │
 ├─ routes.dart
 └─ main.dart


=================================================
🔵 1. Presentation (UI)

Responsabilidade:
⦁	Widgets
⦁	Pages
⦁	Controllers / Cubit / Bloc / ViewModel
⦁	Validações de formulário
⦁	Estados de tela

=================================================
🟢 2. Domain (Regra de Negócio)

Responsabilidade:
⦁	Entidades
⦁	UseCases
⦁	Interfaces (contracts)
⦁	Validators de regra de negócio


=================================================
🟡 3. Data (Implementação)

Responsabilidade:

⦁	Implementar repositórios
⦁	DTOs / Models
⦁	Datasources (API, local, cache)

=================================================
⚫ 4. Core / Shared (Transversal)

Responsabilidade:

⦁	Temas
⦁	Tokens de design
⦁	Helpers
⦁	Erros globais
⦁	Configuração de DI

```

---

## ✅ Checklist TC5

- Flutter Web ✔
- Flutter Mobile ✔
- Setup de ambiente documentado ✔
- Clean Architecture ✔
- Lints ✔
- Testes ✔
- Husky ✔
- CI/CD ✔

---

## 🎯 Objetivo do Projeto

Criar uma plataforma digital acessível que reduza sobrecarga cognitiva
em ambientes acadêmicos e profissionais.
