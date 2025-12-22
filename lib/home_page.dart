import 'package:flutter/material.dart';
import 'radio_player_page.dart';
import 'tv_station_page.dart';
import 'gradient_background.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'pages/about_page.dart';
import 'pages/terms_page.dart';
import 'pages/privacy_page.dart';
import 'my_app.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          "Radio Evangelique Florida",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.indigo,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (RawKeyEvent event) {
          _handleKeyEvent(context, event);
        },
        child: const GradientBackground(
          child: Center(
            child: Text(""),
          ),
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
        currentIndex: 0,
        onTap: (index) {
          // Handle navigation to different pages
          if (index == 0) {
            // Home button - do nothing (stay on home page)
            // This keeps the original functionality
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RadioPlayerPage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TVStationPage()),
            );
          } else if (index == 3) {
            // Menu button - open drawer
            _openDrawer(context);
          }
        },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigo,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF3949AB), Color(0xFF303F9F)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Radio Tele Evangelique',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'N\'ap pote pawòl la',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            // Main Menu Section
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 4.0),
              child: Text(
                'MAIN MENU',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.indigo),
              title: const Text('Home',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.radio, color: Colors.indigo),
              title: const Text('Radio',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RadioPlayerPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.tv, color: Colors.indigo),
              title: const Text('TV',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TVStationPage()),
                );
              },
            ),
            const Divider(),

            // Social Media Section
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 4.0),
              child: Text(
                'FOLLOW US',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.language, color: Colors.blue),
              title: const Text('Website',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              onTap: () async {
                final Uri url = Uri.parse('https://rtefmedia.org/');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.facebook, color: Colors.indigoAccent),
              title: const Text('Facebook',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              onTap: () async {
                final Uri url =
                    Uri.parse('https://www.facebook.com/rteflorida');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_library, color: Colors.red),
              title: const Text('YouTube',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              onTap: () async {
                final Uri url = Uri.parse(
                    'https://www.youtube.com/@radioteleevangeliqueflorid7171');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.music_note, color: Colors.black),
              title: const Text('TikTok',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              onTap: () async {
                final Uri url = Uri.parse('https://www.tiktok.com/@www.rtefmedia.org');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.pink),
              title: const Text('Instagram',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              onTap: () async {
                final Uri url = Uri.parse('https://www.instagram.com/radio_tele_evangelique_florida');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.green),
              title: const Text('Email',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              onTap: () async {
                final Uri url = Uri.parse('mailto:rtefmedia@gmail.com?subject=Contact%20RTEF');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.orange),
              title: const Text('Call',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              onTap: () async {
                final Uri url = Uri.parse('tel:7542724540');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
            ),
            const Divider(),

            // Information Section
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 4.0),
              child: Text(
                'INFORMATION',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.teal),
              title: const Text('About',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutPage()));
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.privacy_tip_outlined, color: Colors.amber),
              title: const Text('Privacy Policy',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PrivacyPage()));
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.gavel_outlined, color: Colors.deepOrange),
              title: const Text('Terms of Service',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TermsPage()));
              },
            ),
            // Theme Switch
            ValueListenableBuilder<ThemeMode>(
              valueListenable: themeModeNotifier,
              builder: (context, mode, _) {
                return SwitchListTile(
                  secondary: Icon(
                    mode == ThemeMode.dark
                        ? Icons.dark_mode
                        : mode == ThemeMode.light
                            ? Icons.light_mode
                            : Icons.brightness_auto,
                    color: Colors.indigo,
                  ),
                  title: Text('Dark Mode',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  value: mode == ThemeMode.dark,
                  onChanged: (val) {
                    themeModeNotifier.value =
                        val ? ThemeMode.dark : ThemeMode.light;
                  },
                  subtitle: Text(
                    mode == ThemeMode.system
                        ? 'System Default'
                        : mode == ThemeMode.dark
                            ? 'Dark'
                            : 'Light',
                  ),
                );
              },
            ),
            const Divider(),

            // Developer Information
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 4.0),
              child: Text(
                'DEVELOPER',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.indigo[100],
                    child: Icon(Icons.person, color: Colors.indigo),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Louvelt Voltaire',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'voltairelouvelt@gmail.com',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.mail_outline, color: Colors.purple),
              title: const Text('Contact Developer',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              onTap: () async {
                final url = Uri.parse(
                    'mailto:voltairelouvelt@gmail.com?subject=Contact%20from%20RTEF%20App');
                if (await canLaunchUrl(url)) await launchUrl(url);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleKeyEvent(BuildContext context, RawKeyEvent keyEvent) {
    if (keyEvent is RawKeyDownEvent) {
      // Check for the center button press (Enter)
      if (keyEvent.logicalKey == LogicalKeyboardKey.select) {
        // Handle the selection logic here
        // For example, you can navigate to the RadioPlayerPage
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RadioPlayerPage()),
        );
      }
    }
  }

  void _openDrawer(BuildContext context) {
    _scaffoldKey.currentState?.openDrawer();
  }
}
