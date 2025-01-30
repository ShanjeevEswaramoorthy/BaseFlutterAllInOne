import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddItemNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  AddItemNotifier() : super([]);

  // Add an item to the list
  void addItem(Map<String, dynamic> item) {
    state = [...state, item];
  }

  // Remove an item by index
  void removeItem(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i != index) state[i],
    ];
  }
}
