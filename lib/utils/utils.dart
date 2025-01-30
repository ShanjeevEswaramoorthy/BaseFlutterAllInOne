import 'package:pdf/widgets.dart' as pdfbuilder;
import 'package:printing/printing.dart';

/// To get the totla amount of the items
///
double calculateTotal(
    List<Map<String, dynamic>> items, double discount, double tax) {
  double subtotal =
      items.fold(0, (sum, item) => sum + item['price'] * item['quantity']);
  double discountAmount = subtotal * (discount / 100);
  double taxAmount = (subtotal - discountAmount) * (tax / 100);
  return subtotal - discountAmount + taxAmount;
}

/// To generate the PDF
///
Future<void> generatePDF(
    List<Map<String, dynamic>> items, double discount, double tax) async {
  final pdf = pdfbuilder.Document();
  pdf.addPage(
    pdfbuilder.Page(
      build: (context) => pdfbuilder.Column(
        crossAxisAlignment: pdfbuilder.CrossAxisAlignment.start,
        children: [
          pdfbuilder.Text('Product purchase Bill',
              style: const pdfbuilder.TextStyle(fontSize: 24)),
          pdfbuilder.Divider(),
          pdfbuilder.TableHelper.fromTextArray(
            headers: ['Name', 'Price', 'Quantity', 'Total'],
            data: items
                .map((item) => [
                      item['name'],
                      item['price'].toStringAsFixed(2),
                      item['quantity'],
                      (item['price'] * item['quantity']).toStringAsFixed(2)
                    ])
                .toList(),
          ),
          pdfbuilder.Divider(),
          pdfbuilder.Text(
              'Total: \$${calculateTotal(items, discount, tax).toStringAsFixed(2)}'),
        ],
      ),
    ),
  );

  /// To generate the printout of the PDF generated
  ///
  await Printing.layoutPdf(
      dynamicLayout: true, onLayout: (format) async => pdf.save());
}
