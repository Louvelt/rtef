import 'package:flutter/material.dart';
import 'dart:math';
import 'package:radio_player/radio_player.dart';
import 'audio.dart';
import 'home_page.dart';
import 'tv_station_page.dart';

class RadioPlayerPage extends StatefulWidget {
  const RadioPlayerPage({super.key});

  @override
  _RadioPlayerPageState createState() => _RadioPlayerPageState();
}

class _RadioPlayerPageState extends State<RadioPlayerPage>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  // Use the singleton AudioPlayerHelper
  final AudioPlayerHelper audioHelper = AudioPlayerHelper();
  String coverImageUrl = 'assets/images/logo2.png';
  bool isPlaying = false;
  String currentTitle = '';
  String currentArtist = 'Radio Evangelique Florida';

  // Animation controller for waveform
  late AnimationController _animationController;
  final List<double> _barHeights = [];
  final int _barsCount = 35;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Generate initial bar heights
    _generateBarHeights();

    // Set up animation listener to regenerate bar heights on each tick
    _animationController.addListener(() {
      if (isPlaying) {
        setState(() {
          _generateBarHeights();
        });
      }
    });

    // Make the animation repeat indefinitely when playing
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
        _animationController.forward();
      }
    });

    // Listen to metadata from the singleton radio player
    audioHelper.metadataStream.listen((metadata) {
      if (metadata.artworkUrl != null && metadata.artworkUrl!.isNotEmpty) {
        coverImageUrl = metadata.artworkUrl!;
        setState(() {});
      }

      // Try to extract title and artist from metadata
      if (metadata.title != null) {
        currentTitle = metadata.title!;
        setState(() {});
      }
      if (metadata.artist != null) {
        currentArtist = metadata.artist!;
        setState(() {});
      }
    });

    _autoPlayIfNeeded();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncUIWithAudioState();
  }

  void _syncUIWithAudioState() {
    if (audioHelper.isPlaying) {
      setState(() {
        isPlaying = true;
      });
      _generateBarHeights();
      _animationController.reset();
      _animationController.forward();
    } else {
      setState(() {
        isPlaying = false;
      });
      _animationController.stop();
      _generateBarHeights();
    }
  }

  // Generate random bar heights for the waveform
  void _generateBarHeights() {
    _barHeights.clear();
    final random = Random();
    for (int i = 0; i < _barsCount; i++) {
      double height;
      if (isPlaying) {
        // When playing, create more dynamic heights
        height = 0.1 + random.nextDouble() * 0.7;

        // Add some patterns to make it look more natural
        if (i > 0 && i < _barsCount - 1) {
          double prevHeight = _barHeights[i - 1];
          height = (height + prevHeight) / 2 + random.nextDouble() * 0.3;
        }
      } else {
        // When paused, create a subtle static pattern
        height = 0.1;
        if (i % 5 == 0) {
          height = 0.3;
        }
      }
      _barHeights.add(height);
    }
  }

  Future<void> _autoPlayIfNeeded() async {
    if (!audioHelper.isPlaying) {
      await audioHelper.play(
        url:
            'https://attractionstream.com/hls/radio_tele_evangelique_florida_2/live.m3u8',
        title: 'Radio Evangelique Florida',
        imagePath: 'assets/images/logo2.png',
      );
      setState(() {
        isPlaying = true;
      });
      _generateBarHeights();
      _animationController.reset();
      _animationController.forward();
    } else {
      setState(() {
        isPlaying = true;
      });
      _generateBarHeights();
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Radio Evangelique Florida",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [Color(0xFF181A20), Color(0xFF23243A)]
                : [
                    Colors.indigo.shade900,
                    Colors.indigo.shade800,
                    Colors.indigo.shade700
                  ],
          ),
        ),
        child: Column(
          children: [
            // Waveform visualization (animated)
            Container(
              height: 100,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: WaveformPainter(
                      isPlaying: isPlaying,
                      barHeights: _barHeights,
                      color: isDark
                          ? Colors.white70
                          : Colors.white.withOpacity(0.5),
                    ),
                    child: Container(),
                  );
                },
              ),
            ),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Album artwork with shadow
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.black.withOpacity(0.7)
                              : Colors.black.withOpacity(0.3),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(150),
                      child: Container(
                        width: 230,
                        height: 230,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: isDark
                                  ? Colors.white24
                                  : Colors.white.withOpacity(0.5),
                              width: 4),
                        ),
                        child: ClipOval(
                          child: _buildCoverImage(coverImageUrl),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Track info
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      children: [
                        Text(
                          currentTitle,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentArtist,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 18,
                                  ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Playback controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Previous button (disabled but for UI consistency)
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white10
                              : Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.skip_previous,
                          color: isDark
                              ? Colors.white24
                              : Colors.white.withOpacity(0.3),
                          size: 35,
                        ),
                      ),

                      const SizedBox(width: 24),

                      // Play/Pause button
                      GestureDetector(
                        onTap: () async {
                          if (isPlaying) {
                            await audioHelper.pause();
                            setState(() {
                              isPlaying = false;
                            });
                          } else {
                            print('[RadioPlayerPage] Play button tapped');
                            await audioHelper.play(
                              url:
                                  'https://attractionstream.com/hls/radio_tele_evangelique_florida_2/live.m3u8',
                              title: 'RTEF Live 24/7',
                              imagePath: 'assets/images/logo2.png',
                            );
                            setState(() {
                              isPlaying = true;
                            });
                            _generateBarHeights();
                            _animationController.reset();
                            _animationController.forward();
                          }
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white24 : Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: isDark
                                    ? Colors.black54
                                    : Colors.indigo.withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            color: isDark ? Colors.amber : Colors.indigo,
                            size: 45,
                          ),
                        ),
                      ),

                      const SizedBox(width: 24),

                      // Next button (disabled but for UI consistency)
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white10
                              : Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.skip_next,
                          color: isDark
                              ? Colors.white24
                              : Colors.white.withOpacity(0.3),
                          size: 35,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Live indicator and message
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: isPlaying
                          ? Colors.red
                          : (isDark ? Colors.white24 : Colors.grey),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isPlaying
                        ? 'LIVE - Radyo kap preche pawòl retou Jezi kri a 24/7'
                        : 'Offline - Tap play to start listening',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.indigo.shade800,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.7),
          selectedFontSize: 12,
          unselectedFontSize: 11,
          iconSize: 24,
          elevation: 0,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 26),
              activeIcon: Icon(Icons.home, size: 28, color: Colors.white),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.radio, size: 26),
              activeIcon: Icon(Icons.radio, size: 28, color: Colors.white),
              label: "Radio",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.tv, size: 26),
              activeIcon: Icon(Icons.tv, size: 28, color: Colors.white),
              label: "TV",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu, size: 26),
              activeIcon: Icon(Icons.menu, size: 28, color: Colors.white),
              label: "Menu",
            ),
          ],
          currentIndex: 1, // Radio is selected
          onTap: (index) {
            // Handle navigation to different pages
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            } else if (index == 2) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => TVStationPage()),
              );
            } else if (index == 3) {
              // Menu button - open drawer (if we add drawer to this page)
              // For now, navigate to home page which has the drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            }
            // Do nothing for index == 1 (Radio) since we're already here
          },
        ),
      ),
    );
  }
}

// Custom waveform visualization
class WaveformPainter extends CustomPainter {
  final bool isPlaying;
  final List<double> barHeights;
  final Color color;

  WaveformPainter(
      {required this.isPlaying, required this.barHeights, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final int bars = barHeights.length;
    final barWidth = size.width / bars;

    for (int i = 0; i < bars && i < barHeights.length; i++) {
      final x = i * barWidth + barWidth / 2;
      final y1 = size.height / 2 - barHeights[i] * size.height / 2;
      final y2 = size.height / 2 + barHeights[i] * size.height / 2;

      canvas.drawLine(Offset(x, y1), Offset(x, y2), paint);
    }
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) =>
      true; // Always repaint for smooth animation
}

  Widget _buildCoverImage(String url) {
    if (url.startsWith('http')) {
      return Image.network(
        url,
        width: 220,
        height: 220,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          'assets/images/logo2.png',
          width: 220,
          height: 220,
          fit: BoxFit.cover,
        ),
      );
    }
    return Image.asset(
      url,
      width: 220,
      height: 220,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        'assets/images/logo2.png',
        width: 220,
        height: 220,
        fit: BoxFit.cover,
      ),
    );
  }
