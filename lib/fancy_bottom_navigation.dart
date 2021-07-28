library fancy_bottom_navigation;

import 'package:fancy_bottom_navigation/paint/painter.dart';
import 'package:flutter/material.dart';

import 'internal/tab_item.dart';

const double CIRCLE_SIZE = 24;
const double ARC_HEIGHT = 70;
const double ARC_WIDTH = 75;
const double CIRCLE_OUTLINE = 5;
const double SHADOW_ALLOWANCE = 4;
const double BAR_HEIGHT = 50;
const int ANIM_DURATION = 250;

class FancyBottomNavigation extends StatefulWidget {
  FancyBottomNavigation({
    @required this.tabs,
    @required this.onTabChangedListener,
    this.key,
    this.initialSelection = 0,
    this.circleColor,
    this.activeColor,
    this.color,
    this.barBackgroundColor,
    this.needNotched = false,
    this.needAddBottomHeight = true,
    this.shadowColor = const Color(0xff999999),
  })  : assert(onTabChangedListener != null),
        assert(tabs != null),
        assert(tabs.length > 1 && tabs.length < 6);

  final Function(int position, bool selected) onTabChangedListener;
  final Color circleColor;
  final Color activeColor;
  final Color color;
  final Color barBackgroundColor;
  final Color shadowColor;
  final List<TabData> tabs;
  final int initialSelection;
  final bool needNotched;
  final Key key;
  final bool needAddBottomHeight;

  @override
  FancyBottomNavigationState createState() => FancyBottomNavigationState();
}

class FancyBottomNavigationState extends State<FancyBottomNavigation>
    with TickerProviderStateMixin, RouteAware, SingleTickerProviderStateMixin {
  String activeIcon;

  int currentSelected = 0;
  Color activeColor;
  Color barBackgroundColor;
  Color textColor;
  Color color;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    activeIcon = widget.tabs[currentSelected].activeIcon;

    activeColor = (widget.activeColor == null)
        ? (Theme.of(context).brightness == Brightness.dark)
            ? Colors.black54
            : Colors.white
        : widget.activeColor;

    barBackgroundColor = (widget.barBackgroundColor == null)
        ? (Theme.of(context).brightness == Brightness.dark)
            ? Color(0xFF212121)
            : Colors.white
        : widget.barBackgroundColor;
    color = (widget.color == null)
        ? (Theme.of(context).brightness == Brightness.dark)
            ? Colors.white
            : Colors.black54
        : widget.color;
  }

  @override
  void initState() {
    super.initState();
    _setSelected(widget.tabs[widget.initialSelection].key);
  }

  _setSelected(UniqueKey key) {
    int selected = widget.tabs.indexWhere((tabData) => tabData.key == key);

    if (mounted) {
      setState(() {
        currentSelected = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: widget.needAddBottomHeight ? BAR_HEIGHT + MediaQuery.of(context).padding.bottom : BAR_HEIGHT,
          color: barBackgroundColor,
          child: CustomPaint(
            painter: ConvexPainter(
              top: -20,
              width: 40,
              height: 52,
              shadowColor: widget.shadowColor,
              sigma: 10,
              needNotched: widget.needNotched,
              leftPercent: const AlwaysStoppedAnimation<double>(0.5),
              textDirection: Directionality.of(context),
              cornerRadius: 0,
              color: barBackgroundColor,
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            padding:
                EdgeInsets.only(bottom: widget.needAddBottomHeight ? MediaQuery.of(context).padding.bottom : 0) ,
            color: barBackgroundColor,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: widget.tabs
                  .map(
                    (t) => TabItem(
                      tabData: t,
                      color: color,
                      activeColor: activeColor,
                      selected: t.key == widget.tabs[currentSelected].key,
                      callbackFunction: (uniqueKey, selected) {
                        int selectedIndex = widget.tabs
                            .indexWhere((tabData) => tabData.key == uniqueKey);
                        widget.onTabChangedListener(selectedIndex, selected);
                        _setSelected(uniqueKey);
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  void setPage(int page) {
    widget.onTabChangedListener(page, true);
    _setSelected(widget.tabs[page].key);

    setState(() {
      currentSelected = page;
    });
  }
}

class TabData {
  TabData({
    @required this.icon,
    @required this.activeIcon,
    @required this.title,
    this.badge,
    this.onclick,
    this.fontSize = 10,
    this.iconSize = 22,
    this.notched = false,
    this.notchedGradient = const LinearGradient(
      colors: [
        Color(0xffD7DBE3),
        Color(0xffD7DBE3),
      ],
    ),
    this.notchedActiveGradient = const LinearGradient(
      colors: [
        Color(0xff69ADF9),
        Color(0xff4C91F6),
      ],
    ),
  });

  String icon;
  String activeIcon;
  String title;
  String badge;
  double fontSize;
  double iconSize;
  Function onclick;
  final UniqueKey key = UniqueKey();

  /// 是否有凸起
  bool notched;
  LinearGradient notchedGradient;
  LinearGradient notchedActiveGradient;
}
