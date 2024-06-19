import 'dart:convert';
import 'package:alfath_stoer_app/features/customer_supplier/data/models/customer_supplier_model.dart';
import 'package:http/http.dart' as http;

class CustomerSupplierListRepository {
  final String baseUrl;

  CustomerSupplierListRepository(this.baseUrl);

  Future<List<CustomerSupplierModel>> fetchData(String type) async {
    final response = await http.get(Uri.parse('$baseUrl/$type/GetAll'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      return data.map((item) => CustomerSupplierModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
