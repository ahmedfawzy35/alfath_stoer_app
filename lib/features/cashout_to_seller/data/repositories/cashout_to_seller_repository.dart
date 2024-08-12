import 'dart:convert';
import 'package:alfath_stoer_app/core/utils/strings.dart';
import 'package:alfath_stoer_app/features/cashout_to_seller/data/models/cashout_to_seller_model.dart';
import 'package:http/http.dart' as http;

class CashOutToSellerRepository {
  final String baseUrl = MyStrings.baseurl;
  final String model = 'CashOutToSeller';
  CashOutToSellerRepository();

  // ===========================================================================
  // GetAllForBranche CashInFromCustomer
  //
  Future<List<CashOutToSeller>> getAllForBranche(int brancheId) async {
    final url = '$baseUrl/$model/GetAllForBranche';

    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('GET', Uri.parse(url));
    request.body = json.encode(brancheId);

    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      return data.map((item) => CashOutToSeller.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

// ===========================================================================
  // GetById CashInFromCustomer
  //

  Future<CashOutToSeller> getByIdCashOutToSeller(int id) async {
    final url = '$baseUrl/$model/GetById/$id';

    var request = http.Request('GET', Uri.parse(url));

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return CashOutToSeller.fromJson(data);
    } else {
      throw Exception('Failed to load data');
    }
  }
  // ===========================================================================
  // add CashInFromCustomer
  // ===========================================================================

  Future<CashOutToSeller> addCashOutToSeller(CashOutToSeller entity) async {
    final url = '$baseUrl/$model/Add';

    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "date": entity.date,
      "value": entity.value,
      "notes": entity.notes,
      "sellerId": entity.sellerId,
      "userId": entity.userId,
      "brancheId": entity.brancheId
    });

    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return CashOutToSeller.fromJson(data);
    } else {
      throw Exception('Failed to load details');
    }
  }

// ===========================================================================
  // EDIT CashInFromCustomer
  // ===========================================================================
  Future<CashOutToSeller> updateCashOutToSeller(CashOutToSeller entity) async {
    final url = '$baseUrl/$model/Edit';

    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('PUT', Uri.parse(url));
    request.body = json.encode({
      "id": entity.id,
      "date": entity.date,
      "value": entity.value,
      "notes": entity.notes,
      "sellerId": entity.sellerId,
      "userId": entity.userId,
      "brancheId": entity.brancheId
    });
    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return CashOutToSeller.fromJson(data);
    } else {
      throw Exception('Failed to update details');
    }
  }
// ===========================================================================
  // Delete CashInFromCustomer
  // ===========================================================================

  Future<CashOutToSeller> deleteCashOutToSeller(int id) async {
    final url = '$baseUrl/$model/Delete/$id';

    var request = http.Request('DELETE', Uri.parse(url));

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return CashOutToSeller.fromJson(data);
    } else {
      throw Exception(response.body);
    }
  }
}
