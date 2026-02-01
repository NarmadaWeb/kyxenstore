import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../providers/smartphone_provider.dart';
import '../providers/cart_provider.dart';
import '../models/smartphone.dart';

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6f7f8),
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF137fec).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.smartphone, color: Color(0xFF137fec), size: 20),
            ),
            const SizedBox(width: 12),
            const Text('Premium Mobile'),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          const CircleAvatar(
            radius: 16,
            backgroundImage: CachedNetworkImageProvider('https://picsum.photos/101'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 32, 16, 4),
              child: Text(
                'Marketplace',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: -0.5),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Discover premium pre-owned devices.',
                style: TextStyle(color: Color(0xFF4c739a), fontSize: 14),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildFilterChip('All Brands', true),
                  const SizedBox(width: 12),
                  _buildFilterChip('iPhone', false),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Consumer<SmartphoneProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.error.isNotEmpty) {
                  return Center(child: Text('Error: ${provider.error}'));
                }
                if (provider.smartphones.isEmpty) {
                  return const Center(child: Text('No smartphones found'));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: provider.smartphones.length,
                  itemBuilder: (context, index) {
                    final smartphone = provider.smartphones[index];
                    return _buildMarketplaceItem(context, smartphone, index == 0);
                  },
                );
              },
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF137fec) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isSelected ? null : Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF4c739a),
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.keyboard_arrow_down,
            size: 16,
            color: isSelected ? Colors.white : const Color(0xFF4c739a),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketplaceItem(BuildContext context, Smartphone smartphone, bool isNew) {
    final currencyFormat = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/details', arguments: smartphone),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: CachedNetworkImage(
                    imageUrl: smartphone.gambar,
                    height: 240,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
                if (isNew)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF137fec),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: const Text(
                        'NEW ARRIVAL',
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              smartphone.nama,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Stok: ${smartphone.stok} • Rating: ${smartphone.rating}',
                              style: const TextStyle(color: Color(0xFF4c739a), fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        currencyFormat.format(smartphone.harga),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF137fec)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(height: 1, color: Color(0xFFf1f5f9)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
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
                                      },
                                      child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Row(
                              children: const [
                                Icon(Icons.delete, size: 20, color: Color(0xFF4c739a)),
                                SizedBox(width: 6),
                                Text('DELETE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF4c739a))),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/add-edit', arguments: smartphone),
                            child: Row(
                              children: const [
                                Icon(Icons.edit, size: 20, color: Color(0xFF4c739a)),
                                SizedBox(width: 6),
                                Text('EDIT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF4c739a))),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<CartProvider>().addItem(smartphone);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${smartphone.nama} added to cart')),
                          );
                        },
                        icon: const Icon(Icons.add_shopping_cart, size: 18),
                        label: const Text('Add'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF137fec),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
    );
  }
}
