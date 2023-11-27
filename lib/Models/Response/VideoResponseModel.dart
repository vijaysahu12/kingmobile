class VideoResponseModel {
  final String title;
  final String author;
  final String thumbnailUrl;
  final String description;

  VideoResponseModel({
    required this.title,
    required this.author,
    required this.thumbnailUrl,
    required this.description,
  });

  factory VideoResponseModel.fromJson(Map<String, dynamic> json) {
    return VideoResponseModel(
      title: json['title'] ?? '',
      author: json['author_name'] ?? '',
      thumbnailUrl: json['thumbnail_url'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
