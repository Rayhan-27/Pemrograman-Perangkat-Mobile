import 'package:flutter/material.dart';
import '../theme.dart';
import '../state.dart';
import '../widgets.dart';
import 'tracking_page.dart';

class SuccessPage extends StatelessWidget {
  final String orderId;
  const SuccessPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final o = appState.orders.firstWhere((x) => x.id == orderId);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            const Spacer(),
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                  color: AppColors.mintTint, shape: BoxShape.circle),
              child: const Icon(Icons.check_circle,
                  size: 64, color: AppColors.secondary),
            ),
            const SizedBox(height: 20),
            Text('Penjemputan Terjadwal!',
                textAlign: TextAlign.center,
                style: ts(24, w: FontWeight.w800, c: AppColors.deep)),
            const SizedBox(height: 8),
            Text('Kurir ReCoin akan datang sesuai jadwal. Siapkan sampahmu ya.',
                textAlign: TextAlign.center,
                style: ts(14, c: AppColors.slate, h: 1.5)),
            const SizedBox(height: 24),
            AppCard(
              margin: EdgeInsets.zero,
              child: Column(children: [
                _r('ID Pesanan', '#${o.id}'),
                _r('Waktu', o.slot.replaceAll(' • ', '\n')),
                _r('Total Berat', '${fmtKg(o.totalKg)} Kg'),
                _r('Estimasi Uang', fmtRp(o.total)),
                _r('Bonus Poin', '+${o.points} Poin'),
              ]),
            ),
            const Spacer(),
            PrimaryButton('Lacak Penjemputan', icon: Icons.navigation_outlined,
                onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => TrackingPage(orderId: o.id)));
            }),
            const SizedBox(height: 8),
            PrimaryButton('Lihat Jadwal', soft: true, onPressed: () {
              tabIndex.value = 3;
              Navigator.popUntil(context, (r) => r.isFirst);
            }),
            const SizedBox(height: 4),
            TextButton(
              onPressed: () {
                tabIndex.value = 0;
                Navigator.popUntil(context, (r) => r.isFirst);
              },
              child: Text('Kembali ke Beranda',
                  style: ts(13, w: FontWeight.w700, c: AppColors.slate)),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _r(String l, String r) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l, style: ts(13, c: AppColors.slate)),
          const Spacer(),
          Text(r,
              textAlign: TextAlign.right,
              style: ts(13, w: FontWeight.w700)),
        ]),
      );
}
