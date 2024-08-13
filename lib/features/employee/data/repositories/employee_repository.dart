import 'dart:convert';
import 'package:alfath_stoer_app/core/utils/strings.dart';
import 'package:alfath_stoer_app/features/employee/data/models/employee_model.dart';
import 'package:http/http.dart' as http;

class EmployeeRepository {
  final String baseUrl = MyStrings.baseurl;
  final String model = 'Employee';
  EmployeeRepository();

  Future<List<Employee>> getAllForBranche(int brancheId) async {
    final url = '$baseUrl/$model/GetAllForBranche';
    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('GET', Uri.parse(url));
    request.body = json.encode(brancheId);

    request.headers.addAll(headers);
    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Employee.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  // ===========================================================================
  // add Employee
  // ===========================================================================

  Future<Employee> addEmployee(Employee entity) async {
    final url = '$baseUrl/$model/Add';

    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "name": entity.name,
      "adress": entity.adress,
      "salary": entity.salary,
      "phone": entity.phone,
      "enabled": entity.enabled,
      "dateStart": entity.dateStart,
      "dateEnd": entity.dateEnd,
      "brancheId": entity.brancheId,
    });
    print('name ${entity.name}');
    print('adress ${entity.adress}');
    print('salary ${entity.salary}');
    print('phone ${entity.phone}');
    print('enabled ${entity.enabled}');
    print('dateStart ${entity.dateStart}');
    print('dateEnd ${entity.dateEnd}');
    print('brancheId ${entity.brancheId}');
    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return Employee.fromJson(data);
    } else {
      throw Exception('Failed to load details');
    }
  }

// ===========================================================================
  // EDIT Employee
  // ===========================================================================

  Future<Employee> updateEmployee(Employee entity) async {
    final url = '$baseUrl/$model/Edit';

    var headers = {'Content-Type': 'application/json'};

    var request = http.Request('PUT', Uri.parse(url));
    request.body = json.encode({
      "id": entity.id,
      "name": entity.name,
      "adress": entity.adress,
      "salary": entity.salary,
      "phone": entity.phone,
      "enabled": entity.enabled,
      "dateStart": entity.dateStart,
      "dateEnd": entity.dateEnd,
      "brancheId": entity.brancheId,
    });
    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return Employee.fromJson(data);
    } else {
      throw Exception('Failed to update details');
    }
  }

// ===========================================================================
  // delete Employee
  // ===========================================================================

  //delete
  Future<bool> deleteEmployee(int id) async {
    final url = '$baseUrl/$model/Delete/$id';

    var request = http.Request('DELETE', Uri.parse(url));

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
