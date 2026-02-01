import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/smartphone.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  CartProvider() {
    _loadCart();
  }

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('cart');
    if (cartData != null) {
      final decodedData = json.decode(cartData) as Map<String, dynamic>;
      _items = decodedData.map((key, value) => MapEntry(key, CartItem.fromJson(value)));
      notifyListeners();
    }
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = json.encode(_items.map((key, value) => MapEntry(key, value.toJson())));
    await prefs.setString('cart', cartData);
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.smartphone.harga * cartItem.quantity;
    });
    return total;
  }

  void addItem(Smartphone smartphone) {
    if (_items.containsKey(smartphone.id)) {
      _items.update(
        smartphone.id,
        (existingCartItem) => CartItem(
          smartphone: existingCartItem.smartphone,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        smartphone.id,
        () => CartItem(smartphone: smartphone),
      );
    }
    _saveCart();
    notifyListeners();
  }

  void removeItem(String smartphoneId) {
    _items.remove(smartphoneId);
    _saveCart();
    notifyListeners();
  }

  void removeSingleItem(String smartphoneId) {
    if (!_items.containsKey(smartphoneId)) {
      return;
    }
    if (_items[smartphoneId]!.quantity > 1) {
      _items.update(
        smartphoneId,
        (existingCartItem) => CartItem(
          smartphone: existingCartItem.smartphone,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(smartphoneId);
    }
    _saveCart();
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _saveCart();
    notifyListeners();
  }
}
