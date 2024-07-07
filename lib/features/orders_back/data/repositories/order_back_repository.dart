import 'dart:convert';
import 'dart:core';

import 'package:alfath_stoer_app/core/utils/strings.dart';
import 'package:alfath_stoer_app/features/orders_back/data/models/order_back.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as dateformate;

class OrderBackRepository {
  final String baseurl = MyStrings.baseurl;
  final String controller = 'OrderBack';
  //add order
  Future<OrderBack> addOrderBack(OrderBack orderback) async {
    final url = '$baseurl/$controller/Add';

    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "date": orderback.date,
      "customerId": orderback.customerId,
      "total": orderback.total,
      "paid": orderback.paid,
      "discount": orderback.discount,
      "remainingAmount": orderback.remainingAmount,
      "brancheId": orderback.brancheId,
      "orderNumber": orderback.orderNumber,
      "notes": orderback.notes
    });

    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return OrderBack.fromJson(data);
    } else {
      throw Exception('Failed to load details');
    }
  }

// edit order
  Future<OrderBack> editOrderBack(OrderBack orderBack) async {
    final url = '$baseurl/$controller/Edit';

    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('PUT', Uri.parse(url));
    request.body = json.encode({
      "Id": orderBack.id,
      "date": orderBack.date,
      "customerId": orderBack.customerId,
      "total": orderBack.total,
      "paid": orderBack.paid,
      "discount": orderBack.discount,
      "remainingAmount": orderBack.remainingAmount,
      "brancheId": orderBack.brancheId,
      "orderNumber": orderBack.orderNumber,
      "notes": orderBack.notes
    });
    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return OrderBack.fromJson(data);
    } else {
      throw Exception('Failed to edit order');
    }
  }

  //delete
  Future<bool> deleteOrderBack(int id) async {
    final url = '$baseurl/$controller/Delete/$id';

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
  Future<OrderBack> getById(int id) async {
    final url = '$baseurl/$controller/GetById/$id';

    var request = http.Request('GET', Uri.parse(url));

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return OrderBack.fromJson(data);
    } else {
      throw Exception('Failed to Delete');
    }
  }

  //get FOR DATE
  Future<List<OrderBack>> getForDate(DateTime date, int brancheId) async {
    final url = '$baseurl/$controller/GetAllForDate';
    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('GET', Uri.parse(url));
    request.body = json.encode({
      "DateFrom": dateformate.DateFormat('yyyy-MM-ddTHH:mm:ss').format(date),
      "BrancheId": brancheId
    });
    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      try {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => OrderBack.fromJson(item)).toList();
      } catch (e) {
        return [];
      }
    } else {
      throw Exception('faild to load data');
    }
  }

  //get FOR Time
  Future<List<OrderBack>> getForTime(
      DateTime dateFrom, DateTime dateTo, int brancheId) async {
    final url = '$baseurl/$controller/GetAllForTime';
    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('GET', Uri.parse(url));
    request.body = json.encode({
      "DateFrom":
          dateformate.DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateFrom),
      "DateTo": dateformate.DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTo),
      "BrancheId": brancheId
    });
    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      return data.map((item) => OrderBack.fromJson(item)).toList();
    } else {
      throw Exception('Failed to Delete');
    }
  }
}
