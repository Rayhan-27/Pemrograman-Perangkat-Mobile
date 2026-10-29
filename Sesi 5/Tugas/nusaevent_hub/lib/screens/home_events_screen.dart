import 'package:flutter/material.dart';
import '../data/sample_events.dart';
import '../models/event_item.dart';
import '../widgets/event_card.dart';
import '../widgets/filter_bottom_sheet.dart';

class HomeEventsScreen extends StatefulWidget {
  final void Function(EventItem event) onRegister;
  const HomeEventsScreen({super.key, required this.onRegister});

  @override
  State<HomeEventsScreen> createState() => _HomeEventsScreenState();
}

class _HomeEventsScreenState extends State<HomeEventsScreen> {
  String _category = 'Semua';
  String _query = '';
  FilterOptions _filter = const FilterOptions();

  List<EventItem> get _filtered {
    return sampleEvents.where((e) {
      final matchCat = _category == 'Semua' || e.trackCategory == _category;
      final q = _query.trim().toLowerCase();
      final matchQuery = q.isEmpty ||
          e.title.toLowerCase().contains(q) ||
          e.speakerName.toLowerCase().contains(q);
      final matchLevel =
          _filter.levels.isEmpty || _filter.levels.contains(e.level);
      final matchFree = !_filter.freeOnly || e.isFree;
      return matchCat && matchQuery && matchLevel && matchFree;
    }).toList();
  }

  Future<void> _openFilter() async {
    final result = await showFilterBottomSheet(context, _filter);
    if (result != null) setState(() => _filter = result);
  }

  void _showDetail(EventItem e) {
    final tt = Theme.of(context).textTheme;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(e.title,
                  style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              _detailRow(Icons.category_rounded, 'Track', e.trackCategory),
              _detailRow(Icons.signal_cellular_alt_rounded, 'Level', e.level),
              _detailRow(Icons.calendar_today_rounded, 'Tanggal', e.date),
              _detailRow(Icons.schedule_rounded, 'Waktu', e.time),
              _detailRow(Icons.location_on_rounded, 'Lokasi', e.venueRoom),
              _detailRow(Icons.person_rounded, 'Pembicara',
                  '${e.speakerName}\n${e.speakerRole}'),
              _detailRow(Icons.event_seat_rounded, 'Kuota',
                  '${e.remainingSeats} dari ${e.totalSeats} kursi tersisa'),
              _detailRow(Icons.payments_rounded, 'Harga',
                  e.isFree ? 'Gratis' : formatRupiah(e.ticketPrice)),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    widget.onRegister(e);
                  },
                  child: const Text('Daftar Sekarang'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: cs.primary),
          const SizedBox(width: 12),
          SizedBox(
              width: 80,
              child: Text(label,
                  style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final events = _filtered;

    return SafeArea(
      bottom: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            itemCount: events.isEmpty ? 2 : events.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) return _buildHeader(context);
              if (events.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 48),
                  child: Column(
                    children: [
                      Icon(Icons.search_off_rounded, size: 56),
                      SizedBox(height: 8),
                      Text('Tidak ada seminar yang cocok.'),
                    ],
                  ),
                );
              }
              final e = events[index - 1];
              return EventCard(
                event: e,
                onDetail: () => _showDetail(e),
                onRegister: () => widget.onRegister(e),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text('Halo, Rayhan Sandika Ardaffa 👋',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            ),
            IconButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Belum ada notifikasi baru'))),
              icon: const Icon(Icons.notifications_none_rounded),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: SearchBar(
                hintText: 'Cari seminar atau pembicara',
                elevation: const WidgetStatePropertyAll(0),
                backgroundColor: const WidgetStatePropertyAll(Colors.white),
                leading: const Icon(Icons.search),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            const SizedBox(width: 8),
            Badge(
              isLabelVisible: _filter.isActive,
              smallSize: 10,
              child: IconButton.filledTonal(
                onPressed: _openFilter,
                icon: const Icon(Icons.tune_rounded),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Statistik
        const Row(
          children: [
            Expanded(child: _StatCard(value: '24', label: 'Total Sesi')),
            SizedBox(width: 10),
            Expanded(child: _StatCard(value: '1.2k+', label: 'Peserta')),
            SizedBox(width: 10),
            Expanded(child: _StatCard(value: '4', label: 'Track Utama')),
          ],
        ),
        const SizedBox(height: 16),
        // Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
                colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)]),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Call for Papers & Hackathon Nusantara 2026',
                  style: tt.titleMedium?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text('Kirim karyamu dan menangkan hadiah total puluhan juta.',
                  style: tt.bodySmall?.copyWith(color: Colors.white70)),
              const SizedBox(height: 12),
              FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFF59E0B)),
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Pendaftaran hackathon segera dibuka'))),
                child: const Text('Ikuti Sekarang'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Filter chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: kCategories.map((c) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(c == 'AI' ? 'AI (Hot) 🔥' : c),
                  selected: _category == c,
                  onSelected: (_) => setState(() => _category = c),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        Text('Seminar & Workshop',
            style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text('${_filtered.length} sesi ditemukan',
            style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        children: [
          Text(value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800, color: cs.primary)),
          Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
