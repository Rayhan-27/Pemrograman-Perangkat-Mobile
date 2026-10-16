import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

// Dekorasi kartu putih dengan bayangan halus (dipakai beberapa kartu)
BoxDecoration _cardBox(ColorScheme cs, {Color? color}) => BoxDecoration(
      color: color ?? cs.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x12071637),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
    );

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // watch: halaman ini otomatis rebuild saat data keranjang berubah,
    // sehingga jumlah, subtotal, dan total pembayaran ikut berubah.
    final cart = context.watch<CartProvider>();
    final isEmpty = cart.items.isEmpty;

    return Scaffold(
      appBar: const NusaAppBar(),
      body: isEmpty
          ? const _EmptyCart()
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                _CartHeader(cart: cart),
                const SizedBox(height: 16),
                _ShippingCard(cart: cart),
                const SizedBox(height: 8),
                _SelectAllRow(cart: cart),
                const SizedBox(height: 16),
                for (final item in cart.items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _CartItemCard(
                      item: item,
                      selected: cart.isSelected(item.book),
                    ),
                  ),
                const _VoucherCard(),
                const SizedBox(height: 16),
                _SummaryCard(cart: cart),
                const SizedBox(height: 8),
                const _GuaranteeBadge(),
              ],
            ),
      bottomNavigationBar: isEmpty ? null : _CheckoutBar(cart: cart),
    );
  }
}

// =====================================================================
// Keranjang kosong
// =====================================================================
class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 80, color: cs.outline),
            const SizedBox(height: 12),
            Text('Keranjang masih kosong',
                style: AppText.serif(22, color: cs.primary)),
            const SizedBox(height: 4),
            Text(
              'Yuk, pilih buku favoritmu dari katalog.',
              style: AppText.sans(13, color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => AppNav.tab.value = 0,
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: AppText.sans(14, weight: FontWeight.w600),
              ),
              child: const Text('Mulai Belanja'),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// Header: tombol kembali, judul, tombol Hapus
// =====================================================================
class _CartHeader extends StatelessWidget {
  final CartProvider cart;
  const _CartHeader({required this.cart});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final canDelete = cart.selectedLineCount > 0;

    return Row(
      children: [
        Material(
          color: cs.surfaceContainer,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => AppNav.tab.value = 0,
            child: SizedBox(
              width: 40,
              height: 40,
              child: Icon(Icons.arrow_back, size: 20, color: cs.primary),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Keranjang Belanja',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.serif(
                  22,
                  weight: FontWeight.w700,
                  color: cs.primary,
                  height: 1.25,
                ),
              ),
              Text(
                '${cart.selectedLineCount} judul buku terpilih',
                style: AppText.sans(12, color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Material(
          color: canDelete ? cs.errorContainer : cs.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: canDelete
                ? () => context.read<CartProvider>().removeSelected()
                : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.delete_outline,
                    size: 16,
                    color: canDelete ? cs.onErrorContainer : cs.outline,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Hapus',
                    style: AppText.sans(
                      11,
                      weight: FontWeight.w700,
                      color: canDelete ? cs.onErrorContainer : cs.outline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =====================================================================
// Kartu progres gratis ongkir
// =====================================================================
class _ShippingCard extends StatelessWidget {
  final CartProvider cart;
  const _ShippingCard({required this.cart});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final free = cart.freeShipping;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardBox(cs, color: cs.surfaceContainerLow),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_shipping, size: 20, color: cs.secondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Bebas Ongkir Spesial Pulau Jawa',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.sans(
                    13,
                    weight: FontWeight.w700,
                    color: cs.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: free ? cs.badgeBg : cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  free ? 'Aktif' : 'Belum aktif',
                  style: AppText.sans(
                    11,
                    weight: FontWeight.w700,
                    color: free ? cs.badgeFg : cs.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            free
                ? 'Pesanan Anda telah memenuhi batas minimum ${formatRupiah(CartProvider.freeShippingMin)} untuk pengiriman gratis.'
                : 'Tambah belanja ${formatRupiah(cart.remainingForFreeShipping)} lagi untuk gratis ongkir (min. ${formatRupiah(CartProvider.freeShippingMin)}).',
            style: AppText.sans(12, color: cs.onSurfaceVariant, height: 1.5),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: cart.shippingProgress,
              minHeight: 6,
              backgroundColor: cs.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(cs.secondary),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// Baris "Pilih Semua"
// =====================================================================
class _SelectAllRow extends StatelessWidget {
  final CartProvider cart;
  const _SelectAllRow({required this.cart});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Checkbox(
            value: cart.allSelected,
            onChanged: (v) =>
                context.read<CartProvider>().setAllSelected(v ?? false),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          Expanded(
            child: Text(
              'Pilih Semua (${cart.items.length} produk)',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.sans(
                13,
                weight: FontWeight.w700,
                color: cs.primary,
              ),
            ),
          ),
          Text(
            'Urutkan: Terbaru',
            style: AppText.sans(12, color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// Kartu satu buku di keranjang
// =====================================================================
class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final bool selected;
  const _CartItemCard({required this.item, required this.selected});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final book = item.book;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardBox(cs),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox pilih item
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: Checkbox(
                    value: selected,
                    onChanged: (_) =>
                        context.read<CartProvider>().toggleSelected(book),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              BookCover(url: book.imageUrl, width: 76, height: 112),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: cs.badgeBg,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  book.cartLabel.toUpperCase(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppText.sans(
                                    10,
                                    weight: FontWeight.w700,
                                    color: cs.badgeFg,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                book.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppText.serif(
                                  20,
                                  color: cs.primary,
                                  height: 1.2,
                                ),
                              ),
                              Text(
                                book.author,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppText.sans(
                                  12,
                                  color: cs.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Hapus satu baris buku
                        InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () =>
                              context.read<CartProvider>().deleteItem(book),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Icon(
                              Icons.delete_outline,
                              size: 20,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Harga Satuan',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppText.sans(
                                  12,
                                  color: cs.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                formatRupiah(book.price),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppText.sans(
                                  15,
                                  weight: FontWeight.w700,
                                  color: cs.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _QuantityStepper(item: item),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Subtotal per buku
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal Buku:',
                  style: AppText.sans(12, color: cs.onSurfaceVariant),
                ),
                Text(
                  formatRupiah(book.price * item.quantity),
                  style: AppText.sans(
                    13,
                    weight: FontWeight.w700,
                    color: cs.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Tombol  -  jumlah  +
class _QuantityStepper extends StatelessWidget {
  final CartItem item;
  const _QuantityStepper({required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CircleButton(
            icon: Icons.remove,
            background: cs.surfaceContainerHighest,
            foreground: cs.primary,
            // removeItem: kurangi jumlah, hapus jika tinggal 1
            onTap: () => context.read<CartProvider>().removeItem(item.book),
          ),
          SizedBox(
            width: 26,
            child: Text(
              '${item.quantity}',
              textAlign: TextAlign.center,
              style: AppText.sans(
                13,
                weight: FontWeight.w700,
                color: cs.primary,
              ),
            ),
          ),
          _CircleButton(
            icon: Icons.add,
            background: cs.primary,
            foreground: cs.onPrimary,
            // addItem: karena buku sudah ada, jumlahnya bertambah
            onTap: () => context.read<CartProvider>().addItem(item.book),
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  const _CircleButton({
    required this.icon,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 28,
          height: 28,
          child: Icon(icon, size: 16, color: foreground),
        ),
      ),
    );
  }
}

// =====================================================================
// Voucher & promo
// =====================================================================
class _VoucherCard extends StatefulWidget {
  const _VoucherCard();

  @override
  State<_VoucherCard> createState() => _VoucherCardState();
}

class _VoucherCardState extends State<_VoucherCard> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: context.read<CartProvider>().voucherCode ?? '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _apply() {
    final cart = context.read<CartProvider>();
    final ok = cart.applyVoucher(_controller.text);
    FocusScope.of(context).unfocus();

    if (ok) {
      _controller.text = cart.voucherCode!;
      showNusaSnackBar(
        context,
        title: 'Voucher berhasil dipasang',
        message: 'Kupon ${cart.voucherCode} aktif.',
      );
    } else {
      showNusaSnackBar(
        context,
        title: 'Kode promo tidak valid',
        message: 'Coba gunakan kode NUSAHEMAT15.',
        isError: true,
      );
    }
  }

  void _showVouchers() {
    final cs = Theme.of(context).colorScheme;

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Voucher & Promo Toko',
                style: AppText.serif(20, color: cs.primary)),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.loyalty, color: cs.secondary),
              title: Text(
                'NUSAHEMAT15',
                style: AppText.sans(14, weight: FontWeight.w700),
              ),
              subtitle: Text(
                'Potongan ${formatRupiah(CartProvider.vouchers['NUSAHEMAT15']!)} untuk semua buku',
                style: AppText.sans(12, color: cs.onSurfaceVariant),
              ),
              trailing: FilledButton(
                onPressed: () {
                  Navigator.pop(sheetContext);
                  _controller.text = 'NUSAHEMAT15';
                  _apply();
                },
                child: const Text('Pakai'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // watch: kartu ini ikut berubah saat voucher dipasang / dilepas
    final cart = context.watch<CartProvider>();
    final applied = cart.voucherCode != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardBox(cs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.loyalty_outlined, size: 20, color: cs.secondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Voucher & Promo Toko',
                  style: AppText.sans(
                    13,
                    weight: FontWeight.w700,
                    color: cs.primary,
                  ),
                ),
              ),
              InkWell(
                onTap: _showVouchers,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    'Lihat Semua',
                    style: AppText.sans(
                      11,
                      weight: FontWeight.w700,
                      color: cs.secondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  textCapitalization: TextCapitalization.characters,
                  onSubmitted: (_) => _apply(),
                  style: AppText.sans(
                    13,
                    weight: FontWeight.w600,
                    color: cs.primary,
                    letterSpacing: 1,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Masukkan kode promo',
                    hintStyle: AppText.sans(13, color: cs.onSurfaceVariant),
                    suffixIcon: applied
                        ? Icon(Icons.verified, size: 18, color: cs.secondary)
                        : null,
                    filled: true,
                    fillColor: cs.surfaceContainerLow,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: _apply,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 46),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: AppText.sans(13, weight: FontWeight.w600),
                ),
                child: const Text('Terapkan'),
              ),
            ],
          ),
          if (applied) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
              decoration: BoxDecoration(
                color: cs.badgeBg.withAlpha(128),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.confirmation_number_outlined,
                      size: 18, color: cs.secondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Kupon "${cart.voucherCode}" Terpasang (-${formatRupiah(cart.discount)})',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.sans(
                        11,
                        weight: FontWeight.w700,
                        color: cs.badgeFg,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Batalkan promo',
                    visualDensity: VisualDensity.compact,
                    icon: Icon(Icons.close, size: 18, color: cs.badgeFg),
                    onPressed: () {
                      context.read<CartProvider>().removeVoucher();
                      _controller.clear();
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// =====================================================================
// Ringkasan belanja
// =====================================================================
class _SummaryCard extends StatelessWidget {
  final CartProvider cart;
  const _SummaryCard({required this.cart});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardBox(cs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ringkasan Belanja',
            style: AppText.serif(20, weight: FontWeight.w700, color: cs.primary),
          ),
          const SizedBox(height: 12),
          _SummaryRow(
            label: 'Total Item Terpilih',
            value: '${cart.selectedQuantity} buku',
          ),
          _SummaryRow(
            label: 'Subtotal Produk',
            value: formatRupiah(cart.subtotal),
          ),
          _SummaryRow(
            label: 'Diskon Voucher Toko',
            value: cart.discount > 0 ? '-${formatRupiah(cart.discount)}' : '-',
            valueColor: cs.secondary,
            bold: true,
            infoIcon: true,
          ),
          _SummaryRow(
            label: 'Estimasi Ongkos Kirim',
            value: cart.subtotal == 0
                ? '-'
                : (cart.freeShipping
                    ? 'Gratis (Bebas Ongkir)'
                    : formatRupiah(cart.shipping)),
            valueColor: cart.freeShipping ? cs.secondary : null,
            bold: cart.freeShipping,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Divider(height: 1, color: cs.outlineVariant),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Pembayaran',
                      style: AppText.serif(
                        20,
                        weight: FontWeight.w700,
                        color: cs.primary,
                      ),
                    ),
                    Text(
                      'Termasuk PPN 11% & penanganan',
                      style: AppText.sans(12, color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                formatRupiah(cart.grandTotal),
                style: AppText.serif(
                  22,
                  weight: FontWeight.w700,
                  color: cs.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;
  final bool infoIcon;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.bold = false,
    this.infoIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    label,
                    style: AppText.sans(14, color: cs.onSurfaceVariant),
                  ),
                ),
                if (infoIcon) ...[
                  const SizedBox(width: 4),
                  Icon(Icons.info_outline, size: 16, color: cs.secondary),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: AppText.sans(
              13,
              weight: bold ? FontWeight.w700 : FontWeight.w600,
              color: valueColor ?? cs.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _GuaranteeBadge extends StatelessWidget {
  const _GuaranteeBadge();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.verified_user_outlined, size: 18, color: cs.onSurfaceVariant),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              '100% Buku Asli Penerbit & Garansi Pengembalian',
              style: AppText.sans(12, color: cs.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// Bar checkout yang menempel di bawah (di atas bottom navigation)
// =====================================================================
class _CheckoutBar extends StatelessWidget {
  final CartProvider cart;
  const _CheckoutBar({required this.cart});

  void _checkout(BuildContext context) {
    final provider = context.read<CartProvider>();

    // Simpan dulu sebelum keranjang dikosongkan
    final total = formatRupiah(provider.grandTotal);
    final qty = provider.selectedQuantity;

    // Jika semua tercentang -> kosongkan keranjang.
    // Jika hanya sebagian -> hapus yang dibayar, sisanya tetap di keranjang.
    if (provider.allSelected) {
      provider.clearCart();
    } else {
      provider.removeSelected();
    }

    showNusaSnackBar(
      context,
      title: 'Checkout berhasil!',
      message: '$qty buku dibayar, total $total',
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final canCheckout = cart.selectedQuantity > 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surface,
        boxShadow: const [
          BoxShadow(
            color: Color(0x14071637),
            blurRadius: 20,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total Tagihan',
                  style: AppText.sans(12, color: cs.onSurfaceVariant),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    formatRupiah(cart.grandTotal),
                    style: AppText.serif(
                      22,
                      weight: FontWeight.w700,
                      color: cs.primary,
                    ),
                  ),
                ),
                if (cart.discount > 0)
                  Text(
                    'Hemat ${formatRupiah(cart.discount)} diterapkan',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.sans(
                      11,
                      weight: FontWeight.w700,
                      color: cs.secondary,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.icon(
            onPressed: canCheckout ? () => _checkout(context) : null,
            icon: const Icon(Icons.shopping_bag_outlined, size: 20),
            label: Text('Checkout / Bayar (${cart.selectedQuantity})'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, 48),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: AppText.sans(14, weight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
