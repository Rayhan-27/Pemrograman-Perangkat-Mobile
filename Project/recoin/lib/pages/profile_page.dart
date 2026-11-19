import 'package:flutter/material.dart';
import '../theme.dart';
import '../state.dart';
import '../widgets.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final menus = <(IconData, String)>[
      (Icons.person_outline, 'Edit Profil'),
      (Icons.location_on_outlined, 'Daftar Alamat'),
      (Icons.account_balance_outlined, 'Rekening & E-Wallet'),
      (Icons.card_giftcard, 'Undang Teman'),
      (Icons.help_outline, 'Pusat Bantuan'),
      (Icons.privacy_tip_outlined, 'Kebijakan Privasi'),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('Profil', style: ts(17, w: FontWeight.w700)),
      ),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.only(bottom: 32),
          children: [
            AppCard(
              child: Row(children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.mintSoft,
                  child: Icon(Icons.person, size: 34, color: AppColors.deep),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(appState.userName, style: ts(18, w: FontWeight.w800)),
                    const SizedBox(height: 4),
                    mintPill('Pahlawan Lingkungan • Level ${appState.level}',
                        icon: Icons.eco_outlined),
                  ]),
                ),
              ]),
            ),
            AppCard(
              child: Row(children: [
                _s('Saldo', fmtRp(appState.balance)),
                _s('Poin', fmtNum(appState.points)),
                _s('Total Setor', '${appState.monthKg.toStringAsFixed(1)} Kg'),
              ]),
            ),
            for (final m in menus)
              AppCard(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                onTap: () => toast(context, '${m.$2} segera hadir'),
                child: Row(children: [
                  Icon(m.$1, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(child: Text(m.$2, style: ts(14, w: FontWeight.w600))),
                  const Icon(Icons.chevron_right, color: AppColors.slate),
                ]),
              ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () => toast(context, 'Keluar (simulasi)'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.roseText.withOpacity(.4)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.logout, color: AppColors.roseText, size: 18),
                  label: Text('Keluar',
                      style: ts(14, w: FontWeight.w700, c: AppColors.roseText)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _s(String l, String v) => Expanded(
        child: Column(children: [
          FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(v, style: ts(16, w: FontWeight.w800, c: AppColors.deep))),
          const SizedBox(height: 2),
          Text(l, style: ts(11, c: AppColors.slate)),
        ]),
      );
}
