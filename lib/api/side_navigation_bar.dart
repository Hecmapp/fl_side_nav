import 'package:flutter/material.dart';
import 'package:side_navigation/core/bar_item_tile.dart';

import 'side_navigation_bar_item.dart';

/// Takes the data from [items] and builds [SideNavigationBarItemTile] with it.
///
/// [selectedIndex] is handled by the user. It defines what item of the navigation
/// options is currently selected.
///
/// Use [onTap] to provide a callback that [selectedIndex] has changed.
///
class SideNavigationBar extends StatefulWidget {
  /// The current index of the navigation bar
  final int selectedIndex;
  final Image logoImagen;

  /// The items to put into the bar
  final List<SideNavigationBarItem> items;

  /// What to do when an item as been tapped
  final ValueChanged<int> onTap;

  /// The background [Color] of the [SideNavigationBar]. If nothing or null is passed it defaults to the
  /// color of the parent container
  final Color? color;

  /// The [Color] of an selected [SideNavigationBarItem]. If nothing or null is passed it defaults to
  /// Colors.blue[200]
  final Color? selectedItemColor;

  /// Specifies wheter that [SideNavigationBar] is expanded or not. Default is true
  final bool expandable;

  /// The [IconData] to use when building the button to toggle [expanded]
  final IconData expandIcon;
  final IconData shrinkIcon;
  const SideNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.logoImagen,
    required this.items,
    required this.onTap,
    this.color,
    this.selectedItemColor,
    this.expandable = true,
    this.expandIcon = Icons.arrow_right,
    this.shrinkIcon = Icons.arrow_left,
  }) : super(key: key);

  @override
  _SideNavigationBarState createState() => _SideNavigationBarState();

  static _SideNavigationBarState of(BuildContext context) =>
      context.findAncestorStateOfType<_SideNavigationBarState>()!;
}

class _SideNavigationBarState extends State<SideNavigationBar> with SingleTickerProviderStateMixin {
  final double minWidth = 70;
  final double maxWidth = 180;
  final double imageMinWidth = 60;
  final double imageMaxWidth = 100;
  late double width;
  late double imageWidth;

  bool expanded = false;

  @override
  void initState() {
    super.initState();
    if (expanded) {
      width = maxWidth;
      imageWidth = imageMinWidth;
    } else {
      width = minWidth;
      imageWidth = imageMaxWidth;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
            offset: Offset(0.5, 0),
          ),
        ],
        color: widget.color,
        border: const Border(
          right: BorderSide(
            width: 0.5,
            color: Colors.blue,
          ),
        ),
      ),
      child: AnimatedSize(
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 350),
        child: SizedBox(
            width: width,
            height: double.infinity,
            child: Column(
              children: [
                SizedBox(
                  width: imageWidth,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 50, top: 10, left: 7, right: 7),
                    child: widget.logoImagen,
                  ),
                ),

                Expanded(
                  child: Scrollbar(
                    child: ListView(
                      children: _generateItems(expanded),
                    ),
                  ),
                ),
                // Toggler widget (Footer)

                widget.expandable
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: IconButton(
                          icon: Icon(expanded ? widget.shrinkIcon : widget.expandIcon),
                          onPressed: () {
                            setState(() {
                              if (expanded) {
                                width = minWidth;
                              } else {
                                width = maxWidth;
                              }
                              expanded = !expanded;
                            });
                          },
                        ),
                      )
                    : Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(),
                      ),
                const SizedBox(
                  height: 10,
                ),
              ],
            )),
      ),
    );
  }

  /// Takes [SideNavigationBarItem] data and builds new widgets with it.
  List<Widget> _generateItems(final bool _expanded) {
    List<Widget> _items = widget.items
        .asMap()
        .entries
        .map<SideNavigationBarItemTile>((MapEntry<int, SideNavigationBarItem> entry) {
      return SideNavigationBarItemTile(
          icon: entry.value.icon,
          label: entry.value.label,
          onTap: widget.onTap,
          index: entry.key,
          expanded: expanded,
          color: _validateSelectedItemColor());
    }).toList();
    return _items;
  }

  /// Checks what was passed as [widget.selectedItemColor]
  /// If nothing was passed return the default value
  /// If a color was passed use that
  Color _validateSelectedItemColor() {
    final Color? color;
    if (widget.selectedItemColor == null) {
      color = Colors.blue[200]!;
    } else {
      color = widget.selectedItemColor!;
    }
    return color;
  }
}
