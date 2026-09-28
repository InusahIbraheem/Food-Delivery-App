import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/models/food_item.dart';
import '../../core/services/cart_service.dart';
import '../../core/services/favorites_service.dart';
import '../../core/services/food_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/price_formatter.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/quantity_selector.dart';
import '../../core/widgets/rating_badge.dart';

class FoodDetailsScreen extends StatefulWidget {
  const FoodDetailsScreen({super.key, required this.foodId});

  final String foodId;

  @override
  State<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  int _quantity = 1;
  FoodItem? _food;

  @override
  void initState() {
    super.initState();
    _food = FoodService.instance.getFoodById(widget.foodId);
  }

  void _addToCart() {
    final food = _food;
    if (food == null) return;
    CartService.instance.addItem(food, quantity: _quantity);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${food.name} added to cart'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () => context.push(AppRoutes.cart),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final food = _food;
    final padding = Responsive.horizontalPadding(context);

    if (food == null) {
      return ScreenScaffold(
        appBar: const CustomAppBar(title: 'Not Found', showBack: true),
        body: const Center(child: Text('Food item not found')),
      );
    }

    return ScreenScaffold(
      appBar: CustomAppBar(
        title: food.name,
        showBack: true,
        showCart: true,
        actions: [
          ListenableBuilder(
            listenable: FavoritesService.instance,
            builder: (context, _) {
              final isFav = FavoritesService.instance.isFavorite(food.id);
              return IconCircleButton(
                icon: isFav ? Icons.favorite : Icons.favorite_border,
                iconColor: isFav ? AppColors.error : AppColors.textPrimary,
                onPressed: () =>
                    FavoritesService.instance.toggleFavorite(food.id),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: food.imageUrl,
                  height: 280,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => Container(
                    height: 280,
                    color: AppColors.divider,
                  ),
                  errorWidget: (_, _, _) => Container(
                    height: 280,
                    color: AppColors.divider,
                    child: const Icon(Icons.restaurant, size: 64),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: padding,
                  child: RatingBadge(rating: food.rating),
                ),
              ],
            ).animate().fadeIn(duration: 400.ms),
            Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              food.name,
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              food.restaurantName,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        PriceFormatter.format(food.price),
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _DetailChip(
                        icon: Icons.access_time_rounded,
                        label: '${food.prepTimeMinutes} min',
                      ),
                      const SizedBox(width: 12),
                      _DetailChip(
                        icon: Icons.local_fire_department_outlined,
                        label: '${food.calories} cal',
                      ),
                      if (food.isVegetarian) ...[
                        const SizedBox(width: 12),
                        _DetailChip(
                          icon: Icons.eco_outlined,
                          label: 'Vegetarian',
                          color: AppColors.success,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Description',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    food.description,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Ingredients',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: food.ingredients
                        .map(
                          (i) => Chip(
                            label: Text(i),
                            backgroundColor: AppColors.background,
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      QuantitySelector(
                        quantity: _quantity,
                        onDecrement: () {
                          if (_quantity > 1) setState(() => _quantity--);
                        },
                        onIncrement: () => setState(() => _quantity++),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: PrimaryButton(
                          label: AppStrings.addToCart,
                          icon: Icons.add_shopping_cart_rounded,
                          onPressed: _addToCart,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  const _DetailChip({
    required this.icon,
    required this.label,
    this.color,
  });

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color ?? AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: color ?? AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
