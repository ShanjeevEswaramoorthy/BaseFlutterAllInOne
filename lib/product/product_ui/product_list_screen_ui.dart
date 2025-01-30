import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:super_market_billing_app/billiing/add_item_provider/provider.dart';

class ProductListScreenUI extends ConsumerWidget {
  const ProductListScreenUI({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addItemWatch = ref.watch(addItemNotifier);
    return Expanded(
      child: ListView.builder(
        itemCount: addItemWatch.length,
        itemBuilder: (context, index) {
          final addItem = addItemWatch[index];
          return ListTile(
            title: Text(addItem['name']),
            subtitle:
                Text('Price: \$${addItem['price']} x ${addItem['quantity']}'),
            trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  ref.read(addItemNotifier.notifier).removeItem(index);
                }),
          );
        },
      ),
    );
  }
}
