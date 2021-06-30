import 'package:aewebshop/controllers/user_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserOrder extends StatelessWidget {
  UserController _userController = Get.find();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text("O R D E R S",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .where("id", isEqualTo: _userController.userData.value.id)
                .orderBy("timestamp", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.docs.length == 0) {
                  return Center(child: Text("No order at the moment"));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      print(snapshot.data.docs[index].data());
                      print("===========================");
                      print(snapshot.data.docs[index].data()["itemsInfo"]);

                      return orderThread(
                        status: snapshot.data.docs[index].data()["status"],
                        itemsInfo:
                            snapshot.data.docs[index].data()["itemsInfo"],
                        price: snapshot.data.docs[index].data()["price"],
                      );
                    },
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }

  Widget orderThread({String status, List itemsInfo, String price}) {
    print(itemsInfo[0]["name"]);
    //Text(item["name"])
    return Column(
      children: itemsInfo
          .map(
            (item) => new ListTile(
              leading: Icon(Icons.notification_important),
              title: Text(item["name"]),
              subtitle: Text(status),
              trailing: Text(price ?? ""),
            ),
          )
          .toList(),
    );
    // return Container(
    //     child: Column(
    //   children: [
    // ListTile(
    //   leading: Icon(Icons.notification_important),
    //   title: Text(itemsInfo[0]["name"]),
    //   subtitle: Text(""),
    //   trailing: Text(status),
    // ),
    //     Padding(
    //       padding: const EdgeInsets.only(left: 10.0, right: 10.0),
    //       child: Divider(),
    //     ),
    //   ],
    // ));
  }
}
