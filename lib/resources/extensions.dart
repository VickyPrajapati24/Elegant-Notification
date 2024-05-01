import 'package:elegant_notification/resources/colors.dart';
import 'package:flutter/material.dart';

enum NotificationType {
  success,
  error,
  info,
  custom,
}

extension NotificationTypeExtension on NotificationType {
  Color color() {
    switch (this) {
      case NotificationType.success:
        return successColor;
      case NotificationType.error:
        return errorColor;
      case NotificationType.info:
        return inforColor;
      default:
        return Colors.blue;
    }
  }
}
