import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'main.dart';
import 'pageLogin.dart';
import 'keranjang.dart';
import 'pesanan.dart';

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

class FavoriteProducts {
  static final List<Product> _favorites = [];

  static void addFavorite(Product product) {
    if (!_favorites.contains(product)) {
      _favorites.add(product);
    }
  }

  static void removeFavorite(Product product) {
    _favorites.remove(product); // Menghapus produk dari daftar
  }

  static List<Product> get favorites => _favorites;
}

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  String selectedRoute = '/favorite';

  @override
  Widget build(BuildContext context) {
    final favorites = FavoriteProducts.favorites;
    final screenWidth = MediaQuery.of(context).size.width;

    // Menentukan jumlah kolom berdasarkan lebar layar
    int crossAxisCount;
    double cardScale; // Skala ukuran card dan isinya

    if (screenWidth >= 1200) {
      crossAxisCount = 4; // PC: 4 kolom
      cardScale = 2.5; // Ukuran 2.5x mobile
    } else if (screenWidth >= 800) {
      crossAxisCount = 3; // Laptop: 3 kolom
      cardScale = 2.0; // Ukuran 2x mobile
    } else if (screenWidth >= 600) {
      crossAxisCount = 2; // Tablet: 2 kolom
      cardScale = 1.5; // Ukuran 1.5x mobile
    } else {
      crossAxisCount = 2; // Mobile: 2 kolom
      cardScale = 1.0; // Ukuran default
    }

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
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/EmptyFavoritePage.svg',
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Produk Favorite Belum ada yang disimpan',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.7, // Proporsi card
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final product = favorites[index];

                // Format harga ke dalam format rupiah tanpa desimal
                final formattedPrice = NumberFormat.currency(
                  locale: 'id',
                  symbol: 'Rp ',
                  decimalDigits: 0,
                ).format(product.price);

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12 * cardScale),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gambar produk
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12 * cardScale),
                          topRight: Radius.circular(12 * cardScale),
                        ),
                        child: Image.asset(
                          product.imageUrl,
                          height: 120 * cardScale,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Konten di dalam card
                      Padding(
                        padding: EdgeInsets.all(8.0 * cardScale),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16 * cardScale,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4 * cardScale),
                            Text(
                              formattedPrice,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14 * cardScale,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Tombol beli
                      Padding(
                        padding: EdgeInsets.all(8.0 * cardScale),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Tambahkan fungsi jika diperlukan
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow, // Warna tombol
                            foregroundColor: Colors.black, // Warna teks
                            minimumSize: Size(double.infinity, 36 * cardScale),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8 * cardScale),
                            ),
                          ),
                          icon: Icon(
                            Icons.shopping_cart,
                            size: 16 * cardScale, // Ikon mengikuti skala
                          ),
                          label: Text(
                            'Beli',
                            style: TextStyle(fontSize: 14 * cardScale),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
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
      leading: Icon(icon, color: selectedRoute == route ? const Color.fromARGB(255, 40, 98, 206): null),
      title: Text(
        title,
        style: TextStyle(
          color: selectedRoute == route ? const Color.fromARGB(255, 40, 98, 206): null,
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
