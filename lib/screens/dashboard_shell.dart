import 'package:flutter/material.dart';

import '../app/smartsit_theme.dart';
import '../widgets/ui_components.dart';
import 'admin_screens.dart';
import 'user_screens.dart';

enum DashboardRole { user, admin }

class _MenuEntry {
  const _MenuEntry(this.label, this.icon);
  final String label;
  final IconData icon;
}

/// [role] is the panel currently being viewed. [authenticatedRole] represents
/// the signed-in account: an owner/admin may preview the user area, while a
/// normal user can never switch into the admin area from this UI.
class DashboardShell extends StatefulWidget {
  const DashboardShell({
    super.key,
    required this.role,
    DashboardRole? authenticatedRole,
  }) : authenticatedRole = authenticatedRole ?? role;

  final DashboardRole role;
  final DashboardRole authenticatedRole;

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  bool get _isAdminPanel => widget.role == DashboardRole.admin;
  bool get _hasAdminAccess => widget.authenticatedRole == DashboardRole.admin;

  List<_MenuEntry> get _menu => _isAdminPanel
      ? const [
          _MenuEntry('Users', Icons.groups_rounded),
          _MenuEntry('Products', Icons.inventory_2_outlined),
          _MenuEntry('Customer Support', Icons.support_agent_rounded),
          _MenuEntry('Settings', Icons.settings_outlined),
        ]
      : const [
          _MenuEntry('Overview', Icons.dashboard_outlined),
          _MenuEntry('Monitoring', Icons.sensors_outlined),
          _MenuEntry('History', Icons.history_rounded),
          _MenuEntry('Reports', Icons.assessment_outlined),
          _MenuEntry('Exercises', Icons.self_improvement_rounded),
          _MenuEntry('Settings', Icons.settings_outlined),
        ];

  Widget _page() {
    if (_isAdminPanel) {
      switch (_selectedIndex) {
        case 0:
          return const AdminUsersScreen();
        case 1:
          return const AdminProductsScreen();
        case 2:
          return const AdminSupportScreen();
        default:
          return const AdminSettingsScreen();
      }
    }

    switch (_selectedIndex) {
      case 0:
        return const OverviewScreen();
      case 1:
        return const MonitoringScreen();
      case 2:
        return const HistoryScreen();
      case 3:
        return const ReportsScreen();
      case 4:
        return const ExercisesScreen();
      default:
        return const UserSettingsScreen();
    }
  }

  String get _pageTitle => _menu[_selectedIndex].label;

  void _setPage(int index, {bool closeDrawer = false}) {
    setState(() => _selectedIndex = index);
    if (closeDrawer && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  void _switchPanel(DashboardRole role) {
    // A user session is limited to user-facing pages. Only an admin session
    // gets the panel-switch entry in the profile menu.
    if (role == DashboardRole.admin && !_hasAdminAccess) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (_) => DashboardShell(
          role: role,
          authenticatedRole: widget.authenticatedRole,
        ),
      ),
      (_) => false,
    );
  }

  void _openSettings() {
    setState(() => _selectedIndex = _isAdminPanel ? 3 : 5);
  }

  void _handleProfileAction(String value) {
    switch (value) {
      case 'admin_panel':
        _switchPanel(DashboardRole.admin);
        break;
      case 'user_panel':
        _switchPanel(DashboardRole.user);
        break;
      case 'sign_out':
        Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
        break;
    }
  }

  Widget _searchControl({required bool wide}) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () => showSearch<String>(
        context: context,
        delegate: _QuickSearchDelegate(
          onSelected: (index) => setState(() => _selectedIndex = index),
          entries: _menu,
        ),
      ),
      child: Container(
        height: 36,
        width: wide ? 255 : 38,
        padding: EdgeInsets.symmetric(horizontal: wide ? 13 : 0),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F4F6),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: wide ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_rounded, size: 20, color: SmartSitColors.muted),
            if (wide) ...[
              const SizedBox(width: 9),
              const Text('Search...', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 960;
    final isCompact = width < 380;

    return Scaffold(
      key: _scaffoldKey,
      drawer: isWide
          ? null
          : Drawer(
              width: 278,
              child: SafeArea(child: _sidebar(isDrawer: true)),
            ),
      appBar: AppBar(
        toolbarHeight: 62,
        titleSpacing: isWide ? 30 : 0,
        leading: isWide
            ? null
            : IconButton(
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                tooltip: 'Open menu',
                icon: const Icon(Icons.menu_rounded),
              ),
        title: isWide
            ? _searchControl(wide: true)
            : const SmartSitLogo(compact: true),
        actions: [
          if (!isWide && !isCompact)
            Padding(
              padding: const EdgeInsets.only(right: 1),
              child: _searchControl(wide: false),
            ),
          IconButton(
            tooltip: 'Notifications',
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              showDragHandle: true,
              builder: (context) => const SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 8, 20, 28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Notifications', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: SmartSitColors.text)),
                      SizedBox(height: 16),
                      ListTile(leading: Icon(Icons.notifications_none_rounded), title: Text('You are all caught up'), subtitle: Text('New posture alerts will appear here.')),
                    ],
                  ),
                ),
              ),
            ),
            icon: const Icon(Icons.notifications_none_rounded, color: SmartSitColors.muted),
          ),
          IconButton(
            tooltip: 'Settings',
            onPressed: _openSettings,
            icon: const Icon(Icons.settings_outlined, color: SmartSitColors.muted),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 1, right: 13),
            child: PopupMenuButton<String>(
              tooltip: 'Account menu',
              position: PopupMenuPosition.under,
              onSelected: _handleProfileAction,
              itemBuilder: (_) => [
                PopupMenuItem<String>(
                  enabled: false,
                  child: SizedBox(
                    width: 175,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _hasAdminAccess ? 'Dr. Aris Thorne' : 'Haider Ali',
                          style: const TextStyle(fontWeight: FontWeight.w900, color: SmartSitColors.text),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _hasAdminAccess ? 'Admin / Owner account' : 'User account',
                          style: const TextStyle(fontSize: 11, color: SmartSitColors.muted),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_hasAdminAccess && !_isAdminPanel)
                  const PopupMenuItem(
                    value: 'admin_panel',
                    child: ListTile(dense: true, contentPadding: EdgeInsets.zero, leading: Icon(Icons.admin_panel_settings_outlined), title: Text('Open Admin Panel')),
                  ),
                if (_hasAdminAccess && _isAdminPanel)
                  const PopupMenuItem(
                    value: 'user_panel',
                    child: ListTile(dense: true, contentPadding: EdgeInsets.zero, leading: Icon(Icons.person_outline_rounded), title: Text('Open User Panel')),
                  ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'sign_out',
                  child: ListTile(dense: true, contentPadding: EdgeInsets.zero, leading: Icon(Icons.logout_rounded, color: SmartSitColors.red), title: Text('Sign out')),
                ),
              ],
              child: CircleAvatar(
                radius: 16,
                backgroundColor: _hasAdminAccess ? const Color(0xFFDDE7E8) : SmartSitColors.greenLight,
                child: Text(
                  _hasAdminAccess ? 'AT' : 'SG',
                  style: const TextStyle(color: SmartSitColors.green, fontSize: 10, fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          if (isWide) SizedBox(width: 246, child: _sidebar(isDrawer: false)),
          Expanded(child: _page()),
        ],
      ),
      bottomNavigationBar: isWide
          ? null
          : NavigationBar(
              height: 67,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              selectedIndex: _bottomSelectedIndex,
              onDestinationSelected: (index) {
                if (!_isAdminPanel && index == 3) {
                  _scaffoldKey.currentState?.openDrawer();
                } else {
                  setState(() => _selectedIndex = index);
                }
              },
              destinations: _isAdminPanel
                  ? const [
                      NavigationDestination(icon: Icon(Icons.groups_outlined), selectedIcon: Icon(Icons.groups_rounded), label: 'Users'),
                      NavigationDestination(icon: Icon(Icons.inventory_2_outlined), selectedIcon: Icon(Icons.inventory_2_rounded), label: 'Products'),
                      NavigationDestination(icon: Icon(Icons.support_agent_outlined), selectedIcon: Icon(Icons.support_agent_rounded), label: 'Support'),
                      NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings_rounded), label: 'Settings'),
                    ]
                  : const [
                      NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard_rounded), label: 'Overview'),
                      NavigationDestination(icon: Icon(Icons.sensors_outlined), selectedIcon: Icon(Icons.sensors_rounded), label: 'Monitor'),
                      NavigationDestination(icon: Icon(Icons.history_outlined), selectedIcon: Icon(Icons.history_rounded), label: 'History'),
                      NavigationDestination(icon: Icon(Icons.grid_view_rounded), selectedIcon: Icon(Icons.grid_view_rounded), label: 'More'),
                    ],
            ),
    );
  }

  int get _bottomSelectedIndex {
    if (_isAdminPanel) return _selectedIndex.clamp(0, 3).toInt();
    return _selectedIndex <= 2 ? _selectedIndex : 3;
  }

  Widget _sidebar({required bool isDrawer}) {
    const background = Color(0xFFF8FAFC);
    return Container(
      decoration: const BoxDecoration(
        color: background,
        border: Border(right: BorderSide(color: SmartSitColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(19, 26, 14, 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SmartSitLogo(),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 1),
                  child: Text(
                    _isAdminPanel ? 'ADMIN PANEL' : 'CLINICAL CURATOR',
                    style: const TextStyle(fontSize: 9, letterSpacing: 1.25, color: Color(0xFF94A3B8), fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 11),
              children: [
                ...List.generate(_isAdminPanel ? _menu.length : 5, (index) {
                  final entry = _menu[index];
                  return _sidebarItem(
                    label: entry.label,
                    icon: entry.icon,
                    selected: _selectedIndex == index,
                    onTap: () => _setPage(index, closeDrawer: isDrawer),
                  );
                }),
                if (!_isAdminPanel) ...[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(12, 21, 12, 8),
                    child: Text('MANAGEMENT', style: TextStyle(color: Color(0xFF9AA5B1), fontSize: 9, letterSpacing: 1.4, fontWeight: FontWeight.w900)),
                  ),
                  _sidebarItem(
                    label: 'Settings',
                    icon: Icons.settings_outlined,
                    selected: _selectedIndex == 5,
                    onTap: () => _setPage(5, closeDrawer: isDrawer),
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(13)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_isAdminPanel ? 'Admin Tools' : 'Upgrade Plan', style: const TextStyle(fontSize: 12, color: SmartSitColors.softText, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 7),
                  Text(
                    _isAdminPanel ? 'Manage system users, products and support.' : 'Access advanced clinical biometrics and posture coaching.',
                    style: const TextStyle(fontSize: 10, color: SmartSitColors.softText, height: 1.45),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebarItem({required String label, required IconData icon, required bool selected, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: selected ? const Color(0xFFE2E8F0) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Icon(icon, size: 20, color: selected ? const Color(0xFF0F172A) : const Color(0xFF64748B)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(label, style: TextStyle(fontSize: 13, fontWeight: selected ? FontWeight.w800 : FontWeight.w600, color: selected ? const Color(0xFF0F172A) : const Color(0xFF64748B))),
                ),
                if (selected) Container(width: 5, height: 5, decoration: const BoxDecoration(color: SmartSitColors.green, shape: BoxShape.circle)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickSearchDelegate extends SearchDelegate<String> {
  _QuickSearchDelegate({required this.onSelected, required this.entries});
  final ValueChanged<int> onSelected;
  final List<_MenuEntry> entries;

  @override
  String get searchFieldLabel => 'Search SmartSit pages';

  @override
  List<Widget>? buildActions(BuildContext context) => [IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(onPressed: () => close(context, ''), icon: const Icon(Icons.arrow_back));

  @override
  Widget buildResults(BuildContext context) => _buildItems(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildItems(context);

  Widget _buildItems(BuildContext context) {
    final matches = entries.asMap().entries.where((entry) => entry.value.label.toLowerCase().contains(query.toLowerCase())).toList();
    if (matches.isEmpty) return const Center(child: Text('No matching pages found.'));
    return ListView(
      children: matches.map((entry) => ListTile(
        leading: const Icon(Icons.arrow_forward, color: SmartSitColors.green),
        title: Text(entry.value.label),
        onTap: () {
          onSelected(entry.key);
          close(context, entry.value.label);
        },
      )).toList(),
    );
  }
}
