import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme.dart';
import '../state.dart';
import '../widgets.dart';
import 'tracking_page.dart';
import 'profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.only(bottom: 32),
          children: [
            const ReCoinTopBar(subtitle: 'Beranda'),
            _greeting(context),
            _balanceCard(context),
            SectionHeader('Penjemputan Terdekat',
                action: appState.nearest != null ? 'AKTIF' : null,
                onAction: () => tabIndex.value = 3),
            _pickupCard(context),
            SectionHeader('Statistik Daur Ulang',
                action: 'Laporan',
                onAction: () => toast(context, 'Laporan lengkap segera hadir'),
                chip: Pill('Bulan Ini',
                    bg: AppColors.surfaceLow, fg: AppColors.slate)),
            _statsCard(),
            SectionHeader('Tips Cerdas Pemilahan',
                icon: Icons.lightbulb_outline,
                action: 'Harga Lebih Tinggi',
                onAction: () => tabIndex.value = 1),
            _tip(
              context,
              icon: Icons.water_drop,
              badge: '+Rp 500/kg',
              title: 'Bilas & Keringkan Botol Plastik',
              short:
                  'Pastikan botol bersih dari sisa sirup atau minyak agar bobot timbangan akurat.',
              long:
                  '1. Buang sisa isi botol.\n2. Bilas dengan air, kocok sebentar.\n3. Lepas tutup dan label jika mudah.\n4. Keringkan dengan posisi terbalik.\n\nBotol bersih dan kering dihargai lebih tinggi karena tidak perlu dicuci ulang oleh pihak daur ulang.',
            ),
            _tip(
              context,
              icon: Icons.inventory_2,
              badge: 'Mudah Angkut',
              title: 'Pipihkan Kardus & Ikat Rapi',
              short:
                  'Buka lipatan kardus hingga rata dan ikat erat dengan tali agar tidak makan tempat.',
              long:
                  '1. Lepas lakban dan staples.\n2. Pipihkan kardus hingga rata.\n3. Tumpuk dan ikat dengan tali rafia.\n4. Simpan di tempat kering.\n\nKardus yang basah akan dikurangi bobotnya saat ditimbang.',
            ),
            _referral(context),
          ],
        );
      },
    );
  }

  Widget _greeting(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Halo, ${appState.userName} 👋',
                style: ts(24, w: FontWeight.w700, h: 1.3)),
            const SizedBox(height: 6),
            mintPill('Pahlawan Lingkungan • Level ${appState.level}',
                icon: Icons.eco_outlined),
          ]),
        ),
        GestureDetector(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ProfilePage())),
          child: Stack(children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.mintSoft,
              child: Text(appState.userName[0],
                  style: ts(26, w: FontWeight.w800, c: AppColors.deep)),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  Widget _balanceCard(BuildContext context) {
    return AppCard(
      child: Column(children: [
        Row(children: [
          Expanded(
            child: _miniBox(Icons.account_balance_wallet_outlined, 'Saldo Aktif',
                fmtRp(appState.balance), null, 'Bisa dicairkan ke bank'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _miniBox(Icons.stars_outlined, 'Poin Hijau',
                fmtNum(appState.points), 'Poin', 'Tukar diskon & voucher'),
          ),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
              child: _action(Icons.add_circle_outline, 'Jual Sampah', true,
                  () => tabIndex.value = 1)),
          const SizedBox(width: 8),
          Expanded(
              child: _action(Icons.account_balance_outlined, 'Tarik Saldo',
                  false, () {
            walletTab.value = 0;
            tabIndex.value = 2;
          })),
          const SizedBox(width: 8),
          Expanded(
              child: _action(Icons.confirmation_number_outlined,
                  'Tukar Voucher', false, () {
            walletTab.value = 1;
            tabIndex.value = 2;
          })),
        ]),
      ]),
    );
  }

  Widget _miniBox(IconData icon, String label, String value, String? unit,
      String caption) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: AppColors.surfaceLow, borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, size: 16, color: AppColors.slate),
          const SizedBox(width: 6),
          Flexible(
              child: Text(label,
                  style: ts(12, w: FontWeight.w600, c: AppColors.slate))),
        ]),
        const SizedBox(height: 8),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(value, style: ts(22, w: FontWeight.w800, c: AppColors.deep)),
            if (unit != null) ...[
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(unit, style: ts(12, c: AppColors.slate)),
              ),
            ],
          ]),
        ),
        const SizedBox(height: 4),
        Text(caption, style: ts(11, c: AppColors.slate)),
      ]),
    );
  }

  Widget _action(IconData icon, String label, bool filled, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 68,
        decoration: BoxDecoration(
          color: filled ? AppColors.primary : AppColors.surfaceLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: filled ? Colors.white : AppColors.primary, size: 24),
          const SizedBox(height: 4),
          Text(label,
              style: ts(12,
                  w: FontWeight.w700,
                  c: filled ? Colors.white : AppColors.text)),
        ]),
      ),
    );
  }

  Widget _pickupCard(BuildContext context) {
    final o = appState.nearest;
    if (o == null) {
      return AppCard(
        child: Row(children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
                color: AppColors.surfaceLow,
                borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.local_shipping_outlined,
                color: AppColors.slate),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Belum ada jadwal penjemputan',
                  style: ts(14, w: FontWeight.w700)),
              Text('Jual sampah pertamamu hari ini.',
                  style: ts(12, c: AppColors.slate)),
            ]),
          ),
          TextButton(
              onPressed: () => tabIndex.value = 1,
              child: Text('Jual', style: ts(13, w: FontWeight.w700, c: AppColors.primary))),
        ]),
      );
    }
    final moving = o.status == OrderStatus.menuju;
    return AppCard(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => TrackingPage(orderId: o.id))),
      child: Column(children: [
        Row(children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
                color: AppColors.mint.withOpacity(.6),
                borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.local_shipping, color: AppColors.deep),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(o.slot, style: ts(15, w: FontWeight.w700)),
              Text(o.address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ts(12, c: AppColors.slate)),
            ]),
          ),
        ]),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: AppColors.surfaceLow,
              borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            const CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.deep,
                child: Icon(Icons.person, color: Colors.white, size: 18)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Armada #B-04 (Mas Dadan)',
                    style: ts(12, w: FontWeight.w700)),
                Text(moving ? 'Menuju alamat (~12 Menit)' : 'Menunggu jadwal',
                    style: ts(12, c: AppColors.slate)),
              ]),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => TrackingPage(orderId: o.id))),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.deep,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              icon: const Icon(Icons.navigation_outlined, size: 16),
              label: Text('Lacak', style: ts(12, w: FontWeight.w700, c: Colors.white)),
            ),
          ]),
        ),
      ]),
    );
  }

  Widget _statsCard() {
    const weeks = [3.2, 4.8, 6.5, 4.0];
    const labels = ['M-1', 'M-2', 'M-3', 'M-4'];
    return AppCard(
      child: Column(children: [
        Row(children: [
          Expanded(
            child: _stat(Icons.scale, AppColors.surfaceLow,
                '${appState.monthKg.toStringAsFixed(1)} Kg', 'Sampah Terkumpul'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _stat(Icons.cloud_outlined, AppColors.mint.withOpacity(.5),
                '${appState.monthCo2.toStringAsFixed(1)} Kg', 'CO2 Dicegah'),
          ),
        ]),
        const SizedBox(height: 16),
        Row(children: [
          Text('Riwayat Mingguan (Kg)', style: ts(12, w: FontWeight.w600)),
          const Spacer(),
          Text('Target: 20 Kg/Bulan', style: ts(11, c: AppColors.slate)),
        ]),
        const SizedBox(height: 12),
        SizedBox(
          height: 130,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(4, (i) {
              final h = weeks[i] / 7 * 90;
              final cur = i == 2;
              return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text(weeks[i].toString(), style: ts(11, c: AppColors.slate)),
                const SizedBox(height: 4),
                Container(
                  width: 38,
                  height: h,
                  decoration: BoxDecoration(
                    color: cur
                        ? AppColors.deep
                        : (i == 1 || i == 3)
                            ? AppColors.secondary.withOpacity(.6)
                            : const Color(0xFFD8E3DC),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                ),
                const SizedBox(height: 6),
                Text(labels[i], style: ts(11, w: FontWeight.w600)),
              ]);
            }),
          ),
        ),
      ]),
    );
  }

  Widget _stat(IconData icon, Color bg, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: AppColors.surfaceLow, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Container(
          width: 40,
          height: 40,
          decoration:
              BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: AppColors.deep, size: 22),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(value, style: ts(18, w: FontWeight.w800))),
            Text(label, style: ts(11, c: AppColors.slate)),
          ]),
        ),
      ]),
    );
  }

  Widget _tip(BuildContext context,
      {required IconData icon,
      required String badge,
      required String title,
      required String short,
      required String long}) {
    return AppCard(
      padding: const EdgeInsets.all(8),
      onTap: () => showSheet(
        context,
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(child: Text(title, style: ts(17, w: FontWeight.w700))),
          ]),
          const SizedBox(height: 12),
          Text(long, style: ts(14, c: AppColors.slate, h: 1.6)),
          const SizedBox(height: 16),
          PrimaryButton('Paham, Jual Sampah Sekarang', onPressed: () {
            Navigator.pop(context);
            tabIndex.value = 1;
          }),
        ]),
      ),
      child: Row(children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [AppColors.mintTint, AppColors.mintSoft],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(children: [
            Center(child: Icon(icon, size: 40, color: AppColors.primary)),
            Positioned(
              left: 6,
              right: 6,
              bottom: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 3),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.9),
                    borderRadius: BorderRadius.circular(8)),
                child: Text(badge,
                    textAlign: TextAlign.center,
                    style: ts(10, w: FontWeight.w700, c: AppColors.deep)),
              ),
            ),
          ]),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: ts(15, w: FontWeight.w700, h: 1.3)),
            const SizedBox(height: 4),
            Text(short,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: ts(12, c: AppColors.slate, h: 1.4)),
          ]),
        ),
      ]),
    );
  }

  Widget _referral(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.deep],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Ajak Tetangga Menabung!',
                style: ts(20, w: FontWeight.w800, c: Colors.white, h: 1.2)),
            const SizedBox(height: 6),
            Text('Dapatkan 250 Poin tambahan tiap referral.',
                style: ts(13, c: AppColors.mintSoft, h: 1.4)),
          ]),
        ),
        const SizedBox(width: 12),
        FilledButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: appState.referralCode));
            toast(context,
                'Kode ${appState.referralCode} disalin. Bagikan ke tetanggamu!');
          },
          style: FilledButton.styleFrom(
            backgroundColor: Colors.white,
            minimumSize: const Size(0, 44),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text('Bagikan Kode',
              style: ts(13, w: FontWeight.w700, c: AppColors.deep)),
        ),
      ]),
    );
  }
}
