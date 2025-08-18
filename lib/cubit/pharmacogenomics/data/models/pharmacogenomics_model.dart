import 'package:m2health/cubit/pharmacogenomics/domain/entities/pharmacogenomics.dart';

class PharmacogenomicsModel extends Pharmacogenomics {
  const PharmacogenomicsModel({
    required int id,
    required int userId,
    required String gene,
    required String genotype,
    required String phenotype,
    required String medicationGuidance,
    String? fullReportPath,
    String? createdAt,
    String? updatedAt,
  }) : super(
          id: id,
          userId: userId,
          gene: gene,
          genotype: genotype,
          phenotype: phenotype,
          medicationGuidance: medicationGuidance,
          fullReportPath: fullReportPath,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory PharmacogenomicsModel.fromJson(Map<String, dynamic> json) {
    print('[DEBUG] PharmacogenomicsModel.fromJson input: $json');
    return PharmacogenomicsModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? -1,
      userId: json['user_id'] is int
          ? json['user_id']
          : int.tryParse(json['user_id'].toString()) ?? -1,
      gene: json['gene']?.toString() ?? '',
      genotype: json['genotype']?.toString() ?? '',
      phenotype: json['phenotype']?.toString() ?? '',
      medicationGuidance: json['medication_guidance']?.toString() ?? '',
      fullReportPath: json['full_report_path']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'gene': gene,
      'genotype': genotype,
      'phenotype': phenotype,
      'medication_guidance': medicationGuidance,
      'full_report_path': fullReportPath,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
