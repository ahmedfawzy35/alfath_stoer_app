import 'dart:convert';
import 'package:alfath_stoer_app/features/customer_supplier/data/models/seller_model.dart';
import 'package:http/http.dart' as http;

class SellerListRepository {
  final String baseUrl;

  SellerListRepository(this.baseUrl);

  Future<List<SellerModel>> fetchData(String type) async {
    final response = await http.get(Uri.parse('$baseUrl/Seller/GetAll'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      return data.map((item) => SellerModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
