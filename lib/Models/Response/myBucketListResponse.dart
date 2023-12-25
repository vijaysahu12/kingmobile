class myBucketListResponse {
  final int id;
  final String name;
  final int daysToGo;

  final DateTime startdate;
  final DateTime enddate;
  final String categoryName;
  final dynamic showReminder;
  bool isHeart;

  myBucketListResponse({
    required this.id,
    required this.daysToGo,
    required this.startdate,
    required this.enddate,
    required this.categoryName,
    required this.name,
    required this.showReminder,
    required this.isHeart,
  });

  factory myBucketListResponse.fromJson(Map<String, dynamic> json) {
    return myBucketListResponse(
      id: json['id'] ?? 0,
      daysToGo: json['daysToGo'] ?? 0,
      name: json['name'] ?? '',
      categoryName: json['categoryName'] ?? '',
      showReminder: json['showReminder'],
      isHeart: json['isHeart'] ?? false,
      startdate: DateTime.parse(json['startdate']),
      enddate: DateTime.parse(json['enddate']),
    );
  }
}
