import 'dart:convert';
import 'package:alfath_stoer_app/features/customer/data/models/customer_model.dart';
import 'package:http/http.dart' as http;

class CustomerListRepository {
  final String baseUrl;
  final String model = 'Customer';

  CustomerListRepository(this.baseUrl);

  Future<List<CustomerModel>> fetchData() async {
    final response = await http.get(Uri.parse('$baseUrl/$model/GetAll'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      return data.map((item) => CustomerModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  // ===========================================================================
  // addCustomer
  // ===========================================================================

  Future<CustomerModel> addCustomer(CustomerModel customer) async {
    final url = '$baseUrl/$model/Add';

    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "id": 0,
      "name": customer.name,
      "adress": customer.adress,
      "startAccount": customer.startAccount,
      "brancheId": customer.brancheId,
      "customertypeId": customer.customertypeId,
      "stopDealing": customer.stopDealing
    });

    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return CustomerModel.fromJson(data);
    } else {
      throw Exception('Failed to load details');
    }
  }
}
