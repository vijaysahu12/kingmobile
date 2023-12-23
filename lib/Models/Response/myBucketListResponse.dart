class myBucketListResponse {
  final int id;
  final String name;
  final int daysToGo;
  final bool isHeart;
  // final DateTime startdate;
  // final DateTime enddate;
  final String categoryName;
  final dynamic showReminder;

  const myBucketListResponse({
    required this.id,
    required this.daysToGo,
    // required this.startdate,
    // required this.enddate,
    required this.categoryName,
    required this.isHeart,
    required this.name,
    required this.showReminder,
  });

  factory myBucketListResponse.fromJson(Map<String, dynamic> json) {
    return myBucketListResponse(
      id: json['id'] ?? 0,
      daysToGo: json['daysToGo'] ?? 0,
      name: json['name'] ?? '',
      categoryName: json['categoryName'] ?? '',
      showReminder: json['showReminder'],
      isHeart: json['isHeart'] ?? false,
    );
  }
}
