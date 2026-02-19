# Controle de Som das Notificações 🔇🔔

## Visão Geral

Sistema implementado para permitir que o usuário controle o som das notificações do navegador através do toggle "Sons de Notificação" na página de perfil.

## ✨ Funcionalidade Implementada

### Toggle de Som
- **Localização**: Página de Perfil → Seção "Notificações" → "Sons de Notificação"
- **Campo no banco**: `notification_sounds` (boolean)
- **Valor padrão**: `false` (sem som)
- **Dependência**: Só funciona se "Notificações Push" estiver ativado

### Comportamento

| Push Notifications | Notification Sounds | Resultado |
|-------------------|---------------------|-----------|
| ✅ ON | ✅ ON | Notificação **COM som** 🔔 |
| ✅ ON | ❌ OFF | Notificação **SEM som** 🔕 |
| ❌ OFF | ✅ ON | **Nenhuma notificação** |
| ❌ OFF | ❌ OFF | **Nenhuma notificação** |

## 🔧 Implementação Técnica

### 1. NotificationService

Adicionado parâmetro `enableSound` aos métodos de notificação:

```dart
Future<void> showPomodoroNotification({
  required String title,
  required String body,
  String? payload,
  bool enableSound = true,  // 🆕 Controla o som
}) async {
  // ...
  if (kIsWeb) {
    _showWebNotification(title, body, silent: !enableSound);
  }
  // ...
}
```

### 2. Método _showWebNotification

Modificado para aceitar parâmetro `silent`:

```dart
void _showWebNotification(String title, String body, {bool silent = false}) {
  final options = web.NotificationOptions(
    body: body,
    icon: '/favicon.png',
    badge: '/favicon.png',
    requireInteraction: false,
    silent: silent,  // 🔇 Controla o som da notificação
  );
  
  web.Notification(title, options);
}
```

### 3. PomodoroController

Atualizado para passar a preferência do usuário:

```dart
Future<void> _sendTimerNotification() async {
  await notificationService.showPomodoroNotification(
    title: title,
    body: body,
    enableSound: preferencesController.notificationSounds,  // 🆕
  );
}

Future<void> _sendTaskTimeAlert(String taskTitle) async {
  await notificationService.showTaskTimeAlert(
    title: '⏰ Alerta de Tempo na Tarefa',
    body: 'Você está há ${alertService.consecutivePomodoros} pomodoros...',
    enableSound: preferencesController.notificationSounds,  // 🆕
  );
}
```

## 📁 Arquivos Modificados

1. ✏️ **lib/shared/services/notification_service.dart**
   - Adicionado parâmetro `silent` ao `NotificationOptions`
   - Adicionado parâmetro `enableSound` aos métodos públicos
   - Modificado `_showWebNotification()` para aceitar `silent`

2. ✏️ **lib/features/auth/presentation/controllers/pomodoro_controller.dart**
   - Atualizado `_sendTimerNotification()` para passar `enableSound`
   - Atualizado `_sendTaskTimeAlert()` para passar `enableSound`

## 🎯 Como Usar

### Para o Usuário

1. **Acessar Configurações**:
   - Faça login no app
   - Vá para a página de Perfil
   - Role até a seção "Notificações"

2. **Habilitar Notificações**:
   - Ative o toggle "Notificações Push"
   - O navegador solicitará permissão (aceite)

3. **Controlar o Som**:
   - Ative o toggle "Sons de Notificação" para **ouvir** o som 🔔
   - Desative o toggle para receber notificações **silenciosas** 🔕

4. **Testar**:
   - Vá para a página de Tarefas
   - Inicie um timer Pomodoro
   - Aguarde o timer completar
   - Você receberá uma notificação (com ou sem som, conforme configurado)

### Para Desenvolvedores

#### Enviar Notificação com Som Controlável

```dart
// Obter preferência do usuário
final enableSound = preferencesController.notificationSounds;

// Enviar notificação
await notificationService.showPomodoroNotification(
  title: 'Título',
  body: 'Mensagem',
  enableSound: enableSound,  // true = com som, false = silencioso
);
```

#### Verificar Estado Atual

```dart
// Verificar se notificações estão habilitadas
final pushEnabled = preferencesController.pushNotifications;

// Verificar se som está habilitado
final soundEnabled = preferencesController.notificationSounds;

// Som só funciona se push estiver ON
final willPlaySound = pushEnabled && soundEnabled;
```

## 🌐 Compatibilidade

### Web (Navegador)
- ✅ **Chrome/Edge**: Suporte completo à propriedade `silent`
- ✅ **Firefox**: Suporte completo
- ✅ **Safari**: Suporte completo (macOS 12+)
- ⚠️ **Navegadores antigos**: Podem ignorar a propriedade `silent`

### Mobile/Desktop
- ℹ️ **Android/iOS**: O controle de som é feito pelo sistema operacional
- ℹ️ **Desktop (Windows/Linux)**: Configuração do sistema prevalece

## 🧪 Como Testar

### Teste Rápido (Web)

1. **Executar o app**:
   ```bash
   flutter run -d chrome
   ```

2. **Configurar**:
   - Faça login
   - Vá para Perfil → Notificações
   - Ative "Notificações Push"
   - Ative "Sons de Notificação"

3. **Testar COM som**:
   - Vá para Tarefas
   - Inicie um timer (1 minuto)
   - Aguarde completar
   - ✅ Deve tocar som

4. **Testar SEM som**:
   - Volte para Perfil
   - Desative "Sons de Notificação"
   - Inicie outro timer
   - Aguarde completar
   - ✅ Notificação aparece, mas SEM som

### Teste de Desenvolvimento (Timer Rápido)

Para testar sem esperar 25 minutos, modifique temporariamente:

```dart
// Em pomodoro_controller.dart
static const int _focusTime = 10; // 10 segundos ao invés de 25 minutos
```

## 🔍 Debug

### Logs no Console

O sistema imprime logs úteis no console:

```
🔔 PomodoroController: Timer completado! Modo: PomodoroMode.focus
🔔 Push Notifications: true
🔔 Enviando notificação do timer...
Web: Notificação criada - 🎉 Tempo de foco concluído! (silent: false)
```

- `silent: false` = **COM som** 🔔
- `silent: true` = **SEM som** 🔕

### Verificar Preferências

```dart
// No console do navegador (DevTools)
print('Push: ${preferencesController.pushNotifications}');
print('Sound: ${preferencesController.notificationSounds}');
```

## 📊 Fluxo de Decisão

```
Timer Completa
    ↓
Push Notifications ON?
    ↓ Sim
    Notification Sounds ON?
        ↓ Sim                    ↓ Não
    Notificação COM som      Notificação SEM som
        🔔                          🔕
    ↓ Não
Nenhuma notificação
```

## 🎨 Interface do Usuário

### Toggle "Sons de Notificação"

```
┌─────────────────────────────────────────┐
│ 🔔 Notificações                         │
├─────────────────────────────────────────┤
│                                         │
│ Notificações Push              [ON]    │
│ Receba notificações no navegador       │
│                                         │
│ Sons de Notificação            [ON]    │
│ Toque um som ao receber notificações   │
│                                         │
└─────────────────────────────────────────┘
```

### Estados do Toggle

- **Habilitado + ON**: Som ativado 🔔
- **Habilitado + OFF**: Som desativado 🔕
- **Desabilitado**: Push Notifications está OFF (cinza)

## 💡 Notas Importantes

1. **Dependência**: O toggle "Sons de Notificação" só funciona se "Notificações Push" estiver ativado
2. **Persistência**: A preferência é salva no Supabase automaticamente
3. **Padrão**: Por padrão, o som está **desativado** (`notification_sounds: false`)
4. **Web Only**: O controle de `silent` só afeta notificações Web
5. **Permissões**: O usuário precisa aceitar permissões do navegador

## 🔮 Melhorias Futuras

Possíveis melhorias que podem ser implementadas:

- [ ] Sons customizados diferentes por tipo de notificação
- [ ] Volume ajustável
- [ ] Preview do som nas configurações
- [ ] Controle de som também para Mobile (via canais de notificação)
- [ ] Modo "Não Perturbe" com horários programados

## 📚 Referências

- [Web Notifications API - MDN](https://developer.mozilla.org/en-US/docs/Web/API/Notifications_API)
- [NotificationOptions.silent - MDN](https://developer.mozilla.org/en-US/docs/Web/API/Notification/silent)
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)

---

**Implementado por**: Cline AI Assistant  
**Data**: 23/02/2026  
**Versão**: 1.0.0
