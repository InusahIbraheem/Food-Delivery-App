import '../constants/app_constants.dart';

abstract final class PriceFormatter {
  static String format(double price) {
    return '${AppConstants.defaultCurrency}${price.toStringAsFixed(2)}';
  }
}
