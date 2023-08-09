import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

class ToDoTheme {
  static late bool isDark;

  static setPrefTheme(bool theme) => isDark = theme;

  static ThemeMode currentTheme() {
    return (isDark) ? ThemeMode.dark : ThemeMode.light;
  }

  static void switchTheme() {
    isDark = !isDark;
  }

  static final ThemeData lightTheme = FlexThemeData.light(
    scheme: FlexScheme.cyanM3,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 7,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 10,
      blendOnColors: false,
      useTextTheme: true,
      useM2StyleDividerInM3: true,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    swapLegacyOnMaterial3: true,
    // To use the Playground font, add GoogleFonts package and uncomment
    fontFamily: GoogleFonts.viga().fontFamily,
  );

  static final ThemeData darkTheme = FlexThemeData.dark(
    scheme: FlexScheme.cyanM3,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 13,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 20,
      useTextTheme: true,
      useM2StyleDividerInM3: true,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    swapLegacyOnMaterial3: true,
    fontFamily: GoogleFonts.viga().fontFamily,
  );
}

/**return base.copyWith(
    //colorScheme: lightColorScheme,
    //primaryColor: lightColorScheme.primary,
    //scaffoldBackgroundColor: lightColorScheme.background,
    textTheme: Typography.whiteHelsinki.apply(fontFamily: 'Viga'),
    elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(
      //backgroundColor: MaterialStateProperty.all(lightColorScheme.onPrimary),
      elevation: MaterialStateProperty.all(3.0),
      textStyle: MaterialStateProperty.all(const TextStyle(/*color: lightColorScheme.secondary*/fontSize: 16.0,fontWeight: FontWeight.bold, fontFamily: 'Viga')),
      //foregroundColor: MaterialStateProperty.all(lightColorScheme.secondary),
      minimumSize: MaterialStateProperty.all(const Size(120.0,50.0)),
      //overlayColor: MaterialStateProperty.all(Colors.grey),
    )),
    appBarTheme: const AppBarTheme(
      //backgroundColor: lightColorScheme.primary,
      titleTextStyle: TextStyle(/*color: lightColorScheme.onPrimary*/fontSize: 25.0, fontWeight: FontWeight.bold),
      elevation: 3.0
    ),
    textSelectionTheme: const TextSelectionThemeData(
      //selectionHandleColor: lightColorScheme.secondary
    )
  );**/
