import 'dart:async';

import 'package:elegant_notification/resources/colors.dart';
import 'package:elegant_notification/resources/extensions.dart';
import 'package:elegant_notification/resources/stacked_options.dart';
import 'package:elegant_notification/widgets/animated_progress_bar.dart';
import 'package:elegant_notification/widgets/overlay_manager.dart';
import 'package:elegant_notification/widgets/toast_content.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ElegantNotification extends StatefulWidget {
  ElegantNotification({
    Key? key,
    this.title,
    required this.description,
    required this.icon,
    this.background = Colors.white,
    this.borderRadius,
    this.border,
    this.showProgressIndicator = true,
    this.closeButton,
    this.stackedOptions,
    this.notificationMargin = 20,
    this.progressIndicatorColor = Colors.blue,
    this.toastDuration = const Duration(milliseconds: 3000),
    this.displayCloseButton = true,
    this.onCloseButtonPressed,
    this.onProgressFinished,
    this.animationDuration = const Duration(milliseconds: 600),
    this.iconSize = 20,
    this.action,
    this.autoDismiss = true,
    this.progressBarHeight,
    this.progressBarWidth,
    this.progressBarPadding,
    this.onDismiss,
    this.isDismissable = true,
    this.dismissDirection = DismissDirection.horizontal,
    this.progressIndicatorBackground = greyColor,
    this.onNotificationPressed,
    this.animationCurve = Curves.ease,
    this.shadow,
  }) : super(key: key) {
    _notificationType = NotificationType.custom;
    checkAssertions();
  }

  ElegantNotification.success({
    Key? key,
    this.title,
    required this.description,
    this.background = Colors.white,
    this.closeButton,
    this.stackedOptions,
    this.notificationMargin = 20,
    this.toastDuration = const Duration(milliseconds: 3000),
    this.displayCloseButton = true,
    this.onCloseButtonPressed,
    this.onProgressFinished,
    this.iconSize = 20,
    this.animationDuration = const Duration(milliseconds: 600),
    this.showProgressIndicator = true,
    this.action,
    this.autoDismiss = true,
    this.progressBarHeight,
    this.progressBarWidth,
    this.progressBarPadding,
    this.onDismiss,
    this.isDismissable = true,
    this.dismissDirection = DismissDirection.horizontal,
    this.progressIndicatorBackground = greyColor,
    this.onNotificationPressed,
    this.animationCurve = Curves.ease,
    this.shadow,
    this.borderRadius,
    this.border,
  }) : super(key: key) {
    _notificationType = NotificationType.success;
    progressIndicatorColor = _notificationType.color();
    icon = null;
    checkAssertions();
  }

  ElegantNotification.error({
    Key? key,
    this.title,
    required this.description,
    this.background = Colors.white,
    this.closeButton,
    this.stackedOptions,
    this.notificationMargin = 20,
    this.toastDuration = const Duration(milliseconds: 3000),
    this.displayCloseButton = true,
    this.onCloseButtonPressed,
    this.onProgressFinished,
    this.iconSize = 20,
    this.animationDuration = const Duration(milliseconds: 600),
    this.showProgressIndicator = true,
    this.action,
    this.autoDismiss = true,
    this.progressBarHeight,
    this.progressBarWidth,
    this.progressBarPadding,
    this.onDismiss,
    this.isDismissable = true,
    this.dismissDirection = DismissDirection.horizontal,
    this.progressIndicatorBackground = greyColor,
    this.onNotificationPressed,
    this.animationCurve = Curves.ease,
    this.shadow,
    this.borderRadius,
    this.border,
  }) : super(key: key) {
    _notificationType = NotificationType.error;
    progressIndicatorColor = _notificationType.color();
    icon = null;
    checkAssertions();
  }

  ElegantNotification.info({
    Key? key,
    this.title,
    required this.description,
    this.background = Colors.white,
    this.closeButton,
    this.stackedOptions,
    this.notificationMargin = 20,
    this.toastDuration = const Duration(milliseconds: 3000),
    this.displayCloseButton = true,
    this.onCloseButtonPressed,
    this.onProgressFinished,
    this.iconSize = 20,
    this.animationDuration = const Duration(milliseconds: 600),
    this.showProgressIndicator = true,
    this.action,
    this.autoDismiss = true,
    this.progressBarHeight,
    this.progressBarWidth,
    this.progressBarPadding,
    this.onDismiss,
    this.isDismissable = true,
    this.dismissDirection = DismissDirection.horizontal,
    this.progressIndicatorBackground = greyColor,
    this.onNotificationPressed,
    this.animationCurve = Curves.ease,
    this.shadow,
    this.borderRadius,
    this.border,
  }) : super(key: key) {
    _notificationType = NotificationType.info;
    progressIndicatorColor = _notificationType.color();
    icon = null;
    checkAssertions();
  }

  ///Checks assertions for various constructors of this package
  void checkAssertions() {
    if (showProgressIndicator) {
      assert(autoDismiss != false);
    }
    if (onNotificationPressed != null) {
      assert(
        action == null,
        'You can not set both an action and an onTap method',
      );
    }
  }

  final Widget? title;
  final Widget description;
  final Widget? action;
  late final Widget? icon;
  final double iconSize;
  final Duration animationDuration;
  final Curve animationCurve;
  late final Color background;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final Duration toastDuration;
  final BoxShadow? shadow;
  late final bool showProgressIndicator;
  late final Color progressIndicatorColor;
  final double? progressBarWidth;
  final double? progressBarHeight;
  final EdgeInsetsGeometry? progressBarPadding;
  final Color progressIndicatorBackground;
  final bool displayCloseButton;

  final Widget Function(void Function() dismissNotification)? closeButton;
  final void Function()? onCloseButtonPressed;
  final void Function()? onProgressFinished;
  final void Function()? onNotificationPressed;
  final Function()? onDismiss;

  final bool autoDismiss;
  final DismissDirection dismissDirection;
  final bool isDismissable;
  final double notificationMargin;

  /// The options for the stacked mode
  final StackedOptions? stackedOptions;

  late final NotificationType _notificationType;
  late OverlayEntry? overlayEntry;

  late final Timer _closeTimer;
  late final Animation<Offset> _offsetAnimation;
  late final AnimationController _slideController;
  final OverlayManager overlayManager = OverlayManager();

  final Key uniqueKey = UniqueKey();

  String get internalKey => stackedOptions != null
      ? '${stackedOptions?.key}%${uniqueKey.toString()}'
      : uniqueKey.toString();

  ///display the notification on the screen
  ///[context] the context of the application
  void show(BuildContext context) {
    overlayEntry = _overlayEntryBuilder();
    Overlay.maybeOf(context)?.insert(overlayEntry!);
    overlayManager.addOverlay(internalKey, overlayEntry!);
  }

  void closeOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
    overlayManager.removeOverlay(internalKey);
  }

  Future<void> dismiss() {
    _closeTimer.cancel();
    return _slideController.reverse().then((value) {
      onDismiss?.call();
      closeOverlay();
    });
  }

  int get stackOverlaysLength => overlayManager.overlays.keys
      .where(
        (element) => element.split('%').first == internalKey.split('%').first,
      )
      .length;

  int get stackedItemPosition => overlayManager.overlays.keys
      .where(
        (element) => element.split('%').first == internalKey.split('%').first,
      )
      .toList()
      .indexWhere((element) => element == internalKey);

  double getScale() {
    if (stackedOptions?.scaleFactor != null) {
      return clampDouble(
        (1 -
            (stackedOptions?.scaleFactor ?? 0) *
                (stackOverlaysLength - (stackedItemPosition + 1))),
        0,
        1,
      );
    } else {
      return 1.0;
    }
  }

  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(
      opaque: false,
      builder: (context) {
        return AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          left: 20,
          right: 20,
          bottom: notificationMargin,
          child: AnimatedScale(
            duration: const Duration(milliseconds: 300),
            scale: getScale(),
            alignment: Alignment.bottomCenter,
            child: Material(
              color: Colors.transparent,
              child: this,
            ),
          ),
        );
      },
    );
  }

  @override
  ElegantNotificationState createState() => ElegantNotificationState();
}

class ElegantNotificationState extends State<ElegantNotification>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget._closeTimer = Timer(widget.toastDuration, () {
      widget._slideController.reverse();
      widget._slideController.addListener(() {
        if (widget._slideController.isDismissed) {
          widget.onProgressFinished?.call();
          widget.closeOverlay();
        }
      });
    });
    if (!widget.autoDismiss) {
      widget._closeTimer.cancel();
    }
    _initializeAnimation();
  }

  void _initializeAnimation() {
    widget._slideController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    widget._offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 4),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: widget._slideController,
        curve: widget.animationCurve,
      ),
    );

    /// ! To support Flutter < 3.0.0
    /// This allows a value of type T or T?
    /// to be treated as a value of type T?.
    ///
    /// We use this so that APIs that have become
    /// non-nullable can still be used with `!` and `?`
    /// to support older versions of the API as well.
    T? ambiguate<T>(T? value) => value;

    ambiguate(WidgetsBinding.instance)?.addPostFrameCallback(
      (_) => widget._slideController.forward(),
    );
  }

  void closeNotification() {
    widget.onCloseButtonPressed?.call();
    widget._closeTimer.cancel();
    widget._slideController.reverse();
    widget.onDismiss?.call();
    widget.closeOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: widget._offsetAnimation,
      child: Dismissible(
        key: widget.uniqueKey,
        direction: widget.isDismissable
            ? widget.dismissDirection
            : DismissDirection.none,
        onDismissed: (direction) {
          widget.onDismiss?.call();
          widget.closeOverlay();
        },
        child: InkWell(
          onTap: widget.onNotificationPressed,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(5.0),
              border: widget.border,
              color: widget.background,
              boxShadow: [
                widget.shadow ?? const BoxShadow(),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ToastContent(
                    title: widget.title,
                    description: widget.description,
                    notificationType: widget._notificationType,
                    icon: widget.icon,
                    displayCloseButton: widget.onNotificationPressed == null
                        ? widget.displayCloseButton
                        : false,
                    closeButton: widget.closeButton,
                    onCloseButtonPressed: closeNotification,
                    iconSize: widget.iconSize,
                    action: widget.action,
                  ),
                ),
                if (widget.showProgressIndicator)
                  Padding(
                    padding:
                        widget.progressBarPadding ?? const EdgeInsets.all(0),
                    child: SizedBox(
                      width: widget.progressBarWidth,
                      height: widget.progressBarHeight,
                      child: AnimatedProgressBar(
                        foregroundColor: widget.progressIndicatorColor,
                        duration: widget.toastDuration,
                        backgroundColor: widget.progressIndicatorBackground,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget._slideController.dispose();
    widget._closeTimer.cancel();
    super.dispose();
  }
}
