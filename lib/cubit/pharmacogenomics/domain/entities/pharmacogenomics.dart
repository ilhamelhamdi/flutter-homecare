import 'package:equatable/equatable.dart';

class Pharmacogenomics extends Equatable {
  final int id;
  final int userId;
  final String gene;
  final String genotype;
  final String phenotype;
  final String medicationGuidance;
  final String? fullReportPath;
  final String? createdAt;
  final String? updatedAt;

  const Pharmacogenomics({
    required this.id,
    required this.userId,
    required this.gene,
    required this.genotype,
    required this.phenotype,
    required this.medicationGuidance,
    this.fullReportPath,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        gene,
        genotype,
        phenotype,
        medicationGuidance,
        fullReportPath,
        createdAt,
        updatedAt,
      ];
}
