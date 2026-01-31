import 'package:flutter_test/flutter_test.dart';
import 'package:kyxenstore/models/smartphone.dart';

void main() {
  group('Smartphone Model', () {
    test('fromJson should create a Smartphone object', () {
      final json = {
        'id': '1',
        'nama': 'Samsung Galaxy S23',
        'harga': 12000000,
        'gambar': 'https://picsum.photos/200/300?random=1',
        'deskripsi': 'HP flagship Samsung',
        'stok': 10,
        'rating': 4.7,
      };

      final smartphone = Smartphone.fromJson(json);

      expect(smartphone.id, '1');
      expect(smartphone.nama, 'Samsung Galaxy S23');
      expect(smartphone.harga, 12000000);
      expect(smartphone.rating, 4.7);
    });

    test('toJson should return a valid Map', () {
      final smartphone = Smartphone(
        id: '1',
        nama: 'Samsung Galaxy S23',
        harga: 12000000,
        gambar: 'https://picsum.photos/200/300?random=1',
        deskripsi: 'HP flagship Samsung',
        stok: 10,
        rating: 4.7,
      );

      final json = smartphone.toJson();

      expect(json['nama'], 'Samsung Galaxy S23');
      expect(json['harga'], 12000000);
      expect(json['stok'], 10);
    });
  });
}
