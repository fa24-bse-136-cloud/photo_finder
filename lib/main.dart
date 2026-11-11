import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3454F5),
        ),
      ),
      home: const ScreensDemo(),
    );
  }
}

class ScreensDemo extends StatefulWidget {
  const ScreensDemo({super.key});

  @override
  State<ScreensDemo> createState() => _ScreensDemoState();
}

class _ScreensDemoState extends State<ScreensDemo> {
  int currentScreen = 0;

  void goToScreen(int screen) {
    setState(() {
      currentScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (currentScreen) {
      case 0:
        return _photoAccessScreen();
      case 1:
        return _accessOffScreen();
      default:
        return _finishedScreen();
    }
  }

  Widget _photoAccessScreen() {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 62,
                backgroundColor: Color(0xFFCDD5FF),
                child: Icon(
                  Icons.photo_library,
                  size: 52,
                  color: Color(0xFF3454F5),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Allow photo access',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Photo Finder needs photos to find duplicates.\n'
                    'Your photos stay on your phone.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green),
                title: Text('Read-only scan'),
                subtitle: Text('We only look at your photos.'),
              ),
              const ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green),
                title: Text('Private on your device'),
                subtitle: Text('Nothing is uploaded.'),
              ),
              const ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green),
                title: Text('You stay in control'),
                subtitle: Text('You choose what to keep.'),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => goToScreen(1),
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('Continue'),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => goToScreen(1),
                child: const Text('Not now'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _accessOffScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo access'),
        leading: BackButton(onPressed: () => goToScreen(0)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 62,
                backgroundColor: Color(0xFFFFD2EB),
                child: Icon(
                  Icons.image_not_supported,
                  size: 52,
                  color: Color(0xFF3454F5),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Photo access is off',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Scanning needs photo access.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(child: Text('1')),
                      title: Text('Open Settings'),
                    ),
                    ListTile(
                      leading: CircleAvatar(child: Text('2')),
                      title: Text('Tap Permissions > Photos'),
                    ),
                    ListTile(
                      leading: CircleAvatar(child: Text('3')),
                      title: Text('Choose Allow'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Settings are not connected in this demo.'),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('Open Settings'),
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: () => goToScreen(2),
                child: const Text('Scan selected photos only'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _finishedScreen() {
    return Scaffold(
      appBar: AppBar(title: const Text('Finished')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 42,
                backgroundColor: Color(0xFFC9F5DB),
                child: Icon(Icons.check, size: 50, color: Colors.green),
              ),
              const SizedBox(height: 20),
              const Text(
                '312 MB freed',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const Text('48 duplicate photos removed'),
              const SizedBox(height: 22),
              const Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Text('Groups cleaned'),
                      trailing: Text('37'),
                    ),
                    Divider(),
                    ListTile(
                      title: Text('Photos deleted'),
                      trailing: Text('48'),
                    ),
                    Divider(),
                    ListTile(
                      title: Text('Photos kept'),
                      trailing: Text('37'),
                    ),
                    Divider(),
                    ListTile(
                      title: Text('Space freed'),
                      trailing: Text('312 MB'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => goToScreen(0),
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('View scan history'),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => goToScreen(0),
                child: const Text('Done'),
              ),
              const Text(
                'Sample result. No files were changed.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}