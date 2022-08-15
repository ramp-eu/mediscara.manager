import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:manager/services/auth.dart';

import '../models/ngsiv2.dart';

class OCB {
  static OCB? _instance;

  final _ocbUrl = dotenv.env["OCB_URL"];

  OCB._() {
    log("A new Orion Context Broker connector has been created");
  }

  factory OCB() {
    return _instance ??= OCB._();
  }

  Future<bool> createEntity(NGSI item) async {
    final oauthToken = AuthService().oauth2Token ?? "";

    final headers = {
      "X-Auth-Token": oauthToken,
      "Content-Type": "application/json",
    };

    final body = item.toMap();

    final response = await http.post(
      Uri.parse("$_ocbUrl/v2/entities"),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      log('''Unable to create entity: ${item.toString()},
      got response: (${response.statusCode} ${response.body})''');
      return false;
    }
  }

  /// Lists entities from the orion context broker with the given type
  Future<List<NGSI>> listEntitiesWithType(String type) async {
    final oauthToken = AuthService().oauth2Token ?? "";

    final headers = {
      'X-Auth-Token': oauthToken,
    };

    final response = await http.get(
      Uri.parse("$_ocbUrl/v2/entities?type=$type"),
      headers: headers,
    );

    List<NGSI> items = [];

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);

      for (final entity in responseJson) {
        items.add(NGSI.fromMap(entity));
      }
    } else {
      log('Error while querying OCB: (${response.statusCode}) ${response.body}');
    }

    return items;
  }

  Future<bool> deleteEntity(NGSI item) async {
    final headers = {
      "X-Auth-Token": AuthService().oauth2Token ?? "",
    };

    final response = await http.delete(
      Uri.parse(
        "$_ocbUrl/v2/entities/${item.id}",
      ),
      headers: headers,
    );

    // no content response
    if (response.statusCode == 204) {
      return true;
    } else {
      log(
        "Could not delete entity $item, (${response.statusCode}) ${response.body}",
      );
      return false;
    }
  }
}
