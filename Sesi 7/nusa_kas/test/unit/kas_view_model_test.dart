import 'package:flutter_test/flutter_test.dart';
import 'package:nusa_kas/domain/models/transaksi.dart';
import 'package:nusa_kas/ui/core/format.dart';
import 'package:nusa_kas/ui/kas/kas_view_model.dart';

String? _tambah(KasViewModel vm, int nominal, JenisTransaksi jenis, {String ket = 'Tes'}) =>
    vm.tambahTransaksi(keterangan: ket, nominal: nominal, jenis: jenis, tanggal: DateTime(2026, 11, 18));

void main() {
  group('Validasi KasViewModel', () {
    test('menolak nominal nol', () {
      final vm = KasViewModel();
      expect(_tambah(vm, 0, JenisTransaksi.pemasukan), isNotNull);
      expect(vm.daftar, isEmpty);
    });

    test('menolak nominal negatif', () {
      final vm = KasViewModel();
      expect(_tambah(vm, -500, JenisTransaksi.pemasukan), isNotNull);
      expect(vm.daftar, isEmpty);
    });

    test('menolak pengeluaran yang melebihi saldo', () {
      final vm = KasViewModel();
      _tambah(vm, 100000, JenisTransaksi.pemasukan);
      expect(_tambah(vm, 100001, JenisTransaksi.pengeluaran), contains('melebihi saldo'));
      expect(vm.saldo, 100000);
    });

    test('menerima pengeluaran tepat sama dengan saldo (nilai batas)', () {
      final vm = KasViewModel();
      _tambah(vm, 100000, JenisTransaksi.pemasukan);
      expect(_tambah(vm, 100000, JenisTransaksi.pengeluaran), isNull);
      expect(vm.saldo, 0);
    });

    test('menolak pengeluaran saat saldo masih 0', () {
      final vm = KasViewModel();
      expect(_tambah(vm, 1, JenisTransaksi.pengeluaran), isNotNull);
    });

    test('menolak keterangan kosong', () {
      final vm = KasViewModel();
      expect(_tambah(vm, 1000, JenisTransaksi.pemasukan, ket: '   '), isNotNull);
    });

    test('hapus pengeluaran selalu boleh, hapus pemasukan yang membuat saldo minus ditolak', () {
      final vm = KasViewModel();
      _tambah(vm, 100000, JenisTransaksi.pemasukan);
      _tambah(vm, 60000, JenisTransaksi.pengeluaran);
      final pemasukan = vm.daftar.firstWhere((t) => t.jenis == JenisTransaksi.pemasukan);
      final pengeluaran = vm.daftar.firstWhere((t) => t.jenis == JenisTransaksi.pengeluaran);
      expect(vm.bisaHapus(pemasukan), isFalse);
      expect(vm.bisaHapus(pengeluaran), isTrue);
      vm.hapus(pengeluaran.id);
      expect(vm.saldo, 100000);
      expect(vm.bisaHapus(pemasukan), isTrue);
    });
  });

  group('Format', () {
    test('formatRupiah memakai titik ribuan', () {
      expect(formatRupiah(14850000), 'Rp 14.850.000');
      expect(formatRupiah(0), 'Rp 0');
      expect(formatRupiah(-1500), '-Rp 1.500');
    });

    test('parseNominal membuang titik ribuan', () {
      expect(parseNominal('50.000'), 50000);
      expect(parseNominal('-5.000'), -5000);
      expect(parseNominal(''), 0);
    });
  });
}
