import 'dart:convert';
import 'dart:core';

import 'package:alfath_stoer_app/core/utils/strings.dart';
import 'package:alfath_stoer_app/features/purchases/datat/models/purchase.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as dateformate;
import 'package:intl/intl.dart';

class PurchaseRepository {
  final String baseurl = MyStrings.baseurl;
  final String model = 'Purchase';
  final DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss");

  //add order
  Future<Purchase> addPurchase(Purchase purchase) async {
    final url = '$baseurl/$model/Add';

    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "date": formatter.format(DateTime.parse(purchase.date!)),
      "sellerId": purchase.sellerrId,
      "total": purchase.total,
      "paid": purchase.paid,
      "discount": purchase.discount,
      "remainingAmount": purchase.remainingAmount,
      "brancheId": purchase.brancheId,
      "orderNumber": purchase.orderNumber,
      "notes": purchase.notes
    });

    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return Purchase.fromJson(data);
    } else {
      throw Exception('Failed to load details');
    }
  }

// edit order
  Future<Purchase> editPurchase(Purchase purchase) async {
    final url = '$baseurl/$model/Edit';

    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('PUT', Uri.parse(url));
    request.body = json.encode({
      "Id": purchase.id,
      "date": purchase.date,
      "sellerrId": purchase.sellerrId,
      "total": purchase.total,
      "paid": purchase.paid,
      "discount": purchase.discount,
      "remainingAmount": purchase.remainingAmount,
      "brancheId": purchase.brancheId,
      "orderNumber": purchase.orderNumber,
      "notes": purchase.notes
    });
    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return Purchase.fromJson(data);
    } else {
      throw Exception('Failed to edit order');
    }
  }

  //delete
  Future<bool> deletePurchase(int id) async {
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
  Future<Purchase> getById(int id) async {
    final url = '$baseurl/$model/GetById/$id';

    var request = http.Request('GET', Uri.parse(url));

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return Purchase.fromJson(data);
    } else {
      throw Exception('Failed to Delete');
    }
  }

  //get FOR DATE
  Future<List<Purchase>> getForDate(DateTime date, int brancheId) async {
    final url = '$baseurl/$model/GetAllForDate';
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
        return data.map((item) => Purchase.fromJson(item)).toList();
      } catch (e) {
        return [];
      }
    } else {
      throw Exception('faild to load data');
    }
  }

  //get FOR Time
  Future<List<Purchase>> getForTime(
      DateTime dateFrom, DateTime dateTo, int brancheId) async {
    final url = '$baseurl/$model/GetAllForTime';
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
      return data.map((item) => Purchase.fromJson(item)).toList();
    } else {
      throw Exception('Failed to Delete');
    }
  }
}
