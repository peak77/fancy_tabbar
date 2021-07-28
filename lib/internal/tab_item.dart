import 'package:flutter/material.dart';

import '../fancy_bottom_navigation.dart';

const double ICON_OFF = -3;
const double ICON_ON = 0;
const double TEXT_OFF = 3;
const double TEXT_ON = 1;
const double ALPHA_OFF = 0;
const double ALPHA_ON = 1;
const int ANIM_DURATION = 250;

class TabItem extends StatelessWidget {
  TabItem({
    @required this.selected,
    @required this.callbackFunction,
    @required this.tabData,
    this.color,
    this.activeColor,
    this.fontSize = 10,
  });

  final TabData tabData;
  final bool selected;
  final Function(UniqueKey uniqueKey, bool selected) callbackFunction;
  final double fontSize;
  final Color color;
  final Color activeColor;

  final double iconYAlign = ICON_ON;
  final double textYAlign = TEXT_OFF;
  final double iconAlpha = ALPHA_ON;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          callbackFunction(tabData.key, selected);
        },
        behavior: HitTestBehavior.translucent,
        child: Container(
          padding: EdgeInsets.only(top: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  tabData.notched
                      ? Stack(
                          alignment: Alignment.center,
                          overflow: Overflow.visible,
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                            ),
                            Positioned(
                              bottom: 0,
                              width: 38,
                              height: 38,
                              child: Container(
                                decoration: ShapeDecoration(
                                  shape: CircleBorder(),
                                  gradient: selected
                                      ? tabData.notchedActiveGradient
                                      : tabData.notchedGradient,
                                ),
                                padding: EdgeInsets.only(bottom: 2),
                                child: Image.asset(
                                  selected ? tabData.activeIcon : tabData.icon,
                                  width: tabData.iconSize,
                                  height: tabData.iconSize,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Image.asset(
                          selected ? tabData.activeIcon : tabData.icon,
                          width: tabData.iconSize,
                          height: tabData.iconSize,
                        ),
                  (tabData.badge != null && tabData.badge.length > 0)
                      ? Positioned(
                          top: 0,
                          right: tabData.badge.length == 1
                              ? -11
                              : (tabData.badge.length == 2 ? -16 : -21),
                          child: Container(
                            alignment: Alignment.center,
                            // constraints: BoxConstraints(minHeight: 10),
                            decoration: tabData.badge.length == 1
                                ? ShapeDecoration(
                                    shape: CircleBorder(),
                                    color: Color(0xffF34444),
                                  )
                                : BoxDecoration(
                                    color: Color(0xffF34444),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 4, vertical: 2),
                            child: Text(
                              tabData.badge,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 8,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  tabData.title,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: fontSize,
                    color: selected ? activeColor : color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
