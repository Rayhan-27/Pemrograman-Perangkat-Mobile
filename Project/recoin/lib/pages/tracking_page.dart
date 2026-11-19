import 'package:flutter/material.dart';
import '../theme.dart';
import '../state.dart';
import '../widgets.dart';

class TrackingPage extends StatefulWidget {
  final String orderId;
  const TrackingPage({super.key, required this.orderId});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  PickupOrder get order =>
      appState.orders.firstWhere((o) => o.id == widget.orderId);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 25));
    final s = order.status;
    if (s == OrderStatus.menuju) {
      _ctrl.forward();
    } else if (s == OrderStatus.selesai) {
      _ctrl.value = 1;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _advance() {
    final o = order;
    if (o.status == OrderStatus.dijadwalkan) {
      appState.setStatus(o, OrderStatus.menuju);
      _ctrl.forward(from: 0);
    } else if (o.status == OrderStatus.menuju) {
      _ctrl.value = 1;
      appState.setStatus(o, OrderStatus.selesai);
      toast(context,
          'Penjemputan selesai! +${fmtRp(o.total)} & +${o.points} Poin masuk');
    }
  }

  void _cancel() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Batalkan penjemputan?', style: ts(17, w: FontWeight.w700)),
        content: Text('Jadwal penjemputan ini akan dibatalkan.',
            style: ts(13, c: AppColors.slate)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Tidak', style: ts(13, c: AppColors.slate))),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.roseText),
            onPressed: () {
              appState.setStatus(order, OrderStatus.dibatalkan);
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: Text('Ya, Batalkan',
                style: ts(13, w: FontWeight.w700, c: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final o = order;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.bg,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: Text('Lacak Penjemputan', style: ts(17, w: FontWeight.w700)),
          ),
          body: ListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              _map(o),
              _statusCard(o),
              _stepper(o),
              _officerCard(context, o),
              _detailCard(o),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(children: [
                  if (o.status == OrderStatus.selesai)
                    PrimaryButton('Lihat Struk',
                        icon: Icons.receipt_long,
                        onPressed: () => showReceipt(context, o))
                  else if (o.status == OrderStatus.dibatalkan)
                    PrimaryButton('Kembali', onPressed: () => Navigator.pop(context))
                  else ...[
                    PrimaryButton(
                      o.status == OrderStatus.dijadwalkan
                          ? 'Simulasi: Petugas Berangkat'
                          : 'Simulasi: Petugas Tiba & Timbang',
                      icon: Icons.play_arrow_rounded,
                      onPressed: _advance,
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _cancel,
                      child: Text('Batalkan Penjemputan',
                          style: ts(13, w: FontWeight.w700, c: AppColors.roseText)),
                    ),
                  ],
                ]),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _map(PickupOrder o) {
    return Container(
      height: 240,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: cardDeco(),
      clipBehavior: Clip.antiAlias,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          final t = o.status == OrderStatus.dijadwalkan ? 0.0 : _ctrl.value;
          return Stack(children: [
            Positioned.fill(
              child: CustomPaint(painter: _MapPainter(t, o.status)),
            ),
            Positioned(
              left: 12,
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                    color: AppColors.deep,
                    borderRadius: BorderRadius.circular(999)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.navigation, size: 14, color: AppColors.mint),
                  const SizedBox(width: 6),
                  Text(
                    o.status == OrderStatus.selesai
                        ? 'Petugas telah tiba'
                        : o.status == OrderStatus.dijadwalkan
                            ? 'Menunggu petugas berangkat'
                            : 'Petugas berjarak ${(1.2 * (1 - t)).toStringAsFixed(1)} Km (±${(12 * (1 - t)).ceil()} Menit)',
                    style: ts(11, w: FontWeight.w600, c: Colors.white),
                  ),
                ]),
              ),
            ),
            Positioned(
              right: 12,
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: AppColors.mint,
                    borderRadius: BorderRadius.circular(6)),
                child: Text('Live',
                    style: ts(10, w: FontWeight.w700, c: AppColors.deep)),
              ),
            ),
          ]);
        },
      ),
    );
  }

  Widget _statusCard(PickupOrder o) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            statusPill(o.status),
            const SizedBox(height: 8),
            Text('Estimasi Penjemputan', style: ts(11, c: AppColors.slate)),
            Text(o.slot, style: ts(15, w: FontWeight.w700)),
          ]),
        ),
        Text('#${o.id}', style: ts(12, c: AppColors.slate)),
      ]),
    );
  }

  Widget _stepper(PickupOrder o) {
    final labels = ['Dijadwalkan', 'Menuju Lokasi', 'Penimbangan', 'Selesai'];
    int step;
    switch (o.status) {
      case OrderStatus.dijadwalkan:
        step = 0;
        break;
      case OrderStatus.menuju:
        step = 1;
        break;
      case OrderStatus.selesai:
        step = 3;
        break;
      case OrderStatus.dibatalkan:
        step = -1;
        break;
    }
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Row(children: [
        for (int i = 0; i < labels.length; i++) ...[
          Expanded(
            child: Column(children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: i <= step ? AppColors.primary : AppColors.surfaceLow,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  i < step || (i == 3 && step == 3)
                      ? Icons.check
                      : Icons.circle,
                  size: i <= step ? 16 : 8,
                  color: i <= step ? Colors.white : AppColors.slate.withOpacity(.4),
                ),
              ),
              const SizedBox(height: 6),
              Text(labels[i],
                  textAlign: TextAlign.center,
                  style: ts(10,
                      w: i == step ? FontWeight.w800 : FontWeight.w500,
                      c: i <= step ? AppColors.deep : AppColors.slate)),
            ]),
          ),
        ],
      ]),
    );
  }

  Widget _officerCard(BuildContext context, PickupOrder o) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Row(children: [
        const CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.deep,
            child: Icon(Icons.person, color: Colors.white, size: 28)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(o.officer, style: ts(15, w: FontWeight.w700)),
            Row(children: [
              const Icon(Icons.star, size: 14, color: AppColors.tertiary),
              Text(' 4.9 • Armada #B-04',
                  style: ts(12, c: AppColors.slate)),
            ]),
          ]),
        ),
        IconButton.filled(
          style: IconButton.styleFrom(backgroundColor: AppColors.mint),
          onPressed: () => toast(context, 'Memanggil ${o.officer}... (simulasi)'),
          icon: const Icon(Icons.call, color: AppColors.deep, size: 20),
        ),
        const SizedBox(width: 4),
        IconButton.filled(
          style: IconButton.styleFrom(backgroundColor: AppColors.mint),
          onPressed: () => toast(context, 'Fitur chat segera hadir'),
          icon: const Icon(Icons.chat_bubble_outline,
              color: AppColors.deep, size: 20),
        ),
      ]),
    );
  }

  Widget _detailCard(PickupOrder o) {
    return AppCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Alamat Penjemputan', style: ts(11, c: AppColors.slate)),
        const SizedBox(height: 2),
        Text(o.address, style: ts(13, w: FontWeight.w600, h: 1.4)),
        const Divider(height: 24),
        Text('Rincian Sampah', style: ts(11, c: AppColors.slate)),
        const SizedBox(height: 8),
        for (final e in o.items.entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(children: [
              Expanded(child: Text(e.key, style: ts(13))),
              Text('${fmtKg(e.value)} Kg', style: ts(13, w: FontWeight.w700)),
            ]),
          ),
        const Divider(height: 24),
        Row(children: [
          Text('Estimasi diterima', style: ts(12, c: AppColors.slate)),
          const Spacer(),
          Text(fmtRp(o.total),
              style: ts(15, w: FontWeight.w800, c: AppColors.primary)),
        ]),
        const SizedBox(height: 4),
        Row(children: [
          Text('Bonus poin', style: ts(12, c: AppColors.slate)),
          const Spacer(),
          Text('+${o.points} Poin',
              style: ts(13, w: FontWeight.w700, c: AppColors.amberText)),
        ]),
      ]),
    );
  }
}

class _MapPainter extends CustomPainter {
  final double t;
  final OrderStatus status;
  _MapPainter(this.t, this.status);

  static const pts = [
    Offset(.12, .84),
    Offset(.12, .56),
    Offset(.46, .56),
    Offset(.46, .26),
    Offset(.84, .26),
  ];

  Offset _scale(Offset p, Size s) => Offset(p.dx * s.width, p.dy * s.height);

  List<Offset> _partial(double t) {
    final segs = <double>[];
    double total = 0;
    for (int i = 0; i < pts.length - 1; i++) {
      final d = (pts[i + 1] - pts[i]).distance;
      segs.add(d);
      total += d;
    }
    double target = t * total;
    final out = <Offset>[pts[0]];
    for (int i = 0; i < segs.length; i++) {
      if (target >= segs[i]) {
        out.add(pts[i + 1]);
        target -= segs[i];
      } else {
        out.add(Offset.lerp(pts[i], pts[i + 1], target / segs[i])!);
        return out;
      }
    }
    return out;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFE3F1E9));

    // blok & jalan
    final block = Paint()..color = const Color(0xFFD3E8DB);
    for (double x = .0; x < 1; x += .34) {
      for (double y = .0; y < 1; y += .30) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH((x + .03) * size.width, (y + .03) * size.height,
                  .28 * size.width, .24 * size.height),
              const Radius.circular(8)),
          block,
        );
      }
    }
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;
    for (final y in [.28, .56, .86]) {
      canvas.drawLine(Offset(0, y * size.height), Offset(size.width, y * size.height), road);
    }
    for (final x in [.12, .46, .84]) {
      canvas.drawLine(Offset(x * size.width, 0), Offset(x * size.width, size.height), road);
    }

    // rute penuh
    final full = Path()..moveTo(_scale(pts[0], size).dx, _scale(pts[0], size).dy);
    for (final p in pts.skip(1)) {
      final s = _scale(p, size);
      full.lineTo(s.dx, s.dy);
    }
    canvas.drawPath(
      full,
      Paint()
        ..color = AppColors.mintSoft
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );

    // rute yang sudah dilalui
    final part = _partial(t);
    final done = Path()..moveTo(_scale(part[0], size).dx, _scale(part[0], size).dy);
    for (final p in part.skip(1)) {
      final s = _scale(p, size);
      done.lineTo(s.dx, s.dy);
    }
    canvas.drawPath(
      done,
      Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );

    // tujuan
    final dest = _scale(pts.last, size);
    canvas.drawCircle(dest, 14, Paint()..color = AppColors.tertiary.withOpacity(.3));
    canvas.drawCircle(dest, 9, Paint()..color = AppColors.tertiary);
    canvas.drawCircle(dest, 3.5, Paint()..color = Colors.white);

    // kurir
    final cur = _scale(part.last, size);
    canvas.drawCircle(
        cur, 15, Paint()..color = Colors.black.withOpacity(.12));
    canvas.drawCircle(cur, 13, Paint()..color = Colors.white);
    canvas.drawCircle(cur, 10, Paint()..color = AppColors.primary);
    canvas.drawCircle(cur, 3.5, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _MapPainter old) =>
      old.t != t || old.status != status;
}
