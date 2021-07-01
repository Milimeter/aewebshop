import 'package:aewebshop/constants/sizes.dart';
import 'package:aewebshop/controllers/user_controller.dart';
import 'package:aewebshop/screens/widget/nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserOrder extends StatefulWidget {
  @override
  _UserOrderState createState() => _UserOrderState();
}

class _UserOrderState extends State<UserOrder> {
  UserController _userController = Get.find();

  @override
  void initState() {
    super.initState();
    if (_userController.userData.value.name == null) {}
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final width = MediaQuery.of(context).size.width;
    final screenSize = WindowSizes.size(width);
    return Title(
      color: Colors.red[100],
      title: "Narudžbe - AE Web shop",
      child: Stack(
        children: [
          Scaffold(
            appBar: screenSize == Sizes.Large
                ? null
                : AppBar(
                    backgroundColor: Colors.red[800],
                    elevation: 0.0,
                    // leading: IconButton(
                    //   icon: Icon(Icons.arrow_back, color: Colors.black),
                    //   onPressed: () => Get.back(),
                    // ),
                    centerTitle: true,
                    title: Text("N A R U DŽ B E",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                  ),
            drawer: screenSize == Sizes.Large
                ? null
                : NavBar(
                    size: screenSize,
                  ),
            body: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: screenSize == Sizes.Large ? 100 : 20),
              child: Container(
                height: size.height,
                width: size.width,
                child: StreamBuilder<QuerySnapshot>(
                    // <2> Pass `Stream<QuerySnapshot>` to stream
                    stream: FirebaseFirestore.instance
                        .collection('orders')
                        // .orderBy("timestamp", descending: true)
                        .where("id",
                            isEqualTo:
                                _userController?.userData?.value?.id ?? "")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.docs.length == 0) {
                          return Center(child: Text("Vaša lista narudžbi je prazna."));
                        } else {
                          return ListView.separated(
                            separatorBuilder: (_, __) => Divider(
                              color: Colors.grey[400],
                              height: 5,
                              indent: 10.0,
                              thickness: 0.5,
                            ),
                            itemCount: snapshot.data.docs.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              print(snapshot.data.docs[index].data());
                              // return postThread(
                              //   title: snapshot.data.docs[index].data()["Title"],
                              //   description:
                              //       snapshot.data.docs[index].data()["Description"],
                              // );
                              return orderThread(
                                  snapshot.data.docs[index].data(),
                                  index,
                                  context);
                            },
                          );
                        }
                      } else if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ),
            ),
          ),
          if (screenSize == Sizes.Large)
            Positioned(
              top: 0,
              right: 0,
              child: NavBar(
                roundLoginButton: true,
                color: Colors.transparent,
              ),
            ),
        ],
      ),
    );
  }

  Widget setupAlertDialoadContainer(List items) {
    return items != null
        ? Container(
            height: 500.0, // Change as per your requirement
            width: Get.width * 0.7, // Change as per your requirement
            child: ListView.separated(
              separatorBuilder: (_, __) => Divider(
                color: Colors.grey[400],
                height: 5,
                indent: 10.0,
                thickness: 0.5,
              ),
              shrinkWrap: true,
              itemCount: items?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return items[index].keys.length == 0
                    ? Text("no items")
                    : ListTile(
                        leading: Image.network(items[index]["image"] ?? ""),
                        subtitle: items[index]["price"].toString()=="1" 
                        ?Text(
                          ("Cijena po dogovoru"),
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize:
                                  WindowSizes.size(Get.width) == Sizes.Large
                                      ? 15
                                      : 12),
                        )
                        :Text(
                          ("Cijena : " + items[index]["price"].toString()
                                  + "KM"),
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize:
                                  WindowSizes.size(Get.width) == Sizes.Large
                                      ? 15
                                      : 12),
                        ), 
                        title: Text(items[index]["name"] ?? "",
                            style: TextStyle(
                                fontSize:
                                    WindowSizes.size(Get.width) == Sizes.Large
                                        ? 18
                                        : 14,
                                fontWeight: FontWeight.bold)),
                      );
              },
            ),
          )
        : Center(child: Text("Nema artikala."));
  }

  Widget orderThread(Map<String, dynamic> data, int index, context) {
    return Container(
        child: Column(
      children: [
        ListTile(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'Podaci o narudžbi',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    content: setupAlertDialoadContainer(data["itemsInfo"]),
                  );
                });
          },
          leading: CircleAvatar(
            backgroundColor: Colors.red[800],
            radius: 20,
            child: Text(index.toString()),
          ),
          title: Text(/*data["name"]*/"Narudžba #" + index.toString(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          //subtitle: Text(data["orderPrice"],
            //  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          trailing: Text(data["status"],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Divider(),
        ),
      ],
    ));
  }
}
