import 'dart:async';

import 'package:flutter/material.dart';

import 'app_context.dart';
import 'build_options.dart';
import 'destination.dart';
import 'window_sizes.dart';

export 'app_context.dart';
export 'build_options.dart';
export 'destination.dart';
export 'window_sizes.dart';

typedef AnyDataBodyBuilder<T> = T Function(
    UserContext userContext, BuildOptions info);
typedef EmptyPageDataBuilder<T> = T Function(
    EmptyUserContext userContext, BuildOptions info);
typedef PopulatedPageDataBuilder<T> = T Function(
    CompleteUserContext userContext, BuildOptions info);
typedef NoDataPageDataBuilder<T> = T Function(BuildOptions info);

typedef DataBuilder<T, S, W extends Widget?> = W? Function(
    T data, S? state, BuildOptions options);
typedef DefaultBuilder<S, W extends Widget?> = W? Function(
    S? state, BuildOptions options);

class PageScaffold<T, S> extends StatefulWidget {
  const PageScaffold({
    super.key,
    this.data,
    this.initialState,
    this.initial,
    this.state,
    this.buildAppBar,
    // this.buildAppBarAny,
    this.buildAppBarWith,
    // this.buildAppBarWithout,
    this.appBar,
    this.buildDrawer,
    // this.buildDrawerAny,
    this.buildDrawerWith,
    // this.buildDrawerWithout,
    this.drawer,
    this.buildBody,
    this.buildBodyWith,
    // this.buildBodyWithout,
    this.body,
    this.bottomNavigationBar,
    this.destinations = const [],
    this.buildFloatingAction,
    this.buildFloatingActionWith,
    // this.buildFloatingActionWithout,
    this.floatingAction,
    this.sizes,
    this.scaffoldKey,
    this.drawerAlwaysVisible = true,
    this.wrapBodyInCard = true,
    this.navigate,
    this.showLabels = true,
  });

  final Stream<T>? data;
  final T? initial;
  final S? initialState;
  final S? Function(T? data)? state;

  // final AnyDataBodyBuilder<PreferredSizeWidget>? buildAppBarAny;
  // final EmptyPageDataBuilder<PreferredSizeWidget>? buildAppBarWithout;
  final DataBuilder<T, S, PreferredSizeWidget>? buildAppBarWith;
  final DefaultBuilder<S, PreferredSizeWidget>? buildAppBar;
  final PreferredSizeWidget? appBar;

  //final EmptyPageDataBuilder<Widget>? buildBodyWithout;
  final DataBuilder<T, S, Widget>? buildBodyWith;
  final DefaultBuilder<S, Widget>? buildBody;
  final Widget? body;

  // final AnyDataBodyBuilder<Widget?>? buildDrawerAny;
  // final EmptyPageDataBuilder<Widget?>? buildDrawerWithout;
  final DataBuilder<T, S, Widget?>? buildDrawerWith;
  final DefaultBuilder<S, Widget?>? buildDrawer;
  final Widget? drawer;

  final Widget? bottomNavigationBar;

  final List<Destination> destinations;

  // final EmptyPageDataBuilder<FloatingActionButton?>? buildFloatingActionWithout;
  final DataBuilder<T, S, FloatingActionButton?>? buildFloatingActionWith;
  final DefaultBuilder<S, FloatingActionButton?>? buildFloatingAction;
  final FloatingActionButton? floatingAction;

  final WindowSizes? sizes;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  /// Indicates whether the body should be wrapped in a [Card] when the drawer is always visible
  final bool wrapBodyInCard;

  /// Indicates if the drawer is always visible when the size is Large or greater
  final bool drawerAlwaysVisible;

  final bool showLabels;

  final void Function(Destination destination)? navigate;

  @override
  State<PageScaffold> createState() => _PageScaffoldState<T, S>();
}

class _PageScaffoldState<T, S> extends State<PageScaffold<T, S>>
    with SingleTickerProviderStateMixin {
  late StreamSubscription? subscription;

  T? data;
  S? state;

  // bool _isCompact = false;
  // bool get isCompact => _isCompact;
  // set isCompact(bool value) {
  //   if (value == _isCompact) return;
  //   setState(() {
  //     _isCompact = value;
  //   });
  // }

  // bool _isLarge = false;
  // bool get isLarge => _isLarge;
  // set isLarge(bool value) {
  //   if (value == _isLarge) return;
  //   setState(() {
  //     _isLarge = value;
  //   });
  // }

  bool get isCompact => windowClass == WindowClass.compact;
  //bool get isLarge => windowClass == WindowClass.large;
  bool get isLargeOrGreater => windowClass >= WindowClass.large;

  WindowClass _windowClass = WindowClass.compact;
  WindowClass get windowClass => _windowClass;
  set windowClass(WindowClass value) {
    if (value == _windowClass) return;
    _windowClass = value;
  }

  @override
  void initState() {
    super.initState();

    data = widget.initial;
    state = widget.initialState;

    subscription = widget.data?.listen((data) {
      setState(() {
        this.data = data;
        this.state = widget.state?.call(data);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget.sizes case WindowSizes breakpoint) {
      final size = MediaQuery.sizeOf(context);
      final width = size.width;
      windowClass = breakpoint.classOf(width: width);

      // isCompact = width <= breakpoint.compactWidth;
      // isLarge = width >= breakpoint.largeWidth;
    }
  }

  @override
  Widget build(BuildContext context) {
    W? choose<W extends Widget?>(
            {required DataBuilder<T, S, W>? data,
            required DefaultBuilder<S, W>? other,
            required W? child,
            required BuildOptions options}) =>
        switch (this.data) {
          T item => data?.call(item, state, options) ??
              other?.call(state, options) ??
              child,
          _ => other?.call(state, options) ?? child
        };

    PreferredSizeWidget? buildAppBar({required BuildOptions info}) => choose(
        data: widget.buildAppBarWith,
        other: widget.buildAppBar,
        child: widget.appBar,
        options: info);

    Widget? buildBody({required BuildOptions info}) => choose(
        data: widget.buildBodyWith,
        other: widget.buildBody,
        child: widget.body,
        options: info);

    FloatingActionButton? buildFab({required BuildOptions info}) => choose(
        data: widget.buildFloatingActionWith,
        other: widget.buildFloatingAction,
        child: widget.floatingAction,
        options: info);

    Widget? buildDrawer({required BuildOptions info}) => choose(
        data: widget.buildDrawerWith,
        other: widget.buildDrawer,
        child: widget.drawer,
        options: info);

    final key = widget.scaffoldKey ?? GlobalKey();
    final temp = widget.drawerAlwaysVisible && isLargeOrGreater;
    final drawer = buildDrawer(
        info: BuildOptions({
      "childPadding": temp ? EdgeInsets.zero : const EdgeInsets.all(16),
      "backgroundColor":
          temp && widget.wrapBodyInCard ? Colors.transparent : null
    }, windowClass: windowClass));
    final drawerAlwaysVisible = temp && drawer != null;
    final body = buildBody(info: BuildOptions.empty(windowClass: windowClass));
    final fab = buildFab(info: BuildOptions.empty(windowClass: windowClass));
    final selectedIndex =
        widget.destinations.indexWhere((destination) => destination.selected);
    return isCompact
        ? Scaffold(
            key: key,
            appBar: buildAppBar(
                info: BuildOptions({"automaticallyImplyLeading": true},
                    windowClass: windowClass)),
            drawer: drawer,
            body: body,
            floatingActionButton: fab,
            bottomNavigationBar: widget.destinations.isNotEmpty
                ? NavigationBar(
                    labelBehavior: widget.showLabels
                        ? null
                        : NavigationDestinationLabelBehavior.alwaysHide,
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      final destination = widget.destinations[value];
                      widget.navigate?.call(destination);
                    },
                    destinations:
                        widget.destinations.toNavigationDestinations())
                : null,
          )
        : Row(children: [
            if (widget.destinations.isNotEmpty)
              NavigationRail(
                  groupAlignment: -0.75,
                  labelType:
                      widget.showLabels ? NavigationRailLabelType.all : null,
                  leading: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (drawerAlwaysVisible)
                        const IconButton(
                          onPressed: null,
                          icon: Icon(null),
                        )
                      else
                        IconButton(
                          onPressed: () {
                            final state = key.currentState!;
                            state.isDrawerOpen
                                ? state.closeDrawer()
                                : state.openDrawer();
                          },
                          icon: const Icon(Icons.menu),
                        ),
                      if (fab != null) ...[const SizedBox(height: 8), fab]
                    ],
                  ),
                  onDestinationSelected: (value) {
                    final destination = widget.destinations[value];
                    widget.navigate?.call(destination);
                  },
                  destinations:
                      widget.destinations.toNavigationRailDestinations(),
                  selectedIndex: selectedIndex > -1 ? selectedIndex : null),
            Expanded(
              child: Scaffold(
                key: key,
                appBar: buildAppBar(
                    info: BuildOptions({"automaticallyImplyLeading": false},
                        windowClass: windowClass)),
                drawer: drawer,
                body: drawerAlwaysVisible
                    ? Row(children: [
                        drawer,
                        if (body != null)
                          Expanded(
                              child: widget.wrapBodyInCard
                                  ? Card(child: body)
                                  : body)
                      ])
                    : body,
              ),
            ),
          ]);
  }
}

// old

class PageScaffold2 extends StatefulWidget {
  const PageScaffold2({
    super.key,
    Stream<UserContext>? user,
    this.initial,
    this.buildAppBar,
    this.buildAppBarAny,
    this.buildAppBarWith,
    this.buildAppBarWithout,
    this.appBar,
    this.buildDrawer,
    this.buildDrawerAny,
    this.buildDrawerWith,
    this.buildDrawerWithout,
    this.drawer,
    this.buildBody,
    this.buildBodyWith,
    this.buildBodyWithout,
    this.body,
    this.bottomNavigationBar,
    this.destinations = const [],
    this.buildFloatingAction,
    this.buildFloatingActionWith,
    this.buildFloatingActionWithout,
    this.floatingAction,
    this.sizes,
    this.scaffoldKey,
    this.drawerAlwaysVisible = true,
    this.wrapBodyInCard = true,
    this.navigate,
    this.showLabels = true,
  }) : _userContextStream = user;

  final Stream<UserContext>? _userContextStream;
  final UserContext? initial;

  final AnyDataBodyBuilder<PreferredSizeWidget>? buildAppBarAny;
  final EmptyPageDataBuilder<PreferredSizeWidget>? buildAppBarWithout;
  final PopulatedPageDataBuilder<PreferredSizeWidget>? buildAppBarWith;
  final NoDataPageDataBuilder<PreferredSizeWidget>? buildAppBar;
  final PreferredSizeWidget? appBar;

  final AnyDataBodyBuilder<Widget>? buildBody;
  final EmptyPageDataBuilder<Widget>? buildBodyWithout;
  final PopulatedPageDataBuilder<Widget>? buildBodyWith;
  final Widget? body;

  final AnyDataBodyBuilder<Widget?>? buildDrawerAny;
  final EmptyPageDataBuilder<Widget?>? buildDrawerWithout;
  final PopulatedPageDataBuilder<Widget?>? buildDrawerWith;
  final NoDataPageDataBuilder<Widget?>? buildDrawer;
  final Widget? drawer;

  final Widget? bottomNavigationBar;

  final List<Destination> destinations;

  final AnyDataBodyBuilder<FloatingActionButton?>? buildFloatingAction;
  final EmptyPageDataBuilder<FloatingActionButton?>? buildFloatingActionWithout;
  final PopulatedPageDataBuilder<FloatingActionButton?>?
      buildFloatingActionWith;
  final FloatingActionButton? floatingAction;

  final WindowSizes? sizes;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  /// Indicates whether the body should be wrapped in a [Card] when the drawer is always visible
  final bool wrapBodyInCard;

  /// Indicates if the drawer is always visible when the size is Large or greater
  final bool drawerAlwaysVisible;

  final bool showLabels;

  final void Function(Destination destination)? navigate;

  @override
  State<PageScaffold2> createState() => _PageScaffold2State();
}

class _PageScaffold2State extends State<PageScaffold2>
    with SingleTickerProviderStateMixin {
  late StreamSubscription? subscription;

  UserContext? data;

  // bool _isCompact = false;
  // bool get isCompact => _isCompact;
  // set isCompact(bool value) {
  //   if (value == _isCompact) return;
  //   setState(() {
  //     _isCompact = value;
  //   });
  // }

  // bool _isLarge = false;
  // bool get isLarge => _isLarge;
  // set isLarge(bool value) {
  //   if (value == _isLarge) return;
  //   setState(() {
  //     _isLarge = value;
  //   });
  // }

  bool get isCompact => windowClass == WindowClass.compact;
  //bool get isLarge => windowClass == WindowClass.large;
  bool get isLargeOrGreater => windowClass >= WindowClass.large;

  WindowClass _windowClass = WindowClass.compact;
  WindowClass get windowClass => _windowClass;
  set windowClass(WindowClass value) {
    if (value == _windowClass) return;
    _windowClass = value;
  }

  @override
  void initState() {
    super.initState();

    data = widget.initial;

    subscription = widget._userContextStream?.listen((pageData) {
      setState(() => data = pageData);
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget.sizes case WindowSizes breakpoint) {
      final size = MediaQuery.sizeOf(context);
      final width = size.width;
      windowClass = breakpoint.classOf(width: width);

      // isCompact = width <= breakpoint.compactWidth;
      // isLarge = width >= breakpoint.largeWidth;
    }
  }

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget? buildAppBarWithData(
            UserContext data, BuildOptions info) =>
        switch (data) {
          CompleteUserContext populated =>
            widget.buildAppBarWith?.call(populated, info) ??
                widget.buildAppBarAny?.call(data, info) ??
                widget.buildAppBar?.call(info) ??
                widget.appBar,
          EmptyUserContext empty =>
            widget.buildAppBarWithout?.call(empty, info) ??
                widget.buildAppBarAny?.call(data, info) ??
                widget.buildAppBar?.call(info) ??
                widget.appBar,
        };

    PreferredSizeWidget? buildAppBar({required BuildOptions info}) =>
        switch (data) {
          UserContext data => buildAppBarWithData(data, info),
          _ => widget.buildAppBar?.call(info) ?? widget.appBar
        };

    Widget? buildBodyWithData(UserContext data, BuildOptions info) {
      return switch (data) {
        CompleteUserContext populated =>
          widget.buildBodyWith?.call(populated, info) ??
              widget.buildBody?.call(data, info) ??
              widget.body,
        EmptyUserContext empty => widget.buildBodyWithout?.call(empty, info) ??
            widget.buildBody?.call(data, info) ??
            widget.body,
      };
    }

    Widget? buildBody({required BuildOptions info}) => switch (data) {
          UserContext data => buildBodyWithData(data, info),
          _ => widget.body
        };

    FloatingActionButton? buildFloatingActionButtonData(UserContext data) =>
        switch (data) {
          CompleteUserContext populated => widget.buildFloatingActionWith?.call(
                  populated, BuildOptions.empty(windowClass: windowClass)) ??
              widget.buildFloatingAction
                  ?.call(data, BuildOptions.empty(windowClass: windowClass)) ??
              widget.floatingAction,
          EmptyUserContext empty => widget.buildFloatingActionWithout
                  ?.call(empty, BuildOptions.empty(windowClass: windowClass)) ??
              widget.buildFloatingAction
                  ?.call(data, BuildOptions.empty(windowClass: windowClass)) ??
              widget.floatingAction,
        };

    FloatingActionButton? buildFloatingActionButton() => switch (data) {
          UserContext data => buildFloatingActionButtonData(data),
          _ => widget.floatingAction
        };

    Widget? buildDrawerWithData(UserContext data, BuildOptions info) =>
        switch (data) {
          CompleteUserContext populated =>
            widget.buildDrawerWith?.call(populated, info) ??
                widget.buildDrawerAny?.call(data, info) ??
                widget.buildDrawer?.call(info) ??
                widget.drawer,
          EmptyUserContext empty =>
            widget.buildDrawerWithout?.call(empty, info) ??
                widget.buildDrawerAny?.call(data, info) ??
                widget.buildDrawer?.call(info) ??
                widget.drawer,
        };

    Widget? buildDrawer({required BuildOptions info}) => switch (data) {
          UserContext data => buildDrawerWithData(data, info),
          _ => widget.buildDrawer?.call(info) ?? widget.drawer
        };

    final key = widget.scaffoldKey ?? GlobalKey();
    final temp = widget.drawerAlwaysVisible && isLargeOrGreater;
    final drawer = buildDrawer(
        info: BuildOptions({
      "childPadding": temp ? EdgeInsets.zero : const EdgeInsets.all(16),
      "backgroundColor":
          temp && widget.wrapBodyInCard ? Colors.transparent : null
    }, windowClass: windowClass));
    final drawerAlwaysVisible = temp && drawer != null;
    final body = buildBody(info: BuildOptions.empty(windowClass: windowClass));
    final fab = buildFloatingActionButton();
    final selectedIndex =
        widget.destinations.indexWhere((destination) => destination.selected);
    return isCompact
        ? Scaffold(
            key: key,
            appBar: buildAppBar(
                info: BuildOptions({"automaticallyImplyLeading": true},
                    windowClass: windowClass)),
            drawer: drawer,
            body: body,
            floatingActionButton: fab,
            bottomNavigationBar: widget.destinations.isNotEmpty
                ? NavigationBar(
                    labelBehavior: widget.showLabels
                        ? null
                        : NavigationDestinationLabelBehavior.alwaysHide,
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      final destination = widget.destinations[value];
                      widget.navigate?.call(destination);
                    },
                    destinations:
                        widget.destinations.toNavigationDestinations())
                : null,
          )
        : Row(children: [
            if (widget.destinations.isNotEmpty)
              NavigationRail(
                  groupAlignment: -0.75,
                  labelType:
                      widget.showLabels ? NavigationRailLabelType.all : null,
                  leading: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (drawerAlwaysVisible)
                        const IconButton(
                          onPressed: null,
                          icon: Icon(null),
                        )
                      else
                        IconButton(
                          onPressed: () {
                            final state = key.currentState!;
                            state.isDrawerOpen
                                ? state.closeDrawer()
                                : state.openDrawer();
                          },
                          icon: const Icon(Icons.menu),
                        ),
                      if (fab != null) ...[const SizedBox(height: 8), fab]
                    ],
                  ),
                  onDestinationSelected: (value) {
                    final destination = widget.destinations[value];
                    widget.navigate?.call(destination);
                  },
                  destinations:
                      widget.destinations.toNavigationRailDestinations(),
                  selectedIndex: selectedIndex > -1 ? selectedIndex : null),
            Expanded(
              child: Scaffold(
                key: key,
                appBar: buildAppBar(
                    info: BuildOptions({"automaticallyImplyLeading": false},
                        windowClass: windowClass)),
                drawer: drawer,
                body: drawerAlwaysVisible
                    ? Row(children: [
                        drawer,
                        if (body != null)
                          Expanded(
                              child: widget.wrapBodyInCard
                                  ? Card(child: body)
                                  : body)
                      ])
                    : body,
              ),
            ),
          ]);
  }
}
