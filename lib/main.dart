import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/smartphone_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'screens/navigation_container.dart';
import 'screens/details_screen.dart';
import 'screens/add_edit_screen.dart';
import 'models/smartphone.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SmartphoneProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Smartphone Marketplace',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF137fec),
            primary: const Color(0xFF137fec),
          ),
          scaffoldBackgroundColor: const Color(0xFFf6f7f8),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            titleTextStyle: TextStyle(
              color: Color(0xFF0d141b),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: Color(0xFF137fec),
            unselectedItemColor: Color(0xFF4c739a),
            backgroundColor: Colors.white,
          ),
        ),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          if (settings.name == '/') {
            return MaterialPageRoute(builder: (_) => const NavigationContainer());
          }
          if (settings.name == '/details') {
            final smartphone = settings.arguments as Smartphone;
            return MaterialPageRoute(builder: (_) => DetailsScreen(smartphone: smartphone));
          }
          if (settings.name == '/add-edit') {
            final smartphone = settings.arguments as Smartphone?;
            return MaterialPageRoute(builder: (_) => AddEditScreen(smartphone: smartphone));
          }
          return null;
        },
      ),
    );
  }
}
