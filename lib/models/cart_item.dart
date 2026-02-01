import 'smartphone.dart';

class CartItem {
  final Smartphone smartphone;
  int quantity;

  CartItem({
    required this.smartphone,
    this.quantity = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      'smartphone': smartphone.toJson()..['id'] = smartphone.id,
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      smartphone: Smartphone.fromJson(json['smartphone']),
      quantity: json['quantity'],
    );
  }
}
