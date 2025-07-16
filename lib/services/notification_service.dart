import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // ✅ Solicitar permisos para notificaciones (en Android no hace nada visible)
    await _messaging.requestPermission();

    // ✅ Obtener y mostrar el token del dispositivo
    final token = await _messaging.getToken();
    print('📱 FCM Token: $token');

    // ✅ Crear canal de notificaciones para Android
    const androidChannel = AndroidNotificationChannel(
      'default_channel',
      'Notificaciones',
      description: 'Canal por defecto para notificaciones importantes',
      importance: Importance.max,
    );

    // ✅ Inicializar configuración para notificaciones locales
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    final initSettings = InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(initSettings);

    // ✅ Crear canal en el sistema Android
    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    // ✅ Escuchar notificaciones cuando la app está en primer plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      final android = message.notification?.android;

      print("📩 Notificación recibida:");
      print("🔹 Título: ${notification?.title}");
      print("🔹 Cuerpo: ${notification?.body}");

      // ✅ Mostrar notificación local si hay contenido y es Android
      if (notification != null && android != null) {
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              androidChannel.id,
              androidChannel.name,
              channelDescription: androidChannel.description,
              icon: '@mipmap/ic_launcher',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
        );
      }
    });
  }
}
