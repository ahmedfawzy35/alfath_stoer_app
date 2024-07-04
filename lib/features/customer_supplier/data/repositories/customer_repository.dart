import 'dart:convert';
import 'package:alfath_stoer_app/features/customer_supplier/data/models/customer_model.dart';
import 'package:http/http.dart' as http;

class CustomerListRepository {
  final String baseUrl;

  CustomerListRepository(this.baseUrl);

  Future<List<CustomerModel>> fetchData() async {
    final response = await http.get(Uri.parse('$baseUrl/Customer/GetAll'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      return data.map((item) => CustomerModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
