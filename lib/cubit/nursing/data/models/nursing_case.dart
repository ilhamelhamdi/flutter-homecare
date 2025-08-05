import 'dart:io';
import 'package:m2health/cubit/nursing/domain/entities/nursing_case.dart';

class NursingCaseModel extends NursingCase {
  const NursingCaseModel({
    required String title,
    required String description,
    required List<File> images,
  }) : super(
          title: title,
          description: description,
          images: images,
        );

  factory NursingCaseModel.fromJson(Map<String, dynamic> json) {
    return NursingCaseModel(
      title: json['title'],
      description: json['description'],
      images: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
    };
  }
}
