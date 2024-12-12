import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:myapp/main.dart';
import 'pageLogin.dart';
import 'favorite.dart';
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
        '/favorite': (context) => const FavoritePage(),
        '/login': (context) => const LoginPage(),
        '/pesanan': (context) => const PesananPage(),
        // '/checkout': (context) => const CheckoutPage(),
      },
    );
  }
}

class KeranjangProducts {
  static final List<Product> _keranjang = [];

  static void addToCarts(Product product) {
    if (!_keranjang.contains(product)) {
      _keranjang.add(product);
    }
  }

  static void removeFromCart(Product product) {
    _keranjang.remove(product);
  }

  static void removeToCarts(Product product) {
    _keranjang.remove(product); // Menghapus produk dari daftar
  }

  static List<Product> get carts => _keranjang;
}

class KeranjangPage extends StatefulWidget {
  const KeranjangPage({super.key});
  @override
  _KeranjangPageState createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  String selectedRoute = '/keranjang';
  String _generateProductDetails(Product product) {
    // Filter ukuran yang memiliki quantity > 0
    String sizes = product.selectedSizes.entries
        .where((entry) => entry.value > 0) // Hanya ukuran dengan jumlah > 0
        .map((entry) => '${entry.key}(${entry.value})')
        .join(', ');

    // Gabungkan nama produk dengan ukuran
    return sizes.isNotEmpty ? "${product.name} ($sizes)" : product.name;
  }

  List<Product> selectedProducts = [];

  @override
  Widget build(BuildContext context) {
    final carts = KeranjangProducts.carts;
    List<Product> selectedProducts =
        carts.where((product) => product.isSelected).toList();

    int totalItems = selectedProducts.length;

    final totalPriceProductAll = selectedProducts.fold(0.0, (sum, product) {
      return sum + product.totalPrice; // Pastikan tipe konsisten (double).
    });

    final totalPayment =
        selectedProducts.isNotEmpty ? totalPriceProductAll + 4000 + 3000 : 0.0;

    String productNames = selectedProducts
        .map((product) => _generateProductDetails(product))
        .join(', ');

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
      body: carts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/EmptyKeranjangPage.svg',
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'belum ada produk yg ditambahkan',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: carts.length,
                    itemBuilder: (context, index) {
                      final product = carts[index];
                      final formattedTotalPrice = NumberFormat.currency(
                        locale: 'id',
                        symbol: '',
                        decimalDigits: 0,
                      ).format(product.totalPrice);

                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: product.isSelected
                            ? Colors.yellow[100]
                            : Colors.white,
                        child: Padding(
                          padding:
                              const EdgeInsets.all(8.0), // Padding pada card
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    value: product.isSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        product.isSelected = value!;
                                      });
                                    },
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      product.imageUrl,
                                      height: 100,
                                      width: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Rp $formattedTotalPrice',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (carts[index].quantity > 0) {
                                              // Kurangi jumlah ukuran yang aktif
                                              if (carts[index].activeSize !=
                                                      null &&
                                                  carts[index]
                                                      .selectedSizes
                                                      .containsKey(carts[index]
                                                          .activeSize!)) {
                                                String activeSize =
                                                    carts[index].activeSize!;
                                                carts[index].selectedSizes[
                                                        activeSize] =
                                                    carts[index].selectedSizes[
                                                            activeSize]! -
                                                        1;

                                                // Jika jumlah ukuran tersebut mencapai 0, hapus dari daftar
                                                if (carts[index].selectedSizes[
                                                        activeSize]! <=
                                                    0) {
                                                  carts[index]
                                                      .selectedSizes
                                                      .remove(activeSize);
                                                  carts[index].activeSize =
                                                      null;
                                                }
                                              }

                                              // Kurangi total quantity
                                              carts[index].quantity--;

                                              // Perbarui total harga
                                              carts[index].updateTotalPrice();
                                            }

                                            // Jika quantity kurang dari 0, tampilkan pop-up konfirmasi
                                            if (carts[index].quantity <= 0) {
                                              carts[index].quantity =
                                                  0; // Pastikan quantity tidak negatif
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        "Hapus Produk"),
                                                    content: const Text(
                                                        "Apakah Anda ingin menghapus produk ini dari keranjang?"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          // Jika pengguna memilih "Tidak", kembalikan quantity ke 0
                                                          setState(() {
                                                            carts[index]
                                                                .quantity = 0;
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child:
                                                            const Text("Tidak"),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          // Jika pengguna memilih "Ya", hapus produk dari keranjang
                                                          setState(() {
                                                            carts.removeAt(
                                                                index);
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text("Ya"),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          });
                                        },
                                        icon: const Icon(
                                            Icons.remove_circle_outline),
                                      ),
                                      Text(product.quantity.toString()),
                                      // IconButton(
                                      //   onPressed: () {
                                      //     setState(() {
                                      //       product.increaseQuantity();
                                      //       product.totalPrice = product.price *
                                      //           product.quantity;
                                      //     });
                                      //   },
                                      //   icon: const Icon(
                                      //       Icons.add_circle_outline),
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Ukuran:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Wrap untuk tombol sizes agar tetap di dalam card
                              Wrap(
                                spacing: 8.0,
                                children: carts[index].sizes.map((size) {
                                  return ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        // Cek apakah ukuran sudah ada di dalam selectedSizes
                                        if (carts[index]
                                            .selectedSizes
                                            .containsKey(size)) {
                                          // Jika ada, tambah jumlahnya
                                          carts[index].selectedSizes[size] =
                                              carts[index]
                                                      .selectedSizes[size]! +
                                                  1;
                                        } else {
                                          // Jika tidak ada, tambahkan ukuran baru dengan jumlah 1
                                          carts[index].selectedSizes[size] = 1;
                                        }

                                        // Tambahkan quantity total
                                        carts[index].quantity++;

                                        // Tandai ukuran aktif
                                        carts[index].activeSize = size;

                                        // Perbarui total harga
                                        carts[index].updateTotalPrice();
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          carts[index].activeSize == size
                                              ? Colors.yellow
                                              : Colors.grey,
                                      minimumSize: const Size(40, 30),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0, horizontal: 8.0),
                                      textStyle: const TextStyle(fontSize: 12),
                                    ),
                                    child: Text(
                                        size), // Misalnya S, M, L, XL, dll.
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (selectedProducts.isNotEmpty)
                  Card(
                    margin: const EdgeInsets.all(8.0),
                    color: Colors.yellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.receipt_long,
                              color: Colors.orange, size: 24),
                          const SizedBox(height: 8),
                          const Text(
                            'Rincian Pembayaran',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const Divider(),
                          Text('Nama Produk: $productNames'),
                          Text('Jumlah Produk: $totalItems'),
                          Text(
                            'Total Harga Produk: Rp${NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format(totalPriceProductAll)}',
                          ),
                          const Text('Ongkos Kirim: Rp4.000'),
                          const Text('Biaya Admin: Rp3.000'),
                          const Text(
                              'Alamat Pengiriman: 3MR6+CQP, Jl. Urip Sumoharjo, Pekalongan'),
                        ],
                      ),
                    ),
                  ),
                Container(
                  color: Colors.grey[300],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total pembayaran:'),
                          Text(
                            'Rp ${NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format(totalPayment)}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: selectedProducts.isNotEmpty
                            ? () {
                                // Menghitung tanggal pengiriman
                                DateTime now = DateTime.now();
                                DateTime shippingDate =
                                    now.add(const Duration(days: 3));
                                String dayName = DateFormat.EEEE('id')
                                    .format(shippingDate); // Nama hari
                                String formattedShippingDate =
                                    DateFormat('d MMMM', 'id')
                                        .format(shippingDate); // Format tanggal
                                String shippingDateText =
                                    '$dayName, $formattedShippingDate';

                                final paymentDetails = {
                                  'productNames': productNames,
                                  'totalItems': totalItems,
                                  'totalPriceProductAll': totalPriceProductAll,
                                  'shippingAddress':
                                      '3MR6+CQP, Jl. Urip Sumoharjo, Pringlangu, Kec. Pekalongan Bar., Kota Pekalongan, Jawa Tengah 51117',
                                  'shippingDate': shippingDateText,
                                  'productDetails': selectedProducts
                                      .map((product) {
                                        return product.selectedSizes.entries
                                            .map((entry) {
                                          return {
                                            'productName': product.name,
                                            'size': entry.key,
                                            'quantity': entry.value,
                                          };
                                        }).toList();
                                      })
                                      .expand((x) => x)
                                      .toList(),
                                };

                                // Menyimpan data pesanan
                                Product.savedOrders.add(paymentDetails);

                                // Menampilkan dialog konfirmasi
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Pesanan Berhasil'),
                                    content: const Text(
                                        'Pesanan Anda telah berhasil disimpan.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Tutup'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(
                                              context); // Tutup dialog
                                          Navigator.pushNamed(
                                              context, '/pesanan');
                                        },
                                        child: const Text('Lihat Pesanan'),
                                      ),
                                    ],
                                  ),
                                );
                                // Product.savedOrders.removeWhere((order) {
                                //   final shippingDateText =
                                //       order['shippingDate'];
                                //   DateTime orderShippingDate =
                                //       DateFormat('EEEE, d MMMM', 'id')
                                //           .parse(shippingDateText);

                                //   // Hapus jika tanggal pengiriman telah lewat
                                //   return orderShippingDate
                                //       .isBefore(DateTime.now());
                                // });
                              }
                            : null,
                        child: const Text('Buat Pesanan'),
                      ),
                    ],
                  ),
                ),
              ],
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
        if (route == '/home' || route == '/keranjang') {
          Navigator.popUntil(context, ModalRoute.withName('/'));
          Navigator.pushReplacementNamed(context, route);
        } else {
          Navigator.popAndPushNamed(context, route);
        }
      },
    );
  }
}
