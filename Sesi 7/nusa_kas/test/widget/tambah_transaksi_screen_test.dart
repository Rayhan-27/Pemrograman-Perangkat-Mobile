import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nusa_kas/domain/models/transaksi.dart';
import 'package:nusa_kas/ui/kas/kas_view_model.dart';
import 'package:nusa_kas/ui/kas/tambah_transaksi_screen.dart';

Future<void> _pump(WidgetTester tester, KasViewModel vm) async {
  tester.view.physicalSize = const Size(400, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MaterialApp(home: TambahTransaksiScreen(viewModel: vm)));
}

Future<void> _ketuk(WidgetTester tester, String key) async {
  final finder = find.byKey(Key(key));
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _isi(WidgetTester tester, String key, String teks) async {
  await tester.enterText(find.byKey(Key(key)), teks);
  await tester.pump();
}

void _seedSaldo(KasViewModel vm, int nominal) => vm.tambahTransaksi(
      keterangan: 'Saldo awal',
      nominal: nominal,
      jenis: JenisTransaksi.pemasukan,
      tanggal: DateTime(2026, 11, 1),
    );

void main() {
  testWidgets('form kosong menampilkan pesan validasi dan tidak menyimpan', (tester) async {
    final vm = KasViewModel();
    await _pump(tester, vm);

    await _ketuk(tester, 'btn_simpan');

    expect(find.text('Keterangan wajib diisi'), findsOneWidget);
    expect(find.text('Nominal wajib diisi'), findsOneWidget);
    expect(vm.daftar, isEmpty);
  });

  testWidgets('nominal nol ditolak', (tester) async {
    final vm = KasViewModel();
    await _pump(tester, vm);

    await _isi(tester, 'input_keterangan', 'Iuran');
    await _isi(tester, 'input_nominal', '0');
    await _ketuk(tester, 'btn_simpan');

    expect(find.text('Nominal harus lebih dari nol'), findsOneWidget);
    expect(vm.daftar, isEmpty);
  });

  testWidgets('nominal negatif ditolak', (tester) async {
    final vm = KasViewModel();
    await _pump(tester, vm);

    await _isi(tester, 'input_keterangan', 'Iuran');
    await _isi(tester, 'input_nominal', '-5000');
    await _ketuk(tester, 'btn_simpan');

    expect(find.text('Nominal harus lebih dari nol'), findsOneWidget);
    expect(vm.daftar, isEmpty);
  });

  testWidgets('pengeluaran melebihi saldo ditolak', (tester) async {
    final vm = KasViewModel();
    _seedSaldo(vm, 100000);
    await _pump(tester, vm);

    await _ketuk(tester, 'toggle_pengeluaran');
    await _isi(tester, 'input_keterangan', 'Beli konsumsi');
    await _isi(tester, 'input_nominal', '100001');
    await _ketuk(tester, 'btn_simpan');

    expect(find.textContaining('melebihi saldo'), findsOneWidget);
    expect(vm.daftar.length, 1);
  });

  testWidgets('pengeluaran tepat sama dengan saldo diterima', (tester) async {
    final vm = KasViewModel();
    _seedSaldo(vm, 100000);
    await _pump(tester, vm);

    await _ketuk(tester, 'toggle_pengeluaran');
    await _isi(tester, 'input_keterangan', 'Beli konsumsi');
    await _isi(tester, 'input_nominal', '100000');
    await _ketuk(tester, 'btn_simpan');

    expect(vm.daftar.length, 2);
    expect(vm.saldo, 0);
  });

  testWidgets('input valid tersimpan sebagai pemasukan dengan nominal terformat', (tester) async {
    final vm = KasViewModel();
    await _pump(tester, vm);

    await _isi(tester, 'input_keterangan', 'Iuran wajib');
    await _isi(tester, 'input_nominal', '850000');
    expect(find.text('850.000'), findsOneWidget); // titik ribuan otomatis
    await _ketuk(tester, 'btn_simpan');

    expect(vm.daftar.single.keterangan, 'Iuran wajib');
    expect(vm.daftar.single.nominal, 850000);
    expect(vm.daftar.single.jenis, JenisTransaksi.pemasukan);
  });
}
