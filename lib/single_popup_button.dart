import 'package:flutter/material.dart';

import 'material_symbols.dart';

class SinglePopupButton extends StatelessWidget {
  const SinglePopupButton({
    super.key,
    required this.content,
    this.contentPadding = const EdgeInsets.all(8),
    this.title,
    this.leadingTitle,
    this.titlePadding = EdgeInsets.zero,
    this.size,
    this.actions = const [],
    this.titleActions = const [],
    this.titleContentSpacing = 8,
  });

  final Widget? title;
  final Widget? leadingTitle;
  final EdgeInsetsGeometry titlePadding;
  final List<Widget> titleActions;
  final List<Widget> actions;
  final EdgeInsetsGeometry contentPadding;
  final Size? size;
  final double titleContentSpacing;
  final List<Widget> content;

  @override
  Widget build(BuildContext context) {
    Widget buildTitle() => ListTile(
        leading: leadingTitle,
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
        title: title);

    final controller = MenuController();
    final outer = Padding(
      padding: contentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ...titleActions,
              CloseButton(
                onPressed: () => controller.close(),
              )
            ],
          ),
          Expanded(
              child: ListView(
            padding: EdgeInsets.zero,
            children: [buildTitle(), ...content],
          )),
          // Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          //   if (leadingTitle != null)
          //     Padding(padding: leadingTitlePadding, child: leadingTitle),
          //   Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          //     if (title != null)
          //       DefaultTextStyle(
          //           style: Theme.of(context).textTheme.titleLarge!,
          //           child: Padding(
          //             padding: titlePadding,
          //             child: title!,
          //           )),
          //     if (title != null) SizedBox(height: titleContentSpacing),
          //     content,
          //   ])
          // ]),
          Row(
            children: [...actions],
          )
        ],
      ),
    );
    return MenuAnchor(
      controller: controller,
      menuChildren: [
        size == null
            ? outer
            : SizedBox(
                width: size!.width,
                height: size!.height,
                child: outer,
              ),
      ],
      builder: (context, controller, child) => IconButton(
          onPressed: () => controller.open(),
          icon: const Icon(MaterialSymbols.moreVert)),
    );
  }
}
