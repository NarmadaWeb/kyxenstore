class Smartphone {
  final String id;
  final String nama;
  final int harga;
  final String gambar;
  final String deskripsi;
  final int stok;
  final double rating;

  Smartphone({
    required this.id,
    required this.nama,
    required this.harga,
    required this.gambar,
    required this.deskripsi,
    required this.stok,
    required this.rating,
  });

  factory Smartphone.fromJson(Map<String, dynamic> json) {
    return Smartphone(
      id: json['id']?.toString() ?? '',
      nama: json['nama'] ?? '',
      harga: json['harga'] is int ? json['harga'] : int.tryParse(json['harga']?.toString() ?? '0') ?? 0,
      gambar: json['gambar'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      stok: json['stok'] is int ? json['stok'] : int.tryParse(json['stok']?.toString() ?? '0') ?? 0,
      rating: json['rating'] is double ? json['rating'] : double.tryParse(json['rating']?.toString() ?? '0.0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'harga': harga,
      'gambar': gambar,
      'deskripsi': deskripsi,
      'stok': stok,
      'rating': rating,
    };
  }
}
