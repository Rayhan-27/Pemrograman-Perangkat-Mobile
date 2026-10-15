import 'package:flutter/foundation.dart';
import '../models/book.dart';

// Satu baris di keranjang: buku + jumlahnya
class CartItem { // dibuat untuk wadah yang nyimpen pasangan Book + quantity (buku di keranjang) dan quantity nggak final karena nilainya bakal naik turun
  final Book book;
  int quantity;

  CartItem({required this.book, this.quantity = 1});
}

class CartProvider extends ChangeNotifier { // bikin class ini bisa “ngabarin” widget yang lagi mendengarkan kalau datanya berubah
  // Daftar buku di keranjang (private)
  final List<CartItem> _items = []; // "_items" diawali underscore, artinya private jadinya Widget nggak bisa ngubah isinya langsung, harus lewat fungsi fungsi di bawah

  // Getter supaya luar class cuma bisa baca, tidak bisa ubah langsung
  List<CartItem> get items => List.unmodifiable(_items);

  // Total jumlah seluruh buku (dipakai untuk badge)
  int get totalItems {
    int total = 0;
    for (final item in _items) {
      total += item.quantity;
    }
    return total;
  }

  // Total harga seluruh buku
  int get totalPrice {
    int total = 0;
    for (final item in _items) {
      total += item.book.price * item.quantity;
    }
    return total;
  }

// ====> totalItems dan totalPrice adalah getter yang ngitung ulang dari _items tiap dipanggil, jadi nilainya selalu sinkron dan nggak perlu disimpan di variabel terpisah

  // Tambah buku, atau tambah jumlah jika sudah ada
  void addItem(Book book) { // addItem() nyari buku di keranjang pakai indexWhere berdasarkan id
    final index = _items.indexWhere((item) => item.book.id == book.id);

    if (index >= 0) { // Kalau ketemu (index >= 0), jumlahnya ++ 
      _items[index].quantity++;
    } else { // Kalau nggak, buku ditambah sebagai item baru
      _items.add(CartItem(book: book));
    }
    notifyListeners();
  }

  // Kurangi jumlah, atau hapus jika jumlahnya tinggal 1 
  void removeItem(Book book) { // ngurangin jumlah kalau lebih dari 1 dan kalau tinggal 1, item dihapus dari keranjang
    final index = _items.indexWhere((item) => item.book.id == book.id);

    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  // Kosongkan keranjang
  void clearCart() { // ngosongin seluruh isi keranjang, nanti dipanggil pas checkout
    _items.clear();
    notifyListeners(); // ini dipanggil di setiap fungsi yang ngubah data, tanpa ini data berubah tapi tampilan nggak ikut update
  }
}