import 'package:flutter_test/flutter_test.dart';
import 'package:nusa_kas/domain/kas_calculator.dart';
import 'package:nusa_kas/domain/models/transaksi.dart';

Transaksi _t(int nominal, JenisTransaksi jenis, [String id = 'x']) => Transaksi(
      id: id,
      keterangan: 'Tes',
      nominal: nominal,
      jenis: jenis,
      tanggal: DateTime(2026, 11, 18),
    );

void main() {
  const calc = KasCalculator();

  group('KasCalculator', () {
    test('daftar kosong menghasilkan saldo dan total 0', () {
      expect(calc.hitungSaldo([]), 0);
      expect(calc.totalPemasukan([]), 0);
      expect(calc.totalPengeluaran([]), 0);
    });

    test('hanya pemasukan: saldo sama dengan total pemasukan', () {
      final data = [_t(100000, JenisTransaksi.pemasukan), _t(50000, JenisTransaksi.pemasukan)];
      expect(calc.totalPemasukan(data), 150000);
      expect(calc.totalPengeluaran(data), 0);
      expect(calc.hitungSaldo(data), 150000);
    });

    test('hanya pengeluaran: total pengeluaran terhitung dan pemasukan 0', () {
      final data = [_t(30000, JenisTransaksi.pengeluaran), _t(20000, JenisTransaksi.pengeluaran)];
      expect(calc.totalPengeluaran(data), 50000);
      expect(calc.totalPemasukan(data), 0);
    });

    test('campuran: saldo = pemasukan - pengeluaran', () {
      final data = [
        _t(500000, JenisTransaksi.pemasukan),
        _t(120000, JenisTransaksi.pengeluaran),
        _t(80000, JenisTransaksi.pemasukan),
        _t(30000, JenisTransaksi.pengeluaran),
      ];
      expect(calc.totalPemasukan(data), 580000);
      expect(calc.totalPengeluaran(data), 150000);
      expect(calc.hitungSaldo(data), 430000);
    });

    test('nilai batas: pengeluaran tepat sama dengan saldo menghasilkan saldo 0', () {
      final data = [_t(250000, JenisTransaksi.pemasukan), _t(250000, JenisTransaksi.pengeluaran)];
      expect(calc.hitungSaldo(data), 0);
    });

    test('nilai batas: pengeluaran lebih 1 rupiah dari saldo menghasilkan saldo -1', () {
      final data = [_t(1000, JenisTransaksi.pemasukan), _t(1001, JenisTransaksi.pengeluaran)];
      expect(calc.hitungSaldo(data), -1);
    });

    test('urutan transaksi tidak memengaruhi hasil', () {
      final a = [_t(100, JenisTransaksi.pemasukan), _t(40, JenisTransaksi.pengeluaran)];
      final b = a.reversed.toList();
      expect(calc.hitungSaldo(a), calc.hitungSaldo(b));
    });

    test('satu transaksi saja', () {
      expect(calc.hitungSaldo([_t(1, JenisTransaksi.pemasukan)]), 1);
      expect(calc.hitungSaldo([_t(1, JenisTransaksi.pengeluaran)]), -1);
    });

    test('nominal besar tidak overflow pada skala kas himpunan', () {
      final data = [_t(2000000000, JenisTransaksi.pemasukan), _t(1999999999, JenisTransaksi.pengeluaran)];
      expect(calc.hitungSaldo(data), 1);
    });

    test('tidak mengubah daftar masukan', () {
      final data = [_t(100, JenisTransaksi.pemasukan, 'a'), _t(50, JenisTransaksi.pengeluaran, 'b')];
      calc.hitungSaldo(data);
      expect(data.map((t) => t.id), ['a', 'b']);
    });
  });
}
