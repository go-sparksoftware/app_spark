import 'package:flutter/material.dart';

import 'material_symbols.dart';

class SinglePopupButton extends StatelessWidget {
  const SinglePopupButton({
    super.key,
    required this.content,
    this.contentPadding = const EdgeInsets.all(8),
    this.title,
    this.titlePadding = EdgeInsets.zero,
    this.size,
    this.actions = const [],
    this.titleActions = const [],
    this.titleContentSpacing = 8,
  });

  final Widget? title;
  final EdgeInsetsGeometry titlePadding;
  final List<Widget> titleActions;
  final List<Widget> actions;
  final Widget content;
  final EdgeInsetsGeometry contentPadding;
  final Size? size;
  final double titleContentSpacing;

  @override
  Widget build(BuildContext context) {
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
          if (title != null)
            DefaultTextStyle(
                style: Theme.of(context).textTheme.titleLarge!,
                child: Padding(
                  padding: titlePadding,
                  child: title!,
                )),
          if (title != null) SizedBox(height: titleContentSpacing),
          Expanded(child: content),
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
