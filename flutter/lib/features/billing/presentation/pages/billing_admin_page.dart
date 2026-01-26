import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eco_bocado/core/l10n/app_localizations.dart';
import 'package:eco_bocado/features/billing/presentation/providers/billing_provider.dart';
import 'package:eco_bocado/features/billing/presentation/utils/invoice_pdf_generator.dart';
import 'package:intl/intl.dart';

class BillingAdminPage extends ConsumerWidget {
  const BillingAdminPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final billingRecordsAsync = ref.watch(billingRecordsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.billing),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(billingRecordsProvider);
            },
          ),
        ],
      ),
      body: billingRecordsAsync.when(
        data: (records) {
          if (records.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 64, color: cs.onSurfaceVariant),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noBillingRecords,
                    style: tt.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.billingRecordsWillAppearHere,
                    style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(billingRecordsProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: records.length,
              itemBuilder: (context, index) {
                final record = records[index];
                final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: _getStatusColor(record.status, cs),
                      child: Icon(
                        _getStatusIcon(record.status),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      record.number.isNotEmpty ? record.number : 'Factura #${record.id}',
                      style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${record.customerName} • ${_getStatusLabel(record.status, l10n)}',
                    ),
                    trailing: Text(
                      '${record.total.toStringAsFixed(2)} €',
                      style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.primary,
                      ),
                    ),
                    children: [
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow(
                              context,
                              icon: Icons.person,
                              label: l10n.customer,
                              value: record.customerName,
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              context,
                              icon: Icons.email,
                              label: l10n.email,
                              value: record.customerEmail,
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              context,
                              icon: Icons.shopping_cart,
                              label: l10n.order,
                              value: 'Pedido #${record.orderId}',
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              context,
                              icon: Icons.calendar_today,
                              label: l10n.createdAt,
                              value: dateFormat.format(record.createdAt),
                            ),
                            if (record.issuedAt != null) ...[
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                context,
                                icon: Icons.check_circle,
                                label: l10n.issuedAt,
                                value: dateFormat.format(record.issuedAt!),
                              ),
                            ],
                          ],
                        ),
                      ),                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () async {
                                try {
                                  await InvoicePdfGenerator.shareInvoice(record);
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error al descargar: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                              icon: const Icon(Icons.download),
                              label: const Text('Descargar PDF'),
                            ),
                            const SizedBox(width: 8),
                            FilledButton.icon(
                              onPressed: () async {
                                try {
                                  await InvoicePdfGenerator.previewInvoice(record);
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error al generar PDF: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                              icon: const Icon(Icons.picture_as_pdf),
                              label: const Text('Ver PDF'),
                            ),
                          ],
                        ),
                      ),                    ],
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: cs.error),
              const SizedBox(height: 16),
              Text(
                l10n.errorLoadingBillingRecords,
                style: tt.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: Text(l10n.retry),
                onPressed: () => ref.invalidate(billingRecordsProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: cs.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status, ColorScheme cs) {
    switch (status) {
      case 'issued':
        return Colors.green;
      case 'requested':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'issued':
        return Icons.check_circle;
      case 'requested':
        return Icons.pending;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.receipt;
    }
  }

  String _getStatusLabel(String status, AppLocalizations l10n) {
    switch (status) {
      case 'issued':
        return l10n.statusIssued;
      case 'requested':
        return l10n.statusRequested;
      case 'cancelled':
        return l10n.statusCancelled;
      default:
        return status;
    }
  }
}
