import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/buku_list_page.dart';
import 'pages/buku_form_page.dart';
import 'pages/buku_detail_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String appName = 'Responsi 2 Mobile Paket 3 H1D023006';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        primarySwatch: Colors.brown,
        useMaterial3: false,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/buku': (_) => const BukuListPage(appBarTitle: 'Inventaris Buku Alyaaamart'),
        '/buku/add': (_) => const BukuFormPage(appBarTitle: 'Tambah Inventaris Alyaaamart'),
        '/buku/tambah': (_) => const BukuFormPage(appBarTitle: 'Tambah Inventaris Alyaaamart'),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/buku/detail') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => BukuDetailPage(id: args['id'], appBarTitle: 'Detail Inventaris Alyaaamart'),
          );
        }
        if (settings.name == '/buku/edit') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => BukuFormPage(id: args['id'], appBarTitle: 'Edit Inventaris Alyaaamart'),
          );
        }
        return null;
      },
    );
  }
}
