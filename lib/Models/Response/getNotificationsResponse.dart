class NotificationsList {
  final String title;
  final String body;
  final String category;
  final String createdOn;
  final String createdBy;
  final bool isRead;
  final bool isDelete;

  const NotificationsList({
    required this.title,
    required this.body,
    required this.category,
    required this.createdOn,
    required this.createdBy,
    required this.isRead,
    required this.isDelete,
  });

  factory NotificationsList.fromJson(Map<String, dynamic> json) {
    return NotificationsList(
        title: json['title'] ?? '',
        body: json['body'] ?? '',
        category: json['category'] ?? '',
        createdOn: json['createdOn'] ?? '',
        createdBy: json['createdBy'] ?? '',
        isRead: json['isRead'],
        isDelete: json['isDelete']);
  }
}

class Category {
  final int id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }
}
