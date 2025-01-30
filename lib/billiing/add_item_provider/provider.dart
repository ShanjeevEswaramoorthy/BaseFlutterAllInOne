import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:super_market_billing_app/billiing/add_item_provider/add_item_provider.dart';

final addItemNotifier =
    StateNotifierProvider<AddItemNotifier, List<Map<String, dynamic>>>(
  (ref) => AddItemNotifier(),
);
