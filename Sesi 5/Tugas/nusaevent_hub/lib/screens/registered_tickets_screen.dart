import 'dart:math';
import 'package:flutter/material.dart';
import '../models/event_item.dart';
import '../models/registration_ticket.dart';
import '../widgets/event_card.dart';

class RegisteredTicketsScreen extends StatelessWidget {
  final List<RegistrationTicket> tickets;
  final void Function(RegistrationTicket ticket) onCancel;

  const RegisteredTicketsScreen({
    super.key,
    required this.tickets,
    required this.onCancel,
  });

  List<RegistrationTicket> _by(String status) =>
      tickets.where((t) => t.status == status).toList();

  @override
  Widget build(BuildContext context) {
    final active = _by('Active');
    final done = _by('Completed');
    final cancelled = _by('Cancelled');

    return SafeArea(
      bottom: false,
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Tiket Terdaftar',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w800)),
              ),
            ),
            TabBar(
              tabs: [
                Tab(text: 'Aktif (${active.length})'),
                Tab(text: 'Riwayat (${done.length})'),
                Tab(text: 'Dibatalkan (${cancelled.length})'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildList(context, active, swipeable: true),
                  _buildList(context, done),
                  _buildList(context, cancelled),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<RegistrationTicket> list,
      {bool swipeable = false}) {
    if (list.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.confirmation_number_outlined, size: 56),
            SizedBox(height: 8),
            Text('Belum ada tiket di kategori ini.'),
          ],
        ),
      );
    }

    final extra = swipeable ? 1 : 0; // panduan check-in di akhir list aktif
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length + extra,
          itemBuilder: (context, i) {
            if (i == list.length) return const _CheckInGuide();
            final t = list[i];
            final card = _TicketCard(
              ticket: t,
              showActions: swipeable,
              onCancelTap: () async {
                if (await _confirmCancel(context, t)) onCancel(t);
              },
            );
            if (!swipeable) return card;

            return Dismissible(
              key: ValueKey(t.ticketCode),
              direction: DismissDirection.endToStart,
              confirmDismiss: (_) => _confirmCancel(context, t),
              onDismissed: (_) {
                onCancel(t);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tiket ${t.ticketCode} dibatalkan')));
              },
              background: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.only(right: 24),
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.delete_outline, color: Colors.white),
                    Text('Batalkan',
                        style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ),
              child: card,
            );
          },
        ),
      ),
    );
  }

  Future<bool> _confirmCancel(BuildContext context, RegistrationTicket t) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.warning_amber_rounded),
        title: const Text('Batalkan Tiket?'),
        content: Text(
            'Tiket ${t.ticketCode} untuk "${t.eventTitle}" akan dibatalkan. Tindakan ini tidak dapat diurungkan.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Kembali')),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

class _TicketCard extends StatelessWidget {
  final RegistrationTicket ticket;
  final bool showActions;
  final VoidCallback onCancelTap;

  const _TicketCard({
    required this.ticket,
    required this.showActions,
    required this.onCancelTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final color = trackColor(ticket.eventTrack);
    final d = ticket.attendanceDate;
    final dateStr =
        '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: cs.outlineVariant),
      ),
      child: Column(
        children: [
          // Header
          Container(
            color: color,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(trackIcon(ticket.eventTrack), color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(ticket.eventTrack.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w800)),
                ),
                Flexible(
                  child: Text(ticket.ticketCode,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ticket.eventTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        tt.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _kv(context, 'Nama', ticket.attendeeName),
                          _kv(context, 'NIM', ticket.attendeeNim),
                          _kv(context, 'Kursi', ticket.seatNumber),
                          _kv(context, 'Tanggal',
                              '$dateStr • Sesi ${ticket.sessionSchedule}'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => _showFullQr(context),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              border: Border.all(color: cs.outlineVariant),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SizedBox(
                              width: 84,
                              height: 84,
                              child: CustomPaint(
                                  painter: _QrPainter(ticket.qrCodeData)),
                            ),
                          ),
                          const SizedBox(height: 6),
                          _StatusPill(status: ticket.status),
                        ],
                      ),
                    ),
                  ],
                ),
                if (showActions) ...[
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilledButton.tonalIcon(
                        onPressed: () => _showFullQr(context),
                        icon: const Icon(Icons.qr_code_2_rounded, size: 18),
                        label: const Text('Tampilkan QR Penuh'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                content:
                                    Text('Ditambahkan ke kalender (demo)'))),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Ke Kalender'),
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                            foregroundColor: cs.error),
                        onPressed: onCancelTap,
                        icon: const Icon(Icons.cancel_outlined, size: 18),
                        label: const Text('Batal / Refund'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Geser kartu ke kiri untuk membatalkan tiket',
                      style: tt.bodySmall
                          ?.copyWith(color: cs.onSurfaceVariant)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _kv(BuildContext context, String k, String v) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: RichText(
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            style: DefaultTextStyle.of(context)
                .style
                .copyWith(fontSize: 13, color: Colors.black87),
            children: [
              TextSpan(
                  text: '$k: ',
                  style: const TextStyle(color: Colors.black54)),
              TextSpan(
                  text: v,
                  style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      );

  void _showFullQr(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('QR Check-in'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 220,
                height: 220,
                child: CustomPaint(painter: _QrPainter(ticket.qrCodeData)),
              ),
              const SizedBox(height: 12),
              Text(ticket.ticketCode,
                  style: const TextStyle(fontWeight: FontWeight.w800)),
              Text(ticket.seatNumber),
              const SizedBox(height: 4),
              Text('Total: ${formatRupiah(ticket.totalPayment)}'),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Tutup')),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String status;
  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    late final Color c;
    late final String label;
    switch (status) {
      case 'Active':
        c = const Color(0xFF10B981);
        label = 'Lunas';
        break;
      case 'Completed':
        c = const Color(0xFF3B82F6);
        label = 'Selesai';
        break;
      default:
        c = const Color(0xFFEF4444);
        label = 'Dibatalkan';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: c.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style:
              TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w800)),
    );
  }
}

class _CheckInGuide extends StatelessWidget {
  const _CheckInGuide();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const steps = [
      'Tuju Kios Mandiri NusaGate di area registrasi.',
      'Pindai QR tiket kamu pada scanner kios.',
      'Ambil gelang RFID & ID card fisik yang tercetak.',
    ];
    return Card(
      elevation: 0,
      color: cs.primaryContainer.withOpacity(0.4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Panduan Check-in Venue',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            for (var i = 0; i < steps.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                        radius: 11,
                        child: Text('${i + 1}',
                            style: const TextStyle(fontSize: 12))),
                    const SizedBox(width: 10),
                    Expanded(child: Text(steps[i])),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// QR "tampilan" (pseudo) dari data string, tanpa package tambahan.
/// Untuk QR asli yang bisa dipindai, ganti dengan package `qr_flutter`.
class _QrPainter extends CustomPainter {
  final String data;
  _QrPainter(this.data);

  static const int n = 25;

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / n;
    final paint = Paint()..color = Colors.black;
    final rnd = Random(data.hashCode);

    bool inFinder(int x, int y) =>
        (x < 8 && y < 8) || (x >= n - 8 && y < 8) || (x < 8 && y >= n - 8);

    for (var y = 0; y < n; y++) {
      for (var x = 0; x < n; x++) {
        if (inFinder(x, y)) continue;
        if (rnd.nextBool()) {
          canvas.drawRect(
              Rect.fromLTWH(x * cell, y * cell, cell + 0.3, cell + 0.3), paint);
        }
      }
    }

    void finder(int ox, int oy) {
      canvas.drawRect(
          Rect.fromLTWH(ox * cell, oy * cell, 7 * cell, 7 * cell), paint);
      canvas.drawRect(
          Rect.fromLTWH((ox + 1) * cell, (oy + 1) * cell, 5 * cell, 5 * cell),
          Paint()..color = Colors.white);
      canvas.drawRect(
          Rect.fromLTWH((ox + 2) * cell, (oy + 2) * cell, 3 * cell, 3 * cell),
          paint);
    }

    finder(0, 0);
    finder(n - 7, 0);
    finder(0, n - 7);
  }

  @override
  bool shouldRepaint(covariant _QrPainter old) => old.data != data;
}
