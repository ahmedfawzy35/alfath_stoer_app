import 'dart:convert';
import 'dart:core';

import 'package:alfath_stoer_app/core/utils/strings.dart';
import 'package:alfath_stoer_app/features/purchases_back/datat/models/purchase_back.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as dateformate;

class PurchaseBackRepository {
  final String baseurl = MyStrings.baseurl;
  final String model = 'PurchaseBack';
  //add order
  Future<PurchaseBack> addPurchaseBack(PurchaseBack purchaseBack) async {
    final url = '$baseurl/$model/Add';

    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "date": purchaseBack.date,
      "sellerrId": purchaseBack.sellerrId,
      "total": purchaseBack.total,
      "paid": purchaseBack.paid,
      "discount": purchaseBack.discount,
      "remainingAmount": purchaseBack.remainingAmount,
      "brancheId": purchaseBack.brancheId,
      "orderNumber": purchaseBack.orderNumber,
      "notes": purchaseBack.notes
    });

    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return PurchaseBack.fromJson(data);
    } else {
      throw Exception('Failed to load details');
    }
  }

// edit order
  Future<PurchaseBack> editPurchaseBack(PurchaseBack purchaseBack) async {
    final url = '$baseurl/$model/Edit';

    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('PUT', Uri.parse(url));
    request.body = json.encode({
      "Id": purchaseBack.id,
      "date": purchaseBack.date,
      "sellerrId": purchaseBack.sellerrId,
      "total": purchaseBack.total,
      "paid": purchaseBack.paid,
      "discount": purchaseBack.discount,
      "remainingAmount": purchaseBack.remainingAmount,
      "brancheId": purchaseBack.brancheId,
      "orderNumber": purchaseBack.orderNumber,
      "notes": purchaseBack.notes
    });
    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return PurchaseBack.fromJson(data);
    } else {
      throw Exception('Failed to edit order');
    }
  }

  //delete
  Future<bool> deletePurchaseBack(int id) async {
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
  Future<PurchaseBack> getById(int id) async {
    final url = '$baseurl/$model/GetById/$id';

    var request = http.Request('GET', Uri.parse(url));

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return PurchaseBack.fromJson(data);
    } else {
      throw Exception('Failed to Delete');
    }
  }

  //get FOR DATE
  Future<List<PurchaseBack>> getForDate(DateTime date, int brancheId) async {
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
        return data.map((item) => PurchaseBack.fromJson(item)).toList();
      } catch (e) {
        return [];
      }
    } else {
      throw Exception('faild to load data');
    }
  }

  //get FOR Time
  Future<List<PurchaseBack>> getForTime(
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

      return data.map((item) => PurchaseBack.fromJson(item)).toList();
    } else {
      throw Exception('Failed to Delete');
    }
  }
}
