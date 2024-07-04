import 'package:alfath_stoer_app/core/utils/strings.dart';
import 'package:alfath_stoer_app/features/customer_supplier/data/models/customer_detail_model.dart';
import 'package:alfath_stoer_app/features/customer_supplier/domain/customer_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomerDetailRepository {
  CustomerDetailRepository();

  Future<CustomerSupplierDetail> fetchCustomerSupplierDetail(int id) async {
    const url = '${MyStrings.baseurl}/Customer/Account';
    final request = http.Request(
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

      return CustomerDetailModel.fromJson(data).toEntity();
    } else {
      throw Exception('Failed to load details');
    }
  }
}
