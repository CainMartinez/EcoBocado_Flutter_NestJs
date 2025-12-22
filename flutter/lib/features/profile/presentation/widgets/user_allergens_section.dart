import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_allergens_provider.dart';
import '../../../shop/presentation/providers/allergens_provider.dart';

/// Sección destacada de alérgenos en el perfil del usuario
/// VALOR AÑADIDO PRINCIPAL DE LA APLICACIÓN
class UserAllergensSection extends ConsumerWidget {
  const UserAllergensSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAllergensAsync = ref.watch(userAllergensProvider);
    final allergensAsync = ref.watch(allergensProvider);

    return Card(
      elevation: 8,
      color: Colors.orange.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.orange.shade300, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con icono y título destacado
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.health_and_safety,
                    color: Colors.orange.shade800,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🌟 Protección Personalizada',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade900,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tus alergias, siempre protegidas',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.orange.shade700,
                            ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle, color: Colors.orange.shade700, size: 32),
                  onPressed: () => _showAllergenSelector(context, ref),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Descripción del valor añadido
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Los productos automáticamente se filtrarán para evitar tus alérgenos',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade700,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Lista de alérgenos del usuario
            userAllergensAsync.when(
              data: (allergenCodes) {
                if (allergenCodes.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_circle_outline, size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 8),
                        Text(
                          'Aún no has agregado alérgenos',
                          style: TextStyle(color: Colors.grey.shade600),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Toca el botón + para empezar',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return allergensAsync.when(
                  data: (allAllergens) {
                    final userAllergenNames = allergenCodes
                        .map((code) => allAllergens.firstWhere(
                              (a) => a.code == code,
                              orElse: () => allAllergens.first,
                            ).name)
                        .toList();

                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: allergenCodes.asMap().entries.map((entry) {
                        final allergenCode = entry.value;
                        final allergenName = userAllergenNames[entry.key];

                        return Chip(
                          avatar: CircleAvatar(
                            backgroundColor: Colors.red.shade100,
                            child: Icon(Icons.cancel, size: 16, color: Colors.red.shade700),
                          ),
                          label: Text(
                            allergenName,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          backgroundColor: Colors.white,
                          deleteIcon: Icon(Icons.close, size: 18, color: Colors.red.shade700),
                          onDeleted: () => _removeAllergen(context, ref, allergenCode, allergenName),
                          elevation: 2,
                        );
                      }).toList(),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) {
                    return Text(
                      'Error cargando alérgenos: ${error.toString()}',
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, _) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Error: $error',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAllergenSelector(BuildContext context, WidgetRef ref) async {
    final allergensAsync = ref.read(allergensProvider);
    final userAllergensAsync = ref.read(userAllergensProvider);

    if (!allergensAsync.hasValue || !userAllergensAsync.hasValue) {
      if (allergensAsync.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error cargando alérgenos: ${allergensAsync.error}')),
        );
      }
      if (userAllergensAsync.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error cargando tus alérgenos: ${userAllergensAsync.error}')),
        );
      }
      return;
    }

    final allAllergens = allergensAsync.value!;
    final userAllergenCodes = userAllergensAsync.value!;

    // Filtrar los alérgenos que el usuario ya tiene
    final availableAllergens = allAllergens
        .where((allergen) => !userAllergenCodes.contains(allergen.code))
        .toList();

    if (availableAllergens.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ya has agregado todos los alérgenos disponibles')),
      );
      return;
    }

    final selected = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.health_and_safety, color: Colors.orange),
              SizedBox(width: 8),
              Text('Agregar Alérgeno'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: availableAllergens.map((allergen) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.orange.shade100,
                    child: Icon(Icons.warning, color: Colors.orange.shade700, size: 20),
                  ),
                  title: Text(allergen.name),
                  trailing: const Icon(Icons.add_circle_outline, color: Colors.orange),
                  onTap: () => Navigator.of(context).pop(allergen.code),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );

    if (selected != null && context.mounted) {
      final success = await ref.read(userAllergensProvider.notifier).addAllergen(selected);
      
      if (success && context.mounted) {
        final allergenName = allAllergens.firstWhere((a) => a.code == selected).name;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✓ $allergenName agregado a tu perfil de protección'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al agregar el alérgeno'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _removeAllergen(BuildContext context, WidgetRef ref, String allergenCode, String allergenName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text('¿Quieres eliminar "$allergenName" de tu perfil de protección?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      final success = await ref.read(userAllergensProvider.notifier).removeAllergen(allergenCode);
      
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✓ $allergenName eliminado'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }
}
