// lib/router/app_router.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

// Import all screens
import '../screens/auth/welcome_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/signin_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/create_meeting/create_meeting_screen.dart';
import '../screens/join_meeting/join_meeting_screen.dart';
import '../screens/meeting/meeting_screen.dart';

// Generate route pages
part 'app_router.gr.dart';

@AutoRouterConfig()
class GcbAppRouter extends _$GcbAppRouter {
  @override
  List<AutoRoute> get routes => [
    // Welcome/Home route
    AutoRoute(
      page: WelcomeRoute.page,
      path: '/',
      initial: true,
    ),

    // Home route
    AutoRoute(
      page: HomeRoute.page,
      path: '/home',
    ),

    // Auth routes
    AutoRoute(
      page: SignInRoute.page,
      path: '/signin',
    ),
    AutoRoute(
      page: SignUpRoute.page,
      path: '/signup',
    ),

    // Meeting routes
    AutoRoute(
      page: CreateMeetingRoute.page,
      path: '/create-meeting',
    ),
    AutoRoute(
      page: JoinMeetingRoute.page,
      path: '/join-meeting',
    ),

    // Main meeting screen with parameter
    AutoRoute(
      page: MeetingRoute.page,
      path: '/meeting/:code',
    ),

    // Redirect route for any undefined paths
    AutoRoute(
      page: WelcomeRoute.page,
      path: '*',
    ),
  ];
}