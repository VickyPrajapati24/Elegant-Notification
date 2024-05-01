import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: ExampleApp(),
      ),
    );
  }
}

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var title = 'Update Update';
    var desc = 'data has been Your data has ';
    TextStyle titleStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    TextStyle descStyle = TextStyle(fontSize: 14);
    return SafeArea(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    ElegantNotification.success(
                      isDismissable: true,
                      displayCloseButton: true,
                      animationCurve: Curves.linear,
                      title: Text(
                        title,
                        style: titleStyle,
                      ),
                      description: Text(
                        desc,
                        style: descStyle,
                      ),
                      onDismiss: () {},
                      notificationMargin: 40,
                      shadow: BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 4),
                      ),
                    ).show(context);
                  },
                  child: Container(
                    width: 150,
                    height: 100,
                    color: Colors.blue,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Notification with action\n(bottom left)',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
