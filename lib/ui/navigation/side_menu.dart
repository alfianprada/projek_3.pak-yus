import 'package:flutter/material.dart';
import '../components/menu_row.dart';
import '../models/menu_item.dart';
import '../theme.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key, required this.onTabChange, required this.closeMenu});

  // Callback untuk mengganti tab di Home
  final Function(int index) onTabChange;
  // Callback untuk menutup menu
  final VoidCallback closeMenu;

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final List<MenuItemModel> _browseMenuIcons = MenuItemModel.menuItems;
  String _selectedMenu = MenuItemModel.menuItems[0].title;

  void onMenuPress(MenuItemModel menu) {
    setState(() {
      _selectedMenu = menu.title;
    });

    if (menu.title == "Help") {
      _showHelpDialog();
      return;
    }

    // Tutup menu
    widget.closeMenu();

    // Ganti konten tab melalui callback
    switch (menu.title) {
      case "Home":
        widget.onTabChange(0);
        break;
      case "Search":
        widget.onTabChange(1);
        break;
      case "Add Courses":
      case "Add Courses ":
        widget.onTabChange(2);
        break;
      case "Account":
        widget.onTabChange(3);
        break;
    }
  }

  void _showHelpDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFEDE6FF),
                  Color(0xFFEAF1FF),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Need Help?",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black54),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  "We’re here to help you learn without obstacles!\n\n"
                  "Find answers to common questions, step-by-step guides, or contact our team if you need further assistance.",
                  style: TextStyle(color: Colors.black87, fontSize: 15, height: 1.4),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  "User Guide",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "• How to easily enroll in a course\n"
                  "• Accessing learning materials and videos\n"
                  "• Tracking your learning progress\n"
                  "• Earning certificates after completing a course",
                  style: TextStyle(fontSize: 14, height: 1.4, color: Colors.black87),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text("Contact Us"),
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "📧 Email: support@courseapp.com\n"
                    "📸 Instagram: @excellion_\n"
                    "📞 Phone: +62 812 3456 7890",
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        bottom: MediaQuery.of(context).padding.bottom - 60,
      ),
      constraints: const BoxConstraints(maxWidth: 288),
      decoration: BoxDecoration(
        color: RiveAppTheme.background2,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white.withAlpha((0.2 * 255).round()),
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.person_outline),
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "XII RPL 1",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontFamily: "Inter",
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Software Engineer",
                      style: TextStyle(
                        color: Colors.white.withAlpha((0.7 * 255).round()),
                        fontSize: 15,
                        fontFamily: "Inter",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MenuButtonSection(
                    title: "BROWSE",
                    selectedMenu: _selectedMenu,
                    menuIcons: _browseMenuIcons,
                    onMenuPress: onMenuPress,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuButtonSection extends StatelessWidget {
  const MenuButtonSection({
    super.key,
    required this.title,
    required this.menuIcons,
    this.selectedMenu = "Home",
    this.onMenuPress,
  });

  final String title;
  final String selectedMenu;
  final List<MenuItemModel> menuIcons;
  final Function(MenuItemModel menu)? onMenuPress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 40, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white.withAlpha((0.7 * 255).round()),
              fontSize: 15,
              fontFamily: "Inter",
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          child: Column(
            children: [
              for (var menu in menuIcons) ...[
                Divider(
                  color: Colors.white.withAlpha((0.1 * 255).round()),
                  thickness: 1,
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                ),
                MenuRow(
                  menu: menu,
                  selectedMenu: selectedMenu,
                  onMenuPress: () => onMenuPress!(menu),
                ),
              ]
            ],
          ),
        ),
      ],
    );
  }
}
