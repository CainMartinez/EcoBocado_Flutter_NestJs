import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TemporaryAddressFormPage extends StatefulWidget {
  const TemporaryAddressFormPage({super.key});

  @override
  State<TemporaryAddressFormPage> createState() =>
      _TemporaryAddressFormPageState();
}

class _TemporaryAddressFormPageState extends State<TemporaryAddressFormPage> {
  final _formKey = GlobalKey<FormState>();
  
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateProvinceController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _countryController = TextEditingController(text: 'España');
  final _phoneController = TextEditingController();
  final _deliveryNotesController = TextEditingController();

  @override
  void dispose() {
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateProvinceController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    _phoneController.dispose();
    _deliveryNotesController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Retornar solo los datos de la dirección temporal (sin deliveryType)
      // El deliveryType se agregará en delivery_time_selection_page
      context.pop({
        'addressLine1': _addressLine1Controller.text.trim(),
        'addressLine2': _addressLine2Controller.text.trim().isEmpty
            ? null
            : _addressLine2Controller.text.trim(),
        'city': _cityController.text.trim(),
        'stateProvince': _stateProvinceController.text.trim().isEmpty
            ? null
            : _stateProvinceController.text.trim(),
        'postalCode': _postalCodeController.text.trim(),
        'country': _countryController.text.trim(),
        'deliveryPhone': _phoneController.text.trim(),
        'deliveryNotes': _deliveryNotesController.text.trim().isEmpty
            ? null
            : _deliveryNotesController.text.trim(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dirección de entrega'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Introduce la dirección para esta entrega',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            
            // Dirección línea 1
            TextFormField(
              controller: _addressLine1Controller,
              decoration: const InputDecoration(
                labelText: 'Dirección *',
                hintText: 'Calle y número',
                prefixIcon: Icon(Icons.home),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La dirección es obligatoria';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Dirección línea 2
            TextFormField(
              controller: _addressLine2Controller,
              decoration: const InputDecoration(
                labelText: 'Detalles (opcional)',
                hintText: 'Piso, puerta, portal...',
                prefixIcon: Icon(Icons.apartment),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            // Ciudad
            TextFormField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'Ciudad *',
                prefixIcon: Icon(Icons.location_city),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La ciudad es obligatoria';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                // Provincia/Estado
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
                
                // Código Postal
                Expanded(
                  child: TextFormField(
                    controller: _postalCodeController,
                    decoration: const InputDecoration(
                      labelText: 'C.P. *',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Requerido';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // País
            TextFormField(
              controller: _countryController,
              decoration: const InputDecoration(
                labelText: 'País *',
                prefixIcon: Icon(Icons.flag),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El país es obligatorio';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Teléfono
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Teléfono de contacto *',
                hintText: '+34 600 000 000',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El teléfono es obligatorio';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Notas de entrega
            TextFormField(
              controller: _deliveryNotesController,
              decoration: const InputDecoration(
                labelText: 'Notas para el repartidor (opcional)',
                hintText: 'Ej: Llamar al timbre, no hay ascensor...',
                prefixIcon: Icon(Icons.note),
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Confirmar dirección',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
