import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../profile/domain/entities/user_address.dart';
import '../../../profile/presentation/providers/user_addresses_provider.dart';

class DeliveryAddressSelectionPage extends ConsumerWidget {
  const DeliveryAddressSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressesAsync = ref.watch(userAddressesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dirección de entrega'),
        elevation: 0,
      ),
      body: addressesAsync.when(
        data: (addresses) {
          if (addresses.isEmpty) {
            return _EmptyAddressesView(
              onAddNewAddress: () {
                context.push('/delivery-time-selection', extra: {
                  'isTemporary': true,
                }).then((result) {
                  if (result != null && context.mounted) {
                    context.pop(result);
                  }
                });
              },
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: addresses.length,
                  itemBuilder: (context, index) {
                    final address = addresses[index];
                    return _AddressCard(
                      address: address,
                      onTap: () {
                        // Ir a selección de fecha y hora de entrega
                        context.push('/delivery-time-selection', extra: {
                          'userAddressId': address.id,
                        }).then((result) {
                          if (result != null && context.mounted) {
                            context.pop(result);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        context.push('/user-addresses-management');
                      },
                      icon: const Icon(Icons.edit_location),
                      label: const Text('Gestionar direcciones guardadas'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.push('/delivery-time-selection', extra: {
                          'isTemporary': true,
                        }).then((result) {
                          if (result != null && context.mounted) {
                            context.pop(result);
                          }
                        });
                      },
                      icon: const Icon(Icons.add_location_alt),
                      label: const Text('Usar dirección temporal'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error al cargar direcciones: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(userAddressesProvider.notifier).refresh();
                },
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final UserAddress address;
  final VoidCallback onTap;

  const _AddressCard({
    required this.address,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: address.isDefault
            ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      address.label,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  if (address.isDefault)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Predeterminada',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                address.fullAddress,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
              if (address.phone != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      address.phone!,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyAddressesView extends StatelessWidget {
  final VoidCallback onAddNewAddress;

  const _EmptyAddressesView({required this.onAddNewAddress});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'No tienes direcciones guardadas',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Añade una dirección para recibir tus pedidos',
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onAddNewAddress,
              icon: const Icon(Icons.add_location_alt),
              label: const Text('Añadir dirección temporal'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
