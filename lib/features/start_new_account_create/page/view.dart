import "dart:ui";

import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/components/components.dart";

class StartNewAccountCreateView extends StatelessWidget {
  const StartNewAccountCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // -> appbar
          const AppBarComponent(title: "Новый счет"),

          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: 15.w,
              vertical: 20.h,
            ),
            sliver: SliverToBoxAdapter(
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // -> title
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Название счета",
                      ),
                    ),
                    const RSizedBox(height: 10.0),

                    // -> type
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Тип счета",
                      ),
                    ),
                    const RSizedBox(height: 10.0),

                    // -> currency
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Валюта",
                      ),
                    ),
                    const RSizedBox(height: 10.0),

                    // -> balance
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Текущий баланс",
                      ),
                    ),
                    const RSizedBox(height: 10.0),

                    // -> submit
                    FilledButton(
                      onPressed: () {},
                      child: Text("Создать"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
