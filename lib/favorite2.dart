import 'package:flutter/material.dart';
import 'package:myapp/main.dart';
import 'pageLogin.dart';
import 'keranjang.dart';
import 'pesanan.dart';
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
        // '/favorite': (context) => FavoritePage(),
        '/login': (context) => const LoginPage(),
        '/pesanan': (context) => const PesananPage(),
        '/keranjang': (context) => const KeranjangPage(),
        // '/checkout': (context) => const CheckoutPage(),
      },
    );
  }
}

class FavoritePage extends StatefulWidget {
  FavoritePage({super.key});

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  String selectedRoute = '/favorite';

  final List<Map<String, String>> favoriteItems = [
    {
      "name": "Produk 1",
      "price": "Rp. 100.000",
      "image": "assets/placeholder_image.png",
    },
    {
      "name": "Produk 2",
      "price": "Rp. 200.000",
      "image": "assets/placeholder_image.png",
    },
    {
      "name": "Produk 3",
      "price": "Rp. 150.000",
      "image": "assets/Baju.jpg",
    },
  ];

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
      body: favoriteItems.isEmpty
          ? const Center(
              child: Text(
                'Belum ada barang favorit.',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.8,
                ),
                itemCount: favoriteItems.length,
                itemBuilder: (context, index) {
                  final item = favoriteItems[index];
                  return Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12.0),
                            topRight: Radius.circular(12.0),
                          ),
                          child: Image.asset(
                            item['image']!,
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name']!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                item['price']!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
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
        if (route == '/home' || route == '/favorite') {
          Navigator.popUntil(context, ModalRoute.withName('/'));
          Navigator.pushReplacementNamed(context, route);
        } else {
          Navigator.popAndPushNamed(context, route);
        }
      },
    );
  }
}
