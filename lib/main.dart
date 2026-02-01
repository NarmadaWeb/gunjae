import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/repository.dart';
import 'screens/welcome_screen.dart';
import 'screens/register_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/booking_form_screen.dart';
import 'screens/confirmation_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/history_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/edit_booking_screen.dart';
import 'screens/map_screen.dart';
import 'screens/admin/admin_home_screen.dart';
import 'screens/admin/add_camp_screen.dart';
import 'utils/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppStarter());
}

class AppStarter extends StatefulWidget {
  const AppStarter({super.key});

  @override
  State<AppStarter> createState() => _AppStarterState();
}

class _AppStarterState extends State<AppStarter> {
  late Future<Repository> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _initRepository();
  }

  Future<Repository> _initRepository() async {
    final repository = Repository();
    await repository.init();
    return repository;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<Repository>(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return Provider<Repository>.value(
              value: snapshot.data!,
              child: const GunjaeApp(),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Error initializing app:\n${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}

class GunjaeApp extends StatelessWidget {
  const GunjaeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gunjae Camping',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/detail': (context) => const DetailScreen(),
        '/booking_form': (context) => const BookingFormScreen(),
        '/confirm': (context) => const ConfirmationScreen(),
        '/payment': (context) => const PaymentScreen(),
        '/history': (context) => const HistoryScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/edit_booking': (context) => const EditBookingScreen(),
        '/map': (context) => const MapScreen(),
        '/admin_home': (context) => const AdminHomeScreen(),
        '/admin/add_camp': (context) => const AddCampScreen(),
      },
    );
  }
}
