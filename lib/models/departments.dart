class Department {
  final String id;
  late final String name;
  late final String? departmentHead;

  Department({required this.id, required this.name,this.departmentHead});

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['_id'],
      name: json['name'],
      departmentHead: json['DepartmentHeadName'],
    );
  }
}