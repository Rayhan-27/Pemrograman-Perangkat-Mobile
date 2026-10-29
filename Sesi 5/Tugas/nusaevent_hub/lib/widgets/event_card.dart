import 'package:flutter/material.dart';
import '../models/event_item.dart';

Color trackColor(String track) {
  switch (track) {
    case 'AI':
      return const Color(0xFF7C3AED);
    case 'Mobile':
      return const Color(0xFF3B82F6);
    case 'IoT':
      return const Color(0xFF10B981);
    case 'Cybersecurity':
      return const Color(0xFFEF4444);
    default:
      return const Color(0xFF1E3A8A);
  }
}

IconData trackIcon(String track) {
  switch (track) {
    case 'AI':
      return Icons.psychology_alt_rounded;
    case 'Mobile':
      return Icons.phone_android_rounded;
    case 'IoT':
      return Icons.sensors_rounded;
    case 'Cybersecurity':
      return Icons.shield_rounded;
    default:
      return Icons.event_rounded;
  }
}

class EventCard extends StatelessWidget {
  final EventItem event;
  final VoidCallback onDetail;
  final VoidCallback onRegister;

  const EventCard({
    super.key,
    required this.event,
    required this.onDetail,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final color = trackColor(event.trackCategory);
    final almostFull = event.remainingSeats <= 20;

    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: cs.outlineVariant),
      ),
      child: InkWell(
        onTap: onDetail,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            Stack(
              children: [
                Container(
                  height: 130,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.55)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Icon(trackIcon(event.trackCategory),
                      size: 64, color: Colors.white.withOpacity(0.85)),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: almostFull
                          ? const Color(0xFFF59E0B)
                          : Colors.white.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Sisa ${event.remainingSeats} Kursi',
                      style: tt.labelSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: almostFull ? Colors.white : cs.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _Badge(label: event.trackCategory, color: color),
                      _Badge(label: event.level, color: cs.outline),
                      _Badge(
                        label: event.isFree
                            ? 'GRATIS'
                            : formatRupiah(event.ticketPrice),
                        color: const Color(0xFF10B981),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: tt.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  _InfoRow(
                      icon: Icons.calendar_today_rounded,
                      text: '${event.date} • ${event.time}'),
                  const SizedBox(height: 4),
                  _InfoRow(
                      icon: Icons.location_on_rounded, text: event.venueRoom),
                  const SizedBox(height: 12),
                  // Speaker
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF8FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: color.withOpacity(0.15),
                          child: Text(
                            event.speakerName
                                .replaceAll(RegExp(r'^(Dr\.|Prof\.|Ir\.)\s*'), '')
                                .substring(0, 1),
                            style: TextStyle(
                                color: color, fontWeight: FontWeight.w800),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(event.speakerName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: tt.labelLarge
                                      ?.copyWith(fontWeight: FontWeight.w700)),
                              Text(event.speakerRole,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: tt.bodySmall
                                      ?.copyWith(color: cs.onSurfaceVariant)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onDetail,
                          child: const Text('Detail Sesi'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilledButton(
                          onPressed: onRegister,
                          child: const Text('Daftar Sekarang'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w700, color: color)),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 16, color: cs.primary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: cs.onSurfaceVariant)),
        ),
      ],
    );
  }
}
