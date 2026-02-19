# Sistema de Notificações e Alertas do Pomodoro Timer 🔔

## Visão Geral

Sistema completo de notificações e alertas implementado para o timer Pomodoro, suportando **Web** e **Mobile** (Android/iOS).

O sistema possui **dois subsistemas independentes**:
1. **Notificações do Timer** - Avisos quando o timer completa (foco ou pausa)
2. **Alertas de Tempo na Tarefa** - Avisos quando você passa muito tempo (4+ pomodoros) na mesma tarefa

## ✨ Funcionalidades Implementadas

### 1. Sistema de Notificações do Timer
- ✅ **Notificações Nativas** (Android, iOS, Web, Linux)
- ✅ **Controlado por**: `pushNotifications` (ON/OFF)
- ✅ **Dispara quando**: Timer de foco ou pausa completa
- ✅ **Mensagens**:
  - Foco: "🎉 Tempo de foco concluído! Hora de fazer uma pausa!"
  - Pausa: "✨ Pausa concluída! Pronto para focar novamente?"

### 2. Sistema de Alertas de Tempo na Tarefa
- ✅ **Rastreamento de Pomodoros** por tarefa "In Progress"
- ✅ **Controlado por**: `taskTimeAlert` (ON/OFF)
- ✅ **Dispara quando**: Passa de 4 pomodoros consecutivos na mesma tarefa
- ✅ **Tipos de Alerta**:
  - **Web**: Toast no canto superior direito
  - **Mobile**: Bottom sheet
  - **Sistema**: Notificação push (se `pushNotifications` também estiver ON)

### 3. Lógica de Combinação (taskTimeAlert + pushNotifications)

| taskTimeAlert | pushNotifications | Resultado |
|---------------|-------------------|-----------|
| ✅ ON | ✅ ON | Toast/Bottom Sheet + Notificação do Sistema |
| ✅ ON | ❌ OFF | Apenas Toast/Bottom Sheet no app |
| ❌ OFF | ✅ ON | Não dispara alerta (push sozinho não funciona) |
| ❌ OFF | ❌ OFF | Não dispara nada |

### 4. Configurações do Usuário
- ✅ **Push Notifications**: Habilita/desabilita notificações do sistema
- ✅ **Task Time Alert**: Habilita/desabilita alertas de tempo na tarefa
- ✅ Configurações salvas no Supabase
- ✅ Interface intuitiva na página de Perfil

## 📁 Arquivos Criados/Modificados

### Novos Arquivos
- `lib/shared/services/notification_service.dart` - Serviço de notificações nativas
- `lib/shared/services/pomodoro_alert_service.dart` - Rastreamento de pomodoros por tarefa
- `lib/shared/services/toast_service.dart` - Toast multiplataforma (Web/Mobile)

### Arquivos Modificados
- `pubspec.yaml` - Adicionada dependência `flutter_local_notifications`
- `android/app/src/main/AndroidManifest.xml` - Permissões Android
- `web/index.html` - Configuração para notificações web
- `lib/main.dart` - Inicialização dos serviços e injeção de dependências
- `lib/features/auth/presentation/controllers/pomodoro_controller.dart` - Lógica completa de notificações e alertas
- `lib/features/auth/presentation/controllers/task_controller.dart` - Reset de contador ao trocar tarefa
- `lib/features/auth/presentation/pages/profile/widgets/cards/notifications/notifications_card.dart` - Toggles de configuração

## 🚀 Como Usar

### Para o Usuário

1. **Habilitar Notificações**:
   - Acesse a página de Perfil
   - Role até a seção "Notificações"
   - Ative o toggle "Notificações do Pomodoro"

2. **Usar o Timer**:
   - Configure o timer Pomodoro (Foco ou Pausa)
   - Inicie o timer
   - Quando o timer terminar, você receberá uma notificação

3. **Permissões**:
   - Na primeira vez, o app solicitará permissão para enviar notificações
   - Android 13+: Permissão será solicitada automaticamente
   - Web: O navegador solicitará permissão ao usuário

### Para Desenvolvedores

#### Enviar uma Notificação Manualmente

```dart
import 'package:mindease_focus/shared/services/notification_service.dart';

// Obter instância do serviço
final notificationService = NotificationService();

// Enviar notificação
await notificationService.showPomodoroNotification(
  title: 'Título da Notificação',
  body: 'Corpo da notificação',
  payload: 'dados_opcionais',
);
```

#### Verificar se Notificações estão Disponíveis

```dart
final service = NotificationService();
if (service.isAvailable) {
  // Notificações estão disponíveis
}
```

## ⚙️ Configurações Técnicas

### Android

**Permissões** (`AndroidManifest.xml`):
- `POST_NOTIFICATIONS` - Para Android 13+ (API 33+)
- `SCHEDULE_EXACT_ALARM` - Para agendar alarmes exatos
- `USE_EXACT_ALARM` - Alternativa para alarmes exatos

**Canal de Notificação**:
- ID: `pomodoro_channel`
- Nome: `Pomodoro Timer`
- Importância: Alta
- Som: Padrão do sistema
- Vibração: Desabilitada (conforme solicitado)

### iOS/macOS

**Configurações**:
- Alert: Habilitado
- Badge: Habilitado
- Sound: Habilitado

### Web

**Configuração** (`index.html`):
- API de Notificações do navegador
- Função JavaScript para solicitar permissão
- Compatível com Chrome, Firefox, Edge, Safari

## 🧪 Como Testar

### Mobile (Android/iOS)

1. **Instalar o app**:
   ```bash
   flutter run
   ```

2. **Testar notificações**:
   - Faça login no app
   - Vá para a página de Tarefas
   - Inicie um timer de 25 minutos (ou modifique para 10 segundos para teste rápido)
   - Coloque o app em segundo plano
   - Aguarde o timer completar
   - ✅ Você deve receber uma notificação do sistema

### Web

1. **Executar em modo web**:
   ```bash
   flutter run -d chrome
   ```

2. **Permitir notificações**:
   - O navegador solicitará permissão
   - Clique em "Permitir"

3. **Testar**:
   - Siga os mesmos passos do mobile
   - ✅ Você deve receber uma notificação do navegador

### Teste Rápido (Modificar Timer)

Para testar rapidamente sem esperar 25 minutos, modifique temporariamente o `pomodoro_controller.dart`:

```dart
// Altere de:
static const int _focusTime = 25 * 60;
// Para:
static const int _focusTime = 10; // 10 segundos
```

## 🔧 Troubleshooting

### Android

**Problema**: Notificações não aparecem
- ✅ Verifique se as permissões estão no `AndroidManifest.xml`
- ✅ Verifique se o app tem permissão nas configurações do dispositivo
- ✅ Android 13+: Aceite a permissão quando solicitada

**Problema**: Som não toca
- ✅ Verifique o volume do dispositivo
- ✅ Verifique se o modo "Não Perturbe" está desativado

### iOS

**Problema**: Notificações não aparecem
- ✅ Verifique se as permissões foram concedidas
- ✅ Verifique as configurações de notificação do iOS
- ✅ iOS não mostra notificações de apps em primeiro plano (comportamento esperado)

### Web

**Problema**: Notificações não funcionam
- ✅ Verifique se o navegador suporta notificações
- ✅ Verifique se a permissão foi concedida
- ✅ Alguns navegadores bloqueiam notificações em HTTP (use HTTPS)

## 📊 Estado das Notificações

O sistema mantém o estado através do `PomodoroController`:

```dart
// Verificar se notificações estão habilitadas
pomodoroController.notificationsEnabled; // bool

// Habilitar/Desabilitar
pomodoroController.toggleNotifications(true); // habilitar
pomodoroController.toggleNotifications(false); // desabilitar
```

## 🎨 Customização

### Alterar Ícone da Notificação (Android)

Substitua o ícone em:
```
android/app/src/main/res/mipmap-*/ic_launcher.png
```

### Alterar Mensagens

Modifique em `pomodoro_controller.dart`:
```dart
Future<void> _sendNotification() async {
  final String title;
  final String body;

  if (_mode == PomodoroMode.focus) {
    title = 'Sua mensagem aqui';
    body = 'Seu corpo aqui';
  } else {
    title = 'Outra mensagem';
    body = 'Outro corpo';
  }
  // ...
}
```

## 📝 Notas Importantes

1. **Sem Vibração**: Conforme solicitado, a vibração está desabilitada
2. **Som Padrão**: Utiliza o som padrão do sistema operacional
3. **Sem Ações Customizadas**: A notificação apenas abre o app ao ser tocada
4. **Estado Persistente**: A preferência de notificações é mantida durante a sessão

## 🔮 Melhorias Futuras

Possíveis melhorias que podem ser implementadas:

- [ ] Salvar preferência de notificações no Supabase
- [ ] Sons customizados diferentes por tipo (foco vs pausa)
- [ ] Ações na notificação (continuar, pausar)
- [ ] Histórico de notificações
- [ ] Notificações programadas para lembrar de iniciar pomodoro
- [ ] Integração com calendário
- [ ] Estatísticas de produtividade baseadas em notificações

## 📚 Referências

- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
- [Android Notifications](https://developer.android.com/develop/ui/views/notifications)
- [iOS Notifications](https://developer.apple.com/documentation/usernotifications)
- [Web Notifications API](https://developer.mozilla.org/en-US/docs/Web/API/Notifications_API)

---

**Implementado por**: Cline AI Assistant  
**Data**: 08/02/2026  
**Versão**: 1.0.0
