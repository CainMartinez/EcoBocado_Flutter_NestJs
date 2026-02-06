import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eco_bocado/core/l10n/app_localizations.dart';
import 'package:eco_bocado/features/profile/presentation/providers/profile_provider.dart';
import 'package:eco_bocado/core/widgets/app_text_field.dart';
import 'package:eco_bocado/core/widgets/app_form_submit.dart';

class UpdateProfilePage extends ConsumerStatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  ConsumerState<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends ConsumerState<UpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _phoneController;
  late TextEditingController _addressLine1Controller;
  late TextEditingController _addressLine2Controller;
  late TextEditingController _cityController;
  late TextEditingController _postalCodeController;
  late TextEditingController _countryCodeController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    final profile = ref.read(profileProvider).value;
    
    _phoneController = TextEditingController(text: profile?.phone ?? '');
    _addressLine1Controller = TextEditingController(text: profile?.addressLine1 ?? '');
    _addressLine2Controller = TextEditingController(text: profile?.addressLine2 ?? '');
    _cityController = TextEditingController(text: profile?.city ?? '');
    _postalCodeController = TextEditingController(text: profile?.postalCode ?? '');
    _countryCodeController = TextEditingController(text: profile?.countryCode ?? 'ES');
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _countryCodeController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(profileProvider.notifier).updateProfile(
            phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
            addressLine1: _addressLine1Controller.text.trim().isEmpty ? null : _addressLine1Controller.text.trim(),
            addressLine2: _addressLine2Controller.text.trim().isEmpty ? null : _addressLine2Controller.text.trim(),
            city: _cityController.text.trim().isEmpty ? null : _cityController.text.trim(),
            postalCode: _postalCodeController.text.trim().isEmpty ? null : _postalCodeController.text.trim(),
            countryCode: _countryCodeController.text.trim().isEmpty ? null : _countryCodeController.text.trim(),
          );

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.profileUpdatedSuccessfully),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorUpdatingProfile}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editProfile),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Teléfono
            AppTextField(
              controller: _phoneController,
              label: l10n.phone,
              hint: '+34 600 111 222',
              keyboardType: TextInputType.phone,
              prefixIcon: const Icon(Icons.phone),
            ),
            const SizedBox(height: 16),

            // Dirección línea 1
            AppTextField(
              controller: _addressLine1Controller,
              label: l10n.addressLine1,
              hint: 'C/ Principal 123',
              prefixIcon: const Icon(Icons.home),
            ),
            const SizedBox(height: 16),

            // Dirección línea 2
            AppTextField(
              controller: _addressLine2Controller,
              label: l10n.addressLine2,
              hint: 'Piso 2, puerta B',
              prefixIcon: const Icon(Icons.apartment),
            ),
            const SizedBox(height: 16),

            // Ciudad
            AppTextField(
              controller: _cityController,
              label: l10n.city,
              hint: 'Valencia',
              prefixIcon: const Icon(Icons.location_city),
            ),
            const SizedBox(height: 16),

            // Código Postal
            AppTextField(
              controller: _postalCodeController,
              label: l10n.postalCode,
              hint: '46870',
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.pin_drop),
            ),
            const SizedBox(height: 16),

            // Código de País
            AppTextField(
              controller: _countryCodeController,
              label: l10n.countryCode,
              hint: 'ES',
              textCapitalization: TextCapitalization.characters,
              prefixIcon: const Icon(Icons.flag),
            ),
            const SizedBox(height: 24),

            // Botón de guardar
            AppFormSubmit(
              isLoading: _isLoading,
              onPressed: _handleSubmit,
              label: l10n.saveChanges,
            ),
          ],
        ),
      ),
    );
  }
}
