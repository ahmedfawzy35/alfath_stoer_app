import 'dart:convert';
import 'dart:core';

import 'package:alfath_stoer_app/core/utils/strings.dart';
import 'package:alfath_stoer_app/features/orders/data/models/order.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as dateformate;

class OrderRepository {
  final String baseurl = MyStrings.baseurl;
  //add order
  Future<Order> addOrder(Order order) async {
    final url = '$baseurl/Order/Add';

    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "date": order.date,
      "customerId": order.customerId,
      "total": order.total,
      "paid": order.paid,
      "discount": order.discount,
      "remainingAmount": order.remainingAmount,
      "brancheId": order.brancheId,
      "orderProfit": order.orderProfit,
      "orderNumber": order.orderNumber,
      "notes": order.notes
    });
    print(order.date);
    print(order.customerId);
    print(order.total);
    print(order.paid);
    print(order.discount);
    print(order.remainingAmount);
    print(order.brancheId);
    print(order.orderProfit);
    print(order.orderNumber);
    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return Order.fromJson(data);
    } else {
      print(response.body);
      throw Exception('Failed to load details');
    }
  }

// edit order
  Future<Order> editOrder(Order order) async {
    final url = '$baseurl/Order/Edit';

    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('PUT', Uri.parse(url));
    request.body = json.encode({
      "Id": order.id,
      "date": order.date,
      "customerId": order.customerId,
      "total": order.total,
      "paid": order.paid,
      "discount": order.discount,
      "remainingAmount": order.remainingAmount,
      "brancheId": order.brancheId,
      "orderProfit": order.orderProfit,
      "orderNumber": order.orderNumber,
      "notes": order.notes
    });
    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return Order.fromJson(data);
    } else {
      throw Exception('Failed to edit order');
    }
  }

  //delete
  Future<bool> deleteOrder(int id) async {
    final url = '$baseurl/Order/Delete/$id';

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
  Future<Order> getById(int id) async {
    final url = '$baseurl/Order/GetById/$id';

    var request = http.Request('GET', Uri.parse(url));

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return Order.fromJson(data);
    } else {
      throw Exception('Failed to Delete');
    }
  }

  //get FOR DATE
  Future<List<Order>> getForDate(DateTime date, int brancheId) async {
    final url = '$baseurl/Order/GetAllForDate';
    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('GET', Uri.parse(url));
    request.body = json.encode({
      "DateFrom": dateformate.DateFormat('yyyy-MM-ddTHH:mm:ss').format(date),
      "BrancheId": brancheId
    });
    print(date);
    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      try {
        final List<dynamic> data = json.decode(response.body);
        print(data);
        return data.map((item) => Order.fromJson(item)).toList();
      } catch (e) {
        print(e.toString());
        return [];
      }
    } else {
      throw Exception('faild to load data');
    }
  }

  //get FOR Time
  Future<List<Order>> getForTime(
      DateTime dateFrom, DateTime dateTo, int brancheId) async {
    final url = '$baseurl/Order/GetAllForTime';
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

      return data.map((item) => Order.fromJson(item)).toList();
    } else {
      throw Exception('Failed to Delete');
    }
  }
}
