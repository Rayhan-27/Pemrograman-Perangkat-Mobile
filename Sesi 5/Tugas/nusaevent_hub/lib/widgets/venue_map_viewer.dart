import 'package:flutter/material.dart';

class _Zone {
  final String name;
  final Rect rect; // koordinat dalam kanvas 400 x 300
  final Color color;
  final IconData icon;
  const _Zone(this.name, this.rect, this.color, this.icon);
}

const _kMainStage = Color(0xFF1E3A8A);
const _kWorkshop = Color(0xFF3B82F6);
const _kRegistration = Color(0xFFF59E0B);
const _kService = Color(0xFF10B981);

const _floor1 = <_Zone>[
  _Zone('Main Stage\nAuditorium BJ Habibie', Rect.fromLTWH(10, 10, 230, 130),
      _kMainStage, Icons.mic_external_on_rounded),
  _Zone('Registrasi\nBadge QR', Rect.fromLTWH(250, 10, 140, 60), _kRegistration,
      Icons.qr_code_scanner_rounded),
  _Zone('Coffee\nBreak', Rect.fromLTWH(250, 80, 140, 60), _kService,
      Icons.local_cafe_rounded),
  _Zone('Expo Booth', Rect.fromLTWH(10, 155, 190, 135), _kWorkshop,
      Icons.storefront_rounded),
  _Zone('Networking\nLounge', Rect.fromLTWH(210, 155, 180, 135), _kService,
      Icons.groups_rounded),
];

const _floor2 = <_Zone>[
  _Zone('Workshop Lab A', Rect.fromLTWH(10, 10, 185, 130), _kWorkshop,
      Icons.computer_rounded),
  _Zone('Workshop Lab B', Rect.fromLTWH(205, 10, 185, 130), _kWorkshop,
      Icons.computer_rounded),
  _Zone('Musholla\nGedung B', Rect.fromLTWH(10, 155, 120, 135), _kService,
      Icons.mosque_rounded),
  _Zone('Ruang Diskusi', Rect.fromLTWH(140, 155, 140, 135), _kMainStage,
      Icons.forum_rounded),
  _Zone('Lift &\nRamp', Rect.fromLTWH(290, 155, 100, 135), _kRegistration,
      Icons.accessible_rounded),
];

class VenueMapViewer extends StatefulWidget {
  const VenueMapViewer({super.key});

  @override
  State<VenueMapViewer> createState() => _VenueMapViewerState();
}

class _VenueMapViewerState extends State<VenueMapViewer> {
  final _controller = TransformationController();
  int _floor = 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _zoom(double factor) {
    _controller.value = _controller.value.clone()..scale(factor);
  }

  void _reset() => _controller.value = Matrix4.identity();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final zones = _floor == 1 ? _floor1 : _floor2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 1, label: Text('Lantai 1')),
              ButtonSegment(value: 2, label: Text('Lantai 2')),
            ],
            selected: {_floor},
            onSelectionChanged: (s) {
              setState(() => _floor = s.first);
              _reset();
            },
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 280,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outlineVariant),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              InteractiveViewer(
                transformationController: _controller,
                minScale: 0.8,
                maxScale: 4,
                boundaryMargin: const EdgeInsets.all(60),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: SizedBox(
                      width: 400,
                      height: 300,
                      child: Stack(
                        children: zones
                            .map((z) => Positioned.fromRect(
                                  rect: z.rect,
                                  child: _ZoneTile(zone: z),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: Column(
                  children: [
                    _MapBtn(icon: Icons.add, onTap: () => _zoom(1.3)),
                    const SizedBox(height: 6),
                    _MapBtn(icon: Icons.remove, onTap: () => _zoom(1 / 1.3)),
                    const SizedBox(height: 6),
                    _MapBtn(icon: Icons.center_focus_strong, onTap: _reset),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text('Geser untuk pan, cubit atau gunakan tombol untuk zoom.',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: cs.onSurfaceVariant)),
        const SizedBox(height: 12),
        const Wrap(
          spacing: 14,
          runSpacing: 6,
          children: [
            _LegendItem(color: _kMainStage, label: 'Panggung Utama'),
            _LegendItem(color: _kWorkshop, label: 'Workshop / Expo'),
            _LegendItem(color: _kRegistration, label: 'Registrasi'),
            _LegendItem(color: _kService, label: 'Fasilitas'),
          ],
        ),
      ],
    );
  }
}

class _ZoneTile extends StatelessWidget {
  final _Zone zone;
  const _ZoneTile({required this.zone});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: zone.color.withOpacity(0.18),
        border: Border.all(color: zone.color, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(zone.icon, color: zone.color, size: 22),
          const SizedBox(height: 2),
          Text(zone.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w700, color: zone.color)),
        ],
      ),
    );
  }
}

class _MapBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _MapBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 20),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
