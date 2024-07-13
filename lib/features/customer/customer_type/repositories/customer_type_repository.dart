import 'dart:convert';
import 'dart:core';

import 'package:alfath_stoer_app/core/utils/strings.dart';
import 'package:alfath_stoer_app/features/customer/customer_type/models/cutomer_type_model.dart';
import 'package:http/http.dart' as http;

class CustomerTypeRepository {
  final String baseurl = MyStrings.baseurl;
  final String model = 'CustomerType';
  //add CustomerType
  Future<CustomerTypeModel> add(CustomerTypeModel customerTypeModel) async {
    final url = '$baseurl/$model/Add';

    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('POST', Uri.parse(url));
    request.body = json
        .encode({"id": customerTypeModel.id, "name": customerTypeModel.name});

    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return CustomerTypeModel.fromJson(data);
    } else {
      throw Exception('Failed to load details');
    }
  }

// edit CustomerType
  Future<CustomerTypeModel> edit(CustomerTypeModel customerTypeModel) async {
    final url = '$baseurl/$model/Edit';

    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('PUT', Uri.parse(url));
    request.body = json
        .encode({"id": customerTypeModel.id, "name": customerTypeModel.name});
    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return CustomerTypeModel.fromJson(data);
    } else {
      throw Exception('Failed to edit order');
    }
  }

  //delete CustomerType
  Future<bool> delete(int id) async {
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
  Future<CustomerTypeModel> getById(int id) async {
    final url = '$baseurl/$model/GetById/$id';

    var request = http.Request('GET', Uri.parse(url));

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return CustomerTypeModel.fromJson(data);
    } else {
      throw Exception('Failed to Delete');
    }
  }

  //get All
  Future<List<CustomerTypeModel>> getAll() async {
    final url = '$baseurl/$model/GetAll';

    var request = http.Request('GET', Uri.parse(url));

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      try {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => CustomerTypeModel.fromJson(item)).toList();
      } catch (e) {
        return [];
      }
    } else {
      throw Exception('faild to load data');
    }
  }
}
