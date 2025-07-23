import 'package:cyber_mobile/account/ui/pages/auth_page.dart';
import 'package:cyber_mobile/account/ui/pages/intro_page.dart';
import 'package:cyber_mobile/account/ui/pages/register_account_page.dart';
import 'package:cyber_mobile/main.dart';
import 'package:cyber_mobile/service/ui/pages/cover_page.dart';
import 'package:cyber_mobile/service/ui/pages/covers_page.dart';
import 'package:cyber_mobile/service/ui/pages/create_cv_page.dart';
import 'package:cyber_mobile/service/ui/pages/cv_preview_page.dart';
import 'package:cyber_mobile/service/ui/pages/cvs_page.dart';
import 'package:cyber_mobile/service/ui/pages/home_page.dart';
import 'package:cyber_mobile/service/ui/pages/main_sreen.dart';
import 'package:cyber_mobile/service/ui/pages/order_page.dart';
import 'package:cyber_mobile/service/ui/pages/orders_page.dart';
import 'package:cyber_mobile/service/ui/pages/print_payment_page.dart';
import 'package:cyber_mobile/service/ui/pages/payment_print_service_page.dart';
import 'package:cyber_mobile/service/ui/pages/pdf_preview_page.dart';
import 'package:cyber_mobile/service/ui/pages/preview_cover_page.dart';
import 'package:cyber_mobile/service/ui/pages/process_print_order_page.dart';
import 'package:cyber_mobile/service/ui/pages/upload_work_page.dart';
import 'package:cyber_mobile/service/ui/templates/classic_template.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'account/ui/pages/otp_login_page.dart';
import 'account/ui/pages/process_register_page.dart';

part 'routers.g.dart';

enum Urls {
  intro,
  auth,
  processRegister,
  registerAccount,
  processLogin,
  otpLogin,
  home,
  main,
  processPrintOrder,
  cvs,
  createCv,
  modeleCv,
  cvPreview,
  upload,
  cover,
  covers,
  payment,
  paymentPrintService,
  previewCover,
  profile,
  settings,
  contact,
  help,
  terms,
  privacy,
  order,
  orders,
  test,
}

@riverpod
GoRouter router(ref) {
  CustomTransitionPage buildPageWithTransition(
    Widget child,
    GoRouterState state,
  ) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: Curves.ease));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  return GoRouter(
    initialLocation: '/main',
    navigatorKey: navigatorKey,
    redirect: (context, state) async {
      //
      if (kDebugMode) {
        print('Redirecting... Current path: 000');
      }
      // Vérifie s’il y a un token
      final prefs = await SharedPreferences.getInstance();
      final sessionToken = prefs.getString('sessionID');

      // Si le token est vide ou null, redirige vers la page d'authentification
      if (kDebugMode) {
        print('object : $sessionToken');
        print('Redirecting... Current path: 1111');
      }

      // Si on est à la racine, on redirige
      if (state.fullPath == '/intro') {
        return (sessionToken == null || sessionToken.isEmpty)
            ? '/intro'
            : '/main';
      }

      return null; // Pas de redirection nécessaire
    },

    routes: <RouteBase>[
      GoRoute(
        path: '/intro',
        name: Urls.intro.name,
        builder: (context, state) {
          return const IntroPage();
        },
      ),
      GoRoute(
        path: '/auth',
        name: Urls.auth.name,
        builder: (context, state) {
          return const AuthPage();
        },
      ),
      GoRoute(
        path: '/process-register',
        name: Urls.processRegister.name,
        builder: (context, state) {
          return const ProcessRegisterPage();
        },
      ),
      GoRoute(
        path: '/otp-login',
        name: Urls.otpLogin.name,
        builder: (context, state) {
          return OtpLoginPage();
        },
      ),
      GoRoute(
        path: '/register-account',
        name: Urls.registerAccount.name,
        builder: (context, state) {
          return RegisterAccountPage(onNext: () {});
        },
      ),
      GoRoute(
        path: '/home',
        name: Urls.home.name,
        builder: (context, state) {
          return const HomePage();
        },
      ),
      GoRoute(
        path: '/main',
        name: Urls.main.name,
        builder: (context, state) {
          return const MainScreen();
        },
      ),
      GoRoute(
        path: '/upload',
        name: Urls.upload.name,
        builder: (context, state) {
          return UploadWorkPage(onNext: () {});
        },
      ),
      GoRoute(
        path: '/cv',
        name: Urls.cvs.name,
        builder: (context, state) {
          return CvsPage();
        },
      ),
      GoRoute(
        path: '/create-cv',
        name: Urls.createCv.name,
        builder: (context, state) {
          return CreateCvPage();
        },
      ),
      GoRoute(
        path: '/modele-cv',
        name: Urls.modeleCv.name,
        builder: (context, state) {
          return PdfPreviewPage();
        },
      ),
      /*GoRoute(
        path: '/cv-preview',
        name: Urls.cvPreview.name,
        builder: (context, state) {
          return CvPreviewPage();
        },
      ),*/
      GoRoute(
        path: '/cover',
        name: Urls.cover.name,
        builder: (context, state) {
          return const CoverPage();
        },
      ),
      GoRoute(
        path: '/order',
        name: Urls.order.name,
        builder: (context, state) {
          return const OrderPage();
        },
      ),
      GoRoute(
        path: '/orders',
        name: Urls.orders.name,
        builder: (context, state) {
          return const OrdersPage();
        },
      ),
      GoRoute(
        path: '/covers',
        name: Urls.covers.name,
        pageBuilder:
            (context, state) =>
                buildPageWithTransition(CoversPage(onNext: () {}), state),
      ),
      GoRoute(
        path: '/payment-print-service',
        name: Urls.paymentPrintService.name,
        pageBuilder:
            (context, state) =>
                buildPageWithTransition(PaymentPrintServicePage(), state),
      ),
      GoRoute(
        path: '/payment',
        name: Urls.payment.name,
        pageBuilder:
            (context, state) =>
                buildPageWithTransition(PrintPaymentPage(), state),
      ),
      GoRoute(
        path: '/process-print-order',
        name: Urls.processPrintOrder.name,
        builder: (context, state) {
          return const ProcessPrintOrderPage();
        },
      ),
      GoRoute(
        path: '/preview-cover',
        name: Urls.previewCover.name,
        builder: (context, state) {
          return PreviewCoverPage();
        },
      ),
    ],
  );
}
