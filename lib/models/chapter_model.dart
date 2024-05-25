class ChapterModel {
  final String id;
  final String name;
  bool isRead;

  ChapterModel({required this.id, required this.name, this.isRead = false});

  ChapterModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        isRead = json['isRead'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['isRead'] = isRead;
    return data;
  }
}