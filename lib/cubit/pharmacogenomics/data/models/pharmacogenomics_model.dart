import 'package:m2health/cubit/pharmacogenomics/domain/entities/pharmacogenomics.dart';

class PharmacogenomicsModel extends Pharmacogenomics {
  final int userId;
  final String gene;
  final String genotype;
  final String phenotype;
  final String medicationGuidance;
  final String? fullReportPath;
  final String? createdAt;
  final String? updatedAt;

  const PharmacogenomicsModel({
    required int id,
    required this.userId,
    required this.gene,
    required this.genotype,
    required this.phenotype,
    required this.medicationGuidance,
    this.fullReportPath,
    this.createdAt,
    this.updatedAt,
  }) : super(
          id: id,
          userId: userId,
          gene: gene,
          genotype: genotype,
          phenotype: phenotype,
          medicationGuidance: medicationGuidance,
          fileUrl: fullReportPath,
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
