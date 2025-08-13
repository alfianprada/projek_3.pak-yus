import 'package:flutter/material.dart';

class CourseModel {
  final String id;
  final String title;
  final String? subtitle;
  final String caption;
  final Color color;
  final String images;
  final String image;
  final String link;

  CourseModel({
    required this.id,
    required this.title,
    this.subtitle,
    required this.caption,
    required this.color,
    required this.images,
    required this.image,
    required this.link,
  });

  // Factory constructor to create CourseModel from Firestore map
  factory CourseModel.fromMap(String id, Map<String, dynamic> map) {
    return CourseModel(
      id: id,
      title: map['title'] ?? '',
      subtitle: map['subtitle'],
      caption: map['caption'] ?? '',
      color: Color(int.parse(map['color'] ?? '0xFFFFFFFF')),
      images: map['images'] ?? '',
      image: map['image'] ?? '',
      link: map['link'] ?? '',
    );
  }
}
