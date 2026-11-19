import 'package:flutter/material.dart';
import '../theme.dart';
import '../state.dart';
import '../widgets.dart';
import 'tracking_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final active = appState.active;
        final done = appState.finished;
        return ListView(
          padding: const EdgeInsets.only(bottom: 32),
          children: [
            const ReCoinTopBar(subtitle: 'Jadwal Dan Riwayat'),
            _tabs(active.length, done.length),
            if (tab == 0) ...[
              if (active.isEmpty) _empty(context),
              for (final o in active) _activeCard(context, o),
            ] else ...[
              SectionHeader('Transaksi Terakhir',
                  icon: Icons.check_circle_outline,
                  action: 'Semua'),
              for (final o in done) _doneCard(context, o),
            ],
            _impact(),
          ],
        );
      },
    );
  }

  Widget _tabs(int a, int d) {
    Widget seg(int i, IconData icon, String label, int count) {
      final sel = tab == i;
      return Expanded(
        child: GestureDetector(
          onTap: () => setState(() => tab = i),
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: sel ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              boxShadow: sel
                  ? [BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 6)]
                  : null,
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(icon, size: 18, color: sel ? AppColors.deep : AppColors.slate),
              const SizedBox(width: 6),
              Text(label,
                  style: ts(13,
                      w: FontWeight.w700,
                      c: sel ? AppColors.deep : AppColors.slate)),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                    color: sel ? AppColors.mint : AppColors.surfaceLow,
                    borderRadius: BorderRadius.circular(999)),
                child: Text('$count',
                    style: ts(11, w: FontWeight.w700, c: AppColors.deep)),
              ),
            ]),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: AppColors.surfaceLow, borderRadius: BorderRadius.circular(14)),
      child: Row(children: [
        seg(0, Icons.local_shipping_outlined, 'Jadwal Aktif', a),
        seg(1, Icons.check_circle_outline, 'Riwayat Selesai', d),
      ]),
    );
  }

  Widget _empty(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(children: [
        const Icon(Icons.local_shipping_outlined,
            size: 48, color: AppColors.slate),
        const SizedBox(height: 10),
        Text('Tidak ada jadwal aktif', style: ts(16, w: FontWeight.w700)),
        const SizedBox(height: 4),
        Text('Yuk jual sampahmu dan jadwalkan penjemputan.',
            textAlign: TextAlign.center,
            style: ts(13, c: AppColors.slate)),
        const SizedBox(height: 16),
        PrimaryButton('Jual Sampah', onPressed: () => tabIndex.value = 1),
      ]),
    );
  }

  Widget _activeCard(BuildContext context, PickupOrder o) {
    final moving = o.status == OrderStatus.menuju;
    void open() => Navigator.push(context,
        MaterialPageRoute(builder: (_) => TrackingPage(orderId: o.id)));
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          statusPill(o.status),
          const Spacer(),
          Text('#${o.id}', style: ts(11, c: AppColors.slate)),
        ]),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: AppColors.surfaceLow,
              borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: AppColors.mint.withOpacity(.6),
                  borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.alarm, color: AppColors.deep),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Estimasi Waktu Penjemputan',
                    style: ts(11, c: AppColors.slate)),
                Text(o.slot, style: ts(14, w: FontWeight.w700)),
              ]),
            ),
          ]),
        ),
        const SizedBox(height: 12),
        Row(children: [
          const CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.deep,
              child: Icon(Icons.person, color: Colors.white)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Petugas: ${o.officer}', style: ts(14, w: FontWeight.w700)),
              Row(children: [
                const Icon(Icons.star, size: 14, color: AppColors.tertiary),
                Text(' 4.9 • Armada #B-04', style: ts(12, c: AppColors.slate)),
              ]),
            ]),
          ),
        ]),
        const SizedBox(height: 12),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.location_on_outlined, color: AppColors.deep),
          const SizedBox(width: 8),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Alamat Penjemputan', style: ts(11, c: AppColors.slate)),
              Text(o.address, style: ts(13, w: FontWeight.w600, h: 1.3)),
            ]),
          ),
        ]),
        const SizedBox(height: 12),
        Text('Rincian Sampah Dijual', style: ts(11, c: AppColors.slate)),
        const SizedBox(height: 6),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final e in o.items.entries)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: AppColors.surfaceLow,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(categories.firstWhere((c) => c.name == e.key).icon,
                    size: 18, color: AppColors.deep),
                const SizedBox(width: 8),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(e.key, style: ts(12, w: FontWeight.w600)),
                  Text('${fmtKg(e.value)} Kg',
                      style: ts(11, c: AppColors.slate)),
                ]),
              ]),
            ),
        ]),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(
            child: SizedBox(
              height: 48,
              child: FilledButton.icon(
                onPressed: () => _contact(context, o),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.mint,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.chat_bubble_outline,
                    size: 18, color: AppColors.deep),
                label: Text('Hubungi',
                    style: ts(12, w: FontWeight.w700, c: AppColors.deep)),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 48,
              child: FilledButton.icon(
                onPressed: open,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.deep,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.map_outlined, size: 18),
                label: Text(moving ? 'Buka Peta / Lacak' : 'Lihat Detail',
                    style: ts(12, w: FontWeight.w700, c: Colors.white)),
              ),
            ),
          ),
        ]),
      ]),
    );
  }

  void _contact(BuildContext context, PickupOrder o) {
    showSheet(
      context,
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Hubungi ${o.officer}', style: ts(18, w: FontWeight.w700)),
        const SizedBox(height: 12),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.call_outlined, color: AppColors.primary),
          title: Text('Telepon Petugas', style: ts(14, w: FontWeight.w600)),
          onTap: () {
            Navigator.pop(context);
            toast(context, 'Memanggil ${o.officer}... (simulasi)');
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.chat_outlined, color: AppColors.primary),
          title: Text('Kirim Pesan', style: ts(14, w: FontWeight.w600)),
          onTap: () {
            Navigator.pop(context);
            toast(context, 'Pesan terkirim: "Saya sudah siap di rumah"');
          },
        ),
      ]),
    );
  }

  Widget _doneCard(BuildContext context, PickupOrder o) {
    final cancelled = o.status == OrderStatus.dibatalkan;
    return AppCard(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(14),
      onTap: () => showReceipt(context, o),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('${fmtDate(o.date)} • ${fmtTime(o.date)}',
              style: ts(12, c: AppColors.slate)),
          const Spacer(),
          statusPill(o.status),
        ]),
        const SizedBox(height: 8),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Text('Setor ${fmtKg(o.totalKg)} Kg ${o.title}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: ts(15, w: FontWeight.w700, h: 1.3)),
          ),
          const SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(cancelled ? '-' : '+${fmtRp(o.total)}',
                style: ts(15,
                    w: FontWeight.w800,
                    c: cancelled ? AppColors.slate : AppColors.primary)),
            if (!cancelled) mintPill('+${o.points} Poin'),
          ]),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          const Icon(Icons.person_outline, size: 14, color: AppColors.slate),
          const SizedBox(width: 4),
          Text('Petugas: ${o.officer} • Kas Masuk Saldo',
              style: ts(11, c: AppColors.slate)),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          const Icon(Icons.eco_outlined, size: 14, color: AppColors.primary),
          const SizedBox(width: 4),
          Text('Reduksi Karbon: ±${o.co2.toStringAsFixed(1)} kg CO₂e',
              style: ts(11, c: AppColors.slate)),
          const Spacer(),
          Text('Lihat Struk ›',
              style: ts(11, w: FontWeight.w700, c: AppColors.primary)),
        ]),
      ]),
    );
  }

  Widget _impact() {
    final kg = appState.monthKg;
    final pct = (kg / 50).clamp(0.0, 1.0);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.deep,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.workspace_premium, color: AppColors.mint),
          const SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('PENCAPAIAN LINGKUNGAN',
                style: ts(10, w: FontWeight.w700, c: AppColors.mintSoft)),
            Text('Dampak Nyata Anda',
                style: ts(16, w: FontWeight.w800, c: Colors.white)),
          ]),
        ]),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(.08),
              borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            const Icon(Icons.public, color: AppColors.mint),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                  'Total ${kg.toStringAsFixed(0)} Kg sampah anorganik berhasil Anda daur ulang dari TPA!',
                  style: ts(12, c: Colors.white, h: 1.4)),
            ),
          ]),
        ),
        const SizedBox(height: 12),
        Row(children: [
          Text('Target Komunitas Bulan Ini: 50 Kg',
              style: ts(11, c: AppColors.mintSoft)),
          const Spacer(),
          Text('${(pct * 100).round()}%',
              style: ts(11, w: FontWeight.w800, c: AppColors.mint)),
        ]),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 8,
            backgroundColor: Colors.white.withOpacity(.15),
            valueColor: const AlwaysStoppedAnimation(AppColors.mint),
          ),
        ),
      ]),
    );
  }
}
