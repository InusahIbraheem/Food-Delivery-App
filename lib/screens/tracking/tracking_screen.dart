import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/models/order.dart';
import '../../core/services/order_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/price_formatter.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/primary_button.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key, required this.orderId});

  final String orderId;

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  static const _steps = [
    (status: OrderStatus.confirmed, label: 'Order Confirmed', icon: Icons.check_circle_outline),
    (status: OrderStatus.preparing, label: 'Preparing', icon: Icons.restaurant),
    (status: OrderStatus.onTheWay, label: 'On the Way', icon: Icons.delivery_dining),
    (status: OrderStatus.delivered, label: 'Delivered', icon: Icons.home),
  ];

  @override
  void initState() {
    super.initState();
    _simulateProgress();
  }

  Future<void> _simulateProgress() async {
    await Future<void>.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    OrderService.instance.updateOrderStatus(widget.orderId, OrderStatus.preparing);

    await Future<void>.delayed(const Duration(seconds: 4));
    if (!mounted) return;
    OrderService.instance.updateOrderStatus(widget.orderId, OrderStatus.onTheWay);

    await Future<void>.delayed(const Duration(seconds: 5));
    if (!mounted) return;
    OrderService.instance.updateOrderStatus(widget.orderId, OrderStatus.delivered);
  }

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.horizontalPadding(context);

    return ScreenScaffold(
      appBar: const CustomAppBar(title: 'Track Order', showBack: true),
      body: ListenableBuilder(
        listenable: OrderService.instance,
        builder: (context, _) {
          final order = OrderService.instance.getOrderById(widget.orderId);

          if (order == null) {
            return const Center(child: Text('Order not found'));
          }

          final currentStep = order.status.stepIndex;

          return SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.delivery_dining, size: 48, color: Colors.white)
                          .animate(onPlay: (c) => c.repeat())
                          .shake(duration: 2000.ms),
                      const SizedBox(height: 12),
                      Text(
                        order.status == OrderStatus.delivered
                            ? AppStrings.orderConfirmed
                            : 'Your order is ${order.status.label.toLowerCase()}',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Est. ${order.estimatedDeliveryMinutes} min • ${order.restaurantName}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),
                const SizedBox(height: 32),
                ...List.generate(_steps.length, (index) {
                  final step = _steps[index];
                  final isCompleted = index <= currentStep;
                  final isActive = index == currentStep;

                  return _TrackingStep(
                    label: step.label,
                    icon: step.icon,
                    isCompleted: isCompleted,
                    isActive: isActive,
                    isLast: index == _steps.length - 1,
                  ).animate().fadeIn(delay: Duration(milliseconds: 200 * index));
                }),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Details',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        order.id,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${order.itemCount} items • ${PriceFormatter.format(order.total)}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textLight),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              order.deliveryAddress,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                if (order.status == OrderStatus.delivered)
                  PrimaryButton(
                    label: 'Back to Home',
                    onPressed: () => context.go(AppRoutes.home),
                  )
                else
                  PrimaryButton(
                    label: AppStrings.trackOrder,
                    icon: Icons.refresh_rounded,
                    onPressed: () {},
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TrackingStep extends StatelessWidget {
  const _TrackingStep({
    required this.label,
    required this.icon,
    required this.isCompleted,
    required this.isActive,
    required this.isLast,
  });

  final String label;
  final IconData icon;
  final bool isCompleted;
  final bool isActive;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = isCompleted ? AppColors.primary : AppColors.textLight;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.primary
                    : AppColors.background,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isActive ? AppColors.primary : AppColors.divider,
                  width: isActive ? 2 : 1,
                ),
              ),
              child: Icon(
                icon,
                size: 22,
                color: isCompleted ? Colors.white : AppColors.textLight,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted ? AppColors.primary : AppColors.divider,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 24),
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isCompleted ? AppColors.textPrimary : AppColors.textLight,
              ),
            ),
          ),
        ),
        if (isActive && !isCompleted)
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: color,
            ),
          ),
      ],
    );
  }
}
