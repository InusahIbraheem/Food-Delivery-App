import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:food_delivery_ui/core/theme/app_theme.dart';
import 'package:food_delivery_ui/screens/onboarding/onboarding_screen.dart';
import 'package:food_delivery_ui/screens/login/login_screen.dart';
import 'package:food_delivery_ui/screens/home/home_screen.dart';
import 'package:food_delivery_ui/screens/restaurants/restaurants_screen.dart';
import 'package:food_delivery_ui/screens/food_details/food_details_screen.dart';
import 'package:food_delivery_ui/screens/cart/cart_screen.dart';
import 'package:food_delivery_ui/screens/checkout/checkout_screen.dart';
import 'package:food_delivery_ui/screens/payment/payment_screen.dart';
import 'package:food_delivery_ui/screens/tracking/tracking_screen.dart';
import 'package:food_delivery_ui/screens/orders/orders_screen.dart';
import 'package:food_delivery_ui/screens/favorites/favorites_screen.dart';
import 'package:food_delivery_ui/screens/profile/profile_screen.dart';
import 'package:food_delivery_ui/screens/settings/settings_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  testWidgets('Generate high-res screenshots for Food Delivery UI App', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;

    final screens = <String, Widget>{
      '01_onboarding': const FoodOnboardingScreen(),
      '02_login': const LoginScreen(),
      '03_home': const HomeScreen(),
      '04_restaurants': const RestaurantsScreen(),
      '05_food_details': const FoodDetailsScreen(foodId: '1'),
      '06_cart': const CartScreen(),
      '07_checkout': const CheckoutScreen(),
      '08_payment': const PaymentScreen(),
      '09_tracking': const TrackingScreen(orderId: 'ORD-1001'),
      '10_orders': const OrdersScreen(),
      '11_favorites': const FavoritesScreen(),
      '12_profile': const ProfileScreen(),
      '13_settings': const SettingsScreen(),
    };

    final dir = Directory('screenshots');
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }

    for (final entry in screens.entries) {
      final repaintBoundaryKey = GlobalKey();
      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          home: RepaintBoundary(
            key: repaintBoundaryKey,
            child: entry.value,
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final boundary = repaintBoundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary != null) {
        await tester.runAsync(() async {
          final image = await boundary.toImage(pixelRatio: 2.0);
          final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
          if (byteData != null) {
            final pngBytes = byteData.buffer.asUint8List();
            final file = File('screenshots/${entry.key}.png');
            await file.writeAsBytes(pngBytes);
            // ignore: avoid_print
            print('Saved screenshot: screenshots/${entry.key}.png (${pngBytes.length} bytes)');
          }
        });
      }
    }
  });
}
