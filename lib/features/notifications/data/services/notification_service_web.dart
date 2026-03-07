import 'package:web/web.dart' as web;

void webRequestPermission() {
  if (web.Notification.permission == 'default') {
    web.Notification.requestPermission();
  }
}

void webShowNotification(String title, String body) {
  if (web.Notification.permission == 'granted') {
    web.Notification(title, web.NotificationOptions(body: body));
    
    try {
      final audio = web.HTMLAudioElement();
      audio.src = 'data:audio/wav;base64,UklGRl9vT19XQVZFZm10IBAAAAABAAEAQB8AAEAfAAABAAgAZGF0YTdvT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT19vT18=';
      audio.play();
    } catch (_) {
    }
  }
}
