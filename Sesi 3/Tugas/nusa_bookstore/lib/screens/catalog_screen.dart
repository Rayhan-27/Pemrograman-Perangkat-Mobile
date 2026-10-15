import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../providers/cart_provider.dart';
import '../providers/theme_provider.dart';
import 'cart_screen.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NusaBookstore'),
        actions: [
          // Tombol Light/Dark Mode
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                tooltip: 'Ganti tema',
                icon: Icon(
                  themeProvider.isDarkMode
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                onPressed: () => context.read<ThemeProvider>().toggleTheme(),
              );
            },
          ),
          // Ikon keranjang dengan badge jumlah item
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return IconButton(
                tooltip: 'Keranjang',
                icon: Badge(
                  label: Text('${cart.totalItems}'),
                  isLabelVisible: cart.totalItems > 0,
                  child: const Icon(Icons.shopping_cart),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: dummyBooks.length,
        itemBuilder: (context, index) {
          final book = dummyBooks[index];
          return _BookCard(book: book);
        },
      ),
    );
  }
}

// Kartu untuk satu buku
class _BookCard extends StatelessWidget {
  final Book book;

  const _BookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Gambar buku (atau ikon placeholder jika imageUrl kosong)
            Container(
              width: 70,
              height: 95,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: book.imageUrl.isEmpty
                  ? Icon(
                      Icons.menu_book,
                      size: 36,
                      color: colorScheme.onPrimaryContainer,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(book.imageUrl, fit: BoxFit.cover),
                    ),
            ),
            const SizedBox(width: 12),
            // Info buku + tombol
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(book.author),
                  const SizedBox(height: 6),
                  Text(
                    formatRupiah(book.price),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        context.read<CartProvider>().addItem(book);
                      },
                      icon: const Icon(Icons.add_shopping_cart, size: 18),
                      label: const Text('Tambah ke Keranjang'),
                    ),
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