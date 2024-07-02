// ignore_for_file: camel_case_types

class clime {
  String? name;

  clime({this.name});

  clime.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // ignore: unnecessary_this
    data['name'] = this.name;
    return data;
  }
}
