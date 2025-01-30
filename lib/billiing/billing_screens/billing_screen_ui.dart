import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:super_market_billing_app/billiing/add_item_provider/provider.dart';

import '../../product/product_ui/product_list_screen_ui.dart';
import '../../utils/utils.dart';
import '../add_item_provider/add_item_provider.dart';

class BillingScreen extends ConsumerStatefulWidget {
  const BillingScreen({super.key});

  @override
  ConsumerState<BillingScreen> createState() => BillingScreen1State();
}

class BillingScreen1State extends ConsumerState<BillingScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  double _price = 0.0;
  int _quantity = 1;
  double discount = 20.0;
  double tax = 18.0;

  @override
  Widget build(BuildContext context) {
    final addItemWatch = ref.watch(addItemNotifier);
    final addItemsRead = ref.read(addItemNotifier.notifier);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Supermarket Billing System'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Product',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                    label: 'Product Name',
                    onSaved: (value) => _name = value!,
                    validator: (value) =>
                        value!.isEmpty ? 'Enter a name of the product' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Price',
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _price = double.parse(value!),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter a price' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Quantity',
                    keyboardType: TextInputType.number,
                    initialValue: '1',
                    onSaved: (value) => _quantity = int.parse(value!),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter quantity of an item' : null,
                  ),
                  const SizedBox(height: 30),
                  _buildAddItemButton(addItemsRead),
                ],
              ),
            ),

            /// List of Item that user has added
            const ProductListScreenUI(),
            const SizedBox(height: 20),
            _buildDiscountAndTaxInfo(),
            const SizedBox(height: 30),
            _buildTotal(addItemWatch),
            const SizedBox(height: 30),
            _buildGenerateBillButton(addItemWatch),
          ],
        ),
      ),
    );
  }

  // Helper method for text fields
  Widget _buildTextField({
    required String label,
    TextInputType keyboardType = TextInputType.text,
    String? initialValue,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      ),
      keyboardType: keyboardType,
      initialValue: initialValue,
      onSaved: onSaved,
      validator: validator,
    );
  }

  // Add Item button
  Widget _buildAddItemButton(AddItemNotifier addItemsRead) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            addItemsRead.addItem({
              'name': _name,
              'price': _price,
              'quantity': _quantity,
            });
          }
        },
        child: const Text(
          'Add Item',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Discount and Tax Details to show in the ui
  Widget _buildDiscountAndTaxInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Discount (%): $discount',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.blueAccent,
            )),
        const SizedBox(height: 10),
        Text('Tax (%): $tax',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.blueAccent,
            )),
      ],
    );
  }

  // Total amount display in UI
  Widget _buildTotal(List<Map<String, dynamic>> items) {
    return Text(
      'Total: \$${calculateTotal(items, discount, tax).toStringAsFixed(2)}',
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
    );
  }

  // Button to generate a PDF
  Widget _buildGenerateBillButton(List<Map<String, dynamic>> items) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () => generatePDF(items, discount, tax),
      child: const Text(
        'Generate Bill',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
