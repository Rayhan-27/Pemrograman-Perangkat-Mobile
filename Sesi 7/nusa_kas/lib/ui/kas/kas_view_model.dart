import 'package:flutter/foundation.dart';

import '../../data/repositories/transaksi_repository.dart';
import '../../domain/kas_calculator.dart';
import '../../domain/models/transaksi.dart';
import '../core/format.dart';

class KasViewModel extends ChangeNotifier {
  KasViewModel({TransaksiRepository? repository, KasCalculator calculator = const KasCalculator()})
      : _repository = repository ?? TransaksiRepository(),
        _calculator = calculator;

  final TransaksiRepository _repository;
  final KasCalculator _calculator;

  /// Daftar transaksi: tanggal terbaru di atas; tanggal sama -> yang terakhir diinput di atas.
  List<Transaksi> get daftar {
    final entries = _repository.ambilSemua().asMap().entries.toList()
      ..sort((a, b) {
        final c = b.value.tanggal.compareTo(a.value.tanggal);
        return c != 0 ? c : b.key.compareTo(a.key);
      });
    return entries.map((e) => e.value).toList();
  }

  int get saldo => _calculator.hitungSaldo(_repository.ambilSemua());
  int get totalPemasukan => _calculator.totalPemasukan(_repository.ambilSemua());
  int get totalPengeluaran => _calculator.totalPengeluaran(_repository.ambilSemua());

  /// Mengembalikan pesan error, atau null jika nominal valid.
  /// Aturan: nominal harus > 0, dan pengeluaran tidak boleh melebihi saldo
  /// (pengeluaran yang tepat sama dengan saldo masih diterima).
  String? validasiNominal(int nominal, JenisTransaksi jenis) {
    if (nominal <= 0) return 'Nominal harus lebih dari nol';
    if (jenis == JenisTransaksi.pengeluaran && nominal > saldo) {
      return 'Pengeluaran melebihi saldo (${formatRupiah(saldo)})';
    }
    return null;
  }

  /// Mengembalikan pesan error, atau null jika berhasil disimpan.
  String? tambahTransaksi({
    required String keterangan,
    required int nominal,
    required JenisTransaksi jenis,
    required DateTime tanggal,
  }) {
    if (keterangan.trim().isEmpty) return 'Keterangan wajib diisi';
    final error = validasiNominal(nominal, jenis);
    if (error != null) return error;
    _repository.tambah(Transaksi(
      id: _repository.buatId(),
      keterangan: keterangan.trim(),
      nominal: nominal,
      jenis: jenis,
      tanggal: tanggal,
    ));
    notifyListeners();
    return null;
  }

  /// Menghapus pemasukan yang sudah terpakai pengeluaran akan membuat saldo minus,
  /// jadi tidak diperbolehkan.
  bool bisaHapus(Transaksi transaksi) {
    if (transaksi.jenis == JenisTransaksi.pengeluaran) return true;
    return saldo - transaksi.nominal >= 0;
  }

  void hapus(String id) {
    _repository.hapus(id);
    notifyListeners();
  }
}
