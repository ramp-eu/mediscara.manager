import 'dart:developer';

import 'package:manager/models/ngsiv2.dart';
import 'package:uuid/uuid.dart';

class QueueItem {
  static const type = "ManufacturingQueueItem";

  late String id;
  String name;
  String programName;
  int count;
  late int remaining;

  QueueItem({
    required this.name,
    required this.programName,
    required this.count,
  }) {
    remaining = count;
    id = const Uuid().v1();
  }

  NGSI toNGSI() {
    NGSI ngsi = NGSI(id: id, type: QueueItem.type);
    ngsi.attrs = {
      'name': {
        'type': 'Text',
        'value': name,
      },
      'programName': {
        'type': 'Text',
        'value': programName,
      },
      'count': {
        'type': 'Number',
        'value': count,
      },
      'remaining': {
        'type': 'Number',
        'value': remaining,
      }
    };

    return ngsi;
  }

  static QueueItem fromNGSI(NGSI item) {
    final queueItem = QueueItem(
      name: item.attrs['name']['value'],
      programName: item.attrs['programName']['value'],
      count: item.attrs['count']['value'],
    );

    queueItem.remaining = item.attrs['remaining']['value'];
    queueItem.id = item.id;

    if (item.type != QueueItem.type) {
      log("Warning: type of item is not ${QueueItem.type} (${item.type})");
    }

    return queueItem;
  }
}
