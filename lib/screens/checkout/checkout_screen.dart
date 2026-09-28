import '../../core/constants/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/services/auth_service.dart';
import '../../core/services/cart_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/price_formatter.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/primary_button.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  String _deliveryOption = 'standard';

  @override
  void initState() {
    super.initState();
    _addressController.text = AuthService.instance.user?.address ?? '';
  }

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.horizontalPadding(context);
    final cart = CartService.instance;

    return ScreenScaffold(
      appBar: const CustomAppBar(title: 'Checkout', showBack: true),
      body: ListenableBuilder(
        listenable: CartService.instance,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery Address',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ).animate().fadeIn(),
                const SizedBox(height: 12),
                TextField(
                  controller: _addressController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Enter delivery address',
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                ).animate().fadeIn(delay: 100.ms),
                const SizedBox(height: 24),
                Text(
                  'Delivery Option',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _DeliveryOptionTile(
                  title: 'Standard Delivery',
                  subtitle: '25-35 minutes',
                  price: 'Free',
                  isSelected: _deliveryOption == 'standard',
                  onTap: () => setState(() => _deliveryOption = 'standard'),
                ),
                const SizedBox(height: 8),
                _DeliveryOptionTile(
                  title: 'Express Delivery',
                  subtitle: '15-20 minutes',
                  price: '\$3.99',
                  isSelected: _deliveryOption == 'express',
                  onTap: () => setState(() => _deliveryOption = 'express'),
                ),
                const SizedBox(height: 24),
                Text(
                  'Order Notes',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Special instructions for delivery...',
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Order Summary',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Column(
                    children: [
                      _SummaryRow('Items (${cart.itemCount})', cart.subtotal),
                      const SizedBox(height: 8),
                      _SummaryRow('Delivery', cart.deliveryFee),
                      const SizedBox(height: 8),
                      _SummaryRow('Tax', cart.tax),
                      const Divider(height: 24),
                      _SummaryRow('Total', cart.total, bold: true),
                    ],
                  ),
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 32),
                PrimaryButton(
                  label: 'Continue to Payment',
                  icon: Icons.payment_rounded,
                  onPressed: cart.isEmpty
                      ? null
                      : () => context.push(AppRoutes.payment),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DeliveryOptionTile extends StatelessWidget {
  const _DeliveryOptionTile({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String price;
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
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: isSelected ? AppColors.primary : AppColors.textLight,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              price,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.value, {this.bold = false});

  final String label;
  final double value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            color: bold ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        Text(
          PriceFormatter.format(value),
          style: GoogleFonts.poppins(
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            color: bold ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}


