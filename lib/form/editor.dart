import 'package:flutter/material.dart';

import '../foundation.dart';

class EditorField<T, C extends ChangeNotifier> {
  EditorField(this.id,
      {this.icon,
      required this.controller,
      required this.builder,
      required this.current});
  final String id;
  final IconData? icon;
  final Widget Function(T item, C controller) builder;
  Widget _build(T item, dynamic controller) {
    final C c = controller;
    return builder(item, c);
  }

  final C Function(T item) controller;
  final dynamic Function(C controller) current;
  dynamic _getCurrent(dynamic controller) {
    final C c = controller;
    return current(c);
  }
}

class Editor<T, C extends ChangeNotifier> extends StatelessWidget {
  const Editor(
      {super.key,
      required this.item$,
      required this.titleText,
      required this.fields,
      this.appBarActions = const [],
      required this.onSave,
      this.formWidth = defaultFormWidth});

  final String titleText;
  final List<Widget> appBarActions;
  final List<EditorField<T, C>> Function(T item) fields;
  final Stream<T> item$;
  final void Function(T item, Map<String, dynamic> data) onSave;
  final double Function(WindowClass windowClass) formWidth;

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget? buildAppBar(T plan, _, info) => AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        leading: IconButton(
            onPressed: context.popOrHome,
            icon: const Icon(MaterialSymbols.close)),
        title: Text(titleText),
        actions: [...appBarActions]);

    Widget buildBody(T item, __, info) {
      final formKey = GlobalKey<FormState>();
      final fields = this.fields(item);
      final fieldControllers = fields.fold(
          <EditorField<T, C>, C>{}, (a, c) => {...a, c: c.controller(item)});
      final fieldWidgets = fieldControllers.entries.map((entry) {
        final field = entry.key;
        final controller = entry.value;
        final widget = field._build(item, controller);
        return ListTile(leading: Icon(field.icon), title: widget);
      }).toList();

      void save() {
        if (formKey.currentState case FormState state) {
          if (state.validate()) {
            final data =
                fieldControllers.entries.fold(<String, dynamic>{}, (a, c) {
              final field = c.key;
              final controller = c.value;
              final v = field._getCurrent(controller);
              return {...a, field.id: v};
            });
            onSave(item, data);
          }
        }
      }

      return Center(
        child: SizedBox(
          width: formWidth(info.windowClass),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                ...fieldWidgets,
                ListTile(
                  title: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: context.popOrHome,
                        child: const Text("Cancel")),
                  ),
                  trailing:
                      FilledButton(onPressed: save, child: const Text("Save")),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return PageScaffold(
      data: item$,
      sizes: const WindowSizes.material(),
      buildAppBarWith: buildAppBar,
      buildBodyWith: buildBody,
    );
  }

  static double defaultFormWidth(WindowClass windowClass) =>
      switch (windowClass) {
        WindowClass.compact => 400,
        WindowClass.medium => 450,
        WindowClass.expanded => 500,
        WindowClass.large => 550,
        WindowClass.extraLarge => 600
      };
}
