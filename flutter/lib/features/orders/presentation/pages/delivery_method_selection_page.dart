import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DeliveryMethodSelectionPage extends StatelessWidget {
  const DeliveryMethodSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Método de entrega'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Text(
              '¿Cómo quieres recibir tu pedido?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _DeliveryMethodCard(
              icon: Icons.store,
              title: 'Recoger en tienda',
              subtitle: 'Elige fecha y hora de recogida',
              onTap: () async {
                final result = await context.push('/pickup-selection');
                if (result != null && context.mounted) {
                  context.pop(result);
                }
              },
            ),
            const SizedBox(height: 16),
            _DeliveryMethodCard(
              icon: Icons.delivery_dining,
              title: 'Entrega a domicilio',
              subtitle: 'Te lo llevamos donde quieras',
              onTap: () async {
                final result = await context.push('/delivery-address-selection');
                if (result != null && context.mounted) {
                  context.pop(result);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DeliveryMethodCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DeliveryMethodCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha :0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
