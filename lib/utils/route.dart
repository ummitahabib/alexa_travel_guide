import 'package:auto_route/auto_route.dart';
import 'package:she_travel/utils/route.gr.dart';
import 'package:she_travel/utils/string.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter();
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: SplashRoute.page,
      initial: true,
      path: RouteString.splashScreen,
    ),
//
  AutoRoute(page: LoginRoute.page, path: RouteString.login),
    AutoRoute(page: SignupRoute.page, path: RouteString.signup),
     AutoRoute(page: ForgetPasswordRoute.page, path: RouteString.forgetPassword),
    //
    AutoRoute(page: HomeRoute.page, path: RouteString.homeScreen),
    AutoRoute(page: AdminGalleryRoute.page, path: RouteString.adminGallery),
    AutoRoute(page: AdminMemoriesRoute.page, path: RouteString.adminMemories),
    AutoRoute(page: AdminLoginRoute.page, path: RouteString.adminLogin),
    AutoRoute(page: AdminPanelRoute.page, path: RouteString.adminPanel),
    
    
  ];
}
