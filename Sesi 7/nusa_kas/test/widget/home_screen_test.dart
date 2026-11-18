import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nusa_kas/domain/models/transaksi.dart';
import 'package:nusa_kas/ui/kas/home_screen.dart';
import 'package:nusa_kas/ui/kas/kas_view_model.dart';

void _tambah(KasViewModel vm, String ket, int nominal, JenisTransaksi jenis) => vm.tambahTransaksi(
      keterangan: ket,
      nominal: nominal,
      jenis: jenis,
      tanggal: DateTime(2026, 11, 18),
    );

Future<void> _pump(WidgetTester tester, KasViewModel vm) async {
  tester.view.physicalSize = const Size(400, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MaterialApp(home: HomeScreen(viewModel: vm)));
}

String _teks(WidgetTester tester, String key) => tester.widget<Text>(find.byKey(Key(key))).data!;

void main() {
  testWidgets('menampilkan saldo, total, dan daftar transaksi', (tester) async {
    final vm = KasViewModel();
    _tambah(vm, 'Iuran wajib', 1000000, JenisTransaksi.pemasukan);
    _tambah(vm, 'Beli konsumsi', 275000, JenisTransaksi.pengeluaran);
    await _pump(tester, vm);

    expect(_teks(tester, 'text_saldo'), 'Rp 725.000');
    expect(_teks(tester, 'text_total_pemasukan'), 'Rp 1.000.000');
    expect(_teks(tester, 'text_total_pengeluaran'), 'Rp 275.000');
    expect(find.text('Iuran wajib'), findsOneWidget);
    expect(find.text('Beli konsumsi'), findsOneWidget);
  });

  testWidgets('daftar kosong menampilkan keadaan kosong dan saldo 0', (tester) async {
    await _pump(tester, KasViewModel());

    expect(find.text('Belum ada transaksi'), findsOneWidget);
    expect(_teks(tester, 'text_saldo'), 'Rp 0');
  });

  testWidgets('geser ke kiri menghapus transaksi dan memperbarui saldo', (tester) async {
    final vm = KasViewModel();
    _tambah(vm, 'Iuran wajib', 500000, JenisTransaksi.pemasukan);
    _tambah(vm, 'Cetak banner', 100000, JenisTransaksi.pengeluaran);
    await _pump(tester, vm);

    final idPengeluaran = vm.daftar.firstWhere((t) => t.jenis == JenisTransaksi.pengeluaran).id;
    await tester.drag(find.byKey(Key('item_$idPengeluaran')), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(find.text('Cetak banner'), findsNothing);
    expect(_teks(tester, 'text_saldo'), 'Rp 500.000');
  });

  testWidgets('pemasukan yang membuat saldo minus tidak bisa dihapus', (tester) async {
    final vm = KasViewModel();
    _tambah(vm, 'Iuran wajib', 500000, JenisTransaksi.pemasukan);
    _tambah(vm, 'Cetak banner', 100000, JenisTransaksi.pengeluaran);
    await _pump(tester, vm);

    final idPemasukan = vm.daftar.firstWhere((t) => t.jenis == JenisTransaksi.pemasukan).id;
    await tester.drag(find.byKey(Key('item_$idPemasukan')), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(find.text('Iuran wajib'), findsOneWidget);
    expect(find.textContaining('saldo akan menjadi minus'), findsOneWidget);
    expect(_teks(tester, 'text_saldo'), 'Rp 400.000');
  });
}
