import 'dart:convert';
import 'package:alfath_stoer_app/core/utils/strings.dart';
import 'package:alfath_stoer_app/features/outgoing/data/models/outgoing_model.dart';
import 'package:http/http.dart' as http;

class OutGoigRepository {
  final String baseUrl = MyStrings.baseurl;
  final String model = 'OutGoing';
  OutGoigRepository();

  Future<List<OutGoig>> getAllForBranche(int brancheId) async {
    final url = '$baseUrl/$model/GetAllForBranche';
    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('GET', Uri.parse(url));
    request.body = json.encode(brancheId);

    request.headers.addAll(headers);
    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => OutGoig.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  // ===========================================================================
  // add OutGoig
  // ===========================================================================

  Future<OutGoig> addOutGoig(OutGoig outGoig) async {
    final url = '$baseUrl/$model/Add';

    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "name": outGoig.name,
      "notes": outGoig.notes,
      "brancheId": outGoig.brancheId
    });

    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return OutGoig.fromJson(data);
    } else {
      throw Exception('Failed to load details');
    }
  }

// ===========================================================================
  // EDIT OutGoig
  // ===========================================================================

  Future<OutGoig> updateOutGoig(OutGoig outGoig) async {
    final url = '$baseUrl/$model/Edit';

    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('PUT', Uri.parse(url));
    request.body = json.encode({
      "id": outGoig.id,
      "name": outGoig.name,
      "notes": outGoig.notes,
      "brancheId": outGoig.brancheId
    });
    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return OutGoig.fromJson(data);
    } else {
      throw Exception('Failed to update details');
    }
  }

// ===========================================================================
  // delete OutGoig
  // ===========================================================================

  //delete
  Future<bool> deleteCustomerDiscountSettlement(int id) async {
    final url = '$baseUrl/$model/Delete/$id';

    var request = http.Request('DELETE', Uri.parse(url));

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
