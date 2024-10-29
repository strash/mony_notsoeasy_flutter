import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 100,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Text(
              "Some cool item $index right there and there",
            ),
          );
        },
      ),
    );
  }
}
