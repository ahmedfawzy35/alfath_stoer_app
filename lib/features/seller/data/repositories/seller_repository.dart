import 'dart:convert';
import 'package:alfath_stoer_app/core/utils/strings.dart';
import 'package:alfath_stoer_app/features/seller/data/models/seller_model.dart';
import 'package:http/http.dart' as http;

class SellerRepository {
  final String baseUrl = MyStrings.baseurl;
  final String model = 'Seller';
  SellerRepository();

  Future<List<SellerModel>> fetchData() async {
    final response = await http.get(Uri.parse('$baseUrl/$model/GetAll'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      return data.map((item) => SellerModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  // ===========================================================================
  // addCustomer
  // ===========================================================================

  Future<SellerModel> addSeller(SellerModel seller) async {
    final url = '$baseUrl/$model/Add';

    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "id": 0,
      "name": seller.name,
      "adress": seller.adress,
      "startAccount": seller.startAccount,
      "brancheId": seller.brancheId,
    });

    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return SellerModel.fromJson(data);
    } else {
      throw Exception('Failed to load details');
    }
  }

  Future<SellerModel> updateSeller(SellerModel seller) async {
    final url = '$baseUrl/$model/Edit';

    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "id": seller.id,
      "name": seller.name,
      "adress": seller.adress,
      "startAccount": seller.startAccount,
      "brancheId": seller.brancheId,
    });

    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return SellerModel.fromJson(data);
    } else {
      throw Exception('Failed to load details');
    }
  }
}
