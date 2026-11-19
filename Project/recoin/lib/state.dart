import 'package:flutter/material.dart';

// ====== Navigasi global ======
final ValueNotifier<int> tabIndex = ValueNotifier<int>(0);
final ValueNotifier<int> walletTab = ValueNotifier<int>(0);

// ====== Model ======
class WasteCategory {
  final String name, desc, tag;
  final int price; // per kg
  final IconData icon;
  final Color iconBg, iconFg;
  const WasteCategory(
    this.name,
    this.desc,
    this.price,
    this.icon, {
    this.tag = '',
    this.iconBg = const Color(0xFFE3F5EC),
    this.iconFg = const Color(0xFF1B6B4A),
  });
}

const categories = <WasteCategory>[
  WasteCategory('Botol Plastik PET', 'Botol air mineral bersih, botol bening',
      3500, Icons.local_drink,
      tag: 'Populer'),
  WasteCategory('Kardus & Karton', 'Kardus packing, box tebal dilipat rapi',
      2200, Icons.inventory_2),
  WasteCategory('Kaleng Aluminium & Logam', 'Kaleng soda, minuman, seng tipis',
      9000, Icons.sports_bar),
  WasteCategory('Gelas Plastik & PP', 'Gelas cup kopi/teh bersih tanpa sedotan',
      2000, Icons.local_cafe),
  WasteCategory('Kertas & Buku Bekas', 'Koran, majalah, kertas HVS putih',
      1800, Icons.menu_book),
  WasteCategory('Elektronik Kecil / E-Waste',
      'Kabel usang, charger bekas, baterai', 12000, Icons.power,
      tag: 'Nilai Tinggi',
      iconBg: Color(0xFFFDEBD9),
      iconFg: Color(0xFFB45309)),
];

int priceOf(String name) =>
    categories.firstWhere((c) => c.name == name).price;

class Voucher {
  final String brand, title;
  final int cost;
  final IconData icon;
  final Color color;
  const Voucher(this.brand, this.title, this.cost, this.icon, this.color);
}

const vouchers = <Voucher>[
  Voucher('Alfamart', 'Voucher Belanja Rp10.000', 500, Icons.storefront,
      Color(0xFFD32F2F)),
  Voucher('Indomaret', 'Voucher Belanja Rp25.000', 1200, Icons.shopping_basket,
      Color(0xFF1565C0)),
  Voucher('Tokopedia', 'Diskon Rp20.000 min. belanja Rp100.000', 900,
      Icons.shopping_bag, Color(0xFF2E7D32)),
  Voucher('Gojek', 'Voucher GoRide Rp15.000', 700, Icons.two_wheeler,
      Color(0xFF00AA5B)),
  Voucher('PLN', 'Token Listrik Rp20.000', 1000, Icons.bolt,
      Color(0xFFF9A825)),
  Voucher('Kopi Kenangan', 'Gratis 1 Minuman Reguler', 650, Icons.coffee,
      Color(0xFF6D4C41)),
];

class MyVoucher {
  final Voucher voucher;
  final String code;
  MyVoucher(this.voucher, this.code);
}

enum OrderStatus { dijadwalkan, menuju, selesai, dibatalkan }

class PickupOrder {
  final String id;
  final DateTime date;
  final Map<String, double> items;
  final String address;
  final String slot;
  final int fee;
  final String officer;
  OrderStatus status;

  PickupOrder({
    required this.id,
    required this.date,
    required this.items,
    required this.address,
    required this.slot,
    required this.fee,
    required this.status,
    this.officer = 'Dadan Hidayat',
  });

  double get totalKg => items.values.fold(0.0, (a, b) => a + b);
  int get gross => items.entries
      .fold(0, (a, e) => a + (priceOf(e.key) * e.value).round());
  int get total => gross - fee;
  int get points => gross ~/ 100;
  double get co2 => totalKg * 0.4;

  String get title {
    final names = items.keys.toList();
    if (names.length == 1) return names.first;
    return '${names.first} +${names.length - 1} lainnya';
  }
}

class Withdrawal {
  final String id, dest;
  final int amount;
  final DateTime date;
  Withdrawal(this.id, this.dest, this.amount, this.date);
}

// ====== State ======
class AppState extends ChangeNotifier {
  final String userName = 'Rayhan Sandika';
  final int level = 3;
  final String referralCode = 'RYSAN2706';

  int balance = 124500;
  int points = 1450;
  double extraKg = 0;
  int unread = 3;
  bool linkAjaLinked = false;
  int _seq = 1;

  final List<String> addresses = [
    'Jl. Melati Indah No. 42, RT 03/RW 05, Kec. Sukasari, Kota Bandung',
    'Jl. Cemara Raya No. 12, Kec. Coblong, Kota Bandung',
  ];
  final List<String> addressLabels = ['Rumah Utama', 'Kantor'];
  int addressIndex = 0;

  final List<PickupOrder> orders = [];
  final List<Withdrawal> withdrawals = [];
  final List<MyVoucher> myVouchers = [];

  AppState() {
    final now = DateTime.now();
    orders.addAll([
      PickupOrder(
        id: 'RC-88231',
        date: DateTime(now.year, now.month, now.day, 14, 0),
        items: {'Botol Plastik PET': 3.0, 'Kardus & Karton': 5.0},
        address: addresses[0],
        slot: 'Hari ini, 14:00 WIB',
        fee: 0,
        status: OrderStatus.menuju,
      ),
      PickupOrder(
        id: 'RC-87012',
        date: now.subtract(const Duration(days: 6, hours: 1)),
        items: {'Botol Plastik PET': 4.5},
        address: addresses[0],
        slot: 'Selesai',
        fee: 0,
        status: OrderStatus.selesai,
        officer: 'Bambang S.',
      ),
      PickupOrder(
        id: 'RC-86544',
        date: now.subtract(const Duration(days: 13, hours: 3)),
        items: {'Kardus & Karton': 8.0},
        address: addresses[0],
        slot: 'Selesai',
        fee: 0,
        status: OrderStatus.selesai,
        officer: 'Asep Sunandar',
      ),
      PickupOrder(
        id: 'RC-85120',
        date: now.subtract(const Duration(days: 20, hours: 2)),
        items: {'Kaleng Aluminium & Logam': 2.1},
        address: addresses[0],
        slot: 'Selesai',
        fee: 0,
        status: OrderStatus.selesai,
        officer: 'Mas Joko',
      ),
    ]);
    withdrawals.add(Withdrawal('RC-89211', 'GoPay', 50000,
        now.subtract(const Duration(days: 1, hours: 4))));
  }

  List<PickupOrder> get active => orders
      .where((o) =>
          o.status == OrderStatus.dijadwalkan ||
          o.status == OrderStatus.menuju)
      .toList();

  List<PickupOrder> get finished => orders
      .where((o) =>
          o.status == OrderStatus.selesai ||
          o.status == OrderStatus.dibatalkan)
      .toList();

  PickupOrder? get nearest => active.isEmpty ? null : active.first;

  double get monthKg => 18.5 + extraKg;
  double get monthCo2 => 14.2 + extraKg * 0.4;

  String get currentAddress => addresses[addressIndex];
  String get currentAddressLabel => addressLabels[addressIndex];

  PickupOrder createOrder({
    required Map<String, double> items,
    required String address,
    required String slot,
    required int fee,
  }) {
    final o = PickupOrder(
      id: 'RC-${89300 + _seq++}',
      date: DateTime.now(),
      items: Map.of(items),
      address: address,
      slot: slot,
      fee: fee,
      status: OrderStatus.dijadwalkan,
    );
    orders.insert(0, o);
    unread++;
    notifyListeners();
    return o;
  }

  void setStatus(PickupOrder o, OrderStatus s) {
    final wasDone = o.status == OrderStatus.selesai;
    o.status = s;
    if (s == OrderStatus.selesai && !wasDone) {
      balance += o.total;
      points += o.points;
      extraKg += o.totalKg;
    }
    notifyListeners();
  }

  void selectAddress(int i) {
    addressIndex = i;
    notifyListeners();
  }

  void addAddress(String label, String addr) {
    addressLabels.add(label);
    addresses.add(addr);
    addressIndex = addresses.length - 1;
    notifyListeners();
  }

  void withdraw(int amount, String dest) {
    balance -= amount;
    withdrawals.insert(
        0, Withdrawal('RC-${89300 + _seq++}', dest, amount, DateTime.now()));
    notifyListeners();
  }

  MyVoucher redeem(Voucher v) {
    points -= v.cost;
    final code =
        'RC${(DateTime.now().millisecondsSinceEpoch % 100000000).toString().padLeft(8, '0')}';
    final mv = MyVoucher(v, code);
    myVouchers.insert(0, mv);
    notifyListeners();
    return mv;
  }

  void linkAja() {
    linkAjaLinked = true;
    notifyListeners();
  }

  void clearUnread() {
    unread = 0;
    notifyListeners();
  }
}

final appState = AppState();
