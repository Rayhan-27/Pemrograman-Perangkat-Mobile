import 'package:flutter/material.dart';
import '../theme.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  static const _items = <(IconData, String, String, String)>[
    (Icons.local_shipping, 'Kurir menuju lokasimu',
        'Mas Dadan sedang dalam perjalanan, estimasi ±12 menit.', 'Baru saja'),
    (Icons.monetization_on_outlined, 'Poin hijau bertambah',
        'Kamu mendapat +120 Poin dari penjualan minggu ini.', '2 jam lalu'),
    (Icons.account_balance_wallet_outlined, 'Penarikan berhasil',
        'Rp 50.000 sudah masuk ke GoPay kamu.', 'Kemarin'),
    (Icons.card_giftcard, 'Promo: Bonus poin 2x',
        'Setor kaleng aluminium akhir pekan ini, dapat poin 2x lipat.', '2 hari lalu'),
    (Icons.eco_outlined, 'Level naik!',
        'Selamat, kamu sekarang Pahlawan Lingkungan Level 3.', '5 hari lalu'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('Notifikasi', style: ts(17, w: FontWeight.w700)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final it = _items[i];
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primary.withOpacity(.08)),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: AppColors.mintTint,
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(it.$1, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(it.$2, style: ts(14, w: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(it.$3, style: ts(12, c: AppColors.slate, h: 1.4)),
                  const SizedBox(height: 4),
                  Text(it.$4, style: ts(11, c: AppColors.slate.withOpacity(.7))),
                ]),
              ),
            ]),
          );
        },
      ),
    );
  }
}
