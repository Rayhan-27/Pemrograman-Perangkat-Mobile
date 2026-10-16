class Book {
  final int id;
  final String title;
  final String author;
  final int price;
  final String imageUrl;

  // Tambahan untuk kebutuhan tampilan desain baru
  final String category; // dipakai untuk filter chip
  final String badge; // label kecil di atas judul
  final bool badgeHighlight; // true = warna terracotta, false = abu
  final String genre;
  final String cartLabel; // label kecil di halaman keranjang
  final double rating;
  final String reviews;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.badge,
    required this.genre,
    required this.cartLabel,
    required this.rating,
    required this.reviews,
    this.badgeHighlight = false,
  });
}

const _coverLaskarPelangi =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBy6249yUSISoCiDoBbjq8yAOqM2Tijo8XAvtpYxoSMvIxJ4obrLkqY0sHoxsic60QePWOxrG_CqrhD4qdZN2D_yiv6SiH3NM-pLg8e9HNau5qgWWCWj96F3Aa-aOpcnSzMgD5Rny7T7j6Xk1Z-f4LXYbcFoHs3TvbMoYv9CDhyv1Dg8P2lKChljDdNQNCV-MO5XICqqdXu9RcTR3nOJP6oDYKq6LKOdDHUAsbDcy1M87vY_-vgEdO7-A';
const _coverBumiManusia =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAVn95Y_jby0fUC8OtO1jOgPpRxJGojMidIN687R5NpY5N0uljkmugMZfA5O9tYv7xoe30RzVRyyaKnLEnKPqLekZc-aGNQvVz_AjrxvumC1cwb932VEPMvy-3qkJCF4-5s3ZelUJ1nwCvc1Y_g_BJvxjW0QGOnqXjdWunBaUMGsXbcbXb5XIE3sLVwfDe4i4BMHdjOc6RhiB77z1VKOAUgb4-EDVrOZSI8FIE5GObkYuqyWQxoRigAQA';
const _coverFilosofiTeras =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuD3vBmoJrzH9eAg3eqOPX2QpmfL_Ppd8ca_U4YzRBAtCONyBwBqfIKUI2Dc4Ad4bNJeUHoKR4bWhDgizcpECp_jNo1M3T04qxkp3ijZeCH3puu_J4MOSoHl-FWqnVgwYOJIn78JxvVITHLdOg_T4gLwcZQev8IH8I6Bn8vBB0DaullC93MGIXkTlSQGuzvlOJ5xNWuctXTvQprjhgi7UwtAgErSjBMb75IySGyXSOdVPpBxs-PR1W7CmQ';
const _coverAtomicHabits =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBpRXNC2WIKjuLrTmVayMQV4mREi_LEDJpBYe6RKh6FdAWglo77ItkMVT-N9qaaAVqZU9dX1WM5ebAmn_VUGsanjLr8-jXEt6CKvXknDAA1OtCrLOy5sYOEGzG3l_IOhSorBwtAEAFS6wfDe1XnLSb8wPIibZvx_UnOrvKjXPVARfig4tenrLUswKcB4JxXhtFLems5rAlx33ZffF-PyWm6sE8xdIKW9PjuOkepw5vg8c__0JWcW-azaw';
const _coverDilan =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAUEcEmhxNBluCPIUtziniQcNFhluQeBWJDGEzBeMJCt3rOOuD9Lh-yYsq6sFUq43boVfds2va0dYOTr-1aK-JKvosaVYvPWtuqXJ41xZ90M0DvTRlsDuM-Bemo0No2F7ID59V4oYwF2u9pBFBwRUu4KVyFYPGcq_yCyy8sIUCADnfICaqQJ6JeF-4hBJ-KRIzx-YwjD2APXOZ2trVN1K_7AQ3TN3tpNuAy5wpCsorZOhttazjfTfNO3w';

// Data dummy untuk katalog (5 buku)
const List<Book> dummyBooks = [
  Book(
    id: 1,
    title: 'Laskar Pelangi',
    author: 'Andrea Hirata',
    price: 85000,
    imageUrl: _coverLaskarPelangi,
    category: 'Sastra Indonesia',
    badge: 'Best Seller',
    badgeHighlight: true,
    genre: 'Fiksi Sastra',
    cartLabel: 'Klasik Indonesia',
    rating: 4.9,
    reviews: '1.4k ulasan',
  ),
  Book(
    id: 2,
    title: 'Bumi Manusia',
    author: 'Pramoedya Ananta Toer',
    price: 120000,
    imageUrl: _coverBumiManusia,
    category: 'Sastra Indonesia',
    badge: 'Karya Klasik',
    badgeHighlight: true,
    genre: 'Sejarah Fiksi',
    cartLabel: 'Tetralogi Buru',
    rating: 5.0,
    reviews: '2.8k ulasan',
  ),
  Book(
    id: 3,
    title: 'Filosofi Teras',
    author: 'Henry Manampiring',
    price: 98000,
    imageUrl: _coverFilosofiTeras,
    category: 'Self Improvement',
    badge: 'Stoikisme',
    genre: 'Self Improvement',
    cartLabel: 'Stoikisme',
    rating: 4.8,
    reviews: '980 ulasan',
  ),
  Book(
    id: 4,
    title: 'Atomic Habits',
    author: 'James Clear',
    price: 110000,
    imageUrl: _coverAtomicHabits,
    category: 'Self Improvement',
    badge: 'Terjemahan Resmi',
    genre: 'Produktivitas',
    cartLabel: 'Terjemahan Resmi',
    rating: 4.9,
    reviews: '3.1k ulasan',
  ),
  Book(
    id: 5,
    title: 'Dilan 1990',
    author: 'Pidi Baiq',
    price: 79000,
    imageUrl: _coverDilan,
    category: 'Novel Populer',
    badge: 'Populer',
    badgeHighlight: true,
    genre: 'Romansa Remaja',
    cartLabel: 'Novel Populer',
    rating: 4.7,
    reviews: '1.8k ulasan',
  ),
];

// Mengubah 85000 menjadi "Rp 85.000"
String formatRupiah(int amount) {
  final text = amount.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+$)'),
        (m) => '${m[1]}.',
      );
  return 'Rp $text';
}
