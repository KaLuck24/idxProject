import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'main.dart';

class BuatPesananPage extends StatefulWidget {
  final Product product;

  const BuatPesananPage({Key? key, required this.product}) : super(key: key);

  @override
  State<BuatPesananPage> createState() => _BuatPesananPageState();
}

class _BuatPesananPageState extends State<BuatPesananPage> {
  late String selectedSize;

   @override
  void initState() {
    super.initState();
    selectedSize = widget.product.sizes.first; // Default ukuran pertama
  }

  void _updateSizeQuantities(String size) {
    setState(() {
      if (widget.product.sizeQuantities.containsKey(size)) {
        widget.product.sizeQuantities[size] =
            (widget.product.sizeQuantities[size]! + 1);
      } else {
        widget.product.sizeQuantities[size] = 1;
      }
    });
  }

   String _getSizeDetails() {
    return widget.product.sizeQuantities.entries
        .map((entry) => "${entry.key}(${entry.value})")
        .join(", ");
  }

  @override
  Widget build(BuildContext context) {
    final formattedPrice =
        NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0)
            .format(widget.product.totalPrice);

    // Data Dummy untuk Rincian Pembayaran
    const int ongkosKirim = 4000;
    const int biayaAdmin = 3000;
    final double totalPembayaran =
        widget.product.totalPrice + ongkosKirim + biayaAdmin;

    final String formattedOngkosKirim =
        NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0)
            .format(ongkosKirim);
    final String formattedBiayaAdmin =
        NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0)
            .format(biayaAdmin);
    final String formattedTotalPembayaran =
        NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0)
            .format(totalPembayaran);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian atas: Gambar dan informasi produk
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row untuk Gambar Produk, Nama, dan Harga
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gambar Produk
                    Image.asset(
                      widget.product.imageUrl,
                      width: 100,
                      height: 125,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 16.0), // Jarak antar gambar dan teks

                    // Nama Produk dan Harga di dalam Kolom
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Nama Produk
                        Text(
                          widget.product.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 76.0), // Jarak antar teks

                        // Harga Produk
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
                    const Spacer(), // Memisahkan tombol di sebelah kanan

                    // Tombol Tambah & Kurang
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: widget.product.quantity > 1
                                  ? () {
                                      setState(() {
                                        widget.product.quantity--;
                                        widget.product.totalPrice =
                                            widget.product.quantity *
                                                widget.product.price;
                                        widget.product.sizeQuantities.clear();
                                        widget.product.sizeQuantities[selectedSize] =
                                            widget.product.quantity;
                                      });
                                    }
                                  : null,
                              icon: Icon(
                                Icons.remove_circle_outline,
                                color: widget.product.quantity > 1
                                    ? Colors.orange
                                    : Colors.grey,
                              ),
                            ),
                            Text(widget.product.quantity.toString()),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  widget.product.quantity++;
                                  widget.product.totalPrice =
                                      widget.product.quantity *
                                          widget.product.price;
                                  _updateSizeQuantities(selectedSize);
                                });
                              },
                              icon: const Icon(
                                Icons.add_circle_outline,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10.0), // Jarak antara gambar dan teks ukuran

                // Teks 'Ukuran:' di bawah gambar
                const Text(
                  'Ukuran :',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8.0),

                // Tombol Ukuran
                const SizedBox(height: 8.0),
                Row(
                  children: widget.product.sizes.map((size) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedSize = size;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedSize == size
                              ? Colors.orange
                              : Colors.grey[200],
                        ),
                        child: Text(
                          size,
                          style: TextStyle(
                            color: selectedSize == size
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const Divider(thickness: 1.0),

          // Bagian tengah: Rincian pembayaran
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.orange[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.receipt_long, color: Colors.orange, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Rincian Pembayaran',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Nama Produk: ${widget.product.name} (${_getSizeDetails()})',
                ),
                const SizedBox(height: 4.0),
                Text('Total Harga Produk : $formattedPrice'),
                const SizedBox(height: 4.0),
                Text('Ongkos kirim : $formattedOngkosKirim'),
                const SizedBox(height: 4.0),
                Text('Biaya Admin : $formattedBiayaAdmin'),
                const SizedBox(height: 4.0),
                const Text(
                  'Alamat Pengiriman : ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4.0),
                const Text(
                  '3MR6+CQP, Jl. Urip Sumoharjo, Pringlangu,\nKec. Pekalongan Bar., Kota Pekalongan, Jawa Tengah 51117',
                ),
              ],
            ),
          ),

          // Bagian bawah: Total pembayaran dan tombol
          Expanded(
            child: Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total pembayaran : $formattedTotalPembayaran',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pesanan berhasil dibuat!'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 12.0,
                      ),
                    ),
                    child: const Text(
                      'Buat Pesanan',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
