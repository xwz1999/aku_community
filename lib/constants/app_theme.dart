import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(primarySwatch: Colors.blue).copyWith(
      progressIndicatorTheme:
      ProgressIndicatorThemeData(color: Color(0xFFFFD000)),
      primaryColor: Color(0xFFFFD000),
      textTheme: ThemeData.light().textTheme.copyWith(
          caption: TextStyle(
            fontSize: 28.sp,
            color: Color(0xFF333333),
          ),
          overline: TextStyle(
            fontSize: 32.sp,
            color: Color(0xFF333333),
          ),
          headline1: TextStyle(
            fontSize: 28.sp,
            color: Color(0xFF333333),
            fontWeight: FontWeight.bold,
          ),
          headline2: TextStyle(
            fontSize: 30.sp,
            color: Color(0xFF333333),
            fontWeight: FontWeight.bold,
          ),
          headline3: TextStyle(
            fontSize: 32.sp,
            color: Color(0xFF333333),
            fontWeight: FontWeight.bold,
          ),
          headline4: TextStyle(
            fontSize: 36.sp,
            color: Color(0xFF333333),
            fontWeight: FontWeight.bold,
          ),
          headline5: TextStyle(
            fontSize: 40.sp,
            color: Color(0xFF333333),
            fontWeight: FontWeight.bold,
          ),
          subtitle1: TextStyle(
            fontSize: 32.sp,
            color: Color(0xFF333333),
          ),
          subtitle2: TextStyle(
            fontSize: 28.sp,
            color: Color(0xFF333333),
          ),
          bodyText1: TextStyle(
            fontSize: 24.sp,
            color: Color(0xFF333333),
          ),
          bodyText2: TextStyle(
            fontSize: 28.sp,
            color: Color(0xFF333333),
          ),
          button: TextStyle(
            fontSize: 28.sp,
            color: Color(0xFF333333),
          )),
      floatingActionButtonTheme: FloatingActionButtonThemeData().copyWith(
        backgroundColor: Color(0xFFFFD000),
      ),
      appBarTheme: AppBarTheme().copyWith(
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Color(0xFF333333),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        toolbarTextStyle: TextTheme(
          headline6: TextStyle(
            color: Color(0xFF333333),
            fontSize: 36.sp,
            fontWeight: FontWeight.bold,
          ),
        ).bodyText2,
        titleTextStyle: TextTheme(
          headline3: TextStyle(
            color: Color(0xFF333333),
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
          ),
        ).headline3,
      ),
      tabBarTheme: TabBarTheme().copyWith(
        labelColor: Color(0xFF333333),
        labelStyle: TextStyle(
          fontSize: 30.sp,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle:
        TextStyle(fontSize: 28.sp, fontWeight: FontWeight.normal),
        indicatorSize: TabBarIndicatorSize.label,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData().copyWith(
        selectedItemColor: Color(0xFF333333),
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        type: BottomNavigationBarType.fixed,
        unselectedLabelStyle: TextStyle(),
      ),
      radioTheme: RadioThemeData().copyWith(
        fillColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.selected)) return Color(0xFFFFD000);
          return null;
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled))
              return Color(0xFFFFF4D7);
            return Color(0xFFFFD000);
          }),
          elevation: MaterialStateProperty.all(0),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled))
              return Color(0xFF666666);
            return Color(0xFF333333);
          }),
          textStyle: MaterialStateProperty.all(TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
          )),
          padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(horizontal: 76.w, vertical: 22.w),
          ),
          enableFeedback: true,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled))
              return Color(0xFFFFF4D7);
            return Color(0xFFFFD000).withOpacity(0.2);
          }),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled))
              return Color(0xFF666666);
            return Color(0xFF333333);
          }),
        ),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      dividerColor: Color(0xFFE8E8E8),
      colorScheme:
      ColorScheme.fromSwatch().copyWith(secondary: Color(0xFFFFD000)),
    );
  }
}

class SystemStyle {
  static const initial = SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
  );

  static const yellowBottomBar = SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFFFFD000),
  );

  static genStyle({required Color bottom}) {
    return SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: bottom,
    );
  }
}
