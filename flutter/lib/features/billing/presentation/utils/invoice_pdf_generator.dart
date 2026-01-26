import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/billing_record.dart';

class InvoicePdfGenerator {
  /// Genera y muestra preview del PDF de la factura
  static Future<void> previewInvoice(BillingRecord record) async {
    final pdf = await _generatePdf(record);
    
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: _getFileName(record),
    );
  }

  /// Genera y comparte/descarga el PDF de la factura
  static Future<void> shareInvoice(BillingRecord record) async {
    final pdf = await _generatePdf(record);
    
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: _getFileName(record),
    );
  }

  static String _getFileName(BillingRecord record) {
    final number = record.number.isNotEmpty 
        ? record.number.replaceAll(' ', '_') 
        : 'factura_${record.id}';
    return '$number.pdf';
  }

  static Future<pw.Document> _generatePdf(BillingRecord record) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header con título
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'FACTURA',
                        style: pw.TextStyle(
                          fontSize: 32,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.green700,
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        record.number.isNotEmpty 
                            ? record.number 
                            : 'N\u00BA ${record.id}',
                        style: pw.TextStyle(
                          fontSize: 16,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'EcoBocado',
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        'CIF: B-12345678',
                        style: const pw.TextStyle(
                          fontSize: 11,
                          color: PdfColors.grey600,
                        ),
                      ),
                      pw.Text(
                        'C/ Ejemplo, 123',
                        style: const pw.TextStyle(
                          fontSize: 11,
                          color: PdfColors.grey600,
                        ),
                      ),
                      pw.Text(
                        '46000 Valencia',
                        style: const pw.TextStyle(
                          fontSize: 11,
                          color: PdfColors.grey600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              pw.SizedBox(height: 30),
              pw.Divider(thickness: 2),
              pw.SizedBox(height: 30),
              
              // Información del cliente
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'FACTURADO A:',
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.grey600,
                          ),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(
                          record.customerName,
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          record.customerEmail,
                          style: const pw.TextStyle(
                            fontSize: 11,
                            color: PdfColors.grey700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 40),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'DETALLES',
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.grey600,
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      _buildInfoRow('Pedido:', '#${record.orderId}'),
                      pw.SizedBox(height: 4),
                      _buildInfoRow(
                        'Creada:', 
                        dateFormat.format(record.createdAt),
                      ),
                      if (record.issuedAt != null) ...[
                        pw.SizedBox(height: 4),
                        _buildInfoRow(
                          'Emitida:', 
                          dateFormat.format(record.issuedAt!),
                        ),
                      ],
                      pw.SizedBox(height: 4),
                      _buildInfoRow(
                        'Estado:', 
                        _getStatusLabel(record.status),
                      ),
                    ],
                  ),
                ],
              ),
              
              pw.SizedBox(height: 40),
              
              // Línea de items (simulada, ya que no tenemos detalles)
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(vertical: 15),
                decoration: const pw.BoxDecoration(
                  border: pw.Border(
                    top: pw.BorderSide(color: PdfColors.grey300),
                    bottom: pw.BorderSide(color: PdfColors.grey300),
                  ),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                      child: pw.Text(
                        'DESCRIPCIÓN',
                        style: pw.TextStyle(
                          fontSize: 11,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.grey600,
                        ),
                      ),
                    ),
                    pw.Container(
                      width: 100,
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(
                        'IMPORTE',
                        style: pw.TextStyle(
                          fontSize: 11,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.grey600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              pw.SizedBox(height: 10),
              
              // Item del pedido
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Pedido #${record.orderId}',
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          'Servicios de restauraci\u00F3n',
                          style: const pw.TextStyle(
                            fontSize: 10,
                            color: PdfColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.Container(
                    width: 100,
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(
                      '${record.total.toStringAsFixed(2)} EUR',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              
              pw.Spacer(),
              
              // Resumen de totales
              pw.Container(
                alignment: pw.Alignment.centerRight,
                child: pw.Container(
                  width: 250,
                  child: pw.Column(
                    children: [
                      pw.Divider(),
                      pw.SizedBox(height: 10),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'TOTAL',
                            style: pw.TextStyle(
                              fontSize: 18,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            '${record.total.toStringAsFixed(2)} EUR',
                            style: pw.TextStyle(
                              fontSize: 24,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.green700,
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 10),
                      pw.Divider(thickness: 2),
                    ],
                  ),
                ),
              ),
              
              pw.SizedBox(height: 30),
              
              // Footer profesional
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      'EcoBocado S.L. - Servicios de Restauraci\u00F3n',
                      style: const pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'CIF: B-12345678 - Tel: +34 900 000 000',
                      style: const pw.TextStyle(
                        fontSize: 9,
                        color: PdfColors.grey600,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Factura v\u00E1lida sin firma ni sello conforme a legislaci\u00F3n vigente',
                      style: const pw.TextStyle(
                        fontSize: 8,
                        color: PdfColors.grey500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Text(
          '$label ',
          style: pw.TextStyle(
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.grey600,
          ),
        ),
        pw.Text(
          value,
          style: const pw.TextStyle(
            fontSize: 11,
            color: PdfColors.grey800,
          ),
        ),
      ],
    );
  }

  static String _getStatusLabel(String status) {
    switch (status) {
      case 'issued':
        return 'Emitida';
      case 'requested':
        return 'Solicitada';
      case 'cancelled':
        return 'Cancelada';
      default:
        return status;
    }
  }
}
