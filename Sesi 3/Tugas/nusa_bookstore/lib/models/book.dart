class Book { // cetakan yang nyimpen informasi satu buku. Isinya persis lima properti: id, title, author, price, imageUrl
  final int id; // final = nilainya nggak bisa diubah setelah objek dibuat
  final String title;
  final String author;
  final int price; // Harga rupiah nggak butuh desimal, dan integer lebih aman buat hitung total nanti
  final String imageUrl;

  const Book({ // constructor konstan, jadi Flutter bisa lebih hemat memori. Constructor-nya pakai required supaya semua data wajib diisi
    required this.id,
    required this.title,
    required this.author,
    required this.price,
    required this.imageUrl,
  });
}

// Data dummy untuk katalog (minimal 4 buku)
const List<Book> dummyBooks = [
  Book(
    id: 1,
    title: 'Laskar Pelangi',
    author: 'Andrea Hirata',
    price: 85000,
    imageUrl: '', // ImageUrl di kosongkan terlebih dahulu, nanti bisa diisi dengan URL gambar buku yang sesuai atau pakai icons bawaan Flutter
  ),
  Book(
    id: 2,
    title: 'Bumi Manusia',
    author: 'Pramoedya Ananta Toer',
    price: 120000,
    imageUrl: '',
  ),
  Book(
    id: 3,
    title: 'Filosofi Teras',
    author: 'Henry Manampiring',
    price: 98000,
    imageUrl: '',
  ),
  Book(
    id: 4,
    title: 'Atomic Habits',
    author: 'James Clear',
    price: 110000,
    imageUrl: '',
  ),
  Book(
    id: 5,
    title: 'Dilan 1990',
    author: 'Pidi Baiq',
    price: 79000,
    imageUrl: '',
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