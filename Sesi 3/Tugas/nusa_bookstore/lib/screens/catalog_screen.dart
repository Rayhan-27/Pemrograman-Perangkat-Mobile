import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  static const List<String> _categories = [
    'Semua',
    'Sastra Indonesia',
    'Self Improvement',
    'Novel Populer',
  ];

  String _category = 'Semua';
  String _query = '';

  // Daftar buku setelah dikenai filter chip + pencarian
  List<Book> get _filteredBooks {
    final q = _query.trim().toLowerCase();
    return dummyBooks.where((b) {
      final matchCategory = _category == 'Semua' || b.category == _category;
      final matchQuery = q.isEmpty ||
          b.title.toLowerCase().contains(q) ||
          b.author.toLowerCase().contains(q);
      return matchCategory && matchQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final books = _filteredBooks;

    return Scaffold(
      appBar: const NusaAppBar(),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          // ---------- Kolom pencarian ----------
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              onChanged: (value) => setState(() => _query = value),
              style: AppText.sans(14, color: cs.onSurface),
              decoration: InputDecoration(
                hintText: 'Cari judul, penulis, ISBN...',
                hintStyle: AppText.sans(14, color: cs.onSurfaceVariant),
                prefixIcon:
                    Icon(Icons.search, size: 20, color: cs.onSurfaceVariant),
                suffixIcon:
                    Icon(Icons.tune, size: 18, color: cs.onSurfaceVariant),
                filled: true,
                fillColor: cs.surfaceContainer,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // ---------- Chip kategori (scroll horizontal) ----------
          SizedBox(
            height: 52,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                final c = _categories[index];
                final selected = c == _category;
                return ChoiceChip(
                  label: Text(c),
                  selected: selected,
                  showCheckmark: false,
                  onSelected: (_) => setState(() => _category = c),
                  labelStyle: AppText.sans(
                    13,
                    weight: FontWeight.w600,
                    color: selected ? cs.onPrimary : cs.onSurface,
                  ),
                  selectedColor: cs.primary,
                  backgroundColor: cs.surfaceContainer,
                  side: BorderSide.none,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              },
            ),
          ),

          // ---------- Banner promo ----------
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: _PromoBanner(),
          ),

          // ---------- Header daftar ----------
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Flexible(
                  child: Text(
                    'Katalog Rekomendasi',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.serif(20, color: cs.primary),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${books.length} Buku)',
                  style: AppText.sans(
                    11,
                    weight: FontWeight.w500,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Icon(Icons.swap_vert, size: 16, color: cs.secondary),
                const SizedBox(width: 2),
                Text(
                  'Terpopuler',
                  style: AppText.sans(
                    13,
                    weight: FontWeight.w600,
                    color: cs.secondary,
                  ),
                ),
              ],
            ),
          ),

          // ---------- Daftar buku ----------
          if (books.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Column(
                children: [
                  Icon(Icons.search_off, size: 56, color: cs.outline),
                  const SizedBox(height: 8),
                  Text(
                    'Buku tidak ditemukan',
                    style: AppText.sans(14, color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            )
          else
            for (final book in books)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: _BookCard(book: book),
              ),
        ],
      ),
    );
  }
}

// =====================================================================
// Banner promo
// =====================================================================
class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const accent = Color(0xFFFFDBCD);

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cs.isDark ? cs.primaryContainer : cs.primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26071637),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Lingkaran dekoratif
          Positioned(
            right: -24,
            bottom: -24,
            child: Container(
              width: 128,
              height: 128,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x0DFFFFFF),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.local_shipping_outlined,
                              size: 16, color: accent),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'PEKAN LITERASI NUSANTARA',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.sans(
                                11,
                                weight: FontWeight.w700,
                                color: accent,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Gratis Ongkir se-Indonesia',
                        style: AppText.serif(20, color: Colors.white, height: 1.3),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Berlaku untuk seluruh karya kurasi pilihan hari ini.',
                        style: AppText.sans(12, color: cs.onPrimaryContainer),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0x1AFFFFFF),
                  ),
                  child: const Icon(Icons.auto_stories, size: 26, color: accent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// Kartu satu buku
// =====================================================================
class _BookCard extends StatelessWidget {
  final Book book;
  const _BookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      shadowColor: const Color(0x33000000),
      surfaceTintColor: Colors.transparent,
      color: cs.surfaceContainerLowest,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookCover(url: book.imageUrl, width: 96, height: 144),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge + genre
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: book.badgeHighlight
                              ? cs.badgeBg
                              : cs.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          book.badge,
                          style: AppText.sans(
                            10,
                            weight: FontWeight.w700,
                            color: book.badgeHighlight
                                ? cs.badgeFg
                                : cs.onSurface,
                          ),
                        ),
                      ),
                      Text(
                        book.genre,
                        style: AppText.sans(12, color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.serif(20, color: cs.onSurface, height: 1.2),
                  ),
                  Text(
                    book.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.sans(12, color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 4),
                  // Rating
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: cs.star),
                      const SizedBox(width: 4),
                      Text(
                        book.rating.toStringAsFixed(1),
                        style: AppText.sans(
                          11,
                          weight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '(${book.reviews})',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.sans(12, color: cs.onSurfaceVariant),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Harga + tombol tambah
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'HARGA',
                              style: AppText.sans(
                                10,
                                weight: FontWeight.w700,
                                color: cs.onSurfaceVariant,
                                letterSpacing: 1,
                              ),
                            ),
                            Text(
                              formatRupiah(book.price),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.sans(
                                15,
                                weight: FontWeight.w700,
                                color: cs.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.icon(
                        // context.read: hanya melakukan aksi, tidak rebuild
                        onPressed: () {
                          context.read<CartProvider>().addItem(book);
                          showNusaSnackBar(
                            context,
                            title: '${book.title} ditambahkan',
                            message: 'Berhasil masuk ke keranjang belanja Anda.',
                            actionLabel: 'Lihat',
                            onAction: () => AppNav.tab.value = 2,
                          );
                        },
                        icon: const Icon(Icons.add_shopping_cart, size: 18),
                        label: const Text('Tambah'),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(0, 36),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          textStyle:
                              AppText.sans(13, weight: FontWeight.w600),
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
