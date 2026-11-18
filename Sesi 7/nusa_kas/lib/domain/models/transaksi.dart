enum JenisTransaksi { pemasukan, pengeluaran }

class Transaksi {
  const Transaksi({
    required this.id,
    required this.keterangan,
    required this.nominal,
    required this.jenis,
    required this.tanggal,
  });

  final String id;
  final String keterangan;

  /// Nominal dalam Rupiah (bilangan bulat, selalu positif).
  final int nominal;
  final JenisTransaksi jenis;
  final DateTime tanggal;
}
