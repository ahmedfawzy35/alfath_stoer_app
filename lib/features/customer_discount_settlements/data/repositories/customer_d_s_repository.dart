import 'dart:convert';
import 'dart:core';

import 'package:alfath_stoer_app/core/utils/strings.dart';
import 'package:alfath_stoer_app/features/customer_discount_settlements/data/models/customer_discount_settlement.dart';
import 'package:http/http.dart' as http;

class CustomerDiscountSettlementRepository {
  final String baseurl = MyStrings.baseurl;
  final String model = 'CustomerDiscountSettlement';
  //add CustomerDiscountSettlement
  Future<CustomerDiscountSettlement> addCustomerDiscountSettlement(
      CustomerDiscountSettlement customerDiscountSettlement) async {
    final url = '$baseurl/$model/Add';

    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "date": customerDiscountSettlement.date.toString(),
      "value": customerDiscountSettlement.value,
      "notes": customerDiscountSettlement.notes,
      "customerId": customerDiscountSettlement.customerId,
      "userId": customerDiscountSettlement.userId,
      "brancheId": customerDiscountSettlement.brancheId
    });

    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return CustomerDiscountSettlement.fromJson(data);
    } else {
      throw Exception('Failed to load details');
    }
  }

// edit CustomerDiscountSettlement
  Future<CustomerDiscountSettlement> editCustomerDiscountSettlement(
      CustomerDiscountSettlement customerDiscountSettlement) async {
    final url = '$baseurl/$model/Edit';

    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('PUT', Uri.parse(url));
    request.body = json.encode({
      "id": customerDiscountSettlement.id,
      "date": customerDiscountSettlement.date.toString(),
      "value": customerDiscountSettlement.value,
      "notes": customerDiscountSettlement.notes,
      "customerId": customerDiscountSettlement.customerId,
      "userId": customerDiscountSettlement.userId,
      "brancheId": customerDiscountSettlement.brancheId
    });
    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return CustomerDiscountSettlement.fromJson(data);
    } else {
      throw Exception('Failed to edit order');
    }
  }

  //delete
  Future<bool> deleteCustomerDiscountSettlement(int id) async {
    final url = '$baseurl/$model/Delete/$id';

    var request = http.Request('DELETE', Uri.parse(url));

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  //get by id
  Future<CustomerDiscountSettlement> getById(int id) async {
    final url = '$baseurl/$model/GetById/$id';

    var request = http.Request('GET', Uri.parse(url));

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return CustomerDiscountSettlement.fromJson(data);
    } else {
      throw Exception('Failed to Delete');
    }
  }

  //Get All For Branche
  Future<List<CustomerDiscountSettlement>> getAllForBranche(
      int brancheId) async {
    final url = '$baseurl/$model/GetAllForBranche';
    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('GET', Uri.parse(url));
    request.body = json.encode({brancheId});
    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      return data
          .map((item) => CustomerDiscountSettlement.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to Delete');
    }
  }
}
