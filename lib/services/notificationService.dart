import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class NotificationService {
  void showNotification({
    required BuildContext context,
    required String message,
    ToastificationType type = ToastificationType.info,
    Duration duration = const Duration(seconds: 4),
  }) {
    toastification.show(
      context: context,
      type: type,
      alignment: Alignment.topRight,
      title: Text(message),
      icon: _getIconByType(type),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
      autoCloseDuration: duration,
    );
  }

  // Función privada para obtener el ícono según el tipo de notificación
  Icon _getIconByType(ToastificationType type) {
    switch (type) {
      case ToastificationType.success:
        return const Icon(Icons.check_circle, color: Colors.green);
      case ToastificationType.error:
        return const Icon(Icons.error, color: Colors.red);
      case ToastificationType.warning:
        return const Icon(Icons.warning, color: Colors.orange);
      default:
        return const Icon(Icons.info, color: Colors.blue);
    }
  }
}
