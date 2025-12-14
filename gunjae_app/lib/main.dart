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
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final repository = Repository();
  await repository.init();

  runApp(
    Provider<Repository>.value(
      value: repository,
      child: const GunjaeApp(),
    ),
  );
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
      },
    );
  }
}
