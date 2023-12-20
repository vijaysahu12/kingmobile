class AllNotificationsCount {
  final int unReadCount;
  const AllNotificationsCount({required this.unReadCount});

  factory AllNotificationsCount.fromJson(Map<String, dynamic> json) {
    return AllNotificationsCount(unReadCount: json['unReadCount'] ?? 0);
  }
}

class NotificationsList {
  final int id;
  final String title;
  final String body;
  final String category;
  final String createdOn;
  final String createdBy;
  final bool isRead;
  final bool isDelete;

  const NotificationsList({
    required this.id,
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
        id: json['id'] ?? 0,
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
