class NGSI {
  String id;
  String type;

  Map<String, dynamic> attrs = {};

  NGSI({required this.id, required this.type});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      ...attrs,
    };
  }

  @override
  String toString() {
    return '''id: $id
    type: $type
    attrs: ${attrs.toString()}''';
  }

  /// Creates a NGSIv2 object from a map
  static NGSI fromMap(Map<String, dynamic> map) {
    String id = "";
    String type = "";
    Map<String, dynamic> attrs = {};

    map.forEach((key, value) {
      switch (key) {
        case 'id':
          {
            id = value;
          }
          break;

        case 'type':
          {
            type = value;
          }
          break;

        default:
          {
            // append the value map to the attributes
            attrs[key] = value;
          }
      }
    });

    final ngsi = NGSI(id: id, type: type);
    ngsi.attrs = attrs;

    return ngsi;
  }
}
