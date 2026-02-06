import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eco_bocado/features/loyalty/presentation/providers/loyalty_provider.dart';
import 'package:eco_bocado/features/loyalty/presentation/screens/loyalty_screen.dart';

class LoyaltyProgressCard extends ConsumerWidget {
  const LoyaltyProgressCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final loyaltyAccountAsync = ref.watch(loyaltyAccountProvider);

    return loyaltyAccountAsync.when(
      data: (account) => Card(
        elevation: 4,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const LoyaltyScreen(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.primary.withValues(alpha: 0.1),
                  colorScheme.primaryContainer.withValues(alpha: 0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.card_giftcard,
                      color: colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '🎁 Programa de Fidelidad',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            account.hasAvailableReward
                                ? '¡Tienes una recompensa disponible!'
                                : '${account.purchasesCount}/10 compras',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: account.hasAvailableReward
                                  ? Colors.green[700]
                                  : colorScheme.onSurfaceVariant,
                              fontWeight: account.hasAvailableReward
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (account.hasAvailableReward)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '¡CANJEAR!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      )
                    else
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: colorScheme.onSurfaceVariant,
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                // Barra de progreso
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: account.hasAvailableReward ? 1.0 : (account.purchasesCount % 10) / 10,
                        minHeight: 8,
                        backgroundColor: colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          account.hasAvailableReward
                              ? Colors.green
                              : colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      account.hasAvailableReward
                          ? '¡Menú gratis disponible!'
                          : 'Faltan ${account.purchasesUntilReward} compras',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      loading: () => Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 12),
              Text(
                'Cargando fidelidad...',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
      error: (error, stack) {
        // Mostrar un mensaje de error más visible para debug
        return Card(
          elevation: 2,
          color: Colors.red.shade50,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Error al cargar fidelidad',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.red.shade600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
