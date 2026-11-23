import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/extensions/context_extensions.dart';
import 'package:syncup/app/core/styles/style_atoms.dart';
import 'package:syncup/app/core/themes/app_colors.dart';
import 'package:syncup/app/core/widgets/app_bars/no_app_bar.dart';
import 'package:syncup/app/core/widgets/buttons/custom_button.dart';
import 'package:syncup/app/core/widgets/common/syncup_logo.dart';
import 'package:syncup/app/router/auto_router.gr.dart';
import 'package:syncup/app/services/storage_service.dart';
import 'package:syncup/generated/i18n/translations.g.dart';

@RoutePage()
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  Future<void> _completeOnboarding() async {
    final storage = ref.read(storageServiceProvider);
    await storage.prefs.setBool('syncup_has_seen_onboarding', true);
    if (!mounted) return;
    context.pushAndPopAll(const LoginRoute());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pages = [
      _OnboardingItem(
        icon: Icons.rocket_launch_rounded,
        title: tr.onboarding.sprintsTitle,
        description: tr.onboarding.sprintsSubtitle,
      ),
      _OnboardingItem(
        icon: Icons.forum_rounded,
        title: tr.onboarding.channelsTitle,
        description: tr.onboarding.channelsSubtitle,
      ),
      _OnboardingItem(
        icon: Icons.security_rounded,
        title: tr.onboarding.multiTenancyTitle,
        description: tr.onboarding.multiTenancySubtitle,
      ),
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDarkApp : AppColors.bgApp,
      appBar: const NoAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Skip Button
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SyncUpLogo(size: 38, borderRadius: 10),
                  TextButton(
                    onPressed: _completeOnboarding,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    ),
                    child: Text(
                      tr.common.skip,
                      style: context.roman14Muted.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // PageView Carousel
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Stylized Icon Box with Burgundy Aura
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.primary.withAlpha(45)
                                : AppColors.primaryLight,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primaryBorder,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withAlpha(isDark ? 80 : 35),
                                blurRadius: 30,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              page.icon,
                              size: 52,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 38),

                        // Title
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: context.bold24TextMain.copyWith(
                            letterSpacing: -0.5,
                            color: isDark ? AppColors.textInverse : AppColors.textMain,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Description
                        Text(
                          page.description,
                          textAlign: TextAlign.center,
                          style: context.roman14Secondary.copyWith(
                            color: isDark ? AppColors.textMuted : AppColors.textSecondary,
                            height: 1.6,
                            fontSize: 14.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Indicator Dots & Next / Get Started Button
            Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                children: [
                  // Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentIndex == index ? 26 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? AppColors.primary
                              : AppColors.borderStrong,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Button
                  CustomButton(
                    onPress: () {
                      if (_currentIndex < pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _completeOnboarding();
                      }
                    },
                    title: _currentIndex == pages.length - 1
                        ? tr.common.getStarted
                        : tr.common.next,
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

class _OnboardingItem {
  final IconData icon;
  final String title;
  final String description;

  const _OnboardingItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}
