import 'package:flutter/material.dart';
import 'package:myapp/main.dart';
import 'package:intl/intl.dart';
import 'pageLogin.dart';
import 'keranjang.dart';
import 'favorite.dart';
// import 'checkout.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proyek Kustom',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomeScreen(),
        '/favorite': (context) => const FavoritePage(),
        '/login': (context) => const LoginPage(),
        '/keranjang': (context) => const KeranjangPage(),
        // '/checkout': (context) => const CheckoutPage(),
      },
    );
  }
}

class PesananPage extends StatefulWidget {
  const PesananPage({super.key});
  @override
  _PesananPageState createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage> {
  String selectedRoute = '/pesanan';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Builder(
          builder: (context) => GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: const Text(
              'KAY',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'NothingYouCould',
                color: Color.fromARGB(255, 62, 19, 216),
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: const Color.fromARGB(255, 0, 140, 255),
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    title: const Text("Menu"),
                  ),
                  Container(
                    color: const Color.fromARGB(255, 0, 140, 255),
                    padding: const EdgeInsets.symmetric(
                        vertical: 27.0, horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          child: Icon(Icons.person, size: 50),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Guest",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              child: const Text(
                                "tambahkan akun",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromRGBO(163, 64, 255, 1),
                                  decoration: TextDecoration.underline,
                                ),
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
            _drawerTile(
              context,
              title: 'Beranda',
              icon: Icons.home,
              route: '/home',
              selectedRoute: selectedRoute,
            ),
            _drawerTile(
              context,
              title: 'Favorite',
              icon: Icons.favorite,
              route: '/favorite',
              selectedRoute: selectedRoute,
            ),
            _drawerTile(
              context,
              title: 'Keranjang',
              icon: Icons.shopping_cart,
              route: '/keranjang',
              selectedRoute: selectedRoute,
            ),
            _drawerTile(
              context,
              title: 'Pesanan Saya',
              icon: Icons.list,
              route: '/pesanan',
              selectedRoute: selectedRoute,
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          'Ini adalah halaman Pesanan.',
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      ),
    );
  }

  Widget _drawerTile(BuildContext context,
      {required String title,
      required IconData icon,
      required String route,
      required String selectedRoute}) {
    return ListTile(
      selected: selectedRoute == route,
      selectedTileColor: Colors.blue.withOpacity(0.2),
      leading: Icon(icon, color: selectedRoute == route ? Colors.yellow : null),
      title: Text(
        title,
        style: TextStyle(
          color: selectedRoute == route ? Colors.yellow : null,
          fontWeight:
              selectedRoute == route ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        setState(() {
          this.selectedRoute = route;
        });

        // Jika navigasi ke '/home', pastikan menggunakan Navigator.pushReplacement
        if (route == '/home' || route == '/pesanan') {
          Navigator.popUntil(context, ModalRoute.withName('/'));
          Navigator.pushReplacementNamed(context, route);
        } else {
          Navigator.popAndPushNamed(context, route);
        }
      },
    );
  }
}
