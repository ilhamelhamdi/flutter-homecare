import 'package:m2health/cubit/pharmacogenomics/domain/entities/pharmacogenomics.dart';

class PharmacogenomicsModel extends Pharmacogenomics {
  const PharmacogenomicsModel({
    required int id,
    required String title,
    String? description,
    String? fileUrl,
  }) : super(
          id: id,
          title: title,
          description: description,
          fileUrl: fileUrl,
        );

  factory PharmacogenomicsModel.fromJson(Map<String, dynamic> json) {
    return PharmacogenomicsModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      fileUrl: json['file_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'file_url': fileUrl,
    };
  }
}
