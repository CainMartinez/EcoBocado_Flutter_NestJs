import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eco_bocado/features/profile/presentation/providers/profile_provider.dart';
import 'package:eco_bocado/features/profile/presentation/widgets/profile_avatar.dart';

/// Widget para el avatar del perfil con botón para cambiar foto
class EditableProfileAvatar extends ConsumerWidget {
  final String? avatarUrl;
  final String name;
  final double radius;

  const EditableProfileAvatar({
    super.key,
    required this.avatarUrl,
    required this.name,
    this.radius = 60,
  });

  Future<void> _pickAndUploadImage(BuildContext context, WidgetRef ref) async {
    final ImagePicker picker = ImagePicker();
    
    // Mostrar diálogo para elegir entre cámara o galería
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Seleccionar foto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galería'),
              onTap: () => Navigator.of(dialogContext).pop(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Cámara'),
              onTap: () => Navigator.of(dialogContext).pop(ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source == null || !context.mounted) return;

    // Seleccionar imagen
    final XFile? image = await picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (image == null || !context.mounted) return;

    // Guardar el messenger antes de operaciones async
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      // Subir imagen (sin loading dialog para evitar problemas con GoRouter)
      await ref.read(profileProvider.notifier).uploadAvatar(image.path);
      
      // Mostrar mensaje de éxito
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('✅ Foto de perfil actualizada'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Mostrar error
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('❌ Error al subir foto: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        ProfileAvatar(
          avatarUrl: avatarUrl,
          name: name,
          radius: radius,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Theme.of(context).primaryColor,
            child: IconButton(
              icon: const Icon(
                Icons.camera_alt,
                size: 18,
                color: Colors.white,
              ),
              onPressed: () => _pickAndUploadImage(context, ref),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }
}
