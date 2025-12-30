class ZikirModel {
  final String id;
  final String title;
  final String description;
  final int? targetCount;

  ZikirModel({
    required this.id,
    required this.title,
    required this.description,
    this.targetCount,
  });

  factory ZikirModel.fromJson(Map<String, dynamic> json) {
    return ZikirModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      targetCount: json['targetCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'targetCount': targetCount,
    };
  }
}
