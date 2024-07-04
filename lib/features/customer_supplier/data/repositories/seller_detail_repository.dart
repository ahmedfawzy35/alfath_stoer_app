import 'package:alfath_stoer_app/core/utils/strings.dart';
import 'package:alfath_stoer_app/features/customer_supplier/data/models/seller_detail_model.dart';
import 'package:alfath_stoer_app/features/customer_supplier/domain/seller_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SellerDetailRepository {
  SellerDetailRepository();

  Future<SellererDetail> fetchSellerDetail(int id) async {
    const url = '${MyStrings.baseurl}/Seller/Account';
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

      try {
        var aa = SellerDetailModel.fromJson(data).toEntity();
      } catch (e) {
        print(e.toString());
      }
      return SellerDetailModel.fromJson(data).toEntity();
    } else {
      throw Exception('Failed to load details');
    }
  }
}
