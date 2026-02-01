import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser;

    if (!auth.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.account_circle_outlined, size: 80, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('Please login to view your profile', style: TextStyle(fontSize: 18, color: Colors.grey)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF137fec),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () => auth.logout(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundColor: const Color(0xFF137fec).withOpacity(0.1),
              backgroundImage: user!.profileImage != null ? NetworkImage(user.profileImage!) : null,
              child: user.profileImage == null
                  ? const Icon(Icons.person, size: 60, color: Color(0xFF137fec))
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              user.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              user.email,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            _ProfileMenuItem(
              icon: Icons.edit_outlined,
              title: 'Edit Profile',
              onTap: () {
                _showEditProfileDialog(context, auth);
              },
            ),
            _ProfileMenuItem(
              icon: Icons.shopping_bag_outlined,
              title: 'My Orders',
              onTap: () {},
            ),
            _ProfileMenuItem(
              icon: Icons.location_on_outlined,
              title: 'Shipping Address',
              onTap: () {},
            ),
            _ProfileMenuItem(
              icon: Icons.payment_outlined,
              title: 'Payment Methods',
              onTap: () {},
            ),
            _ProfileMenuItem(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () {},
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => auth.logout(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, AuthProvider auth) {
    final nameController = TextEditingController(text: auth.currentUser?.name);
    final imageController = TextEditingController(text: auth.currentUser?.profileImage);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: imageController,
              decoration: const InputDecoration(labelText: 'Profile Image URL'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              auth.updateProfile(nameController.text, imageController.text);
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFF137fec)),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}
