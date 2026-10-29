class EventItem {
  final String id;
  final String title;
  final String trackCategory; // 'AI', 'Mobile', 'IoT', 'Cybersecurity'
  final String date;
  final String time;
  final String venueRoom;
  final String speakerName;
  final String speakerRole;
  final String speakerAvatarUrl;
  final int totalSeats;
  final int remainingSeats;
  final double ticketPrice;
  final bool isFree;
  final String level; // 'Beginner', 'Intermediate', 'Advanced'

  const EventItem({
    required this.id,
    required this.title,
    required this.trackCategory,
    required this.date,
    required this.time,
    required this.venueRoom,
    required this.speakerName,
    required this.speakerRole,
    required this.speakerAvatarUrl,
    required this.totalSeats,
    required this.remainingSeats,
    required this.ticketPrice,
    required this.isFree,
    required this.level,
  });
}

/// Format angka ke Rupiah, contoh: 150000 -> "Rp 150.000"
String formatRupiah(num value) {
  final s = value.round().toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return 'Rp $buf';
}
