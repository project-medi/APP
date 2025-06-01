import 'package:go_router/go_router.dart';
import 'package:project_medi/page/app/start_splash_page.dart';
import 'package:project_medi/page/login/resetPassword_page.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const StartSplashPage()),

    GoRoute(
      path: '/reset-password',
      builder: (context, state) {
        final oobcode = state.uri.queryParameters['oobCode'];
        return ResetpasswordPage(oobcode: oobcode ?? '');
      },
    ),
  ],
);
