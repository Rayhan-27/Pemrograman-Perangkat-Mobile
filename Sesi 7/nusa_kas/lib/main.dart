import 'package:flutter/material.dart';

import 'ui/core/app_theme.dart';
import 'ui/kas/home_screen.dart';
import 'ui/kas/kas_view_model.dart';

void main() => runApp(const NusaKasApp());

class NusaKasApp extends StatefulWidget {
  const NusaKasApp({super.key, this.viewModel});

  final KasViewModel? viewModel;

  @override
  State<NusaKasApp> createState() => _NusaKasAppState();
}

class _NusaKasAppState extends State<NusaKasApp> {
  late final KasViewModel _viewModel = widget.viewModel ?? KasViewModel();

  @override
  void dispose() {
    if (widget.viewModel == null) _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NusaKas',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: HomeScreen(viewModel: _viewModel),
    );
  }
}
