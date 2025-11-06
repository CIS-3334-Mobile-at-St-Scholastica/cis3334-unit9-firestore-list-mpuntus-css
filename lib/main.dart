import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore List',
      theme: ThemeData(colorSchemeSeed: const Color(0xFF2962FF)),
      home: const ItemListApp(),
    );
  }
}

class ItemListApp extends StatefulWidget {
  const ItemListApp({super.key});

  @override
  State<ItemListApp> createState() => _ItemListAppState();
}

class _ItemListAppState extends State<ItemListApp> {
  // Controller for the input field
  final TextEditingController _newItemTextField = TextEditingController();

  // Local list of items (Phase 1: local; Phase 2: Firestore stream replaces this).
  final List<String> _itemList = <String>[];

  // ACTION: add one item from the TextField to the local list.
  void _addItem() {
    final newItem = _newItemTextField.text.trim();
    if (newItem.isEmpty) return;
    setState(() {
      _itemList.add(newItem);
      _newItemTextField.clear();
    });
  }

  // ACTION: remove the item at the given index.
  void _removeItemAt(int i) {
    setState(() {
      _itemList.removeAt(i); // remove item from list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firestore List Demo')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Column(
          children: [
            // ====== Item Input  ======
            Row(
              children: [
                // ====== Item Name TextField ======
                Expanded(
                  child: TextField(
                    controller: _newItemTextField,
                    onSubmitted: (_) => _addItem(),
                    decoration: const InputDecoration(
                      labelText: 'New Item Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                // ====== Spacer for formating ======
                const SizedBox(width: 12),
                // ====== Add Item Button ======
                FilledButton(onPressed: _addItem, child: const Text('Add')),
              ],
            ),
            // ====== Spacer for formating ======
            const SizedBox(height: 24),
            Expanded(
              // ====== Item List ======
              child: ListView.builder(
                itemCount: _itemList.length,
                itemBuilder: (context, i) => Dismissible(
                  key: ValueKey(_itemList[i]),
                  background: Container(color: Colors.red),
                  onDismissed: (_) => _removeItemAt(i),
                  // ====== Item Tile ======
                  child: ListTile(
                    leading: const Icon(Icons.check_box),
                    title: Text(_itemList[i]),
                    onTap: () => _removeItemAt(i),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
