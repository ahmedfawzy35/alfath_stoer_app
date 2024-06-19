import 'package:alfath_stoer_app/features/customer_supplier/data/models/customer_supplier_detail_model.dart';
import 'package:alfath_stoer_app/features/customer_supplier/domain/customer_supplier_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomerSupplierDetailRepository {
  final String baseUrl;

  CustomerSupplierDetailRepository({required this.baseUrl});

  Future<CustomerSupplierDetail> fetchCustomerSupplierDetail(
      String type, int id) async {
    final url =
        '$baseUrl/${type == 'Customer' ? 'Customer' : 'Seller'}/Account';
    final request = await http.Request(
      'GET',
      Uri.parse(url),
    );
    var headers = {'Content-Type': 'application/json'};
    request.body = json.encode(id);
    request.headers.addAll(headers);

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (streamedResponse.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return CustomerSupplierDetailModel.fromJson(data).toEntity();
    } else {
      throw Exception('Failed to load details');
    }
  }
}
