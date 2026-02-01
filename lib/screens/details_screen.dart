import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/smartphone.dart';
import '../providers/smartphone_provider.dart';
import '../providers/cart_provider.dart';

class DetailsScreen extends StatelessWidget {
  final Smartphone smartphone;
  const DetailsScreen({super.key, required this.smartphone});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);

    return Scaffold(
      backgroundColor: const Color(0xFFf6f7f8),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Smartphone Details'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 320,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
              ),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: smartphone.gambar,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) =>
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == 0 ? Colors.white : Colors.white.withOpacity(0.4),
                          ),
                        )
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF137fec).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'NEW RELEASE',
                          style: TextStyle(color: Color(0xFF137fec), fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Stok: ${smartphone.stok}',
                        style: const TextStyle(color: Color(0xFF4c739a), fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    smartphone.nama,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    currencyFormat.format(smartphone.harga),
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF137fec)),
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Color(0xFFf1f5f9)),
                  const SizedBox(height: 24),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    smartphone.deskripsi,
                    style: const TextStyle(fontSize: 16, color: Color(0xFF4c739a), height: 1.5),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    child: Row(
                      children: const [
                        Text('Read more', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF137fec))),
                        Icon(Icons.keyboard_arrow_down, color: Color(0xFF137fec), size: 18),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Technical Specifications',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildSpecItem(Icons.star, 'Rating', smartphone.rating.toString()),
                      const SizedBox(width: 12),
                      _buildSpecItem(Icons.inventory, 'Stock', smartphone.stok.toString()),
                      const SizedBox(width: 12),
                      _buildSpecItem(Icons.photo_camera, 'Camera', 'Premium'),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Manage Product', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('Only visible to you', style: TextStyle(color: Color(0xFF4c739a), fontSize: 12)),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pushNamed(context, '/add-edit', arguments: smartphone),
                              icon: const Icon(Icons.edit),
                              style: IconButton.styleFrom(
                                side: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Delete'),
                                    content: const Text('Are you sure you want to delete this item?'),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                                      TextButton(
                                        onPressed: () {
                                          context.read<SmartphoneProvider>().deleteSmartphone(smartphone.id);
                                          Navigator.pop(ctx);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                              style: IconButton.styleFrom(
                                side: BorderSide(color: Colors.red.shade100),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Buy Now logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Proceeding to checkout...')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF137fec),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Buy Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 16),
              InkWell(
                onTap: () {
                  context.read<CartProvider>().addItem(smartphone);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${smartphone.nama} added to cart')),
                  );
                },
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF137fec).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add_shopping_cart, color: Color(0xFF137fec)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecItem(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF137fec), size: 24),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF4c739a))),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
