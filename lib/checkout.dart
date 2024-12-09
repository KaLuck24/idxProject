import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'main.dart'; // Import class Product
import 'favorite.dart';
import 'keranjang.dart';
import 'BuatPesanan.dart';

class CheckoutPage extends StatefulWidget {
  final Product product;

  const CheckoutPage({Key? key, required this.product}) : super(key: key);

  @override
  _DetailProdukPageState createState() => _DetailProdukPageState();
}

class _DetailProdukPageState extends State<CheckoutPage> {
  late bool isFavorite;
  late bool isInCart;
  late String formattedPrice;

  @override
  void initState() {
    super.initState();
    isFavorite = FavoriteProducts.favorites.contains(widget.product);
    isInCart = KeranjangProducts.carts.contains(widget.product);
    formattedPrice =
        NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0)
            .format(widget.product.price);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    // Map untuk ukuran dan detailnya
    final Map<String, String> sizeDetails = {
      'S': 'LD 90 cm, P 100 cm',
      'M': 'LD 95 cm, P 105 cm',
      'L': 'LD 100 cm, P 110 cm',
      'XL': 'LD 105 cm, P 115 cm',
      'XXL': 'LD 110 cm, P 120 cm',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar produk
            Container(
              margin: const EdgeInsets.only(top: 1.0),
              child: Image.asset(
                product.imageUrl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8.0),

            // Detail produk
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Text(
                        'Rp $formattedPrice',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (index) => Icon(
                          index < product.rating.round()
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.orange,
                          size: 16.0,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12.0),
                  const Text(
                    'Ukuran Tersedia:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: product.sizes.map((size) {
                      final sizeInfo = sizeDetails[size] ?? 'Tidak tersedia';
                      return Text(
                        '$size: $sizeInfo',
                        style: const TextStyle(fontSize: 14),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Ikon Favorite
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  if (isFavorite) {
                    FavoriteProducts.removeFavorite(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Dihapus dari favorit!')),
                    );
                  } else {
                    FavoriteProducts.addFavorite(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ditambahkan ke favorit!')),
                    );
                  }
                  isFavorite = !isFavorite;
                });
              },
            ),

            // Ikon Cart
            IconButton(
              icon: Icon(
                isInCart ? Icons.shopping_cart : Icons.shopping_cart_outlined,
                color: isInCart ? Colors.orange : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  if (isInCart) {
                    KeranjangProducts.removeFromCart(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Dihapus dari keranjang!')),
                    );
                  } else {
                    KeranjangProducts.addToCarts(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Ditambahkan ke keranjang!')),
                    );
                  }
                  isInCart = !isInCart;
                });
              },
            ),

            // Tombol Beli Sekarang
            const SizedBox(
                width: 8), // Memberi jarak antara ikon Cart dan tombol
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BuatPesananPage(product: product),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Beli Sekarang',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
