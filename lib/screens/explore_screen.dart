import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../providers/smartphone_provider.dart';
import '../providers/cart_provider.dart';
import '../models/smartphone.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String selectedBrand = 'All';
  final List<String> brands = ['All', 'Samsung', 'Apple', 'Google', 'Xiaomi'];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<SmartphoneProvider>().fetchSmartphones();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6f7f8),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Explore',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0d141b),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: CachedNetworkImageProvider('https://picsum.photos/100'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search smartphones...',
                    hintStyle: TextStyle(color: Color(0xFF4c739a)),
                    prefixIcon: Icon(Icons.search, color: Color(0xFF4c739a)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 36,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: brands.length,
                itemBuilder: (context, index) {
                  final brand = brands[index];
                  final isSelected = selectedBrand == brand;
                  return GestureDetector(
                    onTap: () => setState(() => selectedBrand = brand),
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF137fec) : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: isSelected ? null : Border.all(color: Colors.grey.shade200),
                        boxShadow: isSelected
                            ? [BoxShadow(color: const Color(0xFF137fec).withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2))]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        brand,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : const Color(0xFF4c739a),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<SmartphoneProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (provider.error.isNotEmpty) {
                    return Center(child: Text('Error: ${provider.error}'));
                  }

                  final filteredList = provider.smartphones.where((s) {
                    if (selectedBrand == 'All') return true;
                    return s.nama.toLowerCase().contains(selectedBrand.toLowerCase());
                  }).toList();

                  if (filteredList.isEmpty) {
                    return const Center(child: Text('No smartphones found'));
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final smartphone = filteredList[index];
                      return SmartphoneGridItem(smartphone: smartphone);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SmartphoneGridItem extends StatelessWidget {
  final Smartphone smartphone;
  const SmartphoneGridItem({super.key, required this.smartphone});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/details', arguments: smartphone),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFf8fafc),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CachedNetworkImage(
                  imageUrl: smartphone.gambar,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              smartphone.nama,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0d141b),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  currencyFormat.format(smartphone.harga),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF137fec),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    context.read<CartProvider>().addItem(smartphone);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${smartphone.nama} added to cart'),
                        duration: const Duration(seconds: 1),
                        action: SnackBarAction(
                          label: 'VIEW',
                          onPressed: () {
                            // This might need a way to switch tabs, but for now just a message
                          },
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF137fec),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.add_shopping_cart, size: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(height: 1, color: Color(0xFFf1f5f9)),
            const SizedBox(height: 8),
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/add-edit', arguments: smartphone),
                  child: Row(
                    children: const [
                      Icon(Icons.edit, size: 18, color: Color(0xFF4c739a)),
                      SizedBox(width: 4),
                      Text('Edit', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF4c739a))),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
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
                      Icon(Icons.delete, size: 18, color: Color(0xFF4c739a)),
                      SizedBox(width: 4),
                      Text('Delete', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF4c739a))),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
