class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.address,
    this.totalOrders = 0,
    this.favoriteCount = 0,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final String address;
  final int totalOrders;
  final int favoriteCount;
}
