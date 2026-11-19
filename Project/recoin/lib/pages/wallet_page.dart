import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme.dart';
import '../state.dart';
import '../widgets.dart';

class _Dest {
  final String name;
  final IconData icon;
  final Color color;
  final String sub;
  const _Dest(this.name, this.icon, this.color, this.sub);
}

const _dests = <_Dest>[
  _Dest('GoPay', Icons.account_balance_wallet, Color(0xFF00AA5B), '0812-****-8890'),
  _Dest('OVO', Icons.wallet, Color(0xFF6A1B9A), '0812-9844-3211'),
  _Dest('DANA', Icons.credit_card, Color(0xFF1565C0), '0812-****-8890'),
  _Dest('ShopeePay', Icons.shopping_bag_outlined, Color(0xFFEE4D2D), '0812-****-8890'),
  _Dest('LinkAja', Icons.link, Color(0xFFD32F2F), 'Hubungkan akun'),
  _Dest('Transfer Bank', Icons.account_balance_outlined, AppColors.deep, 'BCA, Mandiri, BRI'),
];

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  static const nominals = [25000, 50000, 100000];
  int nominalIdx = 1; // 3 = Semua
  int destIdx = 0;

  int get amount => nominalIdx == 3
      ? appState.balance
      : nominals[nominalIdx];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([appState, walletTab]),
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.only(bottom: 32),
          children: [
            const ReCoinTopBar(subtitle: 'Dompet Dan Poin'),
            _header(),
            _tabs(),
            if (walletTab.value == 0) ..._ewallet(context) else ..._voucher(context),
          ],
        );
      },
    );
  }

  Widget _header() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.deep],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withOpacity(.2),
              blurRadius: 24,
              offset: const Offset(0, 10)),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('SALDO & POIN HIJAU',
              style: ts(12, w: FontWeight.w700, c: AppColors.mintSoft)),
          const Spacer(),
          Pill('Terverifikasi',
              bg: Colors.white.withOpacity(.14),
              fg: AppColors.mint,
              icon: Icons.verified_outlined),
        ]),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Saldo Tunai Digital',
                  style: ts(12, c: AppColors.mintSoft)),
              const SizedBox(height: 2),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(fmtRp(appState.balance),
                    style: ts(26, w: FontWeight.w800, c: Colors.white)),
              ),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.bolt, size: 14, color: AppColors.mint),
                const SizedBox(width: 2),
                Text('Bebas biaya admin',
                    style: ts(11, w: FontWeight.w600, c: AppColors.mint)),
              ]),
            ]),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(.1),
                borderRadius: BorderRadius.circular(12)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Poin Belanja', style: ts(11, c: AppColors.mintSoft)),
              Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(fmtNum(appState.points),
                    style: ts(22, w: FontWeight.w800, c: Colors.white)),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text('Poin', style: ts(12, c: AppColors.mintSoft)),
                ),
              ]),
              Row(children: [
                const Icon(Icons.eco_outlined, size: 12, color: AppColors.mintSoft),
                const SizedBox(width: 4),
                Text('+120 mgg ini', style: ts(11, c: AppColors.mintSoft)),
              ]),
            ]),
          ),
        ]),
      ]),
    );
  }

  Widget _tabs() {
    Widget seg(int i, IconData icon, String label) {
      final sel = walletTab.value == i;
      return Expanded(
        child: GestureDetector(
          onTap: () => walletTab.value = i,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: 44,
            decoration: BoxDecoration(
              color: sel ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              boxShadow: sel
                  ? [BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 6)]
                  : null,
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(icon, size: 18, color: sel ? AppColors.deep : AppColors.slate),
              const SizedBox(width: 8),
              Text(label,
                  style: ts(13,
                      w: FontWeight.w700,
                      c: sel ? AppColors.deep : AppColors.slate)),
            ]),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: AppColors.surfaceLow, borderRadius: BorderRadius.circular(14)),
      child: Row(children: [
        seg(0, Icons.account_balance_wallet_outlined, 'Tarik E-Wallet'),
        seg(1, Icons.confirmation_number_outlined, 'Tukar Voucher'),
      ]),
    );
  }

  // ===== Tab 1: Tarik e-wallet =====
  List<Widget> _ewallet(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: Row(children: [
          Text('Pilih Nominal Penarikan', style: ts(14, w: FontWeight.w700)),
          const Spacer(),
          Text('Min. Rp 20.000', style: ts(12, c: AppColors.slate)),
        ]),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Row(children: [
          for (int i = 0; i < 4; i++) ...[
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => nominalIdx = i),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: nominalIdx == i ? AppColors.mint : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: nominalIdx == i
                            ? AppColors.secondary
                            : AppColors.primary.withOpacity(.08)),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                      i == 3 ? 'Semua' : fmtNum(nominals[i]),
                      style: ts(14,
                          w: nominalIdx == i ? FontWeight.w700 : FontWeight.w500,
                          c: nominalIdx == i ? AppColors.deep : AppColors.text)),
                ),
              ),
            ),
            if (i < 3) const SizedBox(width: 8),
          ],
        ]),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: Row(children: [
          Text('Tujuan Penarikan', style: ts(14, w: FontWeight.w700)),
          const Spacer(),
          const Icon(Icons.bolt, size: 14, color: AppColors.primary),
          Text('Instan (0 Menit)',
              style: ts(12, w: FontWeight.w600, c: AppColors.primary)),
        ]),
      ),
      for (int i = 0; i < _dests.length; i++) _destTile(context, i),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
        child: PrimaryButton(
          'Tarik Saldo ${fmtRp(amount)} Sekarang',
          icon: Icons.arrow_downward,
          onPressed: () => _confirm(context),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text('Dana masuk instan & tanpa potongan ke dompet pilihan Anda.',
            textAlign: TextAlign.center,
            style: ts(12, c: AppColors.slate)),
      ),
      const SizedBox(height: 20),
      SectionHeader('Riwayat Penarikan Terbaru',
          action: 'Lihat Semua',
          onAction: () => _allHistory(context)),
      for (final w in appState.withdrawals.take(3)) _withdrawTile(w),
    ];
  }

  Widget _destTile(BuildContext context, int i) {
    final d = _dests[i];
    final sel = destIdx == i;
    final isLink = d.name == 'LinkAja';
    final sub = isLink && appState.linkAjaLinked ? '0812-****-8890' : d.sub;
    return GestureDetector(
      onTap: () {
        if (isLink && !appState.linkAjaLinked) {
          _linkDialog(context);
        } else {
          setState(() => destIdx = i);
        }
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        padding: const EdgeInsets.all(12),
        decoration: cardDeco(radius: 14).copyWith(
          border: Border.all(
              color: sel ? AppColors.primary : AppColors.primary.withOpacity(.08),
              width: sel ? 2 : 1),
          color: sel ? AppColors.mintTint.withOpacity(.5) : Colors.white,
        ),
        child: Row(children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
                color: d.color.withOpacity(.12),
                borderRadius: BorderRadius.circular(12)),
            child: Icon(d.icon, color: d.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(d.name, style: ts(15, w: FontWeight.w700)),
                if (i == 0) ...[
                  const SizedBox(width: 6),
                  Pill('Tersambung', bg: AppColors.mint, fg: AppColors.deep),
                ],
              ]),
              Text(sub, style: ts(12, c: AppColors.slate)),
            ]),
          ),
          Pill('Gratis', bg: AppColors.surfaceLow, fg: AppColors.slate),
          const SizedBox(width: 10),
          Icon(sel ? Icons.check_circle : Icons.circle_outlined,
              color: sel ? AppColors.primary : AppColors.slate.withOpacity(.4)),
        ]),
      ),
    );
  }

  Widget _withdrawTile(Withdrawal w) {
    return AppCard(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.all(12),
      child: Row(children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
              color: AppColors.surfaceLow,
              borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.south_west, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Flexible(
                  child: Text('Tarik ${fmtRp(w.amount)} ke ${w.dest}',
                      overflow: TextOverflow.ellipsis,
                      style: ts(13, w: FontWeight.w600))),
              const SizedBox(width: 6),
              mintPill('Berhasil'),
            ]),
            Text('${fmtDate(w.date)}, ${fmtTime(w.date)} • ID #${w.id}',
                style: ts(11, c: AppColors.slate)),
          ]),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('-${fmtRp(w.amount)}', style: ts(13, w: FontWeight.w800)),
          Text('Admin Rp 0', style: ts(11, c: AppColors.slate)),
        ]),
      ]),
    );
  }

  void _allHistory(BuildContext context) {
    showSheet(
      context,
      SizedBox(
        height: 420,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Semua Riwayat Penarikan', style: ts(18, w: FontWeight.w700)),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              children: [
                for (final w in appState.withdrawals)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Tarik ${fmtRp(w.amount)} ke ${w.dest}',
                        style: ts(14, w: FontWeight.w600)),
                    subtitle: Text('${fmtDate(w.date)} • #${w.id}',
                        style: ts(12, c: AppColors.slate)),
                    trailing: mintPill('Berhasil'),
                  ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  void _linkDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Hubungkan LinkAja', style: ts(17, w: FontWeight.w700)),
        content: Text(
            'ReCoin akan mengirim kode verifikasi ke nomor 0812-****-8890. Lanjutkan?',
            style: ts(13, c: AppColors.slate, h: 1.5)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Batal', style: ts(13, c: AppColors.slate))),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              appState.linkAja();
              Navigator.pop(ctx);
              setState(() => destIdx = 4);
              toast(context, 'LinkAja berhasil dihubungkan');
            },
            child: Text('Hubungkan',
                style: ts(13, w: FontWeight.w700, c: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirm(BuildContext context) {
    final amt = amount;
    if (amt < 20000) {
      toast(context, 'Minimal penarikan Rp 20.000');
      return;
    }
    if (amt > appState.balance) {
      toast(context, 'Saldo tidak cukup. Saldo kamu ${fmtRp(appState.balance)}');
      return;
    }
    final d = _dests[destIdx];
    showSheet(
      context,
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Konfirmasi Penarikan', style: ts(18, w: FontWeight.w700)),
        const SizedBox(height: 16),
        _r('Tujuan', d.name),
        _r('Nomor', d.name == 'LinkAja' ? '0812-****-8890' : d.sub),
        _r('Nominal', fmtRp(amt)),
        _r('Biaya admin', 'Rp 0'),
        const Divider(height: 24),
        _r('Total diterima', fmtRp(amt), bold: true),
        const SizedBox(height: 16),
        PrimaryButton('Konfirmasi & Tarik', icon: Icons.lock_outline,
            onPressed: () {
          Navigator.pop(context);
          appState.withdraw(amt, d.name);
          setState(() => nominalIdx = 1);
          _success(context, amt, d.name);
        }),
      ]),
    );
  }

  Widget _r(String l, String r, {bool bold = false}) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(l, style: ts(13, c: AppColors.slate)),
          Text(r, style: ts(bold ? 17 : 13, w: bold ? FontWeight.w800 : FontWeight.w600)),
        ]),
      );

  void _success(BuildContext context, int amt, String dest) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
                color: AppColors.mintTint, shape: BoxShape.circle),
            child: const Icon(Icons.check_circle,
                size: 40, color: AppColors.secondary),
          ),
          const SizedBox(height: 12),
          Text('Penarikan Berhasil', style: ts(18, w: FontWeight.w800)),
          const SizedBox(height: 6),
          Text('${fmtRp(amt)} sudah masuk ke $dest kamu.',
              textAlign: TextAlign.center,
              style: ts(13, c: AppColors.slate, h: 1.4)),
          const SizedBox(height: 16),
          PrimaryButton('Selesai', onPressed: () => Navigator.pop(ctx)),
        ]),
      ),
    );
  }

  // ===== Tab 2: Voucher =====
  List<Widget> _voucher(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: Row(children: [
          Text('Voucher Tersedia', style: ts(14, w: FontWeight.w700)),
          const Spacer(),
          Text('Poin kamu: ${fmtNum(appState.points)}',
              style: ts(12, w: FontWeight.w600, c: AppColors.primary)),
        ]),
      ),
      for (final v in vouchers) _voucherTile(context, v),
      if (appState.myVouchers.isNotEmpty) ...[
        const SizedBox(height: 8),
        const SectionHeader('Voucher Saya'),
        for (final mv in appState.myVouchers)
          AppCard(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            padding: const EdgeInsets.all(12),
            onTap: () => _showCode(context, mv),
            child: Row(children: [
              Icon(mv.voucher.icon, color: mv.voucher.color),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(mv.voucher.title, style: ts(13, w: FontWeight.w600)),
                  Text('Kode: ${mv.code}', style: ts(12, c: AppColors.slate)),
                ]),
              ),
              amberPill('Belum dipakai'),
            ]),
          ),
      ],
    ];
  }

  Widget _voucherTile(BuildContext context, Voucher v) {
    final ok = appState.points >= v.cost;
    return AppCard(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.all(12),
      child: Row(children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
              color: v.color.withOpacity(.12),
              borderRadius: BorderRadius.circular(12)),
          child: Icon(v.icon, color: v.color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(v.brand, style: ts(12, c: AppColors.slate)),
            Text(v.title, style: ts(13, w: FontWeight.w700, h: 1.3)),
            const SizedBox(height: 2),
            Row(children: [
              const Icon(Icons.monetization_on_outlined,
                  size: 14, color: AppColors.tertiary),
              const SizedBox(width: 3),
              Text('${fmtNum(v.cost)} Poin',
                  style: ts(12, w: FontWeight.w700, c: AppColors.amberText)),
            ]),
          ]),
        ),
        SizedBox(
          height: 38,
          child: FilledButton(
            onPressed: ok ? () => _redeem(context, v) : null,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.surfaceLow,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Tukar',
                style: ts(12,
                    w: FontWeight.w700,
                    c: ok ? Colors.white : AppColors.slate.withOpacity(.6))),
          ),
        ),
      ]),
    );
  }

  void _redeem(BuildContext context, Voucher v) {
    showSheet(
      context,
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Tukar Voucher?', style: ts(18, w: FontWeight.w700)),
        const SizedBox(height: 12),
        Text('${v.brand} • ${v.title}', style: ts(14, w: FontWeight.w600)),
        const SizedBox(height: 6),
        Text(
            'Poin kamu akan berkurang ${fmtNum(v.cost)} (sisa ${fmtNum(appState.points - v.cost)} Poin).',
            style: ts(13, c: AppColors.slate, h: 1.4)),
        const SizedBox(height: 16),
        PrimaryButton('Ya, Tukar Sekarang', onPressed: () {
          Navigator.pop(context);
          final mv = appState.redeem(v);
          _showCode(context, mv);
        }),
      ]),
    );
  }

  void _showCode(BuildContext context, MyVoucher mv) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(mv.voucher.icon, size: 40, color: mv.voucher.color),
          const SizedBox(height: 8),
          Text(mv.voucher.title,
              textAlign: TextAlign.center,
              style: ts(15, w: FontWeight.w700)),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
                color: AppColors.surfaceLow,
                borderRadius: BorderRadius.circular(10)),
            child: Text(mv.code,
                style: ts(20, w: FontWeight.w800, c: AppColors.deep)
                    .copyWith(letterSpacing: 2)),
          ),
          const SizedBox(height: 14),
          PrimaryButton('Salin Kode', icon: Icons.copy, onPressed: () {
            Clipboard.setData(ClipboardData(text: mv.code));
            Navigator.pop(ctx);
            toast(context, 'Kode voucher disalin');
          }),
        ]),
      ),
    );
  }
}
