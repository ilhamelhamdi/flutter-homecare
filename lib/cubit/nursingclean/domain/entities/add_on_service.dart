import 'package:equatable/equatable.dart';

class AddOnService extends Equatable {
  final String name;
  final String? description;
  final double price;

  const AddOnService({
    required this.name,
    this.description,
    required this.price,
  });

  @override
  List<Object?> get props => [name, description, price];
}
