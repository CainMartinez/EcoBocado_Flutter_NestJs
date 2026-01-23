import 'package:flutter/material.dart';

/// Badge para mostrar el estado de un pedido con colores apropiados
class OrderStatusBadge extends StatelessWidget {
  final String status;

  const OrderStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final statusInfo = _getStatusInfo(status);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusInfo.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusInfo.icon,
            size: 14,
            color: statusInfo.textColor,
          ),
          const SizedBox(width: 4),
          Text(
            statusInfo.label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: statusInfo.textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  _StatusInfo _getStatusInfo(String status) {
    switch (status) {
      case 'pending_payment':
        return _StatusInfo(
          label: 'Pendiente Pago',
          backgroundColor: Colors.orange.shade100,
          textColor: Colors.orange.shade900,
          icon: Icons.payment,
        );
      case 'confirmed':
        return _StatusInfo(
          label: 'Confirmado',
          backgroundColor: Colors.orange.shade100,
          textColor: Colors.orange.shade900,
          icon: Icons.check_circle,
        );
      case 'prepared':
        return _StatusInfo(
          label: 'Preparado',
          backgroundColor: Colors.purple.shade100,
          textColor: Colors.purple.shade900,
          icon: Icons.restaurant,
        );
      case 'delivered':
        return _StatusInfo(
          label: 'Enviado',
          backgroundColor: Colors.blue.shade100,
          textColor: Colors.blue.shade900,
          icon: Icons.local_shipping,
        );
      case 'completed':
        return _StatusInfo(
          label: 'Completado',
          backgroundColor: Colors.green.shade100,
          textColor: Colors.green.shade900,
          icon: Icons.done_all,
        );
      case 'cancelled':
        return _StatusInfo(
          label: 'Cancelado',
          backgroundColor: Colors.red.shade100,
          textColor: Colors.red.shade900,
          icon: Icons.cancel,
        );
      case 'draft':
        return _StatusInfo(
          label: 'Borrador',
          backgroundColor: Colors.grey.shade100,
          textColor: Colors.grey.shade900,
          icon: Icons.edit,
        );
      default:
        return _StatusInfo(
          label: 'Desconocido',
          backgroundColor: Colors.grey.shade100,
          textColor: Colors.grey.shade900,
          icon: Icons.info,
        );
    }
  }
}

class _StatusInfo {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final IconData icon;

  _StatusInfo({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.icon,
  });
}
