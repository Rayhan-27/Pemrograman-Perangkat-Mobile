import '../../domain/models/transaksi.dart';

/// Penyimpanan transaksi di memori (cukup untuk versi sederhana).
class TransaksiRepository {
  TransaksiRepository({List<Transaksi> awal = const []}) : _items = List.of(awal);

  final List<Transaksi> _items;
  int _counter = 0;

  List<Transaksi> ambilSemua() => List.unmodifiable(_items);

  String buatId() => 'T${++_counter}';

  void tambah(Transaksi transaksi) => _items.add(transaksi);

  void hapus(String id) => _items.removeWhere((t) => t.id == id);
}
