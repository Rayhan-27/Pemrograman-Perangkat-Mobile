import 'package:flutter/material.dart';

class FilterOptions {
  final Set<String> levels;
  final bool freeOnly;
  const FilterOptions({this.levels = const {}, this.freeOnly = false});

  bool get isActive => levels.isNotEmpty || freeOnly;
}

Future<FilterOptions?> showFilterBottomSheet(
    BuildContext context, FilterOptions current) {
  return showModalBottomSheet<FilterOptions>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _FilterSheet(initial: current),
  );
}

class _FilterSheet extends StatefulWidget {
  final FilterOptions initial;
  const _FilterSheet({required this.initial});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late Set<String> _levels;
  late bool _freeOnly;

  @override
  void initState() {
    super.initState();
    _levels = {...widget.initial.levels};
    _freeOnly = widget.initial.freeOnly;
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
            20, 0, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter Seminar',
                style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            Text('Level', style: tt.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['Beginner', 'Intermediate', 'Advanced'].map((l) {
                return FilterChip(
                  label: Text(l),
                  selected: _levels.contains(l),
                  onSelected: (v) =>
                      setState(() => v ? _levels.add(l) : _levels.remove(l)),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Hanya event gratis'),
              value: _freeOnly,
              onChanged: (v) => setState(() => _freeOnly = v),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        Navigator.pop(context, const FilterOptions()), // reset
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context,
                        FilterOptions(levels: _levels, freeOnly: _freeOnly)),
                    child: const Text('Terapkan'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
