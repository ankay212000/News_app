import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: true)
class News {
  final String title;
  final String url;
  final String image;
  final String content;
  final String description;
  News({this.title,this.url,this.image,this.content,this.description});

  factory News.fromJSON(Map<String,dynamic> json) {
    return News(
      title: json['title'],
      url: json['url'],
      image: json['urlToImage'],
      content: json['content'],
      description: json['description']
    );
  }
}