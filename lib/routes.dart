import 'package:flutter/material.dart';
import 'package:paldes/User_module/screens/Auth/registration.dart';
import 'package:paldes/User_module/screens/Home/BottomScreen/Home/home.dart';
import 'package:paldes/User_module/screens/Auth/login.dart';
import 'package:paldes/User_module/screens/splash.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        if (args is int) {
          return MaterialPageRoute(
            builder: (_) =>  HomePage(data: 0,),
          );
        }
        return _errorRoute();
        break;

      case '/selectBranch':
          return MaterialPageRoute(
            builder: (_) =>  SelectBranch(),
          );
            break;

      case '/home':
          return MaterialPageRoute(
            builder: (_) =>  Home(),
          );
          break;

      case '/regScreen':
          return MaterialPageRoute(
            builder: (_) =>  RegScreen(),
          );
          break;

      case '/login':
      // Validation of correct data type
        return
          // MaterialPageRoute(builder: (_) =>PhoneNumber());
        PageRouteBuilder (transitionDuration: Duration(milliseconds: 2500),
            pageBuilder: (
                BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return PhoneNumber();
            },
            transitionsBuilder: (
                BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return Align(
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            }
        );
        break;
        // If args is not of the correct type, return an error page.
        // You can also throw an exception while in development.

      case '/splash':
        return MaterialPageRoute(builder: (_) =>SplashScreen());
        break;

      default:
      // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
        break;
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}