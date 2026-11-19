import 'package:flutter/material.dart';
import 'theme.dart';
import 'state.dart';
import 'pages/notifications_page.dart';
import 'pages/profile_page.dart';

// ====== Format ======
String fmtNum(int v) {
  final s = v.abs().toString();
  final b = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return '${v < 0 ? '-' : ''}$b';
}

String fmtRp(int v) => 'Rp ${fmtNum(v)}';

String fmtKg(double v) => v == v.roundToDouble()
    ? v.toInt().toString()
    : v.toStringAsFixed(1).replaceAll('.', ',');

const _bulan = [
  'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
  'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
];
String fmtDate(DateTime d) => '${d.day} ${_bulan[d.month - 1]} ${d.year}';
String fmtTime(DateTime d) =>
    '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')} WIB';

void toast(BuildContext context, String msg) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg)));
}

// ====== Dekorasi ======
BoxDecoration cardDeco({Color color = Colors.white, double radius = 16}) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: AppColors.primary.withOpacity(.08)),
    boxShadow: [
      BoxShadow(
          color: AppColors.primary.withOpacity(.06),
          blurRadius: 16,
          spreadRadius: -2,
          offset: const Offset(0, 4)),
      BoxShadow(
          color: Colors.black.withOpacity(.04),
          blurRadius: 3,
          offset: const Offset(0, 1)),
    ],
  );
}

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final Color color;
  final EdgeInsets margin;
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.color = Colors.white,
    this.margin = const EdgeInsets.fromLTRB(16, 0, 16, 16),
  });

  @override
  Widget build(BuildContext context) {
    final box = Container(
      margin: margin,
      padding: padding,
      decoration: cardDeco(color: color),
      child: child,
    );
    if (onTap == null) return box;
    return GestureDetector(onTap: onTap, child: box);
  }
}

class Pill extends StatelessWidget {
  final String text;
  final Color bg, fg;
  final IconData? icon;
  const Pill(this.text,
      {super.key, required this.bg, required this.fg, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
        ],
        Text(text, style: ts(11, w: FontWeight.w600, c: fg)),
      ]),
    );
  }
}

Pill mintPill(String t, {IconData? icon}) =>
    Pill(t, bg: AppColors.mintTint, fg: AppColors.primary, icon: icon);
Pill amberPill(String t, {IconData? icon}) =>
    Pill(t, bg: AppColors.amberTint, fg: AppColors.amberText, icon: icon);
Pill rosePill(String t) =>
    Pill(t, bg: AppColors.roseTint, fg: AppColors.roseText);

Pill statusPill(OrderStatus s) {
  switch (s) {
    case OrderStatus.dijadwalkan:
      return amberPill('Dijadwalkan', icon: Icons.schedule);
    case OrderStatus.menuju:
      return amberPill('Kurir Menuju Lokasi', icon: Icons.local_shipping);
    case OrderStatus.selesai:
      return mintPill('Selesai', icon: Icons.done_all);
    case OrderStatus.dibatalkan:
      return rosePill('Dibatalkan');
  }
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool soft;
  const PrimaryButton(this.label,
      {super.key, this.icon, this.onPressed, this.soft = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor:
              soft ? AppColors.secondary.withOpacity(.14) : AppColors.primary,
          foregroundColor: soft ? AppColors.primary : Colors.white,
          disabledBackgroundColor: AppColors.surfaceLow,
          disabledForegroundColor: AppColors.slate.withOpacity(.6),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
          Flexible(
              child: Text(label,
                  overflow: TextOverflow.ellipsis,
                  style: ts(14,
                      w: FontWeight.w700,
                      c: onPressed == null
                          ? AppColors.slate.withOpacity(.6)
                          : (soft ? AppColors.primary : Colors.white)))),
        ]),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  final IconData? icon;
  final Widget? chip;
  const SectionHeader(this.title,
      {super.key, this.action, this.onAction, this.icon, this.chip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(children: [
        if (icon != null) ...[
          Icon(icon, size: 20, color: AppColors.tertiary),
          const SizedBox(width: 6),
        ],
        Text(title, style: ts(18, w: FontWeight.w700)),
        if (chip != null) ...[const SizedBox(width: 8), chip!],
        const Spacer(),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Text(action!,
                style: ts(12, w: FontWeight.w700, c: AppColors.primary)),
          ),
      ]),
    );
  }
}

// ====== Top bar ======
class ReCoinTopBar extends StatelessWidget {
  final String subtitle;
  const ReCoinTopBar({super.key, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.recycling, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('ReCoin',
              style: ts(18, w: FontWeight.w800, c: AppColors.deep, h: 1.1)),
          Text(subtitle, style: ts(11, c: AppColors.slate, h: 1.2)),
        ]),
        const Spacer(),
        ListenableBuilder(
          listenable: appState,
          builder: (context, _) => GestureDetector(
            onTap: () {
              appState.clearUnread();
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const NotificationsPage()));
            },
            child: SizedBox(
              width: 44,
              height: 44,
              child: Stack(alignment: Alignment.center, children: [
                const Icon(Icons.notifications_none, size: 26),
                if (appState.unread > 0)
                  Positioned(
                    top: 9,
                    right: 10,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: const BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
                    ),
                  ),
              ]),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ProfilePage())),
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
                color: AppColors.primary, shape: BoxShape.circle),
            child: const Icon(Icons.person_outline,
                color: Colors.white, size: 22),
          ),
        ),
      ]),
    );
  }
}

// ====== Struk ======
void showReceipt(BuildContext context, PickupOrder o) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (_) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: AppColors.slate.withOpacity(.3),
                  borderRadius: BorderRadius.circular(4))),
          const SizedBox(height: 16),
          Row(children: [
            const Icon(Icons.receipt_long, color: AppColors.primary),
            const SizedBox(width: 8),
            Text('Struk Penjualan', style: ts(18, w: FontWeight.w700)),
            const Spacer(),
            statusPill(o.status),
          ]),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('${o.id} • ${fmtDate(o.date)} • ${fmtTime(o.date)}',
                style: ts(12, c: AppColors.slate)),
          ),
          const Divider(height: 28),
          ...o.items.entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(children: [
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(e.key, style: ts(14, w: FontWeight.w600)),
                        Text(
                            '${fmtKg(e.value)} Kg × ${fmtRp(priceOf(e.key))}',
                            style: ts(12, c: AppColors.slate)),
                      ])),
                  Text(fmtRp((priceOf(e.key) * e.value).round()),
                      style: ts(14, w: FontWeight.w600)),
                ]),
              )),
          if (o.fee > 0)
            _row('Ongkos jemput', '- ${fmtRp(o.fee)}', c: AppColors.roseText),
          _row('Petugas', o.officer),
          _row('Reduksi karbon', '±${o.co2.toStringAsFixed(1)} kg CO₂e'),
          const Divider(height: 24),
          _row('Total masuk saldo', fmtRp(o.total), bold: true),
          _row('Bonus poin hijau', '+${o.points} Poin',
              bold: true, c: AppColors.primary),
          const SizedBox(height: 16),
          PrimaryButton('Tutup', onPressed: () => Navigator.pop(context)),
        ]),
      ),
    ),
  );
}

Widget _row(String l, String r, {bool bold = false, Color? c}) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(l, style: ts(13, c: AppColors.slate)),
        Text(r,
            style: ts(bold ? 16 : 13,
                w: bold ? FontWeight.w800 : FontWeight.w600, c: c)),
      ]),
    );

void showSheet(BuildContext context, Widget child) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (_) => SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            20, 12, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: AppColors.slate.withOpacity(.3),
                  borderRadius: BorderRadius.circular(4))),
          const SizedBox(height: 16),
          child,
        ]),
      ),
    ),
  );
}
