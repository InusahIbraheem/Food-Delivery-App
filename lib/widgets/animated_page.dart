import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:food_delivery_ui/core/utils/responsive.dart';
import 'package:food_delivery_ui/widgets/developer_footer.dart';

class AnimatedPage extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget? floatingActionButton;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final bool showBackButton;

  const AnimatedPage({
    super.key,
    required this.title,
    required this.children,
    this.floatingActionButton,
    this.appBar,
    this.bottomNavigationBar,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ??
          AppBar(
            title: Text(title),
            leading: showBackButton && Navigator.canPop(context)
                ? IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () => Navigator.pop(context),
                  )
                : null,
          ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: Responsive.contentWidth(context)),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              children: [
                ...children.asMap().entries.map((e) => e.value
                    .animate()
                    .fadeIn(duration: 400.ms, delay: (e.key * 80).ms)
                    .slideY(begin: 0.05, end: 0, curve: Curves.easeOutCubic)),
                const DeveloperFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
