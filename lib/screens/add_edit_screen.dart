import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/smartphone.dart';
import '../providers/smartphone_provider.dart';

class AddEditScreen extends StatefulWidget {
  final Smartphone? smartphone;
  const AddEditScreen({super.key, this.smartphone});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _hargaController;
  late TextEditingController _gambarController;
  late TextEditingController _deskripsiController;
  late TextEditingController _stokController;
  late TextEditingController _ratingController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.smartphone?.nama ?? '');
    _hargaController = TextEditingController(text: widget.smartphone?.harga.toString() ?? '');
    _gambarController = TextEditingController(text: widget.smartphone?.gambar ?? '');
    _deskripsiController = TextEditingController(text: widget.smartphone?.deskripsi ?? '');
    _stokController = TextEditingController(text: widget.smartphone?.stok.toString() ?? '');
    _ratingController = TextEditingController(text: widget.smartphone?.rating.toString() ?? '');
  }

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    _gambarController.dispose();
    _deskripsiController.dispose();
    _stokController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      final newSmartphone = Smartphone(
        id: widget.smartphone?.id ?? '',
        nama: _namaController.text,
        harga: int.tryParse(_hargaController.text) ?? 0,
        gambar: _gambarController.text,
        deskripsi: _deskripsiController.text,
        stok: int.tryParse(_stokController.text) ?? 0,
        rating: double.tryParse(_ratingController.text) ?? 0.0,
      );

      bool success;
      if (widget.smartphone == null) {
        success = await context.read<SmartphoneProvider>().addSmartphone(newSmartphone);
      } else {
        success = await context.read<SmartphoneProvider>().updateSmartphone(newSmartphone);
      }

      if (mounted) {
        if (success) {
          Navigator.pop(context);
        } else {
          final error = context.read<SmartphoneProvider>().error;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save: $error'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.smartphone != null;

    return Scaffold(
      backgroundColor: const Color(0xFFf6f7f8),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(isEditing ? 'Edit Smartphone' : 'Add Smartphone'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF137fec), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFcfdbe7), width: 2, style: BorderStyle.solid),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF137fec).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add_a_photo, color: Color(0xFF137fec), size: 36),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Device photo URL',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Enter the image URL below',
                        style: TextStyle(color: Color(0xFF4c739a), fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('General Information'),
              _buildTextField('Product Name', _namaController, 'e.g. Samsung Galaxy S23'),
              Row(
                children: [
                   Expanded(child: _buildTextField('Price (IDR)', _hargaController, '0', isNumber: true)),
                   Expanded(child: _buildTextField('Stock', _stokController, '0', isNumber: true)),
                ],
              ),
              _buildTextField('Image URL', _gambarController, 'https://example.com/image.jpg'),
              const SizedBox(height: 24),
              _buildSectionTitle('Specifications'),
              _buildTextField('Rating', _ratingController, '0.0', isDouble: true),
              _buildTextField('Description', _deskripsiController, 'Condition, battery health...', maxLines: 4),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Consumer<SmartphoneProvider>(
                  builder: (context, provider, child) {
                    return ElevatedButton(
                      onPressed: provider.isLoading ? null : _saveForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF137fec),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                        shadowColor: const Color(0xFF137fec).withOpacity(0.4),
                      ),
                      child: provider.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.save),
                              const SizedBox(width: 8),
                              Text(isEditing ? 'Update Product' : 'Save Product Listing', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                    );
                  }
                ),
              ),
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  child: Text(
                    'By listing your product, you agree to our Terms of Service.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF4c739a), fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF0d141b).withOpacity(0.6),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint,
      {bool isNumber = false, bool isDouble = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          ),
          TextFormField(
            controller: controller,
            keyboardType: (isNumber || isDouble) ? TextInputType.number : TextInputType.text,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFFcfdbe7)),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFcfdbe7)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFcfdbe7)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF137fec), width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $label';
              }
              if (isNumber && int.tryParse(value) == null) {
                return 'Please enter a valid integer';
              }
              if (isDouble && double.tryParse(value) == null) {
                return 'Please enter a valid decimal number';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
