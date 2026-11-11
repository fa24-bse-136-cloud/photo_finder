import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3454F5)),
    scaffoldBackgroundColor: const Color(0xFFF4F5F8),
  ),
  home: const PhotoFinderApp(),
));

// These are sample groups for the front-end demo. No real photos are read.
class PhotoGroup {
  const PhotoGroup(this.name, this.count, this.space, this.type);

  final String name;
  final String count;
  final String space;
  final String type;
}

const groups = [
  PhotoGroup('IMG_2041.jpg', '3 photos', '9.6 MB', 'Exact match'),
  PhotoGroup('Screenshot_0612', '2 photos', '1.1 MB', 'Exact match'),
  PhotoGroup('IMG_1877.jpg', '4 photos', '12.4 MB', 'Similar'),
];

const folderPhotoCounts = {
  'Camera': 2341,
  'Screenshots': 812,
  'WhatsApp Images': 1204,
  'Downloads': 96,
  'Pictures': 148,
};

class PhotoFinderApp extends StatefulWidget {
  const PhotoFinderApp({super.key});

  @override
  State<PhotoFinderApp> createState() => _PhotoFinderAppState();
}

class _PhotoFinderAppState extends State<PhotoFinderApp> {
  final pages = ['Welcome', 'Photo access', 'Access off', 'Home', 'Folders', 'Scanning', 'Results', 'Review', 'Finished'];
  int page = 0;
  int reviewNumber = 0;
  double progress = 0;
  bool findSimilar = true;
  String sensitivity = 'Balanced';
  String resultFilter = 'All';
  final folders = <String>{'Camera', 'Screenshots', 'WhatsApp Images'};
  final selectedGroups = <int>{0, 1};
  Timer? scanTimer;

  @override
  void dispose() {
    scanTimer?.cancel();
    super.dispose();
  }

  void goTo(int nextPage) => setState(() => page = nextPage);

  void startScan() {
    if (folders.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose at least one folder first.')),
      );
      return;
    }
    setState(() {
      page = 5;
      progress = 0;
    });
    scanTimer?.cancel();
    scanTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        progress += 0.025;
        if (progress >= 1) {
          progress = 1;
          timer.cancel();
          page = 6;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: page == 0 || page == 1 || page == 2 || page == 8
          ? null
          : AppBar(
        title: Text(pages[page]),
        backgroundColor: const Color(0xFFF4F5F8),
        leading: page == 3 ? null : BackButton(onPressed: () => goTo(page == 6 ? 4 : page == 7 ? 6 : 3)),
      ),
      body: SafeArea(child: _buildPage()),
      bottomNavigationBar: page == 3
          ? NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) => goTo(index == 0 ? 3 : index == 1 ? 4 : 6),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Scan'),
          NavigationDestination(icon: Icon(Icons.history), label: 'History'),
        ],
      )
          : null,
    );
  }

  Widget _buildPage() {
    switch (page) {
      case 0: return _welcome();
      case 1: return _accessExplanation();
      case 2: return _accessOff();
      case 3: return _home();
      case 4: return _foldersPage();
      case 5: return _scanningPage();
      case 6: return _resultsPage();
      case 7: return _reviewPage();
      default: return _finishedPage();
    }
  }

  Widget _welcome() => _centered([
    const SizedBox(height: 35),
    _photoArt(big: true),
    const SizedBox(height: 28),
    const Text('Free up space,', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
    const Text('keep your best shots', textAlign: TextAlign.center,
        style: TextStyle(fontSize: 27, color: Color(0xFF3454F5), fontWeight: FontWeight.bold)),
    const SizedBox(height: 12),
    const Text('Find duplicate and similar photos,\nthen choose what you want to keep.', textAlign: TextAlign.center),
    const Spacer(),
    _button('Get started', () => goTo(1)),
    TextButton(onPressed: () => goTo(1), child: const Text('Skip intro')),
  ]);

  Widget _accessExplanation() => _centered([
    _photoArt(),
    const SizedBox(height: 24),
    const Text('Allow photo access', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
    const SizedBox(height: 8),
    const Text('Photo Finder needs photos to find duplicates.\nYour photos stay on your phone.', textAlign: TextAlign.center),
    const SizedBox(height: 24),
    const ListTile(leading: Icon(Icons.check_circle, color: Colors.green), title: Text('Read-only scan'), subtitle: Text('We only look at your photos.')),
    const ListTile(leading: Icon(Icons.check_circle, color: Colors.green), title: Text('Private on your device'), subtitle: Text('Nothing is uploaded.')),
    const ListTile(leading: Icon(Icons.check_circle, color: Colors.green), title: Text('You stay in control'), subtitle: Text('You choose what to keep.')),
    const Spacer(),
    _button('Continue', _askForMockPermission),
    TextButton(onPressed: () => goTo(2), child: const Text('Not now')),
  ]);

  Future<void> _askForMockPermission() async {
    final allow = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Allow photo access?'),
        content: const Text('Demo only: this shows where the system permission prompt would appear.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Deny')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Allow')),
        ],
      ),
    );
    goTo(allow == true ? 3 : 2);
  }

  Widget _accessOff() => _centered([
    const SizedBox(height: 20),
    _photoArt(crossed: true),
    const SizedBox(height: 18),
    const Text('Photo access is off', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
    const Text('Scanning needs photo access.', textAlign: TextAlign.center),
    const SizedBox(height: 24),
    const Card(child: Column(children: [
      ListTile(leading: CircleAvatar(child: Text('1')), title: Text('Open Settings')),
      ListTile(leading: CircleAvatar(child: Text('2')), title: Text('Tap Permissions > Photos')),
      ListTile(leading: CircleAvatar(child: Text('3')), title: Text('Choose Allow')),
    ])),
    const Spacer(),
    _button('Open Settings', () => _message('Settings are not connected in this demo.')),
    OutlinedButton(onPressed: () => goTo(3), child: const Text('Scan selected photos only')),
  ]);

  Widget _home() => ListView(padding: const EdgeInsets.all(18), children: [
    const Text('Photo Finder', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
    const SizedBox(height: 16),
    _blueCard(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('TOTAL SPACE FREED'),
      const Text('1.2 GB', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
      const Text('across 4 scans'),
      const SizedBox(height: 12),
      FilledButton.tonal(onPressed: () => goTo(4), child: const Text('Start new scan')),
    ])),
    const SizedBox(height: 18),
    const Card(child: ListTile(leading: CircleAvatar(child: Text('12')), title: Text('Unfinished review'), subtitle: Text('12 groups  |  174 MB to free'), trailing: Text('Resume'))),
    const SizedBox(height: 28),
    const Text('Recent scans', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    const Card(child: ListTile(leading: Icon(Icons.photo_library), title: Text('Sep 28, 2026'), subtitle: Text('Camera, Screenshots'), trailing: Text('312 MB'))),
    const Card(child: ListTile(leading: Icon(Icons.photo_library), title: Text('Sep 14, 2026'), subtitle: Text('Camera'), trailing: Text('204 MB'))),
  ]);

  Widget _foldersPage() => ListView(padding: const EdgeInsets.all(16), children: [
    const Text('Choose folders to scan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    for (final folder in folderPhotoCounts.keys)
      Card(child: CheckboxListTile(
        value: folders.contains(folder),
        title: Text(folder),
        subtitle: Text('${folderPhotoCounts[folder]} sample photos'),
        onChanged: (checked) => setState(() => checked == true ? folders.add(folder) : folders.remove(folder)),
      )),
    SwitchListTile(title: const Text('Find similar photos'), value: findSimilar, onChanged: (value) => setState(() => findSimilar = value)),
    const Text('Sensitivity'),
    SegmentedButton<String>(
      segments: const [ButtonSegment(value: 'Strict', label: Text('Strict')), ButtonSegment(value: 'Balanced', label: Text('Balanced')), ButtonSegment(value: 'Loose', label: Text('Loose'))],
      selected: {sensitivity},
      onSelectionChanged: (value) => setState(() => sensitivity = value.first),
    ),
    const SizedBox(height: 18),
    _button('Start scan', startScan),
  ]);

  Widget _scanningPage() => _centered([
    const Text('Scanning your photos', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
    const SizedBox(height: 28),
    SizedBox(width: 150, height: 150, child: CircularProgressIndicator(value: progress, strokeWidth: 14)),
    const SizedBox(height: 16),
    Text('${(progress * 100).round()}% complete', style: const TextStyle(fontSize: 20)),
    const Text('Comparing sample photos...'),
    const SizedBox(height: 28),
    const Card(child: Column(children: [ListTile(leading: Icon(Icons.check_circle, color: Colors.green), title: Text('Reading files')), ListTile(leading: Icon(Icons.sync), title: Text('Comparing photo groups')), ListTile(leading: Icon(Icons.search), title: Text('Finding similar photos'))])),
    const Spacer(),
    OutlinedButton(onPressed: () { scanTimer?.cancel(); goTo(4); }, child: const Text('Cancel scan')),
    const Text('Demo scan only. Nothing is uploaded.', textAlign: TextAlign.center),
  ]);

  Widget _resultsPage() => Column(children: [
    _blueCard(const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('486 MB\ncan be freed'), Text('37 groups\n112 duplicates\n4,357 scanned') ])),
    Padding(padding: const EdgeInsets.all(8), child: Text('${selectedGroups.length} groups selected')),
    Wrap(spacing: 8, children: [
      for (final filter in ['All', 'Exact', 'Similar'])
        FilterChip(label: Text(filter), selected: resultFilter == filter, onSelected: (_) => setState(() => resultFilter = filter)),
    ]),
    Expanded(child: ListView.builder(
      itemCount: groups.where((group) => resultFilter == 'All' || group.type.startsWith(resultFilter)).length,
      itemBuilder: (context, index) {
        final visibleGroups = groups.where((group) => resultFilter == 'All' || group.type.startsWith(resultFilter)).toList();
        final group = visibleGroups[index];
        final groupIndex = groups.indexOf(group);
        return Card(child: CheckboxListTile(
          value: selectedGroups.contains(groupIndex),
          title: Text(group.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('${group.type}  |  ${group.count}'),
          secondary: const Icon(Icons.photo, size: 38, color: Color(0xFF3454F5)),
          onChanged: (checked) => setState(() => checked == true ? selectedGroups.add(groupIndex) : selectedGroups.remove(groupIndex)),
          controlAffinity: ListTileControlAffinity.leading,
        ));
      },
    )),
    Padding(padding: const EdgeInsets.all(12), child: Row(children: [
      Expanded(child: OutlinedButton(onPressed: _openReview, child: const Text('Review a group'))),
      const SizedBox(width: 10),
      Expanded(child: FilledButton(onPressed: selectedGroups.isEmpty ? null : _confirmCleanup, child: const Text('Delete selected'))),
    ])),
  ]);

  Widget _reviewPage() {
    final group = groups[reviewNumber % groups.length];
    return _centered([
      Text('Group ${reviewNumber + 1} of ${groups.length}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const SizedBox(height: 22),
      Row(children: [
        _photoCard('Keep', Colors.green),
        const SizedBox(width: 12),
        _photoCard('Possible copy', Colors.red),
      ]),
      const SizedBox(height: 12),
      Text(group.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      Text('${group.space}  |  ${group.type}'),
      const SizedBox(height: 16),
      const Text('Look at both photos before choosing. This is a preview; no files will be deleted.', textAlign: TextAlign.center),
      const Spacer(),
      Row(children: [
        Expanded(child: OutlinedButton(onPressed: () => _message('Keeping both photos.'), child: const Text('Keep both'))),
        const SizedBox(width: 8),
        Expanded(child: OutlinedButton(onPressed: _nextGroup, child: const Text('Keep this'))),
        const SizedBox(width: 8),
        Expanded(child: FilledButton(onPressed: _nextGroup, child: const Text('Delete this'))),
      ]),
      TextButton(onPressed: _nextGroup, child: const Text('Next group')),
      TextButton(onPressed: () => goTo(6), child: const Text('Back to results')),
    ]);
  }

  Widget _finishedPage() => _centered([
    const CircleAvatar(radius: 42, backgroundColor: Color(0xFFC9F5DB), child: Icon(Icons.check, size: 50, color: Colors.green)),
    const SizedBox(height: 20),
    const Text('312 MB freed', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
    const Text('48 duplicate photos removed'),
    const SizedBox(height: 22),
    const Card(child: Column(children: [ListTile(title: Text('Groups cleaned'), trailing: Text('37')), Divider(), ListTile(title: Text('Photos deleted'), trailing: Text('48')), Divider(), ListTile(title: Text('Photos kept'), trailing: Text('37')), Divider(), ListTile(title: Text('Space freed'), trailing: Text('312 MB'))])),
    const Spacer(),
    _button('View scan history', () => goTo(3)),
    TextButton(onPressed: () => goTo(3), child: const Text('Done')),
    const Text('Sample result. No files were changed.', textAlign: TextAlign.center),
  ]);

  Future<void> _confirmCleanup() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Finish demo cleanup?'),
        content: const Text('This only shows the completion screen. It will not delete files.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Go back')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Continue')),
        ],
      ),
    );
    if (confirm == true) goTo(8);
  }

  void _openReview() => setState(() {
    reviewNumber = 0;
    page = 7;
  });

  void _nextGroup() => setState(() => reviewNumber = (reviewNumber + 1) % groups.length);

  Widget _photoCard(String label, Color color) => Expanded(child: Card(
    child: Padding(padding: const EdgeInsets.all(12), child: Column(children: [
      Icon(Icons.image, size: 90, color: color),
      Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      const Text('Jun 12, Camera', style: TextStyle(fontSize: 11)),
    ])),
  ));

  Widget _photoArt({bool big = false, bool crossed = false}) => CircleAvatar(
    radius: big ? 105 : 62,
    backgroundColor: crossed ? const Color(0xFFFFD2EB) : const Color(0xFFCDD5FF),
    child: Icon(crossed ? Icons.image_not_supported : Icons.photo_library, size: big ? 80 : 52, color: const Color(0xFF3454F5)),
  );

  Widget _centered(List<Widget> children) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: children),
  );

  Widget _button(String label, VoidCallback action) => SizedBox(
    width: double.infinity,
    child: FilledButton(onPressed: action, child: Padding(padding: const EdgeInsets.all(12), child: Text(label))),
  );

  Widget _blueCard(Widget child) => Card(
    color: const Color(0xFF3454F5),
    child: Padding(padding: const EdgeInsets.all(20), child: DefaultTextStyle(style: const TextStyle(color: Colors.white), child: child)),
  );

  void _message(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}