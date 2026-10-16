import 'package:flutter/foundation.dart';
import '../models/book.dart';

// Satu baris di keranjang: buku + jumlahnya
class CartItem {
  final Book book;
  int quantity;

  CartItem({required this.book, this.quantity = 1});
}

class CartProvider extends ChangeNotifier {
  // ---------------- Aturan toko ----------------
  static const int freeShippingMin = 100000; // min. belanja gratis ongkir
  static const int shippingFee = 15000; // ongkir jika belum memenuhi
  static const Map<String, int> vouchers = {'NUSAHEMAT15': 15000};

  // ---------------- State ----------------
  final List<CartItem> _items = [];
  final Set<int> _selectedIds = {}; // id buku yang dicentang
  String? _voucherCode;

  // =====================================================================
  // BAGIAN WAJIB SOAL
  // =====================================================================

  // Daftar buku di keranjang (read-only dari luar)
  List<CartItem> get items => List.unmodifiable(_items);

  // Jumlah seluruh buku di keranjang (dipakai untuk badge)
  int get totalItems => _items.fold(0, (sum, i) => sum + i.quantity);

  // Total harga seluruh buku di keranjang
  int get totalPrice =>
      _items.fold(0, (sum, i) => sum + i.book.price * i.quantity);

  // Tambah buku, atau tambah jumlah jika sudah ada
  void addItem(Book book) {
    final index = _items.indexWhere((i) => i.book.id == book.id);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(book: book));
      _selectedIds.add(book.id); // buku baru langsung tercentang
    }
    notifyListeners();
  }

  // Kurangi jumlah, atau hapus jika jumlahnya tinggal 1
  void removeItem(Book book) {
    final index = _items.indexWhere((i) => i.book.id == book.id);
    if (index < 0) return;

    if (_items[index].quantity > 1) {
      _items[index].quantity--;
    } else {
      _items.removeAt(index);
      _selectedIds.remove(book.id);
      _resetVoucherIfEmpty();
    }
    notifyListeners();
  }

  // Kosongkan keranjang
  void clearCart() {
    _items.clear();
    _selectedIds.clear();
    _voucherCode = null;
    notifyListeners();
  }

  // =====================================================================
  // TAMBAHAN UNTUK DESAIN BARU (checklist, voucher, ongkir)
  // =====================================================================

  // Hapus satu baris buku sekaligus (ikon tempat sampah)
  void deleteItem(Book book) {
    _items.removeWhere((i) => i.book.id == book.id);
    _selectedIds.remove(book.id);
    _resetVoucherIfEmpty();
    notifyListeners();
  }

  // ---- Checklist ----
  bool isSelected(Book book) => _selectedIds.contains(book.id);

  List<CartItem> get selectedItems =>
      _items.where((i) => _selectedIds.contains(i.book.id)).toList();

  // Jumlah judul yang dicentang ("2 judul buku terpilih")
  int get selectedLineCount => selectedItems.length;

  // Jumlah eksemplar yang dicentang ("3 buku")
  int get selectedQuantity =>
      selectedItems.fold(0, (sum, i) => sum + i.quantity);

  bool get allSelected =>
      _items.isNotEmpty && _items.every((i) => _selectedIds.contains(i.book.id));

  void toggleSelected(Book book) {
    if (!_selectedIds.remove(book.id)) _selectedIds.add(book.id);
    notifyListeners();
  }

  void setAllSelected(bool value) {
    _selectedIds.clear();
    if (value) _selectedIds.addAll(_items.map((i) => i.book.id));
    notifyListeners();
  }

  // Hapus semua yang dicentang (tombol "Hapus" di header)
  void removeSelected() {
    _items.removeWhere((i) => _selectedIds.contains(i.book.id));
    _selectedIds.clear();
    _resetVoucherIfEmpty();
    notifyListeners();
  }

  // ---- Voucher ----
  String? get voucherCode => _voucherCode;

  // Mengembalikan true jika kode valid
  bool applyVoucher(String code) {
    final c = code.trim().toUpperCase();
    if (!vouchers.containsKey(c)) return false;
    _voucherCode = c;
    notifyListeners();
    return true;
  }

  void removeVoucher() {
    _voucherCode = null;
    notifyListeners();
  }

  // ---- Ringkasan belanja (hanya buku yang dicentang) ----
  int get subtotal => selectedItems.fold(
        0,
        (sum, i) => sum + i.book.price * i.quantity,
      );

  int get discount {
    if (_voucherCode == null) return 0;
    final d = vouchers[_voucherCode] ?? 0;
    return d > subtotal ? subtotal : d; // diskon tidak boleh melebihi subtotal
  }

  bool get freeShipping => subtotal >= freeShippingMin;

  int get shipping => (subtotal == 0 || freeShipping) ? 0 : shippingFee;

  int get remainingForFreeShipping =>
      freeShipping ? 0 : freeShippingMin - subtotal;

  double get shippingProgress =>
      (subtotal / freeShippingMin).clamp(0.0, 1.0).toDouble();

  int get grandTotal => subtotal - discount + shipping;

  void _resetVoucherIfEmpty() {
    if (_items.isEmpty) _voucherCode = null;
  }
}
