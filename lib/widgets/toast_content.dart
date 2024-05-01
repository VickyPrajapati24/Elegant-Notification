import 'package:elegant_notification/resources/extensions.dart';
import 'package:flutter/material.dart';

import '../resources/colors.dart';

class ToastContent extends StatelessWidget {
  const ToastContent({
    Key? key,
    this.title,
    required this.description,
    required this.notificationType,
    required this.displayCloseButton,
    required this.onCloseButtonPressed,
    this.closeButton,
    this.icon,
    this.iconSize = 20,
    this.action,
  }) : super(key: key);

  final Widget? title;
  final Widget description;
  final Widget? icon;
  final double iconSize;
  final NotificationType notificationType;
  final void Function() onCloseButtonPressed;
  final bool displayCloseButton;
  final Widget Function(void Function() dismissNotification)? closeButton;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    const verticalComponentPadding = 20.0;
    // const defaultIconSize = 20.0;
    const horizontalComponentPadding = 10.0;
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: horizontalComponentPadding),
          child: _getNotificationIcon(),
        ),
        const SizedBox(
          width: 15,
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 20,
            bottom: 20,
          ),
          child: Container(
            width: 1,
            color: greyColor,
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (title != null) ...[
                title!,
                const SizedBox(
                  height: 5,
                ),
              ],
              description,
              if (action != null) ...[
                const SizedBox(
                  height: 5,
                ),
                action!,
              ],
            ],
          ),
        ),
        Visibility(
          visible: displayCloseButton,
          child: closeButton?.call(onCloseButtonPressed) ??
              InkWell(
                onTap: () {
                  onCloseButtonPressed.call();
                },
                child: const Padding(
                  padding: EdgeInsets.only(
                    top: verticalComponentPadding,
                    right: horizontalComponentPadding,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.close,
                        color: greyColor,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
        ),
      ],
    );
  }

  Widget _getNotificationIcon() {
    switch (notificationType) {
      case NotificationType.success:
        return _renderImage('assets/icons/success.png');
      case NotificationType.error:
        return _renderImage('assets/icons/error.png');
      case NotificationType.info:
        return _renderImage('assets/icons/info.png');
      default:
        return icon!;
    }
  }

  Image _renderImage(String imageAsset) {
    return Image(
      image: AssetImage(imageAsset, package: 'elegant_notification'),
      width: iconSize,
    );
  }
}
