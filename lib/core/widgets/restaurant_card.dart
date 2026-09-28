import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/restaurant.dart';
import '../theme/app_colors.dart';
import '../utils/price_formatter.dart';
import 'rating_badge.dart';

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({
    super.key,
    required this.restaurant,
    required this.onTap,
    this.isHorizontal = true,
  });

  final Restaurant restaurant;
  final VoidCallback onTap;
  final bool isHorizontal;

  @override
  Widget build(BuildContext context) {
    if (isHorizontal) {
      return _HorizontalRestaurantCard(restaurant: restaurant, onTap: onTap);
    }
    return _VerticalRestaurantCard(restaurant: restaurant, onTap: onTap);
  }
}

class _HorizontalRestaurantCard extends StatelessWidget {
  const _HorizontalRestaurantCard({
    required this.restaurant,
    required this.onTap,
  });

  final Restaurant restaurant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: CachedNetworkImage(
                    imageUrl: restaurant.coverUrl,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => Container(
                      height: 140,
                      color: AppColors.divider,
                    ),
                    errorWidget: (_, _, _) => Container(
                      height: 140,
                      color: AppColors.divider,
                      child: const Icon(Icons.store, color: AppColors.textLight),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: RatingBadge(rating: restaurant.rating),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    restaurant.categories.join(' • '),
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _InfoChip(
                        icon: Icons.access_time_rounded,
                        label: '${restaurant.deliveryTimeMinutes} min',
                      ),
                      const SizedBox(width: 12),
                      _InfoChip(
                        icon: Icons.delivery_dining_rounded,
                        label: PriceFormatter.format(restaurant.deliveryFee),
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

class _VerticalRestaurantCard extends StatelessWidget {
  const _VerticalRestaurantCard({
    required this.restaurant,
    required this.onTap,
  });

  final Restaurant restaurant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              child: CachedNetworkImage(
                imageUrl: restaurant.imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                placeholder: (_, _) => Container(
                  width: 100,
                  height: 100,
                  color: AppColors.divider,
                ),
                errorWidget: (_, _, _) => Container(
                  width: 100,
                  height: 100,
                  color: AppColors.divider,
                  child: const Icon(Icons.store),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            restaurant.name,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        RatingBadge(rating: restaurant.rating, compact: true),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      restaurant.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded, size: 14, color: AppColors.textLight),
                        const SizedBox(width: 4),
                        Text(
                          '${restaurant.deliveryTimeMinutes} min',
                          style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textLight),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.place_outlined, size: 14, color: AppColors.textLight),
                        const SizedBox(width: 4),
                        Text(
                          '${restaurant.distanceKm} km',
                          style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textLight),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textLight),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
