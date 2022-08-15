import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:manager/models/queue_item.dart';
import 'package:manager/services/ocb.dart';

class VisionWidget extends StatefulWidget {
  const VisionWidget({Key? key}) : super(key: key);

  @override
  State<VisionWidget> createState() => _VisionWidgetState();
}

class _VisionWidgetState extends State<VisionWidget> {
  late TextEditingController _programEdit;
  late TextEditingController _nameEdit;
  late TextEditingController _countEdit;

  final OCB _ocb = OCB();

  List<QueueItem> items = [];

  @override
  void initState() {
    super.initState();

    _programEdit = TextEditingController();
    _nameEdit = TextEditingController();
    _countEdit = TextEditingController();

    _loadItems();
  }

  @override
  void dispose() {
    super.dispose();
    _countEdit.dispose();
    _nameEdit.dispose();
    _programEdit.dispose();
  }

  void _loadItems() {
    _ocb.listEntitiesWithType(QueueItem.type).then((value) {
      List<QueueItem> newItems = [];

      for (var element in value) {
        newItems.add(QueueItem.fromNGSI(element));
      }

      setState(() {
        items = newItems;
      });
    });
  }

  void _addQueueItem() async {
    final item = QueueItem(
      name: _nameEdit.text,
      programName: _programEdit.text,
      count: int.parse(_countEdit.text),
    );

    final result = await _ocb.createEntity(item.toNGSI());

    if (result) {
      log("Successfully created item");
      _loadItems();
    } else {
      log("Error while creating item");
    }
  }

  void _deleteQueueItem(int index) async {
    final item = items[index];

    final success = await _ocb.deleteEntity(item.toNGSI());

    if (success) {
      log("Successfully deleted item");
      _loadItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: const Text("Editor"),
          actions: [
            SizedBox(
              width: 600,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _programEdit,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Program name',
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _nameEdit,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Part name',
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextField(
                        controller: _countEdit,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Count',
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: _addQueueItem,
                        child: const Text('Add'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          automaticallyImplyLeading: false,
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: items.length,
            itemBuilder: ((BuildContext context, int index) {
              return SizedBox(
                height: 100,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Name: ${items[index].name}',
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Program name: ${items[index].programName}',
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Count: ${items[index].count}',
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Remaining: ${items[index].remaining}',
                          ),
                        ),
                        IconButton(
                          onPressed: () => _deleteQueueItem(index),
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
