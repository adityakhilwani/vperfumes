import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vperfumes/home/view/banner_widget.dart';
import 'package:vperfumes/utlils/colors.dart';
import 'package:vperfumes/utlils/size_constants.dart';
import '../../search/view/search_screen.dart';
import 'drawer_widget.dart';
import 'homepage_display_item.dart';
import 'homepage_display_products_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.scaffoldBackgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Row(
          children: [
            Text(
              "Hi, ",
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  ?.copyWith(color: Colors.grey, fontSize: 14),
            ),
            Text(
              FirebaseAuth.instance.currentUser?.displayName!.split(" ")[0] ??
                  "",
              style: Theme.of(context)
                  .textTheme
                  .headline2
                  ?.copyWith(color: Colors.black),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchScreen(),
                    ));
              },
              icon: Icon(Icons.search))
        ],
        elevation: 1,
        backgroundColor: Colors.white,
      ),
      drawer: customDrawer(context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const BannerCrousel(),
            HomepageDisplayProducts(productListName: "Featured Perfume"),
            HomepageDisplayProducts(
                productListName: "Men's Perfume", categoryName: "men"),
            HomepageDisplayProducts(
                productListName: "Women's Perfume", categoryName: "women"),
            HomepageDisplayProducts(
                productListName: "Child Perfume", categoryName: "child"),
          ],
        ),
      ),
    );
  }
}
