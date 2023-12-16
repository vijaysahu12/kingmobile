// class getNotificationsResponse {
//   final int statusCode;
//   final String message;
//   final List<NotificationsList> data;

//   const getNotificationsResponse(
//       {required this.statusCode, required this.message, required this.data});

//   factory getNotificationsResponse.fromJson(Map<String, dynamic> json) {
//     return getNotificationsResponse(
//       statusCode: json['statusCode'] ?? 0,
//       message: json['message'] ?? '',
//       data: (json['data'] != null && json['data'] is List)
//           ? List<NotificationsList>.from(
//               json['data'].map((item) => NotificationsList.fromJson(item)),
//             )
//           : [],
//     );
//   }
// }

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
