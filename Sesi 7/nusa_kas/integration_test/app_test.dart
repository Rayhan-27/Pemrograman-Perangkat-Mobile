import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nusa_kas/main.dart';

Future<void> _ketuk(WidgetTester tester, String key) async {
  final finder = find.byKey(Key(key));
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _isi(WidgetTester tester, String key, String teks) async {
  await tester.enterText(find.byKey(Key(key)), teks);
  await tester.pumpAndSettle();
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('tambah dua transaksi lalu periksa saldo', (tester) async {
    await tester.pumpWidget(const NusaKasApp());
    await tester.pumpAndSettle();

    expect(tester.widget<Text>(find.byKey(const Key('text_saldo'))).data, 'Rp 0');

    // 1) Pemasukan Rp 1.000.000
    await _ketuk(tester, 'fab_tambah');
    await _isi(tester, 'input_keterangan', 'Iuran wajib anggota');
    await _isi(tester, 'input_nominal', '1000000');
    await _ketuk(tester, 'btn_simpan');

    // 2) Pengeluaran Rp 250.000
    await _ketuk(tester, 'fab_tambah');
    await _ketuk(tester, 'toggle_pengeluaran');
    await _isi(tester, 'input_keterangan', 'Beli konsumsi rapat');
    await _isi(tester, 'input_nominal', '250000');
    await _ketuk(tester, 'btn_simpan');

    expect(tester.widget<Text>(find.byKey(const Key('text_saldo'))).data, 'Rp 750.000');
    expect(tester.widget<Text>(find.byKey(const Key('text_total_pemasukan'))).data, 'Rp 1.000.000');
    expect(tester.widget<Text>(find.byKey(const Key('text_total_pengeluaran'))).data, 'Rp 250.000');
    expect(find.text('Iuran wajib anggota'), findsOneWidget);
    expect(find.text('Beli konsumsi rapat'), findsOneWidget);
  });
}
