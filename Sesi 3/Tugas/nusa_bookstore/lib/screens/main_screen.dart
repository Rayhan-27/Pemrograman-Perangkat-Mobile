import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'cart_screen.dart';
import 'catalog_screen.dart';

/// Rangka aplikasi: halaman aktif + bottom navigation bar.
/// Tiap halaman punya Scaffold + AppBar sendiri; bar bawah ada di sini.
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static const List<Widget> _pages = [
    CatalogScreen(),
    _CategoryScreen(),
    CartScreen(),
    _AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ValueListenableBuilder<int>(
      valueListenable: AppNav.tab,
      builder: (context, index, child) {
        // Tombol back di Android: dari tab lain kembali ke Beranda dulu
        return PopScope(
          canPop: index == 0,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) AppNav.tab.value = 0;
          },
          child: Material(
            color: cs.surface,
            child: Column(
              children: [
                Expanded(
                  // Padding bawah dihapus karena sudah ditangani bar navigasi
                  child: MediaQuery.removePadding(
                    context: context,
                    removeBottom: true,
                    // IndexedStack: state tiap tab (scroll, filter) tidak hilang
                    child: IndexedStack(index: index, children: _pages),
                  ),
                ),
                _BottomNav(currentIndex: index),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------
// Bottom navigation (Beranda, Kategori, Keranjang, Akun Saya)
// ---------------------------------------------------------------------
class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem(this.icon, this.activeIcon, this.label);
}

const List<_NavItem> _navItems = [
  _NavItem(Icons.storefront_outlined, Icons.storefront, 'Beranda'),
  _NavItem(Icons.menu_book_outlined, Icons.menu_book, 'Kategori'),
  _NavItem(Icons.local_mall_outlined, Icons.local_mall, 'Keranjang'),
  _NavItem(Icons.account_circle_outlined, Icons.account_circle, 'Akun Saya'),
];

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  const _BottomNav({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F071637),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              for (int i = 0; i < _navItems.length; i++)
                Expanded(
                  child: _NavButton(
                    item: _navItems[i],
                    active: i == currentIndex,
                    showCartBadge: i == 2,
                    onTap: () => AppNav.tab.value = i,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final _NavItem item;
  final bool active;
  final bool showCartBadge;
  final VoidCallback onTap;

  const _NavButton({
    required this.item,
    required this.active,
    required this.showCartBadge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = active ? cs.primary : cs.onSurfaceVariant;

    Widget icon = Icon(
      active ? item.activeIcon : item.icon,
      size: 22,
      color: color,
    );

    // Badge jumlah item di ikon Keranjang
    if (showCartBadge) {
      icon = Consumer<CartProvider>(
        builder: (context, cart, child) => Badge(
          isLabelVisible: cart.totalItems > 0,
          label: Text('${cart.totalItems}'),
          backgroundColor: cs.secondary,
          textColor: cs.onSecondary,
          child: child,
        ),
        child: icon,
      );
    }

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(height: 3),
          Text(
            item.label,
            style: AppText.sans(
              11,
              weight: active ? FontWeight.w700 : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------
// Halaman sederhana untuk tab yang belum ada di soal
// ---------------------------------------------------------------------
class _CategoryScreen extends StatelessWidget {
  const _CategoryScreen();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const NusaAppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.menu_book_outlined, size: 72, color: cs.outline),
              const SizedBox(height: 12),
              Text(
                'Kategori Buku',
                style: AppText.serif(22, color: cs.primary),
              ),
              const SizedBox(height: 4),
              Text(
                'Halaman ini menyusul. Untuk sementara, gunakan chip kategori di Beranda.',
                textAlign: TextAlign.center,
                style: AppText.sans(13, color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountScreen extends StatelessWidget {
  const _AccountScreen();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const NusaAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 1,
            color: cs.surfaceContainerLowest,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: cs.primary,
                    child: Icon(Icons.person, size: 32, color: cs.onPrimary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Rayhan', style: AppText.serif(22, color: cs.primary)),
                        const SizedBox(height: 2),
                        Text(
                          'NIM 20240040187',
                          style: AppText.sans(13, color: cs.onSurfaceVariant),
                        ),
                        Text(
                          'Teknik Informatika / TI-24G',
                          style: AppText.sans(13, color: cs.onSurfaceVariant),
                        ),
                      ],
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
