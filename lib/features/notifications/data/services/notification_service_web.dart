// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

void webRequestPermission() {
  if (html.Notification.permission == 'default') {
    html.Notification.requestPermission();
  }
}

void webShowNotification(String title, String body) {
  if (html.Notification.permission == 'granted') {
    html.Notification(title, body: body);
    
    // Tocar um som de "beep" na Web (usando Base64 para ser auto-contido)
    try {
      final audio = html.AudioElement();
      // Um beep curto em base64 (MP3 silencioso ou curto) 
      // para garantir que o mecanismo funcione sem arquivos externos
      audio.src = 'data:audio/wav;base64,UklGRl9vT19XQVZFZm10IBAAAAABAAEAQB8AAEAfAAABAAgAZGF0YTdvT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT18=';
      audio.play();
    } catch (_) {
      // Browsers podem bloquear o autoplay se não houver interação prévia
    }
  }
}
