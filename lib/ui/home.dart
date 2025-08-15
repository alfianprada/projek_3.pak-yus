import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

// Halaman aplikasi
import 'package:flutter_samples/ui/screen/acount.dart';
import 'package:flutter_samples/ui/screen/addcourse.dart';
import 'package:flutter_samples/ui/screen/search.dart';

// Navigasi & tema
import 'package:flutter_samples/ui/navigation/custom_tab_bar.dart';
import 'package:flutter_samples/ui/navigation/home_tab_view.dart';
import 'package:flutter_samples/ui/navigation/side_menu.dart';
import 'package:flutter_samples/ui/theme.dart';
import 'package:flutter_samples/ui/assets.dart' as app_assets;

// Rive
import 'package:rive/rive.dart' hide LinearGradient, Image;

Widget commonTabScene(Widget content) {
  return Container(
    decoration: BoxDecoration(
      color: RiveAppTheme.background,
    ),
    alignment: Alignment.center,
    child: content,
  );
}

class RiveAppHome extends StatefulWidget {
  const RiveAppHome({super.key});

  static const String route = '/course-rive';

  @override
  State<RiveAppHome> createState() => _RiveAppHomeState();
}

  class _RiveAppHomeState extends State<RiveAppHome>
      with TickerProviderStateMixin {
    late AnimationController? _animationController;
    late AnimationController? _onBoardingAnimController;
    late Animation<double> _onBoardingAnim;
    late Animation<double> _sidebarAnim;
    late SMIBool _menuBtn;

    final bool _showOnBoarding = false;
    Widget _tabBody = Container(color: RiveAppTheme.background);

    // Tambahkan variabel untuk track tab aktif
    int _currentTabIndex = 0;

    final List<Widget> _screens = [
      const HomeTabView(),
      commonTabScene(const SearchPage()),
      commonTabScene(const AddCoursePage()),
      commonTabScene(const AcountPage()),
    ];

    final springDesc = const SpringDescription(
      mass: 0.1,
      stiffness: 40,
      damping: 5,
    );

    void _onMenuIconInit(Artboard artboard) {
      final controller = StateMachineController.fromArtboard(
        artboard,
        "State Machine",
      );
      artboard.addController(controller!);
      _menuBtn = controller.findInput<bool>("isOpen") as SMIBool;
      _menuBtn.value = true;
    }

    void onMenuPress() {
      if (_menuBtn.value) {
        final springAnim = SpringSimulation(springDesc, 0, 1, 0);
        _animationController?.animateWith(springAnim);
      } else {
        _animationController?.reverse();
      }
      _menuBtn.change(!_menuBtn.value);

      SystemChrome.setSystemUIOverlayStyle(
        _menuBtn.value ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
      );
    }

    @override
    void initState() {
      super.initState();
      _animationController = AnimationController(
        duration: const Duration(milliseconds: 200),
        upperBound: 1,
        vsync: this,
      );
      _onBoardingAnimController = AnimationController(
        duration: const Duration(milliseconds: 350),
        upperBound: 1,
        vsync: this,
      );

      _sidebarAnim = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController!, curve: Curves.linear),
      );

      _onBoardingAnim = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _onBoardingAnimController!, curve: Curves.linear),
      );

      _tabBody = _screens[_currentTabIndex];
    }

    @override
    void dispose() {
      _animationController?.dispose();
      _onBoardingAnimController?.dispose();
      super.dispose();
    }

    void _changeTab(int index) {
      setState(() {
        _currentTabIndex = index;
        _tabBody = _screens[index];
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        extendBody: true,
        body: Stack(
          children: [
            Positioned(child: Container(color: RiveAppTheme.background2)),
            RepaintBoundary(
              child: AnimatedBuilder(
                animation: _sidebarAnim,
                builder: (BuildContext context, Widget? child) {
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(((1 - _sidebarAnim.value) * -30) * math.pi / 180)
                      ..translate((1 - _sidebarAnim.value) * -300),
                    child: child,
                  );
                },
                child: FadeTransition(
                  opacity: _sidebarAnim,
                  child: SideMenu(
                    onTabChange: _changeTab, // sinkronisasi menu
                    closeMenu: onMenuPress,
                  ),
                ),
              ),
            ),
            RepaintBoundary(
              child: AnimatedBuilder(
                animation: _showOnBoarding ? _onBoardingAnim : _sidebarAnim,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1 - (_showOnBoarding
                        ? _onBoardingAnim.value * 0.08
                        : _sidebarAnim.value * 0.1),
                    child: Transform.translate(
                      offset: Offset(_sidebarAnim.value * 265, 0),
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY((_sidebarAnim.value * 30) * math.pi / 180),
                        child: child,
                      ),
                    ),
                  );
                },
                child: _tabBody,
              ),
            ),
          AnimatedBuilder(
            animation: _sidebarAnim,
            builder: (context, child) {
              return Positioned(
                top: MediaQuery.of(context).padding.top + 20,
                right: (_sidebarAnim.value * -100) + 16,
                child: child!,
              );
            },
            child: GestureDetector(
              child: Container(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/samples/images/topi.png',
                  width: 40,
                  height: 50,
                ),
              ),
            ),
          ),
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _sidebarAnim,
              builder: (context, child) {
                return SafeArea(
                  child: Row(
                    children: [
                      SizedBox(width: _sidebarAnim.value * 216),
                      child!,
                    ],
                  ),
                );
              },
              child: GestureDetector(
                onTap: onMenuPress,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    width: 44,
                    height: 44,
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(44 / 2),
                      boxShadow: [
                        BoxShadow(
                          color: RiveAppTheme.shadow.withAlpha((0.2 * 255).round()),
                          blurRadius: 5,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: RiveAnimation.asset(
                      app_assets.menuButtonRiv,
                      stateMachines: const ["State Machine"],
                      animations: const ["open", "close"],
                      onInit: _onMenuIconInit,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_showOnBoarding)
            RepaintBoundary(
              child: AnimatedBuilder(
                animation: _onBoardingAnim,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      0,
                      -(MediaQuery.of(context).size.height +
                              MediaQuery.of(context).padding.bottom) *
                          (1 - _onBoardingAnim.value),
                    ),
                    child: child!,
                  );
                },
                child: SafeArea(
                  top: false,
                  maintainBottomViewPadding: true,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom + 18,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.5 * 255).round()),
                          blurRadius: 40,
                          offset: const Offset(0, 40),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          IgnorePointer(
            ignoring: true,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedBuilder(
                animation: !_showOnBoarding ? _sidebarAnim : _onBoardingAnim,
                builder: (context, child) {
                  return Container(
                    height: 150,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          RiveAppTheme.background.withAlpha(0),
                          RiveAppTheme.background.withAlpha(
                            ((1 - (!_showOnBoarding
                                        ? _sidebarAnim.value
                                        : _onBoardingAnim.value)) *
                                255)
                                .round(),
                          ),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: RepaintBoundary(
        child: AnimatedBuilder(
          animation: !_showOnBoarding ? _sidebarAnim : _onBoardingAnim,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(
                0,
                !_showOnBoarding
                    ? _sidebarAnim.value * 300
                    : _onBoardingAnim.value * 200,
              ),
              child: child,
            );
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomTabBar(
                currentIndex: _currentTabIndex, // pasangkan tab aktif
                onTabChange: _changeTab,       // sinkronisasi tab
              ),
            ],
          ),
        ),
      ),
    );
  }
}