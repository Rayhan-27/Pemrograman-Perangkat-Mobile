class RegistrationTicket {
  final String ticketCode; // e.g. "TKT-NUSA-2026-0891"
  final String eventId;
  final String eventTitle;
  final String eventTrack;
  final String attendeeName;
  final String attendeeNim;
  final String attendeeEmail;
  final String attendeeWhatsapp;
  final String participantType; // 'Mahasiswa', 'Dosen/Peneliti', 'Profesional'
  final String sessionSchedule; // 'Pagi' atau 'Siang'
  final DateTime attendanceDate;
  final String kitPackage; // 'Basic Digital' atau 'Premium Swag'
  final double donationAmount;
  final double totalPayment;
  final String seatNumber; // e.g. "Row C • Seat 14"
  final String qrCodeData;
  final String status; // 'Active', 'Completed', 'Cancelled'
  final DateTime registrationDate;

  const RegistrationTicket({
    required this.ticketCode,
    required this.eventId,
    required this.eventTitle,
    required this.eventTrack,
    required this.attendeeName,
    required this.attendeeNim,
    required this.attendeeEmail,
    required this.attendeeWhatsapp,
    required this.participantType,
    required this.sessionSchedule,
    required this.attendanceDate,
    required this.kitPackage,
    required this.donationAmount,
    required this.totalPayment,
    required this.seatNumber,
    required this.qrCodeData,
    required this.status,
    required this.registrationDate,
  });

  RegistrationTicket copyWith({String? status}) => RegistrationTicket(
        ticketCode: ticketCode,
        eventId: eventId,
        eventTitle: eventTitle,
        eventTrack: eventTrack,
        attendeeName: attendeeName,
        attendeeNim: attendeeNim,
        attendeeEmail: attendeeEmail,
        attendeeWhatsapp: attendeeWhatsapp,
        participantType: participantType,
        sessionSchedule: sessionSchedule,
        attendanceDate: attendanceDate,
        kitPackage: kitPackage,
        donationAmount: donationAmount,
        totalPayment: totalPayment,
        seatNumber: seatNumber,
        qrCodeData: qrCodeData,
        status: status ?? this.status,
        registrationDate: registrationDate,
      );
}
