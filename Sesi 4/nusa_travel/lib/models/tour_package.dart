class TourPackage {
  final String id;
  final String title;
  final String description;
  final int price;
  final String imageUrl;
  final String location;
  final String duration;
  final double rating;

  const TourPackage({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.location = '',
    this.duration = '',
    this.rating = 0,
  });

  String get formattedPrice => 'Rp ${formatRupiah(price)}';
}

String formatRupiah(int value) {
  final s = value.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return buf.toString();
}

const String _img = 'https://lh3.googleusercontent.com/aida-public/';

const List<TourPackage> tourPackages = [
  TourPackage(
    id: 'pkg-001',
    title: 'Labuan Bajo & Pulau Padar',
    location: 'Nusa Tenggara Timur',
    duration: '4 Hari 3 Malam',
    rating: 4.9,
    price: 4850000,
    description:
        'Jelajahi surga kepulauan Komodo dengan tinggal di atas kapal phinisi tradisional. '
        'Trekking ke puncak Pulau Padar saat matahari terbit, snorkeling bersama manta ray '
        'di Manta Point, dan saksikan Komodo di habitat aslinya. Termasuk makan 3x sehari, '
        'alat snorkeling, dan pemandu lokal berlisensi.',
    imageUrl:
        '${_img}AB6AXuCFMAGHI1hx3FsUiMFSNXXTC0sEXXbH9UWWadbPV2yO8p1KcF5z8lCXj7Qnbxzw-ikhPjDMXqkvlnwlRA5ahWY-PnU_hvIrLbSho7UeXLF_m338xJa7Q0fLBuAK_ihuUfG4g_oivfuVmhz34kOx2LKK90yGRJ7xh-BRCxL9KBwJCd69Txk-AVueXkscxJaXmpVrAuvQXBKVKIj0Mzx7NgweEBUk9KlNmEYAH6fcpciNoTzjUsqpHbx5',
  ),
  TourPackage(
    id: 'pkg-002',
    title: 'Eksotisme Raja Ampat & Wayag',
    location: 'Papua Barat Daya',
    duration: '5 Hari 4 Malam',
    rating: 5.0,
    price: 9200000,
    description:
        'Nikmati gugusan karst Wayag dan laguna sebening kristal di Raja Ampat. '
        'Paket ini mencakup speedboat eksplorasi, diving dan snorkeling di terumbu karang '
        'terbaik dunia, serta dokumentasi drone.',
    imageUrl:
        '${_img}AB6AXuAxhhQDO5cwPEe0B-Z4I-5XWxf_yR3JcdzZvlUTRqukDeTHPzvBBZ7LXgQnDcbEUmQ2zBm_-a9vsWZSx7RgOI1ddNs5nfTIfg-eOu1E4yiLFkmvj_6-hjwrlXP8ZeUbeNeCTUzD02hdt505iAfwUBsD8RwPkqYKtn9y-I5Ml7Zp2hGUUhueOhRUYohCjX0sJG8LZRvlUoCQ5snhjyXbRtsVthchkS0Haxh0J39VW2JWhUulSXPVuQpT',
  ),
  TourPackage(
    id: 'pkg-003',
    title: 'Magical Sunrise Bromo & Madakaripura',
    location: 'Jawa Timur',
    duration: '3 Hari 2 Malam',
    rating: 4.8,
    price: 1950000,
    description:
        'Saksikan sunrise dari kaldera Bromo dengan Jeep 4x4, jelajahi lautan pasir, '
        'lalu bermain di air terjun Madakaripura yang megah. Menginap di hotel dekat kawasan Bromo.',
    imageUrl:
        '${_img}AB6AXuBcPg1Zv2SxW_f6QKXYxCXYhm01GCy9OeblWC-zwV2FhuNGseeQ1L2pNNNTeNcB5vJQQsEtOHwgQ-x7IsulpJqodw0Gjyt57GhPh7PLnDtcJkxePFeR7dUg216-MHBZEIIwwdW4tMreO5Xy7saapIebIScQlMuStHa8DHLwXPVhShuLf_dJK9jfkrwYO7COBAVYg70rqifiYvJ7KiDrxTAceCKtKQqZvodwbtIGSQY8AHuhUQlGSIfs',
  ),
  TourPackage(
    id: 'pkg-004',
    title: 'Wisata Budaya & Alam Tana Toraja',
    location: 'Sulawesi Selatan',
    duration: '4 Hari 3 Malam',
    rating: 4.9,
    price: 3400000,
    description:
        'Kenali budaya Toraja: rumah adat Tongkonan, Desa Kete Kesu, dan hamparan sawah '
        'berundak di dataran tinggi. Ditemani pemandu budaya lokal dan eksplorasi kopi Toraja.',
    imageUrl:
        '${_img}AB6AXuDBEP-2zt_adPsJgWUxFRT2tIoUdF7ilLXebkhvDh1da6DTCabD5tHo5G7Sv8uKIYULNba77bnU8laPVmbnB7g-qptL9BibCjInWfoLuEcJMPwYycr6dHrCI7vPk2MSF6DdTCpbFZI7rDPRMh3d8mgS9AoMgkHWEbYs7P0G9XfbyJlBxnaWjclUK2cOYRAVxPYZWGH2ZXfmSJyMurSTL9kgjGybTjL4gkt7Aj2XcEKI_onymk1HECzM',
  ),
  TourPackage(
    id: 'pkg-005',
    title: 'Pesona Danau Toba & Samosir Heritage',
    location: 'Sumatera Utara',
    duration: '3 Hari 2 Malam',
    rating: 4.7,
    price: 2100000,
    description:
        'Berlayar di danau vulkanik terbesar di dunia, kunjungi Tomok dan Pulau Samosir, '
        'tonton tari Sigale-gale, dan menginap di resort tepi danau.',
    imageUrl:
        '${_img}AB6AXuAZ2yiBya9NqOV2uheYI3Lk28TVhKTbIdor6PguIocYIPH4OK6VjDtdamV6DBa0PsGTC_NwjIwWVJ6n0apF0fJgcV6-qM8weDPPcCrGxx1Hid6pvVKpzWJ521TvYD9Bx3KLwSHqXPxqLCEELyOo8i-o_hXJw5HLdk3Ud1Ci5-IR4eILlYSycljkuQ-1UXlJbkzxdyx33ZNuZhkeLgMyRqt9izX-IOsZrLBbHT2pPKGZnKH-UtxljkUF',
  ),
];

const String appLogoUrl =
    '${_img}AB6AXuDpzDORhY5od7GyuqXtiP2OEk0pZUZ-5AJuhqMDam61gySsdQlz0WH5dSUH441dCWQ9SBDlgbOMAnx6ezJK9Mu7berSaO1YO9up6EMDDcCqH851roVUT9MC-2Oo96uqaRYQ1Eagujm8isGaNo5py2jOeOsfdCKdU18WMVIb5ZKmwiLDLcLF29qGvZOUdCeHeuWTaOsqRv3KRKRP5rXvci0wsM9npSRwW3mollHZQCaKVcCShMte0YMn';
