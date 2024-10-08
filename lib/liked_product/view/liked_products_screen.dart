import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../product_detail/view/product_deatail_screen.dart';

class LikedProductsScreen extends StatefulWidget {
  const LikedProductsScreen({Key? key}) : super(key: key);

  @override
  State<LikedProductsScreen> createState() => _LikedProductsScreenState();
}

class _LikedProductsScreenState extends State<LikedProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite items",
            style:
                Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 18)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.chevron_left)),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs != null && snapshot.data!.docs.isNotEmpty) {
            Map userData = snapshot.data!.docs.first.data();
            List likedProducts = [];
            likedProducts = userData["liked_products"];
            return Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('products')
                      .where("id", whereIn: likedProducts)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.data!.docs != null &&
                        snapshot.data!.docs.isNotEmpty) {
                      return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.315,
                          width: MediaQuery.of(context).size.width,
                          child: ListView(
                            scrollDirection: Axis.vertical,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> productData =
                                  document.data()! as Map<String, dynamic>;
                              return ListTile(
                                title: Text(productData["product_name"]),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ProductDetailScreen(
                                          productData: productData)));
                                },
                              );
                            }).toList(),
                          ));
                    } else {
                      return Center(child: Text("No liked products found"));
                    }
                  },
                ),
              ],
            );
          } else {
            return Center(child: Text("No liked products found"));
          }
        },
      ),
    );
  }
}
