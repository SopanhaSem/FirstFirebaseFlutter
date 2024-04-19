import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_setup/src/view/auth/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CollectionReference dataRef = FirebaseFirestore.instance.collection("Course");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
          CupertinoButton(
            child: Text(
              "Log Out",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut().whenComplete(() =>
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false));
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: dataRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // ignore: prefer_const_constructors
            return Center(
              child: const Icon(
                Icons.info,
                color: Colors.red,
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.separated(
                itemBuilder: (context, index) {
                  var data =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  return courseCard(data: data);
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: snapshot.data!.docs.length);
          }
        },
      ),
    );
  }
}

Widget courseCard({required Map data}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      child: Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CachedNetworkImage(
              height: 120,
              width: 120,
              imageUrl: data['Img'],
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress)),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data['Name'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "\$ ${double.parse(data['Price'].toString())}",
                  style: const TextStyle(color: Colors.red),
                )
              ],
            )
          ],
        ),
      ),
    ),
  );
}
