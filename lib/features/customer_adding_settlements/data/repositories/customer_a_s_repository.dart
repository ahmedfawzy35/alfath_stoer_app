import 'dart:convert';
import 'dart:core';

import 'package:alfath_stoer_app/core/utils/strings.dart';
import 'package:alfath_stoer_app/features/customer_adding_settlements/data/models/customer_adding_settlement.dart';
import 'package:http/http.dart' as http;

class CustomerAddingSettlementRepository {
  final String baseurl = MyStrings.baseurl;
  final String model = 'CustomerAddingSettlement';
  //add customerAddingSettlement
  Future<CustomerAddingSettlement> addcustomerAddingSettlement(
      CustomerAddingSettlement customerAddingSettlement) async {
    final url = '$baseurl/$model/Add';

    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "date": customerAddingSettlement.date.toString(),
      "value": customerAddingSettlement.value,
      "notes": customerAddingSettlement.notes,
      "customerId": customerAddingSettlement.customerId,
      "userId": customerAddingSettlement.userId,
      "brancheId": customerAddingSettlement.brancheId
    });

    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return CustomerAddingSettlement.fromJson(data);
    } else {
      throw Exception('Failed to load details');
    }
  }

// edit customerAddingSettlement
  Future<CustomerAddingSettlement> editcustomerAddingSettlement(
      CustomerAddingSettlement customerAddingSettlement) async {
    final url = '$baseurl/$model/Edit';

    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('PUT', Uri.parse(url));
    request.body = json.encode({
      "id": customerAddingSettlement.id,
      "date": customerAddingSettlement.date.toString(),
      "value": customerAddingSettlement.value,
      "notes": customerAddingSettlement.notes,
      "customerId": customerAddingSettlement.customerId,
      "userId": customerAddingSettlement.userId,
      "brancheId": customerAddingSettlement.brancheId
    });
    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return CustomerAddingSettlement.fromJson(data);
    } else {
      throw Exception('Failed to edit order');
    }
  }

  //delete
  Future<bool> deleteCustomerAddingSettlement(int id) async {
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
  Future<CustomerAddingSettlement> getById(int id) async {
    final url = '$baseurl/$model/GetById/$id';

    var request = http.Request('GET', Uri.parse(url));

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return CustomerAddingSettlement.fromJson(data);
    } else {
      throw Exception('Failed to Delete');
    }
  }

  //Get All
  Future<List<CustomerAddingSettlement>> GetAll() async {
    final url = '$baseurl/$model/GetAllForDate';

    var request = http.Request('GET', Uri.parse(url));

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      try {
        final List<dynamic> data = json.decode(response.body);
        return data
            .map((item) => CustomerAddingSettlement.fromJson(item))
            .toList();
      } catch (e) {
        return [];
      }
    } else {
      throw Exception('faild to load data');
    }
  }

  //Get All For Branche
  Future<List<CustomerAddingSettlement>> GetAllForBranche(int brancheId) async {
    final url = '$baseurl/$model/GetAllForTime';
    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('GET', Uri.parse(url));
    request.body = json.encode({brancheId});
    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      return data
          .map((item) => CustomerAddingSettlement.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to Delete');
    }
  }
}
