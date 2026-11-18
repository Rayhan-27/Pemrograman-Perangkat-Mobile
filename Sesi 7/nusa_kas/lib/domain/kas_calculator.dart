import 'models/transaksi.dart';

/// Logika perhitungan kas. Murni Dart, tidak bergantung pada widget.
class KasCalculator {
  const KasCalculator();

  int totalPemasukan(List<Transaksi> daftar) => _total(daftar, JenisTransaksi.pemasukan);

  int totalPengeluaran(List<Transaksi> daftar) => _total(daftar, JenisTransaksi.pengeluaran);

  int hitungSaldo(List<Transaksi> daftar) => totalPemasukan(daftar) - totalPengeluaran(daftar);

  int _total(List<Transaksi> daftar, JenisTransaksi jenis) =>
      daftar.where((t) => t.jenis == jenis).fold(0, (jumlah, t) => jumlah + t.nominal);
}
