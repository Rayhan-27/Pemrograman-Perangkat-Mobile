import 'package:flutter/material.dart';
import '../data/sample_events.dart';
import '../models/event_item.dart';
import '../widgets/event_card.dart';
import '../widgets/venue_map_viewer.dart';

/// Tab 2: Galeri poster (GridView.builder) + denah venue (InteractiveViewer).
class GalleryVenueScreen extends StatelessWidget {
  final void Function(EventItem event) onRegister;
  const GalleryVenueScreen({super.key, required this.onRegister});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return SafeArea(
      bottom: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final cols = w >= 900 ? 4 : (w >= 600 ? 3 : 2);

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Galeri & Denah Venue',
                        style: tt.titleLarge
                            ?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    const Text('Jakarta Convention Center'),
                    const SizedBox(height: 16),
                    const VenueMapViewer(),
                    const SizedBox(height: 20),
                    Text('Fasilitas & Aksesibilitas',
                        style: tt.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 10),
                    const Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _FacilityChip(Icons.wifi_rounded, 'Wi-Fi 500 Mbps'),
                        _FacilityChip(Icons.mosque_rounded, 'Musholla Gd. B Lt. 2'),
                        _FacilityChip(Icons.local_parking_rounded, 'Parkir 800+ mobil'),
                        _FacilityChip(Icons.accessible_rounded, 'Ramp & Lift'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                content: Text(
                                    'Membuka Google Maps... (demo)'))),
                        icon: const Icon(Icons.map_rounded),
                        label: const Text('Navigasi ke Google Maps'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('Poster Event',
                        style: tt.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 10),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: sampleEvents.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.72,
                      ),
                      itemBuilder: (context, i) => _PosterTile(
                        event: sampleEvents[i],
                        onTap: () => onRegister(sampleEvents[i]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FacilityChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FacilityChip(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: cs.primary),
          const SizedBox(width: 6),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _PosterTile extends StatelessWidget {
  final EventItem event;
  final VoidCallback onTap;
  const _PosterTile({required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = trackColor(event.trackCategory);
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(event.trackCategory,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
              ),
              Expanded(
                child: Center(
                  child: Icon(trackIcon(event.trackCategory),
                      size: 56, color: Colors.white.withOpacity(0.9)),
                ),
              ),
              Text(event.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 13)),
              const SizedBox(height: 4),
              Text(event.date,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }
}
