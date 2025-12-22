import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'audio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home_page.dart';
import 'radio_player_page.dart';

class TVStationPage extends StatefulWidget {
  const TVStationPage({super.key});

  @override
  _TVStationPageState createState() => _TVStationPageState();
}

class _TVStationPageState extends State<TVStationPage>
    with WidgetsBindingObserver {
  // For WebView
  WebViewController? webViewController;
  late final WebViewController _modernWebViewController;
  bool isWebLoading = false;

  // For Video Player
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isVideoReady = false;
  bool _isInitializingVideo = false;

  // Current content type
  String _contentType = 'direct'; // 'direct', 'youtube', 'facebook', 'website'
  final String _youtubeUrl =
      'https://www.youtube.com/@radioteleevangeliqueflorid7171';
  final String _facebookUrl = 'https://www.facebook.com/rteflorida';
  final String _websiteUrl = 'https://rtefmedia.org/';

  // Casting variables
  bool _isCasting = false;
  bool _isCastAvailable = false;
  String? _castDeviceName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Stop radio if playing
    if (AudioPlayerHelper().isPlaying) {
      AudioPlayerHelper().stop();
    }
    // Keep screen awake while watching TV
    WakelockPlus.enable();

    // Initialize the direct video stream
    _initializeVideo();
    
    // Initialize casting
    _initializeCast();
    
    _modernWebViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(
          'Mozilla/5.0 (iPhone; CPU iPhone OS 13_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1.2 Mobile/15E148 Safari/604.1')
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isWebLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isWebLoading = false;
            });
          },
        ),
      );
  }

  Future<void> _initializeVideo() async {
    if (_isInitializingVideo) return;

    setState(() {
      _isInitializingVideo = true;
      _isVideoReady = false;
    });

    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse('http://video.attractionstream.com/live/rtef.m3u8'),
    );

    try {
      await _videoPlayerController.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: 16 / 9,
        autoPlay: true,
        looping: true,
        allowFullScreen: true,
        startAt: Duration.zero,
        allowPlaybackSpeedChanging: false,
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
        systemOverlaysAfterFullScreen: SystemUiOverlay.values,
        showControls: true,
        showControlsOnInitialize: false,
        allowMuting: true,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 40,
                ),
                SizedBox(height: 12),
                Text(
                  'Error loading video stream',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    _disposeVideo();
                    _initializeVideo();
                  },
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        },
        placeholder: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
          ),
        ),
      );
      setState(() {
        _isVideoReady = true;
        _isInitializingVideo = false;
      });
    } catch (e) {
      setState(() {
        _isInitializingVideo = false;
      });
      print('Error initializing video player: $e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Allow screen to sleep when leaving TV page
    WakelockPlus.disable();
    if (_chewieController != null) {
      _chewieController!.dispose();
    }
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _contentType == 'direct' &&
        _isVideoReady) {
      _videoPlayerController.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "TV Station",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        actions: [
          // Cast button
          IconButton(
            icon: Icon(
              _isCasting ? Icons.cast_connected : Icons.cast,
              color: _isCasting ? Colors.orange : Colors.white,
            ),
            onPressed: _isCastAvailable ? _toggleCast : null,
            tooltip: _isCasting ? 'Stop Casting' : 'Cast to TV',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (_contentType == 'direct') {
                _disposeVideo();
                _initializeVideo();
              } else if (webViewController != null) {
                webViewController!.reload();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Live indicator
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Colors.indigo.shade800,
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'LIVE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (_isCasting)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.cast_connected,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _castDeviceName != null ? 'CASTING TO $_castDeviceName' : 'CASTING',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_isCasting) const SizedBox(width: 8),
                Text(
                  'Tele Evangelique Florida',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Content area
          Expanded(
            child: Stack(
              children: [
                // Background image
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF3ad5d8), Color(0xFF513ce8)],
                      ),
                    ),
                  ),
                ),

                // Direct video stream
                if (_contentType == 'direct')
                  _isVideoReady
                      ? Positioned.fill(
                          child: Chewie(controller: _chewieController!),
                        )
                      : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.indigo),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Loading direct stream...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                // WebView content (YouTube, Facebook, Website)
                if (_contentType != 'direct')
                  Visibility(
                    visible: _contentType != 'direct',
                    child: WebViewWidget(controller: _modernWebViewController),
                  ),

                // Loading indicator for WebView
                if (_contentType != 'direct' && isWebLoading)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.indigo),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Loading $_contentType content...',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Channel controls
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF23243A)
                  : Colors.indigo[100],
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, -1),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildChannelButton(
                  'Live TV',
                  Icons.live_tv,
                  'direct',
                ),
                _buildChannelButton(
                  'YouTube',
                  Icons.ondemand_video,
                  'youtube',
                ),
                _buildChannelButton(
                  'Facebook',
                  Icons.facebook,
                  'facebook',
                ),
                _buildChannelButton(
                  'Website',
                  Icons.language,
                  'website',
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.indigo,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.7),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.radio),
            label: "Radio",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: "TV",
          ),
        ],
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const RadioPlayerPage()),
            );
          }
          // Do nothing if index == 2 (already on TV)
        },
      ),
    );
  }

  Widget _buildChannelButton(String label, IconData icon, String contentType) {
    final isActive = _contentType == contentType;
    Color iconColor;
    switch (contentType) {
      case 'direct':
        iconColor = const Color(0xFFFFD700); // Gold
        break;
      case 'youtube':
        iconColor = Colors.red;
        break;
      case 'facebook':
        iconColor = Colors.indigo; // Facebook blue
        break;
      case 'website':
        iconColor = const Color(0xFF3ad5d8); // Teal from gradient
        break;
      default:
        iconColor = isActive ? Colors.indigo : Colors.grey.shade600;
    }
    return InkWell(
      onTap: () async {
        if (contentType == 'youtube') {
          final url = Uri.parse(_youtubeUrl);
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          }
        } else if (contentType == 'facebook') {
          final url = Uri.parse(_facebookUrl);
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          }
        } else if (contentType == 'website') {
          final url = Uri.parse(_websiteUrl);
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          }
        } else {
          _switchContentType(contentType);
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.indigo.shade50 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? Colors.indigo : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.indigo : Colors.grey.shade800,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _switchContentType(String contentType) {
    if (_contentType == contentType) return;

    // Pause video if we're switching away from direct
    if (_contentType == 'direct' && _isVideoReady) {
      _videoPlayerController.pause();
    }

    setState(() {
      _contentType = contentType;
      isWebLoading = contentType != 'direct';
    });

    if (contentType == 'direct') {
      // Make sure video is ready and playing
      if (!_isVideoReady) {
        _initializeVideo();
      } else {
        _videoPlayerController.play();
      }
    } else {
      _modernWebViewController.loadRequest(Uri.parse(_getWebContentUrl()));
    }
  }

  String _getWebContentUrl() {
    switch (_contentType) {
      case 'youtube':
        return _youtubeUrl;
      case 'facebook':
        return _facebookUrl;
      case 'website':
        return _websiteUrl;
      default:
        return '';
    }
  }

  void _disposeVideo() {
    if (_chewieController != null) {
      _chewieController!.dispose();
      _chewieController = null;
    }
    if (_videoPlayerController.value.isInitialized) {
      _videoPlayerController.dispose();
    }
    setState(() {
      _isVideoReady = false;
    });
  }

  // Casting methods
  Future<void> _initializeCast() async {
    // For now, we'll assume casting is available
    // In a real implementation, you would check for available casting devices
    setState(() {
      _isCastAvailable = true;
    });
  }

  Future<void> _toggleCast() async {
    if (!_isCastAvailable) return;

    if (_isCasting) {
      // Stop casting - show message
      setState(() {
        _isCasting = false;
        _castDeviceName = null;
      });
      _showSnackBar('Casting stopped', Colors.orange);
    } else {
      // Start casting
      if (_contentType == 'direct' && _isVideoReady) {
        await _startVideoCasting();
      } else {
        _showSnackBar('Casting is only available for live TV stream', Colors.red);
      }
    }
  }

  Future<void> _startVideoCasting() async {
    try {
      // Get the video URL
      final videoUrl = 'http://video.attractionstream.com/live/rtef.m3u8';
      
      // Show casting options dialog
      await _showCastingOptionsDialog(videoUrl);
      
    } catch (e) {
      print('Error starting video casting: $e');
      _showSnackBar('Failed to start casting: $e', Colors.red);
    }
  }

  Future<void> _showCastingOptionsDialog(String videoUrl) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cast to TV'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Choose how you want to cast the video:'),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.cast, color: Colors.blue),
                title: const Text('Open in Chromecast App'),
                subtitle: const Text('Use Google Home app'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _openInChromecastApp(videoUrl);
                },
              ),
              ListTile(
                leading: const Icon(Icons.smart_display, color: Colors.green),
                title: const Text('Open in Smart TV App'),
                subtitle: const Text('Use your TV\'s casting app'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _openInSmartTVApp(videoUrl);
                },
              ),
              ListTile(
                leading: const Icon(Icons.share, color: Colors.orange),
                title: const Text('Share Video URL'),
                subtitle: const Text('Copy link to share'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _shareVideoUrl(videoUrl);
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _openInChromecastApp(String videoUrl) async {
    try {
      // Try to open Google Home app
      final url = Uri.parse('googlehome://cast?url=${Uri.encodeComponent(videoUrl)}');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
        setState(() {
          _isCasting = true;
          _castDeviceName = 'Chromecast';
        });
        _showSnackBar('Opening in Chromecast app...', Colors.blue);
      } else {
        // Fallback to Google Home app
        final homeUrl = Uri.parse('https://home.google.com/');
        if (await canLaunchUrl(homeUrl)) {
          await launchUrl(homeUrl, mode: LaunchMode.externalApplication);
          _showSnackBar('Please use Google Home app to cast the video', Colors.blue);
        } else {
          _showSnackBar('Google Home app not found', Colors.red);
        }
      }
    } catch (e) {
      _showSnackBar('Error opening Chromecast app: $e', Colors.red);
    }
  }

  Future<void> _openInSmartTVApp(String videoUrl) async {
    try {
      // Try to open with a generic video player that supports casting
      final url = Uri.parse(videoUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        setState(() {
          _isCasting = true;
          _castDeviceName = 'Smart TV';
        });
        _showSnackBar('Opening in video player...', Colors.green);
      }
    } catch (e) {
      _showSnackBar('Error opening video player: $e', Colors.red);
    }
  }

  Future<void> _shareVideoUrl(String videoUrl) async {
    try {
      await Clipboard.setData(ClipboardData(text: videoUrl));
      _showSnackBar('Video URL copied to clipboard!', Colors.green);
    } catch (e) {
      _showSnackBar('Error copying URL: $e', Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
