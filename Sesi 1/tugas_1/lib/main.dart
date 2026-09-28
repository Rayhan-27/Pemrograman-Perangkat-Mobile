import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PPM Sesi 1',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const CounterPage(),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;

  bool get _isEven => _counter % 2 == 0;

  void _increment() => setState(() => _counter++);

  void _decrement() {
    if (_counter == 0) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Counter tidak boleh di bawah 0!')),
      );
      return;
    }
    setState(() => _counter--);
  }

  void _reset() => setState(() => _counter = 0);

  @override
  Widget build(BuildContext context) {
    final numberColor = _isEven ? Colors.blue : Colors.deepOrange;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PPM Sesi 1 - Rayhan Sandika Ardaffa (20240040187)'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Kartu identitas
            const Card(
              elevation: 3,
              child: ListTile(
                leading: CircleAvatar(child: Icon(Icons.person)),
                title: Text('Rayhan Sandika Ardaffa'),
                subtitle: Text('NIM: 20240040187\nProdi: Teknik Informatika / Kelas: G'),
                isThreeLine: true,
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$_counter',
                      style: TextStyle(
                        fontSize: 96,
                        fontWeight: FontWeight.bold,
                        color: numberColor,
                      ),
                    ),
                    Text(
                      _isEven ? 'Angka Genap' : 'Angka Ganjil',
                      style: TextStyle(fontSize: 22, color: numberColor),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton.icon(
                  onPressed: _decrement,
                  icon: const Icon(Icons.remove),
                  label: const Text('Kurang'),
                ),
                OutlinedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                ),
                FilledButton.icon(
                  onPressed: _increment,
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah'),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
