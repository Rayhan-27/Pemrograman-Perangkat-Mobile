import 'dart:math';
import 'package:flutter/material.dart';
import '../models/event_item.dart';
import '../models/registration_ticket.dart';

class EventRegistrationScreen extends StatefulWidget {
  final EventItem event;
  const EventRegistrationScreen({super.key, required this.event});

  @override
  State<EventRegistrationScreen> createState() =>
      _EventRegistrationScreenState();
}

class _EventRegistrationScreenState extends State<EventRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameC = TextEditingController();
  final _nimC = TextEditingController();
  final _emailC = TextEditingController();
  final _waC = TextEditingController(text: '+62');
  final _dateC = TextEditingController();

  static const _participantTypes = ['Mahasiswa', 'Dosen/Peneliti', 'Profesional'];
  static const _donations = [0, 10000, 25000, 50000];
  static const _premiumKitPrice = 35000.0;

  String _participantType = 'Mahasiswa';
  String _session = 'Pagi';
  String _kit = 'Basic Digital';
  int _donation = 0;
  bool _agreed = false;
  DateTime? _date;
  bool _loading = false;

  @override
  void dispose() {
    _nameC.dispose();
    _nimC.dispose();
    _emailC.dispose();
    _waC.dispose();
    _dateC.dispose();
    super.dispose();
  }

  // ---------- Perhitungan harga ----------
  double get _basePrice {
    if (widget.event.isFree) return 0;
    final p = widget.event.ticketPrice;
    return _participantType == 'Mahasiswa' ? p * 0.5 : p;
  }

  double get _kitPrice => _kit == 'Premium Swag' ? _premiumKitPrice : 0;
  double get _total => _basePrice + _kitPrice + _donation;

  // ---------- Date picker ----------
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      helpText: 'Pilih tanggal kehadiran',
    );
    if (picked != null) {
      setState(() {
        _date = picked;
        _dateC.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  // ---------- Submit ----------
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreed) return; // pesan error ditampilkan oleh FormField checkbox

    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2)); // simulasi request
    if (!mounted) return;

    final rnd = Random();
    final code = 'TKT-NUSA-${DateTime.now().year}-${1000 + rnd.nextInt(9000)}';
    final row = String.fromCharCode(65 + rnd.nextInt(8)); // A-H
    final seat = (1 + rnd.nextInt(30)).toString().padLeft(2, '0');

    final ticket = RegistrationTicket(
      ticketCode: code,
      eventId: widget.event.id,
      eventTitle: widget.event.title,
      eventTrack: widget.event.trackCategory,
      attendeeName: _nameC.text.trim(),
      attendeeNim: _nimC.text.trim(),
      attendeeEmail: _emailC.text.trim(),
      attendeeWhatsapp: _waC.text.replaceAll(RegExp(r'[\s-]'), ''),
      participantType: _participantType,
      sessionSchedule: _session,
      attendanceDate: _date!,
      kitPackage: _kit,
      donationAmount: _donation.toDouble(),
      totalPayment: _total,
      seatNumber: 'Row $row • Seat $seat',
      qrCodeData: code,
      status: 'Active',
      registrationDate: DateTime.now(),
    );

    setState(() => _loading = false);
    Navigator.pop(context, ticket);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final e = widget.event;

    return Scaffold(
      appBar: AppBar(title: const Text('Pendaftaran Tiket')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Ringkasan event
                  Card(
                    elevation: 0,
                    color: cs.primaryContainer.withOpacity(0.5),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.title,
                              style: tt.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 6),
                          Text('${e.date} • ${e.time}',
                              style: tt.bodySmall),
                          Text(e.venueRoom, style: tt.bodySmall),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _section('Data Peserta'),
                  TextFormField(
                    controller: _nameC,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Nama Lengkap',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Nama wajib diisi';
                      }
                      if (v.trim().length < 3) return 'Minimal 3 karakter';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _nimC,
                    keyboardType: TextInputType.number,
                    maxLength: 12,
                    decoration: const InputDecoration(
                      labelText: 'NIM / ID Institusi',
                      hintText: '10-12 digit angka',
                      prefixIcon: Icon(Icons.badge_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'NIM wajib diisi';
                      if (!RegExp(r'^\d{10,12}$').hasMatch(v)) {
                        return 'NIM harus 10-12 digit angka';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _emailC,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Aktif',
                      hintText: 'nama@campus.ac.id',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Email wajib diisi';
                      }
                      if (!RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$')
                          .hasMatch(v.trim())) {
                        return 'Format email tidak valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _waC,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Nomor WhatsApp',
                      hintText: '+6281234567890',
                      prefixIcon: Icon(Icons.chat_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      final s = (v ?? '').replaceAll(RegExp(r'[\s-]'), '');
                      if (s.isEmpty || s == '+62') {
                        return 'Nomor WhatsApp wajib diisi';
                      }
                      if (!RegExp(r'^\+62\d{8,12}$').hasMatch(s)) {
                        return 'Gunakan kode negara +62 (mis. +6281234567890)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  _section('Tipe Peserta'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _participantTypes
                        .map((t) => ChoiceChip(
                              label: Text(t == 'Mahasiswa'
                                  ? 'Mahasiswa (diskon 50%)'
                                  : t),
                              selected: _participantType == t,
                              onSelected: (_) =>
                                  setState(() => _participantType = t),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 20),

                  _section('Kehadiran'),
                  TextFormField(
                    controller: _dateC,
                    readOnly: true,
                    onTap: _pickDate,
                    decoration: const InputDecoration(
                      labelText: 'Tanggal Kehadiran',
                      prefixIcon: Icon(Icons.calendar_month_outlined),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'Pilih tanggal kehadiran'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                            value: 'Pagi',
                            label: Text('Sesi Pagi'),
                            icon: Icon(Icons.wb_sunny_outlined)),
                        ButtonSegment(
                            value: 'Siang',
                            label: Text('Sesi Siang'),
                            icon: Icon(Icons.wb_twilight)),
                      ],
                      selected: {_session},
                      onSelectionChanged: (s) =>
                          setState(() => _session = s.first),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _session == 'Pagi'
                        ? 'Keynote & Panel'
                        : 'Hands-on Workshop Lab',
                    style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 20),

                  _section('Paket Seminar Kit'),
                  _KitOption(
                    title: 'Basic Digital',
                    price: 'Gratis',
                    desc: 'E-certificate resmi, slide PDF, rekaman video',
                    selected: _kit == 'Basic Digital',
                    onTap: () => setState(() => _kit = 'Basic Digital'),
                  ),
                  const SizedBox(height: 10),
                  _KitOption(
                    title: 'Premium Swag',
                    price: '+${formatRupiah(_premiumKitPrice)}',
                    desc:
                        'Sertifikat emboss fisik, tote bag canvas, t-shirt, lunch box',
                    selected: _kit == 'Premium Swag',
                    onTap: () => setState(() => _kit = 'Premium Swag'),
                  ),
                  const SizedBox(height: 20),

                  _section('Donasi Open Source (opsional)'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _donations
                        .map((d) => ChoiceChip(
                              label: Text(
                                  d == 0 ? 'Tanpa donasi' : formatRupiah(d)),
                              selected: _donation == d,
                              onSelected: (_) => setState(() => _donation = d),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 20),

                  FormField<bool>(
                    initialValue: _agreed,
                    validator: (_) =>
                        _agreed ? null : 'Anda harus menyetujui tata tertib',
                    builder: (state) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          value: _agreed,
                          onChanged: (v) {
                            setState(() => _agreed = v ?? false);
                            state.didChange(_agreed);
                          },
                          title: const Text(
                              'Saya menyetujui tata tertib acara & menerima notifikasi tiket.'),
                        ),
                        if (state.hasError)
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Text(state.errorText!,
                                style: TextStyle(
                                    color: cs.error, fontSize: 12)),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Ringkasan transaksi
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: cs.outlineVariant),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _priceRow(
                              'Tiket ($_participantType)',
                              e.isFree ? 'Gratis' : formatRupiah(_basePrice)),
                          _priceRow('Kit ($_kit)',
                              _kitPrice == 0 ? 'Gratis' : formatRupiah(_kitPrice)),
                          _priceRow('Donasi',
                              _donation == 0 ? '-' : formatRupiah(_donation)),
                          const Divider(),
                          _priceRow('Total', formatRupiah(_total), bold: true),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    height: 52,
                    child: FilledButton(
                      onPressed: _loading ? null : _submit,
                      child: _loading
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.5, color: Colors.white),
                                ),
                                SizedBox(width: 12),
                                Text('Memproses...'),
                              ],
                            )
                          : const Text('Konfirmasi & Terbitkan Tiket'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _section(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(text,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w800)),
      );

  Widget _priceRow(String label, String value, {bool bold = false}) {
    final style = TextStyle(
        fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
        fontSize: bold ? 16 : 14);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
              child: Text(label,
                  maxLines: 1, overflow: TextOverflow.ellipsis, style: style)),
          const SizedBox(width: 8),
          Text(value, style: style),
        ],
      ),
    );
  }
}

class _KitOption extends StatelessWidget {
  final String title;
  final String price;
  final String desc;
  final bool selected;
  final VoidCallback onTap;

  const _KitOption({
    required this.title,
    required this.price,
    required this.desc,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? cs.primaryContainer.withOpacity(0.5) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: selected ? cs.primary : cs.outlineVariant,
              width: selected ? 2 : 1),
        ),
        child: Row(
          children: [
            Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected ? cs.primary : cs.outline),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(desc,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: cs.onSurfaceVariant)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(price,
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: price == 'Gratis'
                        ? const Color(0xFF10B981)
                        : const Color(0xFFF59E0B))),
          ],
        ),
      ),
    );
  }
}
