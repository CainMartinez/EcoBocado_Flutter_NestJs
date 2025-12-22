import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_address.dart';
import '../../data/dtos/user_address_dto.dart';
import '../providers/user_addresses_provider.dart';

class UserAddressesManagementPage extends ConsumerWidget {
  const UserAddressesManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressesAsync = ref.watch(userAddressesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis direcciones'),
        elevation: 0,
      ),
      body: addressesAsync.when(
        data: (addresses) {
          if (addresses.isEmpty) {
            return _EmptyState(
              onAddAddress: () => _showAddAddressDialog(context, ref),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final address = addresses[index];
              return _AddressManagementCard(
                address: address,
                onEdit: () => _showEditAddressDialog(context, ref, address),
                onDelete: () => _confirmDelete(context, ref, address),
                onSetDefault: () => _setAsDefault(context, ref, address),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _ErrorState(
          error: error.toString(),
          onRetry: () => ref.read(userAddressesProvider.notifier).refresh(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddAddressDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Nueva dirección'),
      ),
    );
  }

  void _showAddAddressDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _AddressFormSheet(
        onSave: (dto) async {
          final notifier = ref.read(userAddressesProvider.notifier);
          final result = await notifier.createAddress(dto);
          if (result != null && context.mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Dirección guardada correctamente')),
            );
          }
        },
      ),
    );
  }

  void _showEditAddressDialog(
      BuildContext context, WidgetRef ref, UserAddress address) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _AddressFormSheet(
        address: address,
        onSave: (dto) async {
          final notifier = ref.read(userAddressesProvider.notifier);
          final success = await notifier.updateAddress(address.id, dto);
          if (success && context.mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Dirección actualizada')),
            );
          }
        },
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, WidgetRef ref, UserAddress address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar dirección'),
        content: Text('¿Estás seguro de eliminar "${address.label}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final notifier = ref.read(userAddressesProvider.notifier);
              final success = await notifier.deleteAddress(address.id);
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Dirección eliminada')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _setAsDefault(
      BuildContext context, WidgetRef ref, UserAddress address) async {
    final notifier = ref.read(userAddressesProvider.notifier);
    final success = await notifier.setAsDefault(address.id);
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dirección predeterminada actualizada')),
      );
    }
  }
}

class _AddressManagementCard extends StatelessWidget {
  final UserAddress address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const _AddressManagementCard({
    required this.address,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
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
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!address.isDefault)
                  TextButton.icon(
                    onPressed: onSetDefault,
                    icon: const Icon(Icons.star_border, size: 18),
                    label: const Text('Predeterminar'),
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Editar'),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, size: 18),
                  label: const Text('Eliminar'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressFormSheet extends StatefulWidget {
  final UserAddress? address;
  final Function(dynamic) onSave;

  const _AddressFormSheet({
    this.address,
    required this.onSave,
  });

  @override
  State<_AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends State<_AddressFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _labelController;
  late TextEditingController _addressLine1Controller;
  late TextEditingController _addressLine2Controller;
  late TextEditingController _cityController;
  late TextEditingController _stateProvinceController;
  late TextEditingController _postalCodeController;
  late TextEditingController _countryController;
  late TextEditingController _phoneController;
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    final address = widget.address;
    _labelController = TextEditingController(text: address?.label ?? '');
    _addressLine1Controller =
        TextEditingController(text: address?.addressLine1 ?? '');
    _addressLine2Controller =
        TextEditingController(text: address?.addressLine2 ?? '');
    _cityController = TextEditingController(text: address?.city ?? '');
    _stateProvinceController =
        TextEditingController(text: address?.stateProvince ?? '');
    _postalCodeController =
        TextEditingController(text: address?.postalCode ?? '');
    _countryController =
        TextEditingController(text: address?.country ?? 'España');
    _phoneController = TextEditingController(text: address?.phone ?? '');
    _isDefault = address?.isDefault ?? false;
  }

  @override
  void dispose() {
    _labelController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateProvinceController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final dto = widget.address == null
          ? CreateUserAddressDto(
              label: _labelController.text.trim(),
              addressLine1: _addressLine1Controller.text.trim(),
              addressLine2: _addressLine2Controller.text.trim().isEmpty
                  ? null
                  : _addressLine2Controller.text.trim(),
              city: _cityController.text.trim(),
              stateProvince: _stateProvinceController.text.trim().isEmpty
                  ? null
                  : _stateProvinceController.text.trim(),
              postalCode: _postalCodeController.text.trim(),
              country: _countryController.text.trim(),
              phone: _phoneController.text.trim().isEmpty
                  ? null
                  : _phoneController.text.trim(),
              isDefault: _isDefault,
            )
          : UpdateUserAddressDto(
              label: _labelController.text.trim(),
              addressLine1: _addressLine1Controller.text.trim(),
              addressLine2: _addressLine2Controller.text.trim().isEmpty
                  ? null
                  : _addressLine2Controller.text.trim(),
              city: _cityController.text.trim(),
              stateProvince: _stateProvinceController.text.trim().isEmpty
                  ? null
                  : _stateProvinceController.text.trim(),
              postalCode: _postalCodeController.text.trim(),
              country: _countryController.text.trim(),
              phone: _phoneController.text.trim().isEmpty
                  ? null
                  : _phoneController.text.trim(),
            );

      widget.onSave(dto);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.address == null
                      ? 'Nueva dirección'
                      : 'Editar dirección',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _labelController,
                  decoration: const InputDecoration(
                    labelText: 'Etiqueta *',
                    hintText: 'Casa, Oficina, etc.',
                    prefixIcon: Icon(Icons.label),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v?.trim().isEmpty ?? true ? 'Requerido' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _addressLine1Controller,
                  decoration: const InputDecoration(
                    labelText: 'Dirección *',
                    hintText: 'Calle y número',
                    prefixIcon: Icon(Icons.home),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v?.trim().isEmpty ?? true ? 'Requerido' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _addressLine2Controller,
                  decoration: const InputDecoration(
                    labelText: 'Detalles',
                    hintText: 'Piso, puerta...',
                    prefixIcon: Icon(Icons.apartment),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'Ciudad *',
                    prefixIcon: Icon(Icons.location_city),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v?.trim().isEmpty ?? true ? 'Requerido' : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _stateProvinceController,
                        decoration: const InputDecoration(
                          labelText: 'Provincia',
                          prefixIcon: Icon(Icons.map),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _postalCodeController,
                        decoration: const InputDecoration(
                          labelText: 'C.P. *',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) => v?.trim().isEmpty ?? true ? 'Requerido' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _countryController,
                  decoration: const InputDecoration(
                    labelText: 'País *',
                    prefixIcon: Icon(Icons.flag),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v?.trim().isEmpty ?? true ? 'Requerido' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                if (widget.address == null) ...[
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    value: _isDefault,
                    onChanged: (value) => setState(() => _isDefault = value ?? false),
                    title: const Text('Establecer como predeterminada'),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ],
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(widget.address == null ? 'Guardar' : 'Actualizar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAddAddress;

  const _EmptyState({required this.onAddAddress});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              'No tienes direcciones guardadas',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Añade direcciones para usarlas en tus pedidos',
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onAddAddress,
              icon: const Icon(Icons.add),
              label: const Text('Añadir primera dirección'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorState({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error: $error'),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Reintentar')),
        ],
      ),
    );
  }
}
