import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler); // Register the background message handler
    _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    // Get the FCM token
    final fcmToken = await _firebaseMessaging.getToken();
    print("FCM Token: $fcmToken");

    // Handle the initial notification when the app is opened from a terminated state
    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      handleForegroundMessage(initialMessage);
    }

    // Listen for incoming messages when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground Message Received");
      handleForegroundMessage(message);
    });

    // Listen for notification tap events when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Background Message Received");
      handleForegroundMessage(message);
    });
  }

  // Handle background messages
  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print('Background Message Received');
  }

  // Handle foreground messages
  void handleForegroundMessage(RemoteMessage message) {
    print('Foreground Message Received');
    print('Notification Title: ${message.notification?.title}');
    print('Notification Body: ${message.notification?.body}');
  }
}
