import 'package:flutter/material.dart';

import '../models/tour_package.dart';

/// Hasil pemesanan yang dikembalikan lewat Navigator.pop().
class BookingResult {
  final String name;
  final int participants;
  final DateTime date;
  final int total;

  const BookingResult({
    required this.name,
    required this.participants,
    required this.date,
    required this.total,
  });

  String get dateLabel => formatDate(date);
  String get totalLabel => 'Rp ${formatRupiah(total)}';
}

String formatDate(DateTime d) {
  const months = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];
  return '${d.day} ${months[d.month - 1]} ${d.year}';
}

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key, required this.tour});

  final TourPackage tour;

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  static const int _maxParticipants = 12;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  int _participants = 1;
  DateTime? _date;

  int get _total => widget.tour.price * _participants;

  // Form dianggap "kotor" bila user sudah mengisi sesuatu.
  bool get _isDirty =>
      _nameController.text.trim().isNotEmpty ||
      _date != null ||
      _participants != 1;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<bool> _confirmDiscard() async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Batalkan Pemesanan?'),
        content: const Text(
          'Data yang sudah Anda isi akan hilang jika keluar dari halaman ini.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Lanjut Mengisi'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Ya, Keluar'),
          ),
        ],
      ),
    );
    return leave ?? false;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      helpText: 'Pilih Tanggal Keberangkatan',
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih tanggal keberangkatan dulu.')),
      );
      return;
    }

    // Kembalikan hasil pemesanan ke halaman sebelumnya.
    Navigator.pop(
      context,
      BookingResult(
        name: _nameController.text.trim(),
        participants: _participants,
        date: _date!,
        total: _total,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tour = widget.tour;

    return PopScope(
      // Blokir back otomatis hanya jika form sudah diisi.
      canPop: !_isDirty,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final leave = await _confirmDiscard();
        if (leave && context.mounted) {
          Navigator.pop(context); // keluar tanpa hasil (null)
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Booking Form')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ringkasan paket
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 80,
                            height: 80,
                            child: Image.network(
                              tour.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: cs.surfaceContainerHighest,
                                child: const Icon(Icons.image_not_supported),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(tour.location.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: cs.tertiary,
                                      fontWeight: FontWeight.bold)),
                              Text(tour.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              const SizedBox(height: 4),
                              Text('${tour.formattedPrice} /pax',
                                  style: TextStyle(
                                      color: cs.primary,
                                      fontWeight: FontWeight.w800)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Nama
                const Text('Nama Lengkap Pemesan *',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.badge_outlined),
                    hintText: 'cth. Arya Pratama',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Nama wajib diisi'
                      : null,
                ),
                const SizedBox(height: 20),

                // Tanggal
                const Text('Tanggal Keberangkatan *',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(4),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.event_available),
                      suffixIcon: Icon(Icons.edit_calendar),
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      _date == null ? 'Pilih tanggal' : formatDate(_date!),
                      style: TextStyle(
                        color: _date == null ? cs.outline : cs.onSurface,
                        fontWeight:
                            _date == null ? FontWeight.normal : FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Jumlah peserta
                const Text('Jumlah Peserta',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.group, color: cs.primary),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text('Maksimal 12 peserta per booking',
                            style: TextStyle(fontSize: 12)),
                      ),
                      IconButton.filledTonal(
                        onPressed: _participants > 1
                            ? () => setState(() => _participants--)
                            : null,
                        icon: const Icon(Icons.remove),
                      ),
                      SizedBox(
                        width: 36,
                        child: Text(
                          '$_participants',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton.filled(
                        onPressed: _participants < _maxParticipants
                            ? () => setState(() => _participants++)
                            : null,
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Rincian biaya
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$_participants peserta x ${tour.formattedPrice}',
                        style: TextStyle(
                            color: cs.onPrimaryContainer.withOpacity(0.85)),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('TOTAL',
                              style: TextStyle(
                                  color: cs.onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1)),
                          Text(
                            'Rp ${formatRupiah(_total)}',
                            style: TextStyle(
                              color: cs.onPrimaryContainer,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.check),
                    label: const Text('Konfirmasi Pemesanan'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    // maybePop -> memicu PopScope, sama seperti tombol Back.
                    onPressed: () => Navigator.maybePop(context),
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Batal & Kembali'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
