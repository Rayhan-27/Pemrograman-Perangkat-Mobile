import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

// ============================================================
// WARNA & HELPER
// ============================================================
class AppColors {
  static const emerald900 = Color(0xFF064E3B);
  static const emerald800 = Color(0xFF065F46);
  static const emerald700 = Color(0xFF047857);
  static const emerald100 = Color(0xFFD1FAE5);
  static const emerald50 = Color(0xFFECFDF5);
  static const teal900 = Color(0xFF134E4A);
  static const slate900 = Color(0xFF0F172A);
  static const slate800 = Color(0xFF1E293B);
  static const slate700 = Color(0xFF334155);
  static const slate600 = Color(0xFF475569);
  static const slate500 = Color(0xFF64748B);
  static const slate400 = Color(0xFF94A3B8);
  static const slate200 = Color(0xFFE2E8F0);
  static const slate100 = Color(0xFFF1F5F9);
  static const slate50 = Color(0xFFF8FAFC);
  static const amber400 = Color(0xFFFBBF24);
  static const amber700 = Color(0xFFB45309);
  static const amber50 = Color(0xFFFFFBEB);
}

String rupiah(int n) =>
    'Rp ${n.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]}.')}';

// State sederhana yang dibagi antar halaman (keranjang)
class CartItem {
  final String name;
  final int qty;
  final int price;
  CartItem(this.name, this.qty, this.price);
}

final ValueNotifier<List<CartItem>> cart = ValueNotifier([]);

void showSnack(BuildContext context, String msg) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontSize: 13)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.slate900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        action: SnackBarAction(
          label: 'OKE',
          textColor: const Color(0xFF34D399),
          onPressed: () {},
        ),
      ),
    );
}

// ============================================================
// APP
// ============================================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return MaterialApp(
      title: 'PPM Sesi 2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.emerald800),
        scaffoldBackgroundColor: AppColors.slate50,
      ),
      home: const MainScreen(),
    );
  }
}

// ============================================================
// MAIN SCREEN (Scaffold + AppBar + BottomNavigationBar)
// ============================================================
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;

  final _pages = const [
    HomePage(),
    CatalogPage(),
    OrdersPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.emerald900,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.black45,
        titleSpacing: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PPM Sesi 2 - Rayhan (20240040187)',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            Text(
              'Flutter Mobile Development UI',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFA7F3D0)),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => showSnack(context, 'Tidak ada notifikasi baru'),
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_none_rounded, size: 26),
                Positioned(
                  top: 0,
                  right: 1,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: AppColors.amber400,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.emerald900, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: AppColors.emerald900),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text('Rayhan\n20240040187',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
            for (final e in const [
              (Icons.home_rounded, 'Beranda', 0),
              (Icons.grid_view_rounded, 'Katalog', 1),
              (Icons.shopping_bag_outlined, 'Pesanan', 2),
              (Icons.person_outline_rounded, 'Profil', 3),
            ])
              ListTile(
                leading: Icon(e.$1),
                title: Text(e.$2),
                selected: _index == e.$3,
                onTap: () {
                  setState(() => _index = e.$3);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
      // IndexedStack: halaman tidak hilang state-nya saat pindah tab
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.slate200)),
        ),
        child: BottomNavigationBar(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: AppColors.emerald800,
          unselectedItemColor: AppColors.slate400,
          selectedLabelStyle:
              const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home_rounded),
                label: 'Beranda'),
            BottomNavigationBarItem(
                icon: Icon(Icons.grid_view_rounded), label: 'Katalog'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_outlined),
                activeIcon: Icon(Icons.shopping_bag),
                label: 'Pesanan'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded),
                activeIcon: Icon(Icons.person_rounded),
                label: 'Profil'),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// HALAMAN 1: BERANDA
// ============================================================
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          PromoBanner(),
          SizedBox(height: 16),
          StudentProfileCard(),
          SizedBox(height: 16),
          ProductCard(),
          SizedBox(height: 16),
          WidgetChecklist(),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ---------- Banner promo (Stack & Positioned) ----------
class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.emerald800, AppColors.teal900, AppColors.slate900],
        ),
        border: Border.all(color: const Color(0x66047857)),
        boxShadow: const [
          BoxShadow(color: Color(0x33042F2E), blurRadius: 12, offset: Offset(0, 6)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Ikon tag dekoratif
            Positioned(
              right: -16,
              bottom: -16,
              child: Transform.rotate(
                angle: -0.21,
                child: const Icon(Icons.sell,
                    size: 160, color: Color(0x4099F6E4)),
              ),
            ),
            // Badge -50%
            Positioned(
              top: 14,
              right: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.amber400,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFCD34D)),
                ),
                child: const Text('-50%',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: AppColors.slate900)),
              ),
            ),
            // Konten
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 56, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0x99047857),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                            radius: 3, backgroundColor: Color(0xFF6EE7B7)),
                        SizedBox(width: 6),
                        Text('Stack & Positioned Widget',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFA7F3D0))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('PROMO SPESIAL',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.white)),
                  const SizedBox(height: 6),
                  const Text('Diskon hingga 50% minggu ini khusus mahasiswa IT!',
                      style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Color(0xE6CCFBF1))),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () =>
                        showSnack(context, 'Voucher diskon 50% berhasil diklaim! 🎟️'),
                    icon: const Icon(Icons.local_activity,
                        size: 18, color: AppColors.emerald700),
                    label: const Text('KLAIM VOUCHER'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.emerald900,
                      elevation: 1,
                      textStyle: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
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

// ---------- Wrapper card + header label ----------
class SectionCard extends StatelessWidget {
  final String label;
  final String badge;
  final Color badgeBg;
  final Color badgeFg;
  final Color badgeBorder;
  final Widget child;

  const SectionCard({
    super.key,
    required this.label,
    required this.badge,
    required this.badgeBg,
    required this.badgeFg,
    required this.badgeBorder,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.slate200),
        boxShadow: const [
          BoxShadow(color: Color(0x0D000000), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: AppColors.slate400)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: badgeBorder),
                ),
                child: Text(badge,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: badgeFg)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: AppColors.slate100),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

// ---------- Kartu profil (StatelessWidget) ----------
class StudentProfileCard extends StatelessWidget {
  const StudentProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      label: 'Kartu Profil Mahasiswa',
      badge: 'StatelessWidget',
      badgeBg: AppColors.emerald50,
      badgeFg: AppColors.emerald700,
      badgeBorder: const Color(0xFFA7F3D0),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [Color(0xFFA7F3D0), Color(0xFFDCFCE7)],
                  ),
                ),
                child: const Icon(Icons.person_rounded,
                    size: 36, color: AppColors.emerald800),
              ),
              Positioned(
                right: -3,
                bottom: -3,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5),
                  ),
                  child: const Center(
                    child: CircleAvatar(radius: 3, backgroundColor: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Rayhan',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.slate800)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.slate100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Aktif',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.slate600)),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                const Text.rich(
                  TextSpan(
                    text: 'NIM: ',
                    style: TextStyle(fontSize: 15, color: AppColors.slate500),
                    children: [
                      TextSpan(
                        text: '20240040187',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.slate700),
                      ),
                    ],
                  ),
                ),
                const Text('Teknik Informatika / TI-24G',
                    style: TextStyle(fontSize: 15, color: AppColors.slate500)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    for (int i = 0; i < 5; i++)
                      const Icon(Icons.star_rounded,
                          size: 20, color: AppColors.amber400),
                    const SizedBox(width: 6),
                    const Text('5.0',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.slate700)),
                    const SizedBox(width: 4),
                    const Flexible(
                      child: Text('(Presensi Penuh)',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 13, color: AppColors.slate400)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- Kartu produk (StatefulWidget) ----------
class ProductCard extends StatefulWidget {
  const ProductCard({super.key});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  static const _name = 'Kopi Susu Barista IT';
  static const _price = 12500;

  int _qty = 1;
  int _likes = 128;
  bool _liked = false;

  void _toggleLike() => setState(() {
        _liked = !_liked;
        _likes += _liked ? 1 : -1;
      });

  void _addToCart() {
    cart.value = [...cart.value, CartItem(_name, _qty, _price)];
    showSnack(context, '$_qty $_name masuk keranjang! 🎉');
  }

  @override
  Widget build(BuildContext context) {
    final likeColor = _liked ? const Color(0xFFF43F5E) : AppColors.slate400;

    return SectionCard(
      label: 'Produk Terbaru',
      badge: 'StatefulWidget',
      badgeBg: AppColors.amber50,
      badgeFg: AppColors.amber700,
      badgeBorder: const Color(0xFFFDE68A),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDFA),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFCCFBF1)),
                ),
                child: const Icon(Icons.card_giftcard_rounded,
                    size: 44, color: AppColors.emerald700),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.emerald50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('Snack & Coffee',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.emerald700)),
                        ),
                        InkWell(
                          onTap: _toggleLike,
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Row(
                              children: [
                                AnimatedScale(
                                  scale: _liked ? 1.2 : 1.0,
                                  duration: const Duration(milliseconds: 200),
                                  child: Icon(
                                    _liked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 22,
                                    color: likeColor,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text('$_likes',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: _liked
                                            ? const Color(0xFFE11D48)
                                            : AppColors.slate600)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(_name,
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: AppColors.slate800)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(rupiah(_price),
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: AppColors.emerald800)),
                        const SizedBox(width: 8),
                        Text(rupiah(25000),
                            style: const TextStyle(
                                fontSize: 15,
                                color: AppColors.slate400,
                                decoration: TextDecoration.lineThrough)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Counter
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.slate50,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Jumlah Pesanan',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.slate600)),
                    SizedBox(height: 6),
                    Text('Atur kuantitas barang',
                        style:
                            TextStyle(fontSize: 14, color: AppColors.slate400)),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.slate200),
                    boxShadow: const [
                      BoxShadow(color: Color(0x0D000000), blurRadius: 3),
                    ],
                  ),
                  child: Row(
                    children: [
                      _CounterButton(
                        icon: Icons.remove,
                        onTap: () {
                          if (_qty > 1) setState(() => _qty--);
                        },
                      ),
                      SizedBox(
                        width: 44,
                        child: Text('$_qty',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.slate800)),
                      ),
                      _CounterButton(
                        icon: Icons.add,
                        onTap: () => setState(() => _qty++),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _addToCart,
              icon: const Icon(Icons.shopping_cart_outlined,
                  color: Color(0xFFA7F3D0)),
              label: const Text('Tambah ke Keranjang'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.emerald800,
                foregroundColor: Colors.white,
                textStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CounterButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFD1FAE5),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 38,
          height: 38,
          child: Icon(icon, size: 22, color: AppColors.emerald900),
        ),
      ),
    );
  }
}

// ---------- Checklist widget ----------
class WidgetChecklist extends StatelessWidget {
  const WidgetChecklist({super.key});

  Widget _chip(String text, {Color? bg, Color? fg, bool bold = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bg ?? AppColors.slate100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text,
          style: TextStyle(
              fontSize: 14,
              fontWeight: bold ? FontWeight.w500 : FontWeight.w400,
              color: fg ?? AppColors.slate600)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.slate200),
      ),
    );
  }
}

// ============================================================
// HALAMAN 2: KATALOG
// ============================================================
class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  static const _items = [
    ('Kopi Susu Barista IT', 12500, Icons.coffee_rounded),
    ('Es Teh Manis', 5000, Icons.local_drink_rounded),
    ('Roti Bakar Coklat', 10000, Icons.bakery_dining_rounded),
    ('Mie Goreng Spesial', 15000, Icons.ramen_dining_rounded),
    ('Kentang Goreng', 9000, Icons.fastfood_rounded),
    ('Donat Gula', 7000, Icons.cookie_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, i) {
        final item = _items[i];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.slate200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDFA),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(item.$3, size: 44, color: AppColors.emerald700),
                ),
              ),
              const SizedBox(height: 10),
              Text(item.$1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: AppColors.slate800)),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(rupiah(item.$2),
                      style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppColors.emerald800)),
                  InkWell(
                    onTap: () {
                      cart.value = [
                        ...cart.value,
                        CartItem(item.$1, 1, item.$2),
                      ];
                      showSnack(context, '${item.$1} masuk keranjang! 🎉');
                    },
                    child: const Icon(Icons.add_circle,
                        color: AppColors.emerald800),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================
// HALAMAN 3: PESANAN
// ============================================================
class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<CartItem>>(
      valueListenable: cart,
      builder: (context, items, _) {
        if (items.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shopping_bag_outlined,
                    size: 72, color: AppColors.slate400),
                SizedBox(height: 12),
                Text('Belum ada pesanan',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.slate600)),
                Text('Tambah produk dari Beranda atau Katalog',
                    style: TextStyle(color: AppColors.slate400)),
              ],
            ),
          );
        }

        final total = items.fold<int>(0, (s, e) => s + e.qty * e.price);

        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final e = items[i];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.slate200),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: AppColors.emerald100,
                          child: Icon(Icons.coffee_rounded,
                              color: AppColors.emerald800),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700)),
                              Text('${e.qty} x ${rupiah(e.price)}',
                                  style: const TextStyle(
                                      color: AppColors.slate500)),
                            ],
                          ),
                        ),
                        Text(rupiah(e.qty * e.price),
                            style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: AppColors.emerald800)),
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: AppColors.slate400),
                          onPressed: () {
                            final list = [...items]..removeAt(i);
                            cart.value = list;
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  Text(rupiah(total),
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.emerald800)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================
// HALAMAN 4: PROFIL
// ============================================================
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 12),
        const Center(
          child: CircleAvatar(
            radius: 48,
            backgroundColor: AppColors.emerald100,
            child:
                Icon(Icons.person_rounded, size: 56, color: AppColors.emerald800),
          ),
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text('Rayhan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
        ),
        const Center(
          child: Text('Teknik Informatika / TI-24G',
              style: TextStyle(color: AppColors.slate500)),
        ),
        const SizedBox(height: 24),
        const Card(
          child: ListTile(
            leading: Icon(Icons.badge_outlined),
            title: Text('NIM'),
            subtitle: Text('20240040187'),
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(Icons.school_outlined),
            title: Text('Program Studi'),
            subtitle: Text('Teknik Informatika'),
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(Icons.verified_outlined),
            title: Text('Status'),
            subtitle: Text('Aktif - Presensi Penuh'),
          ),
        ),
      ],
    );
  }
}
