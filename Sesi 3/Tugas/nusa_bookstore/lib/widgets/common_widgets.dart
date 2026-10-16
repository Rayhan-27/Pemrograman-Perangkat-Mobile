import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';

// =====================================================================
// NAVIGASI TAB
// Index: 0 = Beranda (Katalog), 1 = Kategori, 2 = Keranjang, 3 = Akun Saya
// Dibuat sebagai ValueNotifier sederhana supaya AppBar, toast, dan tombol
// "Mulai Belanja" bisa pindah tab tanpa perlu provider tambahan.
// =====================================================================
class AppNav {
  AppNav._();
  static final ValueNotifier<int> tab = ValueNotifier<int>(0);
}

// =====================================================================
// APPBAR BERSAMA (logo, cari, Light/Dark Mode, keranjang + badge, avatar)
// =====================================================================
class NusaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NusaAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AppBar(
      toolbarHeight: 64,
      automaticallyImplyLeading: false,
      backgroundColor: cs.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 1,
      scrolledUnderElevation: 1,
      shadowColor: const Color(0x14000000),
      systemOverlayStyle:
          cs.isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      actionsIconTheme: IconThemeData(color: cs.onSurfaceVariant, size: 22),
      titleSpacing: 16,
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: cs.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.auto_stories, size: 18, color: cs.onPrimary),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              'NusaBookstore',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.serif(
                20,
                color: cs.primary,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ],
      ),
      actions: [
        // Cari -> kembali ke Beranda (tempat kolom pencarian berada)
        IconButton(
          tooltip: 'Cari buku',
          icon: const Icon(Icons.search),
          onPressed: () => AppNav.tab.value = 0,
        ),

        // Tombol Light / Dark Mode
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return IconButton(
              tooltip: 'Ubah mode tampilan',
              icon: Icon(
                themeProvider.isDarkMode
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
              ),
              onPressed: () => context.read<ThemeProvider>().toggleTheme(),
            );
          },
        ),

        // Ikon keranjang + badge jumlah item (otomatis berubah)
        Consumer<CartProvider>(
          builder: (context, cart, child) {
            return IconButton(
              tooltip: 'Keranjang belanja',
              icon: Badge(
                isLabelVisible: cart.totalItems > 0,
                label: Text('${cart.totalItems}'),
                backgroundColor: cs.secondary,
                textColor: cs.onSecondary,
                child: const Icon(Icons.shopping_bag_outlined),
              ),
              onPressed: () => AppNav.tab.value = 2,
            );
          },
        ),

        // Avatar -> Akun Saya
        Padding(
          padding: const EdgeInsets.only(left: 4, right: 16),
          child: GestureDetector(
            onTap: () => AppNav.tab.value = 3,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: cs.primary,
              child: Icon(Icons.person, size: 18, color: cs.onPrimary),
            ),
          ),
        ),
      ],
    );
  }
}

// =====================================================================
// COVER BUKU (punggung buku + bayangan, fallback ke ikon jika gambar gagal)
// =====================================================================
class BookCover extends StatelessWidget {
  final String url;
  final double width;
  final double height;

  const BookCover({
    super.key,
    required this.url,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget placeholder() => ColoredBox(
          color: cs.primaryContainer,
          child: Center(
            child: Icon(
              Icons.menu_book,
              size: width * 0.4,
              color: cs.onPrimaryContainer,
            ),
          ),
        );

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2E071637),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            url.isEmpty
                ? placeholder()
                : Image.network(
                    url,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) =>
                        progress == null ? child : placeholder(),
                    errorBuilder: (context, error, stack) => placeholder(),
                  ),
            // Lipatan punggung buku di sisi kiri
            const Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 6,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0x40000000),
                      Color(0x1AFFFFFF),
                      Color(0x00FFFFFF),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// TOAST / SNACKBAR bergaya desain baru
// =====================================================================
void showNusaSnackBar(
  BuildContext context, {
  required String title,
  String? message,
  String? actionLabel,
  VoidCallback? onAction,
  bool isError = false,
}) {
  final cs = Theme.of(context).colorScheme;
  final bg = cs.isDark ? cs.surfaceContainerHighest : cs.primary;
  final fg = cs.isDark ? cs.onSurface : cs.onPrimary;
  final sub = cs.isDark ? cs.onSurfaceVariant : cs.onPrimaryContainer;
  final badge = isError ? cs.error : cs.secondary;
  final onBadge = isError ? cs.onError : cs.onSecondary;

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: bg,
        elevation: 6,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(milliseconds: 2800),
        content: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(color: badge, shape: BoxShape.circle),
              child: Icon(
                isError ? Icons.close : Icons.check,
                size: 16,
                color: onBadge,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.sans(13, weight: FontWeight.w600, color: fg),
                  ),
                  if (message != null)
                    Text(
                      message,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.sans(12, color: sub),
                    ),
                ],
              ),
            ),
          ],
        ),
        action: actionLabel == null
            ? null
            : SnackBarAction(
                label: actionLabel,
                textColor: const Color(0xFFFFDBCD),
                onPressed: onAction ?? () {},
              ),
      ),
    );
}
