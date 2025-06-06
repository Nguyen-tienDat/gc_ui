// lib/main.dart - FIXED VERSION (Simple)
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

// Import services
import 'services/meeting_service.dart';      // Original P2P service
import 'services/auth_service.dart';
import 'theme/app_theme.dart';

// Import screens directly
import 'screens/auth/welcome_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/auth/signin_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/create_meeting/create_meeting_screen.dart';
import 'screens/join_meeting/join_meeting_screen.dart';
import 'screens/meeting/meeting_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp();
    print('✅ Firebase initialized successfully');
  } catch (e) {
    print('❌ Firebase initialization failed: $e');
  }

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Set system UI overlay style for dark theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF121212),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Auth Service
        ChangeNotifierProvider(
          create: (context) => AuthService(),
        ),

        // Meeting Service (P2P for now)
        ChangeNotifierProvider(
          create: (context) => GcbMeetingService()..initialize(),
        ),
      ],
      child: MaterialApp(
        title: 'GlobeCast - Global Communication Bridge',
        debugShowCheckedModeBanner: false,

        // Use the custom theme
        theme: GcbAppTheme.darkTheme,
        themeMode: ThemeMode.dark,

        // Simple navigation without auto_route
        home: const WelcomeScreen(),

        // Define all routes manually
        routes: {
          '/welcome': (context) => const WelcomeScreen(),
          '/home': (context) => const HomeScreen(),
          '/signin': (context) => const SignInScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/create-meeting': (context) => const CreateMeetingScreen(),
          '/join-meeting': (context) => const JoinMeetingScreen(),
        },

        // Handle parameterized routes
        onGenerateRoute: (settings) {
          // Handle meeting route with code parameter
          if (settings.name?.startsWith('/meeting/') == true) {
            final code = settings.name!.split('/').last;
            return MaterialPageRoute(
              builder: (context) => MeetingScreen(code: code),
              settings: settings,
            );
          }

          // Handle unknown routes
          return MaterialPageRoute(
            builder: (context) => const WelcomeScreen(),
          );
        },

        // Global app configuration
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1.0),
            ),
            child: child!,
          );
        },
      ),
    );
  }
}

// Auth wrapper to handle navigation based on auth state
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        // Show loading indicator while checking auth state
        if (authService.isLoading) {
          return const Scaffold(
            backgroundColor: Color(0xFF121212),
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            ),
          );
        }

        // Navigate based on authentication status
        if (authService.isAuthenticated) {
          return const HomeScreen();
        } else {
          return const WelcomeScreen();
        }
      },
    );
  }
}

// Enhanced version with error handling
class MyAppWithErrorHandling extends StatefulWidget {
  const MyAppWithErrorHandling({Key? key}) : super(key: key);

  @override
  State<MyAppWithErrorHandling> createState() => _MyAppWithErrorHandlingState();
}

class _MyAppWithErrorHandlingState extends State<MyAppWithErrorHandling> {
  @override
  void initState() {
    super.initState();

    // Global error handling
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint('Flutter Error: ${details.exception}');
      debugPrint('Stack trace: ${details.stack}');
    };
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Authentication Service
        ChangeNotifierProvider(
          create: (context) => AuthService(),
          lazy: false, // Initialize immediately
        ),

        // Meeting Service
        ChangeNotifierProvider(
          create: (context) => GcbMeetingService()..initialize(),
          lazy: false, // Initialize immediately
        ),
      ],
      child: MaterialApp(
        title: 'GlobeCast - Global Communication Bridge',
        debugShowCheckedModeBanner: false,

        // Theme configuration
        theme: GcbAppTheme.darkTheme,
        themeMode: ThemeMode.dark,

        // Auth wrapper as home
        home: const AuthWrapper(),

        // Define routes
        routes: {
          '/welcome': (context) => const WelcomeScreen(),
          '/home': (context) => const HomeScreen(),
          '/signin': (context) => const SignInScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/create-meeting': (context) => const CreateMeetingScreen(),
          '/join-meeting': (context) => const JoinMeetingScreen(),
        },

        // Handle parameterized routes
        onGenerateRoute: (settings) {
          if (settings.name?.startsWith('/meeting/') == true) {
            final code = settings.name!.split('/').last;
            return MaterialPageRoute(
              builder: (context) => MeetingScreen(code: code),
              settings: settings,
            );
          }

          return MaterialPageRoute(
            builder: (context) => const WelcomeScreen(),
          );
        },

        // Global app configuration
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1.0),
            ),
            child: _buildAppWithErrorBoundary(child!),
          );
        },
      ),
    );
  }

  Widget _buildAppWithErrorBoundary(Widget child) {
    return Builder(
      builder: (context) {
        return child;
      },
    );
  }
}

// Navigation helper class to replace auto_route functionality
class AppNavigator {
  static void pushWelcome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/welcome',
          (route) => false,
    );
  }

  static void pushHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
          (route) => false,
    );
  }

  static void pushSignIn(BuildContext context) {
    Navigator.pushNamed(context, '/signin');
  }

  static void pushSignUp(BuildContext context) {
    Navigator.pushNamed(context, '/signup');
  }

  static void pushCreateMeeting(BuildContext context) {
    Navigator.pushNamed(context, '/create-meeting');
  }

  static void pushJoinMeeting(BuildContext context) {
    Navigator.pushNamed(context, '/join-meeting');
  }

  static void pushMeeting(BuildContext context, String code) {
    Navigator.pushNamed(context, '/meeting/$code');
  }

  static void pop(BuildContext context) {
    Navigator.pop(context);
  }

  static void popAndPush(BuildContext context, String routeName) {
    Navigator.popAndPushNamed(context, routeName);
  }

  static void replaceAll(BuildContext context, String routeName) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
          (route) => false,
    );
  }
}

// Extension to make navigation easier in existing code
extension ContextExtension on BuildContext {
  AppNavigator get router => AppNavigator();

  // Helper methods to match existing router usage
  void pushWelcome() => AppNavigator.pushWelcome(this);
  void pushHome() => AppNavigator.pushHome(this);
  void pushSignIn() => AppNavigator.pushSignIn(this);
  void pushSignUp() => AppNavigator.pushSignUp(this);
  void pushCreateMeeting() => AppNavigator.pushCreateMeeting(this);
  void pushJoinMeeting() => AppNavigator.pushJoinMeeting(this);
  void pushMeeting(String code) => AppNavigator.pushMeeting(this, code);
}