import 'package:flutter/material.dart';
import '../core/res_kit.dart';

/// Destination model for [ResKitNavScaffold].
class ResKitNavDestination {
  const ResKitNavDestination({
    required this.icon,
    required this.label,
    this.selectedIcon,
    this.badge,
  });

  final Widget icon;
  final Widget? selectedIcon;
  final String label;
  final Widget? badge;
}

/// Adaptive navigation scaffold that automatically switches between:
///
/// | Screen width   | Navigation pattern          |
/// |----------------|-----------------------------|
/// | Mobile         | [BottomNavigationBar]        |
/// | Tablet         | [NavigationRail] (collapsed) |
/// | Tablet Large   | [NavigationRail] (extended)  |
/// | Desktop        | [NavigationDrawer] sidebar   |
///
/// ```dart
/// ResKitNavScaffold(
///   destinations: const [
///     ResKitNavDestination(icon: Icon(Icons.home), label: 'Home'),
///     ResKitNavDestination(icon: Icon(Icons.search), label: 'Search'),
///     ResKitNavDestination(icon: Icon(Icons.person), label: 'Profile'),
///   ],
///   selectedIndex: _index,
///   onDestinationSelected: (i) => setState(() => _index = i),
///   body: _pages[_index],
/// )
/// ```
class ResKitNavScaffold extends StatelessWidget {
  const ResKitNavScaffold({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.backgroundColor,
    this.railBackgroundColor,
    this.drawerWidth,
    this.drawerHeader,
    this.selectedIconTheme,
    this.unselectedIconTheme,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.bottomNavType = BottomNavigationBarType.fixed,
    this.showLabels = true,
    this.extendedRailMinWidth,
    this.railGroupAlignment = -1.0,
  });

  final List<ResKitNavDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final Color? railBackgroundColor;
  final double? drawerWidth;
  final Widget? drawerHeader;
  final IconThemeData? selectedIconTheme;
  final IconThemeData? unselectedIconTheme;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;
  final BottomNavigationBarType bottomNavType;
  final bool showLabels;
  final double? extendedRailMinWidth;
  final double railGroupAlignment;

  @override
  Widget build(BuildContext context) {
    if (ResKit.isMobile)      return _mobileLayout(context);
    if (ResKit.isTabletSmall) return _railLayout(context, extended: false);
    if (ResKit.isTablet)      return _railLayout(context, extended: false);
    if (ResKit.isTabletLarge) return _railLayout(context, extended: true);
    return _drawerLayout(context);
  }

  // ── Mobile: BottomNavigationBar ──────────────────────────────────────
  Widget _mobileLayout(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor,
      floatingActionButton: floatingActionButton,
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onDestinationSelected,
        type: bottomNavType,
        showSelectedLabels: showLabels,
        showUnselectedLabels: showLabels,
        selectedIconTheme: selectedIconTheme,
        unselectedIconTheme: unselectedIconTheme,
        selectedLabelStyle: selectedLabelStyle,
        unselectedLabelStyle: unselectedLabelStyle,
        items: destinations.map((d) => BottomNavigationBarItem(
          icon: d.badge != null ? Badge(label: d.badge, child: d.icon) : d.icon,
          activeIcon: d.selectedIcon,
          label: d.label,
        )).toList(),
      ),
    );
  }

  // ── Tablet: NavigationRail ────────────────────────────────────────────
  Widget _railLayout(BuildContext context, {required bool extended}) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor,
      floatingActionButton: floatingActionButton,
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            extended: extended,
            backgroundColor: railBackgroundColor,
            minExtendedWidth: extendedRailMinWidth ?? ResKit.width(200),
            groupAlignment: railGroupAlignment,
            selectedIconTheme: selectedIconTheme,
            unselectedIconTheme: unselectedIconTheme,
            selectedLabelTextStyle: selectedLabelStyle,
            unselectedLabelTextStyle: unselectedLabelStyle,
            labelType: extended ? null : NavigationRailLabelType.selected,
            destinations: destinations.map((d) => NavigationRailDestination(
              icon: d.badge != null ? Badge(label: d.badge, child: d.icon) : d.icon,
              selectedIcon: d.selectedIcon,
              label: Text(d.label),
            )).toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: body),
        ],
      ),
    );
  }

  // ── Desktop: NavigationDrawer sidebar ────────────────────────────────
  Widget _drawerLayout(BuildContext context) {
    final dw = drawerWidth ?? ResKit.width(240);
    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor,
      floatingActionButton: floatingActionButton,
      body: Row(
        children: [
          SizedBox(
            width: dw,
            child: Material(
              color: railBackgroundColor ?? Theme.of(context).colorScheme.surface,
              elevation: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (drawerHeader != null) drawerHeader!,
                  Expanded(
                    child: ListView(
                      children: [
                        for (var i = 0; i < destinations.length; i++)
                          _DrawerItem(
                            destination: destinations[i],
                            selected: i == selectedIndex,
                            onTap: () => onDestinationSelected(i),
                            selectedLabelStyle: selectedLabelStyle,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: body),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.destination, required this.selected,
    required this.onTap, this.selectedLabelStyle,
  });
  final ResKitNavDestination destination;
  final bool selected;
  final VoidCallback onTap;
  final TextStyle? selectedLabelStyle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      selected: selected,
      selectedTileColor: cs.primaryContainer.withAlpha(80),
      leading: selected
          ? (destination.selectedIcon ?? destination.icon)
          : destination.icon,
      title: Text(destination.label,
          style: selected ? selectedLabelStyle : null),
      trailing: destination.badge,
      onTap: onTap,
    );
  }
}
