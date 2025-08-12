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
      // PERBAIKAN: Lakukan parsing dari String ke int dengan aman.
      // Jika 'id' dari API berupa String "123", ini akan mengubahnya menjadi int 123.
      // Jika data null atau tidak valid, akan diberi nilai default -1 untuk keamanan.
      id: int.tryParse(json['id'].toString()) ?? -1,

      // PENINGKATAN: Beri nilai default jika data null untuk menghindari error.
      title: json['title'] ?? 'No Title',

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
