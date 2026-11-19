import 'package:flutter/material.dart';
import '../theme.dart';
import '../state.dart';
import '../widgets.dart';
import 'success_page.dart';

class SellPage extends StatefulWidget {
  const SellPage({super.key});

  @override
  State<SellPage> createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  final Map<String, double> qty = {};
  static const slots = [
    'Besok, Pagi Hari • 10:00 - 12:00 WIB',
    'Besok, Siang Hari • 13:00 - 15:00 WIB',
    'Lusa, Pagi Hari • 10:00 - 12:00 WIB',
    'Lusa, Siang Hari • 13:00 - 15:00 WIB',
  ];
  int slotIndex = 0;

  double get totalKg => qty.values.fold(0.0, (a, b) => a + b);
  int get gross => qty.entries
      .fold(0, (a, e) => a + (priceOf(e.key) * e.value).round());
  int get fee => (totalKg > 0 && totalKg < 5) ? 5000 : 0;
  int get net => gross - fee;
  int get bonus => gross ~/ 100;

  void _change(String name, double delta) {
    final v = ((qty[name] ?? 0) + delta).clamp(0.0, 99.0);
    setState(() {
      if (v == 0) {
        qty.remove(name);
      } else {
        qty[name] = v;
      }
    });
  }

  void _submit() {
    final o = appState.createOrder(
      items: qty,
      address: appState.currentAddress,
      slot: slots[slotIndex],
      fee: fee,
    );
    setState(() => qty.clear());
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => SuccessPage(orderId: o.id)));
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) => Stack(children: [
        ListView(
          padding: const EdgeInsets.only(bottom: 100),
          children: [
            const ReCoinTopBar(subtitle: 'Jual Sampah'),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                mintPill('Kategori Sampah Anorganik', icon: Icons.eco_outlined),
                const SizedBox(height: 10),
                Text('Pilih Jenis Sampah',
                    style: ts(26, w: FontWeight.w800, c: AppColors.deep)),
                const SizedBox(height: 4),
                Text(
                    'Pilah sampah bersih & kering untuk nilai tukar koin terbaik.',
                    style: ts(13, c: AppColors.slate, h: 1.4)),
              ]),
            ),
            _guide(context),
            ...categories.map(_categoryCard),
            _summary(),
            _pickupOptions(context),
          ],
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 12,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            PrimaryButton(
              totalKg == 0
                  ? 'Pilih sampah dulu'
                  : 'Jadwalkan Penjemputan Sekarang',
              icon: totalKg == 0 ? null : Icons.local_shipping_outlined,
              onPressed: totalKg == 0 ? null : _submit,
            ),
          ]),
        ),
      ]),
    );
  }

  Widget _guide(BuildContext context) {
    return AppCard(
      color: AppColors.surfaceLow,
      padding: const EdgeInsets.all(12),
      onTap: () => showSheet(
        context,
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Panduan Kondisi Sampah', style: ts(18, w: FontWeight.w700)),
          const SizedBox(height: 12),
          for (final t in const [
            'Sampah harus bersih dari sisa makanan/minuman.',
            'Keringkan botol dan kaleng sebelum disetor.',
            'Pipihkan kardus dan ikat dengan tali.',
            'Pisahkan sampah per kategori.',
            'Sampah basah/berminyak dapat dikurangi bobotnya.',
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(Icons.check_circle,
                    size: 18, color: AppColors.secondary),
                const SizedBox(width: 8),
                Expanded(child: Text(t, style: ts(13, h: 1.4))),
              ]),
            ),
          const SizedBox(height: 8),
          PrimaryButton('Mengerti', onPressed: () => Navigator.pop(context)),
        ]),
      ),
      child: Row(children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              color: AppColors.mint.withOpacity(.6), shape: BoxShape.circle),
          child: const Icon(Icons.verified_outlined, color: AppColors.deep),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Panduan Kondisi Sampah', style: ts(13, w: FontWeight.w700)),
            Text('Keringkan & pipihkan botol atau kardus',
                style: ts(12, c: AppColors.slate)),
          ]),
        ),
        const Icon(Icons.chevron_right, color: AppColors.slate),
      ]),
    );
  }

  Widget _categoryCard(WasteCategory c) {
    final v = qty[c.name] ?? 0;
    final active = v > 0;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      padding: const EdgeInsets.all(12),
      decoration: cardDeco().copyWith(
        color: active ? AppColors.mintTint.withOpacity(.5) : Colors.white,
        border: Border.all(
            color: active ? AppColors.primary : AppColors.primary.withOpacity(.08),
            width: active ? 2 : 1),
      ),
      child: Column(children: [
        Row(children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
                color: c.iconBg, borderRadius: BorderRadius.circular(12)),
            child: Icon(c.icon, color: c.iconFg, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Flexible(
                    child: Text(c.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: ts(15, w: FontWeight.w700))),
                if (c.tag.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  c.tag == 'Populer'
                      ? Pill(c.tag, bg: AppColors.surfaceLow, fg: AppColors.slate)
                      : amberPill(c.tag),
                ],
              ]),
              Text(c.desc,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ts(12, c: AppColors.slate)),
              const SizedBox(height: 2),
              Text('${fmtRp(c.price)} / kg',
                  style: ts(13, w: FontWeight.w700, c: AppColors.primary)),
            ]),
          ),
        ]),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
              color: AppColors.surfaceLow,
              borderRadius: BorderRadius.circular(10)),
          child: Row(children: [
            Text('Perkiraan Berat:', style: ts(12, c: AppColors.slate)),
            const Spacer(),
            _stepBtn(Icons.remove, v > 0 ? () => _change(c.name, -0.5) : null, false),
            SizedBox(
              width: 80,
              child: Text('${fmtKg(v)} Kg',
                  textAlign: TextAlign.center,
                  style: ts(16, w: FontWeight.w700)),
            ),
            _stepBtn(Icons.add, () => _change(c.name, 0.5), true),
          ]),
        ),
      ]),
    );
  }

  Widget _stepBtn(IconData icon, VoidCallback? onTap, bool filled) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: filled ? AppColors.deep : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: filled ? null : Border.all(color: AppColors.primary.withOpacity(.12)),
        ),
        child: Icon(icon,
            size: 20,
            color: filled
                ? Colors.white
                : (onTap == null
                    ? AppColors.slate.withOpacity(.4)
                    : AppColors.primary)),
      ),
    );
  }

  Widget _summary() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.deep],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.payments_outlined, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text('Ringkasan Penjualan',
              style: ts(14, w: FontWeight.w700, c: Colors.white)),
          const Spacer(),
          Pill('${fmtKg(totalKg)} Kg Total',
              bg: Colors.white.withOpacity(.18), fg: Colors.white),
        ]),
        const SizedBox(height: 12),
        Text('Estimasi Uang Diterima',
            style: ts(12, c: AppColors.mintSoft)),
        const SizedBox(height: 2),
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(fmtRp(net < 0 ? 0 : net),
                  style: ts(28, w: FontWeight.w800, c: Colors.white)),
            ),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('Bonus ReCoin', style: ts(11, c: AppColors.mintSoft)),
            Row(children: [
              const Icon(Icons.monetization_on_outlined,
                  size: 18, color: AppColors.mint),
              const SizedBox(width: 4),
              Text('+$bonus Poin',
                  style: ts(16, w: FontWeight.w800, c: AppColors.mint)),
            ]),
          ]),
        ]),
        if (fee > 0) ...[
          const SizedBox(height: 8),
          Text('Sudah dipotong ongkos jemput ${fmtRp(fee)} (gratis min. 5 Kg)',
              style: ts(11, c: AppColors.mintSoft)),
        ],
      ]),
    );
  }

  Widget _pickupOptions(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.local_shipping_outlined, color: AppColors.deep),
          const SizedBox(width: 8),
          Text('Opsi Penjemputan', style: ts(17, w: FontWeight.w700)),
        ]),
        const SizedBox(height: 14),
        Text('Alamat Penjemputan', style: ts(12, c: AppColors.slate)),
        const SizedBox(height: 6),
        _optBox(
          Icons.location_on_outlined,
          appState.currentAddressLabel,
          appState.currentAddress,
          'Ganti',
          () => _pickAddress(context),
        ),
        const SizedBox(height: 12),
        Text('Waktu Penjemputan', style: ts(12, c: AppColors.slate)),
        const SizedBox(height: 6),
        _optBox(
          Icons.calendar_month_outlined,
          slots[slotIndex].split(' • ').first,
          slots[slotIndex].split(' • ').last,
          'Pilih Waktu',
          () => _pickSlot(context),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: AppColors.surfaceLow,
              borderRadius: BorderRadius.circular(10)),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.info_outline, size: 18, color: AppColors.slate),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                  'Kurir ReCoin akan membawa timbangan digital resmi. Penimbangan dilakukan transparan di depan Anda.',
                  style: ts(12, c: AppColors.slate, h: 1.4)),
            ),
          ]),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text('Bebas biaya admin & gratis ongkos jemput untuk berat minimal 5 Kg.',
              textAlign: TextAlign.center,
              style: ts(11, c: AppColors.slate)),
        ),
      ]),
    );
  }

  Widget _optBox(IconData icon, String title, String sub, String action,
      VoidCallback onTap) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: AppColors.surfaceLow, borderRadius: BorderRadius.circular(10)),
      child: Row(children: [
        Icon(icon, color: AppColors.deep),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: ts(13, w: FontWeight.w700)),
            Text(sub,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: ts(12, c: AppColors.slate)),
          ]),
        ),
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Text(action,
                style: ts(12, w: FontWeight.w700, c: AppColors.primary)
                    .copyWith(decoration: TextDecoration.underline)),
          ),
        ),
      ]),
    );
  }

  void _pickSlot(BuildContext context) {
    showSheet(
      context,
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Pilih Waktu Penjemputan', style: ts(18, w: FontWeight.w700)),
        const SizedBox(height: 12),
        for (int i = 0; i < slots.length; i++)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
                i == slotIndex ? Icons.radio_button_checked : Icons.radio_button_off,
                color: AppColors.primary),
            title: Text(slots[i].split(' • ').first,
                style: ts(14, w: FontWeight.w600)),
            subtitle: Text(slots[i].split(' • ').last,
                style: ts(12, c: AppColors.slate)),
            onTap: () {
              setState(() => slotIndex = i);
              Navigator.pop(context);
            },
          ),
      ]),
    );
  }

  void _pickAddress(BuildContext context) {
    showSheet(
      context,
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Pilih Alamat', style: ts(18, w: FontWeight.w700)),
        const SizedBox(height: 12),
        for (int i = 0; i < appState.addresses.length; i++)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
                i == appState.addressIndex
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: AppColors.primary),
            title: Text(appState.addressLabels[i],
                style: ts(14, w: FontWeight.w600)),
            subtitle: Text(appState.addresses[i],
                style: ts(12, c: AppColors.slate)),
            onTap: () {
              appState.selectAddress(i);
              Navigator.pop(context);
            },
          ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.add_location_alt_outlined,
              color: AppColors.primary),
          title: Text('Tambah alamat baru',
              style: ts(14, w: FontWeight.w700, c: AppColors.primary)),
          onTap: () {
            Navigator.pop(context);
            _addAddress(context);
          },
        ),
      ]),
    );
  }

  void _addAddress(BuildContext context) {
    final label = TextEditingController();
    final addr = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Alamat Baru', style: ts(17, w: FontWeight.w700)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
              controller: label,
              decoration: const InputDecoration(labelText: 'Label (mis. Rumah Ibu)')),
          TextField(
              controller: addr,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Alamat lengkap')),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Batal', style: ts(13, c: AppColors.slate))),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              if (addr.text.trim().isEmpty) return;
              appState.addAddress(
                  label.text.trim().isEmpty ? 'Alamat Baru' : label.text.trim(),
                  addr.text.trim());
              Navigator.pop(ctx);
            },
            child: Text('Simpan', style: ts(13, w: FontWeight.w700, c: Colors.white)),
          ),
        ],
      ),
    );
  }
}
