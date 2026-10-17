import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runway_finance/services/notification_service.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
