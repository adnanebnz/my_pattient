class Exercise {
  int? id;
  String name;
  String description;
  int? isProgrammed;
  int? isDone;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    this.isProgrammed,
    this.isDone,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}
