import '../../core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/services/auth_service.dart';
import '../../core/services/cart_service.dart';
import '../../core/services/order_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/price_formatter.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/primary_button.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _paymentMethod = 'card';
  bool _isProcessing = false;
  final _cardNumberController = TextEditingController(text: '4242 4242 4242 4242');
  final _expiryController = TextEditingController(text: '12/28');
  final _cvvController = TextEditingController(text: '123');

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);
    await Future<void>.delayed(const Duration(milliseconds: 1500));

    final cart = CartService.instance;
    final restaurantName = cart.items.isNotEmpty
        ? cart.items.first.food.restaurantName
        : 'FoodieGo';

    final order = OrderService.instance.placeOrder(
      items: cart.items,
      deliveryAddress: AuthService.instance.user?.address ?? 'Default Address',
      restaurantName: restaurantName,
    );

    if (!mounted) return;
    setState(() => _isProcessing = false);
    context.go('/tracking/${order.id}');
  }

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.horizontalPadding(context);
    final total = CartService.instance.total;

    return ScreenScaffold(
      appBar: const CustomAppBar(title: 'Payment', showBack: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Amount to Pay',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    PriceFormatter.format(total),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: -0.1, end: 0),
            const SizedBox(height: 24),
            Text(
              'Payment Method',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _PaymentMethodTile(
              icon: Icons.credit_card_rounded,
              title: 'Credit / Debit Card',
              isSelected: _paymentMethod == 'card',
              onTap: () => setState(() => _paymentMethod = 'card'),
            ),
            const SizedBox(height: 8),
            _PaymentMethodTile(
              icon: Icons.account_balance_wallet_rounded,
              title: 'Digital Wallet',
              isSelected: _paymentMethod == 'wallet',
              onTap: () => setState(() => _paymentMethod = 'wallet'),
            ),
            const SizedBox(height: 8),
            _PaymentMethodTile(
              icon: Icons.money_rounded,
              title: 'Cash on Delivery',
              isSelected: _paymentMethod == 'cash',
              onTap: () => setState(() => _paymentMethod = 'cash'),
            ),
            if (_paymentMethod == 'card') ...[
              const SizedBox(height: 24),
              TextField(
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                  prefixIcon: Icon(Icons.credit_card),
                ),
              ).animate().fadeIn(delay: 100.ms),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _expiryController,
                      decoration: const InputDecoration(labelText: 'Expiry'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _cvvController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'CVV'),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 32),
            PrimaryButton(
              label: AppStrings.payNow,
              icon: Icons.lock_rounded,
              isLoading: _isProcessing,
              onPressed: _isProcessing ? null : _processPayment,
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  const _PaymentMethodTile({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.08)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? AppColors.primary : AppColors.textLight,
            ),
          ],
        ),
      ),
    );
  }
}


