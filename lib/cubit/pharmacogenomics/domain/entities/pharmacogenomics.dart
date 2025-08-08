import 'package:equatable/equatable.dart';

class Pharmacogenomics extends Equatable {
  final int id;
  final String title;
  final String? description;
  final String? fileUrl;

  const Pharmacogenomics({
    required this.id,
    required this.title,
    this.description,
    this.fileUrl,
  });

  @override
  List<Object?> get props => [id, title, description, fileUrl];
}
