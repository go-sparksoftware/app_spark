import 'package:flutter/material.dart';

class HeroItems extends StatelessWidget {
  const HeroItems({
    super.key,
    this.title,
    this.titleAlignment = Alignment.centerLeft,
    this.titlePadding = const EdgeInsets.all(8),
    this.titleTextStyle,
    this.itemCount = 0,
    this.itemBuilder = buildDefaultItem,
    this.actionsAlignment = Alignment.centerLeft,
    this.actionsPadding = const EdgeInsets.all(8),
    this.actions = const [],
    this.widthFactor = .7,
    this.heightFactor = .5,
    this.itemsPerRow = 5,
    this.itemAspectRatio = 1,
    this.leading = const [],
    this.trailing = const [],
    this.onTap,
    this.onLeadingTap,
    this.onTrailingTap,
  });

  const HeroItems.builder({
    super.key,
    this.title,
    this.titleAlignment = Alignment.centerLeft,
    this.titlePadding = const EdgeInsets.all(8),
    this.titleTextStyle,
    required this.itemCount,
    required this.itemBuilder,
    this.actionsAlignment = Alignment.centerLeft,
    this.actionsPadding = const EdgeInsets.all(8),
    this.actions = const [],
    this.widthFactor = .7,
    this.heightFactor = .5,
    this.itemsPerRow = 5,
    this.itemAspectRatio = 1,
    this.leading = const [],
    this.trailing = const [],
    this.onTap,
    this.onLeadingTap,
    this.onTrailingTap,
  });

  const HeroItems.empty({
    super.key,
    this.title,
    this.titleAlignment = Alignment.centerLeft,
    this.titlePadding = const EdgeInsets.all(8),
    this.titleTextStyle,
    this.actionsAlignment = Alignment.centerLeft,
    this.actionsPadding = const EdgeInsets.all(8),
    this.actions = const [],
    this.widthFactor = .7,
    this.heightFactor = .5,
    this.itemsPerRow = 5,
    this.itemAspectRatio = 1,
    this.leading = const [],
    this.trailing = const [],
    this.onTap,
    this.onLeadingTap,
    this.onTrailingTap,
  })  : itemCount = 0,
        itemBuilder = buildDefaultItem;

  final Widget? title;
  final AlignmentGeometry titleAlignment;
  final TextStyle? titleTextStyle;
  final EdgeInsetsGeometry titlePadding;
  final NullableIndexedWidgetBuilder itemBuilder;
  final double widthFactor;
  final double heightFactor;
  final int itemCount;
  final int itemsPerRow;
  final double itemAspectRatio;
  final List<Widget> leading;
  final List<Widget> trailing;
  final AlignmentGeometry actionsAlignment;
  final EdgeInsetsGeometry actionsPadding;
  final List<Widget> actions;
  final Function(int index)? onTap;
  final Function(int index)? onLeadingTap;
  final Function(int index)? onTrailingTap;

  @override
  Widget build(BuildContext context) {
    final totalItemCount = itemCount + leading.length + trailing.length;
    final indexModifier = leading.isEmpty ? 0 : -leading.length;
    Widget buildCard({
      Function()? onTap,
      Widget? child,
    }) =>
        Card(
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: onTap,
            child: child,
          ),
        );

    return Center(
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        child: Column(
          children: [
            if (title != null)
              Align(
                alignment: titleAlignment,
                child: Padding(
                  padding: titlePadding,
                  child: DefaultTextStyle(
                      style: titleTextStyle ??
                          Theme.of(context).textTheme.titleLarge!,
                      child: title!),
                ),
              ),
            if (actions.isNotEmpty)
              Align(
                  alignment: actionsAlignment,
                  child: Padding(
                    padding: actionsPadding,
                    child: Row(
                        mainAxisSize: MainAxisSize.min, children: [...actions]),
                  )),
            Expanded(
              child: GridView.builder(
                itemCount: totalItemCount,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: itemAspectRatio,
                    crossAxisCount: itemsPerRow),
                itemBuilder: (context, index) {
                  final itemIndex = index + indexModifier;

                  if (itemIndex < 0) {
                    return buildCard(
                        onTap: onLeadingTap != null
                            ? () => onLeadingTap!(index)
                            : null,
                        child: leading[index]);
                  } else if (itemIndex >= itemCount) {
                    final trailingIndex = itemIndex - itemCount;
                    return buildCard(
                        onTap: onTrailingTap != null
                            ? () => onTrailingTap!(trailingIndex)
                            : null,
                        child: trailing[trailingIndex]);
                  } else {
                    return buildCard(
                        onTap: onTap != null ? () => onTap!(itemIndex) : null,
                        child: itemBuilder(context, itemIndex));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildDefaultItem(BuildContext context, int index) =>
      Center(child: Text("Item at index $index"));
}
