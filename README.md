
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

---

## ▶️ Rodar o projeto — WEB

Na raiz do projeto:

### 1️⃣ flutter clean
Limpa arquivos temporários e o cache de build do Flutter.

Use quando:
- houver mudanças na estrutura do projeto
- ocorrerem erros inesperados de compilação
- após grandes refatorações

```bash
flutter clean
```

---

### 2️⃣ flutter pub get
Instala e resolve todas as dependências definidas no `pubspec.yaml`.

```bash
flutter pub get
```

---

### 3️⃣ flutter run -d chrome
Executa a aplicação Flutter no navegador Google Chrome (Flutter Web).

```bash
flutter run -d chrome
```

> Caso o projeto ainda não tenha suporte Web:
```bash
flutter create .
```

---

### Dispositivo físico
- Ativar Depuração USB
- Conectar o celular

```bash
flutter run
```

---

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
