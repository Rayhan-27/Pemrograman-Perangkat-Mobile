import 'dart:ui';
import 'package:flutter/material.dart';
import 'theme.dart';
import 'state.dart';
import 'pages/home_page.dart';
import 'pages/sell_page.dart';
import 'pages/wallet_page.dart';
import 'pages/history_page.dart';

void main() => runApp(const ReCoinApp());

class ReCoinApp extends StatelessWidget {
  const ReCoinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReCoin',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  static const _pages = <Widget>[
    HomePage(),
    SellPage(),
    WalletPage(),
    HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: tabIndex,
      builder: (context, idx, _) {
        // Urutan tampilan bar: Beranda, Jual Sampah (tengah), Dompet, Riwayat
        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: IndexedStack(index: idx, children: _pages),
          ),
          bottomNavigationBar: _BottomBar(index: idx),
        );
      },
    );
  }
}

class _BottomBar extends StatelessWidget {
  final int index;
  const _BottomBar({required this.index});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.bg.withOpacity(.92),
            border: Border(
                top: BorderSide(color: AppColors.primary.withOpacity(.08))),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 82,
              child: Row(children: [
                _item(0, Icons.eco_outlined, Icons.eco, 'Beranda'),
                _center(),
                _item(2, Icons.account_balance_wallet_outlined,
                    Icons.account_balance_wallet, 'Dompet'),
                _item(3, Icons.history, Icons.history, 'Riwayat'),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _item(int i, IconData off, IconData on, String label) {
    final sel = index == i;
    final color = sel ? AppColors.primary : AppColors.slate;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => tabIndex.value = i,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(sel ? on : off, color: color, size: 26),
          const SizedBox(height: 3),
          Text(label,
              style: ts(11,
                  w: sel ? FontWeight.w700 : FontWeight.w500, c: color)),
        ]),
      ),
    );
  }

  Widget _center() {
    final sel = index == 1;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => tabIndex.value = 1,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: sel ? AppColors.deep : AppColors.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: AppColors.primary.withOpacity(.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: const Icon(Icons.recycling, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 2),
          Text('Jual Sampah',
              style: ts(11, w: FontWeight.w700, c: AppColors.primary)),
        ]),
      ),
    );
  }
}
