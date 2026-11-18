import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/models/transaksi.dart';
import '../core/app_theme.dart';
import '../core/format.dart';
import 'kas_view_model.dart';

class TambahTransaksiScreen extends StatefulWidget {
  const TambahTransaksiScreen({
    super.key,
    required this.viewModel,
    this.jenisAwal = JenisTransaksi.pemasukan,
  });

  final KasViewModel viewModel;
  final JenisTransaksi jenisAwal;

  @override
  State<TambahTransaksiScreen> createState() => _TambahTransaksiScreenState();
}

class _TambahTransaksiScreenState extends State<TambahTransaksiScreen> {
  final _formKey = GlobalKey<FormState>();
  final _keteranganController = TextEditingController();
  final _nominalController = TextEditingController();
  final _tanggalController = TextEditingController();

  late JenisTransaksi _jenis = widget.jenisAwal;
  late DateTime _tanggal = _hariIni();

  static DateTime _hariIni() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  @override
  void initState() {
    super.initState();
    _tanggalController.text = formatTanggal(_tanggal);
  }

  @override
  void dispose() {
    _keteranganController.dispose();
    _nominalController.dispose();
    _tanggalController.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal() async {
    final dipilih = await showDatePicker(
      context: context,
      initialDate: _tanggal,
      firstDate: DateTime(2020),
      lastDate: _hariIni(),
    );
    if (dipilih != null) {
      setState(() {
        _tanggal = dipilih;
        _tanggalController.text = formatTanggal(dipilih);
      });
    }
  }

  void _simpan() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final error = widget.viewModel.tambahTransaksi(
      keterangan: _keteranganController.text,
      nominal: parseNominal(_nominalController.text),
      jenis: _jenis,
      tanggal: _tanggal,
    );
    if (error != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    if (Navigator.of(context).canPop()) Navigator.of(context).pop(true);
  }

  void _reset() {
    _formKey.currentState?.reset();
    _keteranganController.clear();
    _nominalController.clear();
    setState(() {
      _jenis = widget.jenisAwal;
      _tanggal = _hariIni();
    });
    _tanggalController.text = formatTanggal(_tanggal);
  }

  InputDecoration _dekorasi({String? hint, Widget? suffix, String? prefixText, TextStyle? prefixStyle}) {
    OutlineInputBorder border(Color color, [double width = 1.5]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: width),
        );
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.muted),
      suffixIcon: suffix,
      prefixText: prefixText,
      prefixStyle: prefixStyle,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: border(AppColors.inputBorder),
      focusedBorder: border(AppColors.primary, 2),
      errorBorder: border(AppColors.outflow),
      focusedErrorBorder: border(AppColors.outflow, 2),
      errorStyle: const TextStyle(color: AppColors.outflow, fontWeight: FontWeight.w500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        title: const Text('Tambah Transaksi',
            style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.text)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _Label('Jenis Transaksi Kas'),
                _buildJenisToggle(),
                const SizedBox(height: 20),
                const _Label('Nominal Transaksi'),
                TextFormField(
                  key: const Key('input_nominal'),
                  controller: _nominalController,
                  keyboardType: TextInputType.number,
                  inputFormatters: const [RibuanInputFormatter()],
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    fontFeatures: angkaTabular,
                  ),
                  decoration: _dekorasi(
                    hint: '0',
                    prefixText: 'Rp ',
                    prefixStyle: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                  validator: (value) {
                    final teks = value?.trim() ?? '';
                    if (teks.isEmpty) return 'Nominal wajib diisi';
                    return widget.viewModel.validasiNominal(parseNominal(teks), _jenis);
                  },
                ),
                if (_jenis == JenisTransaksi.pengeluaran)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 4),
                    child: Text(
                      'Saldo tersedia: ${formatRupiah(widget.viewModel.saldo)}',
                      key: const Key('text_saldo_tersedia'),
                      style: const TextStyle(fontSize: 12, color: AppColors.muted),
                    ),
                  ),
                const SizedBox(height: 20),
                const _Label('Keterangan Transaksi *'),
                TextFormField(
                  key: const Key('input_keterangan'),
                  controller: _keteranganController,
                  textCapitalization: TextCapitalization.sentences,
                  inputFormatters: [LengthLimitingTextInputFormatter(80)],
                  style: const TextStyle(fontSize: 16),
                  decoration: _dekorasi(hint: 'Contoh: Iuran Bulanan Divisi Kominfo'),
                  validator: (value) =>
                      (value == null || value.trim().isEmpty) ? 'Keterangan wajib diisi' : null,
                ),
                const SizedBox(height: 20),
                const _Label('Tanggal Transaksi'),
                TextFormField(
                  key: const Key('input_tanggal'),
                  controller: _tanggalController,
                  readOnly: true,
                  onTap: _pilihTanggal,
                  style: const TextStyle(fontSize: 16),
                  decoration: _dekorasi(suffix: const Icon(Icons.calendar_today_outlined, size: 20)),
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Tanggal wajib dipilih' : null,
                ),
                const SizedBox(height: 28),
                SizedBox(
                  height: 50,
                  child: FilledButton.icon(
                    key: const Key('btn_simpan'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: _simpan,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Simpan Transaksi Kas',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    key: const Key('btn_reset'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      backgroundColor: const Color(0xFFF1F5F9),
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: _reset,
                    icon: const Icon(Icons.restart_alt),
                    label: const Text('Batal / Reset Formulir'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJenisToggle() {
    return Container(
      key: const Key('input_jenis'),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.segmentBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _JenisButton(
            key: const Key('toggle_pemasukan'),
            label: 'Pemasukan',
            ikon: Icons.south_west_rounded,
            aktif: _jenis == JenisTransaksi.pemasukan,
            onTap: () => setState(() => _jenis = JenisTransaksi.pemasukan),
          ),
          _JenisButton(
            key: const Key('toggle_pengeluaran'),
            label: 'Pengeluaran',
            ikon: Icons.north_east_rounded,
            aktif: _jenis == JenisTransaksi.pengeluaran,
            onTap: () => setState(() => _jenis = JenisTransaksi.pengeluaran),
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.teks);

  final String teks;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 2),
        child: Text(teks,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.2, color: Color(0xFF334155))),
      );
}

class _JenisButton extends StatelessWidget {
  const _JenisButton({
    super.key,
    required this.label,
    required this.ikon,
    required this.aktif,
    required this.onTap,
  });

  final String label;
  final IconData ikon;
  final bool aktif;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: aktif ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(ikon, size: 18, color: aktif ? Colors.white : AppColors.text),
              const SizedBox(width: 6),
              Text(label,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: aktif ? Colors.white : AppColors.text)),
            ],
          ),
        ),
      ),
    );
  }
}
