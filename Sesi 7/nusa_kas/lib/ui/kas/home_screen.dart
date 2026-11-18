import 'package:flutter/material.dart';

import '../../domain/models/transaksi.dart';
import '../core/app_theme.dart';
import '../core/format.dart';
import 'kas_view_model.dart';
import 'tambah_transaksi_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.viewModel});

  final KasViewModel viewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _sembunyikanSaldo = false;

  KasViewModel get _vm => widget.viewModel;

  String get _periode {
    final now = DateTime.now();
    final awal = now.month >= 8 ? now.year : now.year - 1;
    return 'Periode $awal/${awal + 1}';
  }

  Future<void> _bukaTambah(JenisTransaksi jenis) async {
    final berhasil = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => TambahTransaksiScreen(viewModel: _vm, jenisAwal: jenis),
      ),
    );
    if (berhasil == true && mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Transaksi berhasil disimpan')));
    }
  }

  Future<bool> _konfirmasiHapus(Transaksi t) async {
    if (_vm.bisaHapus(t)) return true;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(
        content: Text('Tidak bisa dihapus: saldo akan menjadi minus'),
      ));
    return false;
  }

  void _hapus(Transaksi t) {
    _vm.hapus(t.id);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Transaksi dihapus')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        key: const Key('fab_tambah'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        onPressed: () => _bukaTambah(JenisTransaksi.pemasukan),
        child: const Icon(Icons.add, size: 28),
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _vm,
          builder: (context, _) {
            final daftar = _vm.daftar;
            return ListView.builder(
              key: const Key('list_transaksi'),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
              itemCount: 1 + (daftar.isEmpty ? 1 : daftar.length),
              itemBuilder: (context, index) {
                if (index == 0) return _buildHeader();
                if (daftar.isEmpty) return const _EmptyState();
                final t = daftar[index - 1];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Dismissible(
                    key: Key('item_${t.id}'),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (_) => _konfirmasiHapus(t),
                    onDismissed: (_) => _hapus(t),
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB91C1C),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('HAPUS',
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                          SizedBox(width: 8),
                          Icon(Icons.delete_outline, color: Colors.white),
                        ],
                      ),
                    ),
                    child: _TransaksiTile(transaksi: t),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final saldoTeks = _sembunyikanSaldo ? 'Rp ••••••' : formatRupiah(_vm.saldo);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.account_balance_wallet_outlined, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('NUSA KAS',
                    style: TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1, color: AppColors.muted)),
                Text('Beranda',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.text)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Kartu saldo (hero)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primaryMid, AppColors.blue],
              stops: [0, 0.6, 1],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withAlpha(64),
                blurRadius: 24,
                spreadRadius: -6,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.school_outlined, size: 14, color: Color(0xFF402E00)),
                        const SizedBox(width: 4),
                        Text(_periode,
                            style: const TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF402E00))),
                      ],
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    key: const Key('btn_privasi'),
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => setState(() => _sembunyikanSaldo = !_sembunyikanSaldo),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _sembunyikanSaldo ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            size: 18,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          const Text('Privasi',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Kas Himpunan Aktif',
                  style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  saldoTeks,
                  key: const Key('text_saldo'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.6,
                    fontFeatures: angkaTabular,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Quick action bar (glass pill)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(38),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _AksiCepat(
                        key: const Key('aksi_pemasukan'),
                        ikon: Icons.south_west_rounded,
                        label: 'Catat Pemasukan',
                        onTap: () => _bukaTambah(JenisTransaksi.pemasukan),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _AksiCepat(
                        key: const Key('aksi_pengeluaran'),
                        ikon: Icons.north_east_rounded,
                        label: 'Catat Pengeluaran',
                        onTap: () => _bukaTambah(JenisTransaksi.pengeluaran),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _RingkasanCard(
                label: 'Total Pemasukan',
                nilai: formatRupiah(_vm.totalPemasukan),
                valueKey: const Key('text_total_pemasukan'),
                warna: AppColors.primary,
                warnaBg: AppColors.inflowBg,
                ikon: Icons.south_west_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _RingkasanCard(
                label: 'Total Pengeluaran',
                nilai: formatRupiah(_vm.totalPengeluaran),
                valueKey: const Key('text_total_pengeluaran'),
                warna: AppColors.outflow,
                warnaBg: AppColors.outflowBg,
                ikon: Icons.north_east_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        const Text('Mutasi Kas Terbaru',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.text)),
        const SizedBox(height: 4),
        const Row(
          children: [
            Icon(Icons.swipe_left_alt_outlined, size: 16, color: AppColors.muted),
            SizedBox(width: 6),
            Text('Geser ke kiri untuk menghapus',
                style: TextStyle(fontSize: 12, color: AppColors.muted)),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _AksiCepat extends StatelessWidget {
  const _AksiCepat({super.key, required this.ikon, required this.label, required this.onTap});

  final IconData ikon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Icon(ikon, color: Colors.white, size: 22),
            const SizedBox(height: 4),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _RingkasanCard extends StatelessWidget {
  const _RingkasanCard({
    required this.label,
    required this.nilai,
    required this.valueKey,
    required this.warna,
    required this.warnaBg,
    required this.ikon,
  });

  final String label;
  final String nilai;
  final Key valueKey;
  final Color warna;
  final Color warnaBg;
  final IconData ikon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withAlpha(13), blurRadius: 8, spreadRadius: -2, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: warnaBg, borderRadius: BorderRadius.circular(10)),
            child: Icon(ikon, color: warna, size: 20),
          ),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              nilai,
              key: valueKey,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: warna,
                fontFeatures: angkaTabular,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransaksiTile extends StatelessWidget {
  const _TransaksiTile({required this.transaksi});

  final Transaksi transaksi;

  @override
  Widget build(BuildContext context) {
    final masuk = transaksi.jenis == JenisTransaksi.pemasukan;
    final warna = masuk ? AppColors.primary : AppColors.outflow;
    final prefix = masuk ? '+' : '-';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: masuk ? AppColors.inflowBg : AppColors.outflowBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(masuk ? Icons.south_west_rounded : Icons.north_east_rounded, color: warna),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaksi.keterangan,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.text),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: masuk ? AppColors.inflowBg : AppColors.outflowBg,
                        border: Border.all(color: masuk ? AppColors.inflowBorder : AppColors.outflowBorder),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        masuk ? 'Pemasukan' : 'Pengeluaran',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: warna),
                      ),
                    ),
                    Text(formatTanggal(transaksi.tanggal),
                        style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$prefix ${formatRupiah(transaksi.nominal)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: warna,
              fontFeatures: angkaTabular,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(Icons.receipt_long_outlined, size: 48, color: AppColors.inputBorder),
          SizedBox(height: 12),
          Text('Belum ada transaksi',
              style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.text)),
          SizedBox(height: 4),
          Text('Tekan tombol + untuk mencatat kas pertama',
              style: TextStyle(fontSize: 12, color: AppColors.muted)),
        ],
      ),
    );
  }
}
