class Employee {
  int? id;
  String? name;
  String? adress;
  double? salary;
  String? phone;
  bool? enabled;
  String? dateStart;
  String? dateEnd;
  int? brancheId;
  String? brancheName;

  Employee(
      {this.id,
      this.name,
      this.adress,
      this.salary,
      this.phone,
      this.enabled,
      this.dateStart,
      this.dateEnd,
      this.brancheId,
      this.brancheName});

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    adress = json['adress'];
    salary = (json['salary'] as num).toDouble();
    phone = json['phone'];
    enabled = json['enabled'];
    dateStart = json['dateStart'];
    dateEnd = json['dateEnd'];
    brancheId = json['brancheId'];
    brancheName = json['brancheName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['adress'] = this.adress;
    data['salary'] = this.salary;
    data['phone'] = this.phone;
    data['enabled'] = this.enabled;
    data['dateStart'] = this.dateStart;
    data['dateEnd'] = this.dateEnd;
    data['brancheId'] = this.brancheId;
    data['brancheName'] = this.brancheName;
    return data;
  }
}
