import 'package:flutter/material.dart';
import 'data/sample_events.dart';
import 'models/event_item.dart';
import 'models/registration_ticket.dart';
import 'screens/event_registration_screen.dart';
import 'screens/gallery_venue_screen.dart';
import 'screens/home_events_screen.dart';
import 'screens/registered_tickets_screen.dart';

void main() => runApp(const NusaEventApp());

class NusaEventApp extends StatelessWidget {
  const NusaEventApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF1E3A8A),
      primary: const Color(0xFF1E3A8A),
      secondary: const Color(0xFF3B82F6),
      surface: const Color(0xFFFAF8FF),
    );

    return MaterialApp(
      title: 'NusaEvent Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: const Color(0xFFFAF8FF),
        // fontFamily: 'PlusJakartaSans', // aktifkan jika font sudah ditambahkan di pubspec
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFAF8FF),
          surfaceTintColor: Colors.transparent,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  final List<RegistrationTicket> _tickets = buildSampleTickets();

  Future<void> _openRegistration(EventItem event) async {
    final ticket = await Navigator.push<RegistrationTicket>(
      context,
      MaterialPageRoute(
        builder: (_) => EventRegistrationScreen(event: event),
      ),
    );
    if (ticket == null || !mounted) return;

    setState(() => _tickets.insert(0, ticket));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Pendaftaran berhasil! Tiket ${ticket.ticketCode} terbit.'),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'LIHAT',
            onPressed: () => setState(() => _index = 2),
          ),
        ),
      );
  }

  void _cancelTicket(RegistrationTicket t) {
    setState(() {
      final i = _tickets.indexWhere((x) => x.ticketCode == t.ticketCode);
      if (i != -1) _tickets[i] = _tickets[i].copyWith(status: 'Cancelled');
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeCount = _tickets.where((t) => t.status == 'Active').length;

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomeEventsScreen(onRegister: _openRegistration),
          GalleryVenueScreen(onRegister: _openRegistration),
          RegisteredTicketsScreen(tickets: _tickets, onCancel: _cancelTicket),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          const NavigationDestination(
              icon: Icon(Icons.event_outlined),
              selectedIcon: Icon(Icons.event),
              label: 'Seminar'),
          const NavigationDestination(
              icon: Icon(Icons.map_outlined),
              selectedIcon: Icon(Icons.map),
              label: 'Galeri & Denah'),
          NavigationDestination(
              icon: Badge(
                  isLabelVisible: activeCount > 0,
                  label: Text('$activeCount'),
                  child: const Icon(Icons.confirmation_number_outlined)),
              selectedIcon: const Icon(Icons.confirmation_number),
              label: 'Tiket'),
        ],
      ),
    );
  }
}
