import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'dart:js' as js;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _urlController = TextEditingController();
  String? imageUrl;
  bool isMenuOpen = false;

  void _toggleFullScreen() {
    js.context.callMethod('eval', [
      "if (document.fullscreenElement) { document.exitFullscreen(); } else { document.documentElement.requestFullscreen(); }"
    ]);
    setState(() {
      isMenuOpen = false;
    });
  }

  void _toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Image Display with Fullscreen')),
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _urlController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Image URL',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        imageUrl = _urlController.text;
                      });
                    },
                    child: const Text('Display Image'),
                  ),
                  if (imageUrl != null && imageUrl!.isNotEmpty)
                    GestureDetector(
                      onDoubleTap: _toggleFullScreen,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.network(
                          imageUrl!,
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (isMenuOpen) ...[
              GestureDetector(
                onTap: _toggleMenu,
                child: Container(
                  color: Colors.black54,
                ),
              ),
              Positioned(
                bottom: 80,
                right: 20,
                child: Column(
                  children: [
                    FloatingActionButton(
                      onPressed: _toggleFullScreen,
                      child: const Icon(Icons.fullscreen),
                    ),
                    const SizedBox(height: 10),
                    FloatingActionButton(
                      onPressed: _toggleFullScreen,
                      child: const Icon(Icons.fullscreen_exit),
                    ),
                  ],
                ),
              ),
            ],
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: _toggleMenu,
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
