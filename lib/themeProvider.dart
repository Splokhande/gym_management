
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';


class DarkThemePreference {
  static const THEME_STATUS = "THEMESTATUS";
  SharedPreferences prefs;
  setDarkTheme(bool value) async {
     prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_STATUS) ?? false;
  }
}

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();
  bool _darkTheme = false;
  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    // notifyListeners();
  }

}

class Styles {

  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    MaterialColor colorCustom = MaterialColor(0xffB41A18, {
      50:Color.fromRGBO(180,26,24, .1),
      100:Color.fromRGBO(180,26,24, .2),
      200:Color.fromRGBO(180,26,24, .3),
      300:Color.fromRGBO(180,26,24, .4),
      400:Color.fromRGBO(180,26,24, .5),
      500:Color.fromRGBO(180,26,24, .6),
      600:Color.fromRGBO(180,26,24, .7),
      700:Color.fromRGBO(180,26,24, .8),
      800:Color.fromRGBO(180,26,24, .9),
      900:Color.fromRGBO(180,26,24, 1),
    });
    return ThemeData(
      primarySwatch: colorCustom,
      primaryColor: isDarkTheme ? Theme.of(context).backgroundColor: Color.fromRGBO(180,26,24, 1),
      primaryColorLight: Colors.red.withOpacity(0.6),
      backgroundColor: isDarkTheme ? Colors.black : Color(0xffffffff),

      cardColor: isDarkTheme ? Color(0xFF151515) : Color(0xffffffff),
      canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      secondaryHeaderColor: isDarkTheme ? Theme.of(context).backgroundColor:Color(0xffEC3237),
      buttonTheme: Theme.of(context).buttonTheme.copyWith(colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
      fontFamily: 'Futura Bk BT',
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(elevation: 0.0),

    );
  }
}