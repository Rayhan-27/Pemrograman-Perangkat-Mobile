import 'package:flutter/services.dart';

String pisahRibuan(String digits) {
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

String formatRupiah(int nilai) =>
    '${nilai < 0 ? '-' : ''}Rp ${pisahRibuan(nilai.abs().toString())}';

const _bulan = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];

String formatTanggal(DateTime d) => '${d.day} ${_bulan[d.month - 1]} ${d.year}';

/// "50.000" -> 50000, "-5.000" -> -5000, teks tidak valid -> 0.
int parseNominal(String teks) => int.tryParse(teks.replaceAll('.', '').trim()) ?? 0;

/// Memformat input nominal dengan titik ribuan. Tanda minus di depan
/// dipertahankan supaya nominal negatif tetap bisa ditolak oleh validator.
class RibuanInputFormatter extends TextInputFormatter {
  const RibuanInputFormatter();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final negatif = newValue.text.trimLeft().startsWith('-');
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length > 13) return oldValue;
    final minus = negatif ? '-' : '';
    final teks = digits.isEmpty ? minus : '$minus${pisahRibuan(digits)}';
    return TextEditingValue(text: teks, selection: TextSelection.collapsed(offset: teks.length));
  }
}
