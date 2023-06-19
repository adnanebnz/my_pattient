class Exercise {
  int? id;
  String name;
  String description;
  int? duration;
  int? isProgrammed;
  int? isDone;
  DateTime? startTime;
  DateTime? endTime;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    this.isProgrammed,
    this.isDone,
    this.duration,
    this.startTime,
    this.endTime,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  Exercise.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        description = map['description'];
}
