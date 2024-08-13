import 'dart:convert';
import 'package:alfath_stoer_app/core/utils/strings.dart';
import 'package:alfath_stoer_app/features/cashout_to_OutGoing/data/models/cashout_to_OutGoing_model.dart';
import 'package:http/http.dart' as http;

class CashOutToOutGoingRepository {
  final String baseUrl = MyStrings.baseurl;
  final String model = 'CashOutToOutGoing';
  CashOutToOutGoingRepository();

  // ===========================================================================
  // GetAllForBranche CashInFromCustomer
  //
  Future<List<CashOutToOutGoing>> getAllForBranche(int brancheId) async {
    final url = '$baseUrl/$model/GetAllForBranche';

    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('GET', Uri.parse(url));
    request.body = json.encode(brancheId);

    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      return data.map((item) => CashOutToOutGoing.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

// ===========================================================================
  // GetById CashInFromCustomer
  //

  Future<CashOutToOutGoing> getByIdCashOutToOutGoing(int id) async {
    final url = '$baseUrl/$model/GetById/$id';

    var request = http.Request('GET', Uri.parse(url));

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return CashOutToOutGoing.fromJson(data);
    } else {
      throw Exception('Failed to load data');
    }
  }
  // ===========================================================================
  // add CashInFromCustomer
  // ===========================================================================

  Future<CashOutToOutGoing> addCashOutToOutGoing(
      CashOutToOutGoing entity) async {
    final url = '$baseUrl/$model/Add';

    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "date": entity.date,
      "value": entity.value,
      "notes": entity.notes,
      "outGoingId": entity.outGoingId,
      "userId": entity.userId,
      "brancheId": entity.brancheId
    });

    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return CashOutToOutGoing.fromJson(data);
    } else {
      throw Exception('Failed to load details');
    }
  }

// ===========================================================================
  // EDIT CashInFromCustomer
  // ===========================================================================
  Future<CashOutToOutGoing> updateCashOutToOutGoing(
      CashOutToOutGoing entity) async {
    final url = '$baseUrl/$model/Edit';

    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('PUT', Uri.parse(url));
    request.body = json.encode({
      "id": entity.id,
      "date": entity.date,
      "value": entity.value,
      "notes": entity.notes,
      "outGoingId": entity.outGoingId,
      "userId": entity.userId,
      "brancheId": entity.brancheId
    });
    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return CashOutToOutGoing.fromJson(data);
    } else {
      throw Exception('Failed to update details');
    }
  }
// ===========================================================================
  // Delete CashInFromCustomer
  // ===========================================================================

  Future<CashOutToOutGoing> deleteCashOutToOutGoing(int id) async {
    final url = '$baseUrl/$model/Delete/$id';

    var request = http.Request('DELETE', Uri.parse(url));

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return CashOutToOutGoing.fromJson(data);
    } else {
      throw Exception(response.body);
    }
  }
}
