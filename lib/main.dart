import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'keranjang.dart';
import 'checkout.dart';
import 'pageLogin.dart';
import 'favorite.dart';
import 'pesanan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proyek Kustom',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      routes: {
        '/login': (context) => const LoginPage(),
        // '/checkout': (context) => const CheckoutPage(),
        '/favorite': (context) => const FavoritePage(),
        '/keranjang': (context) => const KeranjangPage(),
        '/pesanan': (context) => const PesananPage(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  //List Produk Card
  final List<Product> products = [
    Product(
      name: 'Batik',
      description: 'Batik daster berbahan katun berkualitas...',
      imageUrl: 'assets/images/ProdukBaju1.jpeg',
      price: 9999,
      rating: 2,
      sizes: ['S', 'M', 'L', 'XXL'],
      
    ),
    Product(
      name: 'Daster',
      description: 'Daster Batik Khas Pekalongan',
      imageUrl: 'assets/baju.jpg',
      price: 250000,
      rating: 5,
      sizes: ['M', 'L', 'XL', 'XXL'],
    
    ),
    Product(
      name: 'Baju Anak',
      description:
          'Baju anak yg sangat cocok untuk hari batik maupun acara lainnyaa...',
      imageUrl: 'assets/images/ProdukBaju1.jpeg',
      price: 120000,
      rating: 4,
      sizes: ['L', 'XL', 'S', 'M'],
    ),
  ];

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedRoute = '/home';
  String searchLabel = 'Untukmu>';
  TextEditingController searchController = TextEditingController();
  List<Product> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    filteredProducts = widget.products; // Awalnya tampilkan semua produk
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        // Jika input kosong, tampilkan semua produk
        filteredProducts = widget.products;
        searchLabel = 'Untukmu>';
      } else {
        // Filter produk berdasarkan input dan ubah teks label
        filteredProducts = widget.products
            .where((product) =>
                product.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
        searchLabel = 'mencari barang "$query"';
      }
    });
  }

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
            ListTile(
              selected:
                  selectedRoute == '/home', // Aktif jika di halaman 'Beranda'
              selectedTileColor:
                  Colors.blue.withOpacity(0.2), // Warna latar saat aktif
              leading: Icon(Icons.home,
                  color: selectedRoute == '/home' ? Colors.yellow : null),
              title: Text(
                'Beranda',
                style: TextStyle(
                  color: selectedRoute == '/home' ? Colors.yellow : null,
                  fontWeight: selectedRoute == '/home'
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              onTap: () {
                setState(() {
                  selectedRoute = '/home'; // Update route aktif
                });
                Navigator.pop(context); // Tutup drawer
              },
            ),
            ListTile(
              selected: selectedRoute ==
                  '/favorite', // Aktif jika di halaman 'Favorite'
              selectedTileColor: Colors.blue.withOpacity(0.2),
              leading: Icon(Icons.favorite,
                  color: selectedRoute == '/favorite' ? Colors.yellow : null),
              title: Text(
                'Favorite',
                style: TextStyle(
                  color: selectedRoute == '/favorite' ? Colors.yellow : null,
                  fontWeight: selectedRoute == '/favorite'
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              onTap: () {
                // setState(() {
                //   selectedRoute = '/favorite'; // Update route aktif
                // });
                Navigator.pushNamed(
                    context, '/favorite'); // Navigasi ke halaman Favorite
              },
            ),
            ListTile(
              selected: selectedRoute ==
                  '/keranjang', // Aktif jika di halaman 'Keranjang'
              selectedTileColor: Colors.blue.withOpacity(0.2),
              leading: Icon(Icons.shopping_cart,
                  color: selectedRoute == '/keranjang' ? Colors.yellow : null),
              title: Text(
                'Keranjang',
                style: TextStyle(
                  color: selectedRoute == '/keranjang' ? Colors.yellow : null,
                  fontWeight: selectedRoute == '/keranjang'
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              onTap: () {
                // setState(() {
                //   selectedRoute = '/keranjang';
                // });
                Navigator.pushNamed(
                    context, '/keranjang'); // Navigasi ke halaman Favorite
              },
            ),
            ListTile(
              selected: selectedRoute ==
                  '/pesanan', // Aktif jika di halaman 'Pesanan saya'
              selectedTileColor: Colors.blue.withOpacity(0.2),
              leading: Icon(Icons.list,
                  color: selectedRoute == '/pesanan' ? Colors.yellow : null),
              title: Text(
                'Pesanan saya',
                style: TextStyle(
                  color: selectedRoute == '/pesanan' ? Colors.yellow : null,
                  fontWeight: selectedRoute == '/pesanan'
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              onTap: () {
                // setState(() {
                //   selectedRoute = '/pesanan';
                // });
                Navigator.pushNamed(
                    context, '/pesanan'); // Navigasi ke halaman Favorite
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Mau cari apa hari ini?',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                width: 300,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: 'Cari Barang',
                          border: InputBorder.none,
                        ),
                        cursorColor: const Color.fromARGB(255, 126, 126, 126),
                        cursorWidth: 2.0,
                        onChanged: _filterProducts,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          _filterProducts(searchController.text);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  searchLabel,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical:
                        8.0), // Memberikan sedikit jarak antara search label dan produk
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (filteredProducts.isEmpty)
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/Notfound.svg',
                              width: 200,
                              height: 200,
                            ),
                            const SizedBox(height: 16.0),
                            const Text(
                              'Produk tidak ditemukan',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      // Menambahkan SingleChildScrollView untuk scroll horizontal
                      SingleChildScrollView(
                        scrollDirection:
                            Axis.horizontal, // Membuat scroll horizontal
                        child: Row(
                          children: filteredProducts.map((product) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  right:
                                      8.0), // Memberikan jarak antar produk di row
                              child: ProductCard(
                                product: product,
                                onBuyPressed: (product) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CheckoutPage(product: product),
                                    ),
                                  );
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final Function(Product) onBuyPressed;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onBuyPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mendapatkan ukuran layar
    final screenWidth = MediaQuery.of(context).size.width;
    final formattedPrice =
        NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0)
            .format(product.price);

    // Menyesuaikan ukuran card berdasarkan lebar layar
    final isMobile = screenWidth <= 480;
    final cardWidth = isMobile ? screenWidth * 0.4 : 150.0;
    final cardHeight = isMobile ? cardWidth * 1.5 : 211.0;

    return Container(
      width: cardWidth,
      height: cardHeight,
      margin: const EdgeInsets.only(right: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Gambar Produk
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
              child: Image.asset(
                product.imageUrl,
                height: cardHeight * 0.55, // Proporsional dengan tinggi card
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // Bagian Detail Produk
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    product.description,
                    maxLines: 1, // Membatasi deskripsi menjadi 1 baris
                    overflow: TextOverflow
                        .ellipsis, // Menambahkan titik-titik jika teks terlalu panjang
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Bagian Harga
                      Text(
                        'Rp $formattedPrice',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Tombol Beli
                      SizedBox(
                        height: cardHeight * 0.15, // Tinggi tombol responsif
                        child: ElevatedButton(
                          onPressed: () => onBuyPressed(product),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange, // Warna tombol
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal:
                                  12.0, // Padding tombol agar proporsional
                            ),
                          ),
                          child: const Text(
                            'Beli',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
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
    );
  }
}

class Product {
  final String name;
  final String description;
  final String imageUrl;
  final List<String> sizes;
  final double price;
  final double rating;
  int quantity;
  double totalPrice;
  bool isSelected;
  bool isCheckBoxCart;
  Map<String, int> sizeQuantities;

  Product({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.sizes,
    required this.price,
    required this.rating,
    this.quantity = 1,
    this.isSelected = false,
    this.isCheckBoxCart = false,
    Map<String, int>? sizeQuantities,
  })  : totalPrice = price * (sizeQuantities?[sizes.first] ?? 1),
        sizeQuantities = sizeQuantities ?? {sizes.first: 1};

  void increaseQuantity() {
    quantity++;
    updateTotalPrice();
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      quantity--;
      updateTotalPrice();
    }
  }

  void updateTotalPrice() {
    totalPrice = price * quantity; // Update total price based on quantity
  }

  String getFormattedPrice() {
    // Format the price with currency formatting
    return NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(totalPrice);
  }
}

