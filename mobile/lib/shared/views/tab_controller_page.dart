import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immich_mobile/modules/home/providers/multiselect.provider.dart';
import 'package:immich_mobile/routing/router.dart';

class TabControllerPage extends ConsumerWidget {
  const TabControllerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    navigationRail(TabsRouter tabsRouter) {
      return NavigationRail(
        labelType: NavigationRailLabelType.all,
        selectedIndex: tabsRouter.activeIndex,
        onDestinationSelected: (index) {
          HapticFeedback.selectionClick();
          tabsRouter.setActiveIndex(index);
        },
        destinations: [
          NavigationRailDestination(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 4,
              left: 4,
              right: 4,
              bottom: 4,
            ),
            icon: const Icon(Icons.photo_outlined), 
            label: const Text('tab_controller_nav_photos').tr(),
          ),
          NavigationRailDestination(
            padding: const EdgeInsets.all(4),
            icon: const Icon(Icons.search_rounded), 
            label: const Text('tab_controller_nav_search').tr(),
          ),
          NavigationRailDestination(
            padding: const EdgeInsets.all(4),
            icon: const Icon(Icons.share_rounded), 
            label: const Text('tab_controller_nav_sharing').tr(),
          ),
          NavigationRailDestination(
            padding: const EdgeInsets.all(4),
            icon: const Icon(Icons.photo_album_outlined), 
            label: const Text('tab_controller_nav_library').tr(),
          ),
        ],
      );
    }

    bottomNavigationBar(TabsRouter tabsRouter) {
      return BottomNavigationBar(
        selectedLabelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        currentIndex: tabsRouter.activeIndex,
        onTap: (index) {
          HapticFeedback.selectionClick();
          tabsRouter.setActiveIndex(index);
        },
        items: [
          BottomNavigationBarItem(
            label: 'tab_controller_nav_photos'.tr(),
            icon: const Icon(Icons.photo_outlined),
            activeIcon: const Icon(Icons.photo),
          ),
          BottomNavigationBarItem(
            label: 'tab_controller_nav_search'.tr(),
            icon: const Icon(Icons.search_rounded),
            activeIcon: const Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            label: 'tab_controller_nav_sharing'.tr(),
            icon: const Icon(Icons.group_outlined),
            activeIcon: const Icon(Icons.group),
          ),
          BottomNavigationBarItem(
            label: 'tab_controller_nav_library'.tr(),
            icon: const Icon(Icons.photo_album_outlined),
            activeIcon: const Icon(Icons.photo_album_rounded),
          )
        ],
      );
    }

    final multiselectEnabled = ref.watch(multiselectProvider);
    return AutoTabsRouter(
      routes: [
        const HomeRoute(),
        SearchRoute(),
        const SharingRoute(),
        const LibraryRoute()
      ],
      builder: (context, child, animation) {
        final tabsRouter = AutoTabsRouter.of(context);
        final appRouter = AutoRouter.of(context);
        return WillPopScope(
          onWillPop: () async {
            bool atHomeTab = tabsRouter.activeIndex == 0;
            if (!atHomeTab) {
              tabsRouter.setActiveIndex(0);
            } else {
              appRouter.navigateBack();
            }
            return atHomeTab;
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              const medium = 600;
              final Widget? bottom;
              final Widget body;
              if (constraints.maxWidth < medium) {
                // Normal phone width
                bottom = bottomNavigationBar(tabsRouter);
                body = FadeTransition(
                  opacity: animation,
                  child: child,
                );
              } else {
                // Medium tablet width
                bottom = null;
                body = Row(
                  children: [
                    navigationRail(tabsRouter),
                    Expanded(
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    ),
                  ],
                );
              }              return Scaffold(
               body: body,
               bottomNavigationBar: multiselectEnabled
                  ? null
                  : bottom,
            );
          },),
        );
      },
    );
  }
}
