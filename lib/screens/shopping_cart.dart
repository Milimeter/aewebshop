import 'dart:convert';

import 'package:aewebshop/constants/sizes.dart';
import 'package:aewebshop/controllers/cart_controller.dart';
import 'package:aewebshop/controllers/order_controller.dart';
import 'package:aewebshop/controllers/user_controller.dart';
import 'package:aewebshop/screens/widget/nav_bar.dart';
import 'package:aewebshop/widgets/custom_btn.dart';
import 'package:aewebshop/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShoppingCartWidget extends StatelessWidget {
  final CartController cartController = Get.find();
  final UserController userController = Get.find();
  final OrderController orderController = Get.find();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final screenSize = WindowSizes.size(width);
    return Title(
      color: Colors.red[800],
      title: "Korpa",
      child: Scaffold(
        drawer: screenSize == Sizes.Large
            ? null
            : NavBar(
                size: screenSize,
              ),
        appBar: screenSize == Sizes.Large
            ? null
            : AppBar(
                title: Text(
                  'K O R P A',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                elevation: 0.0,
                backgroundColor:
                    screenSize == Sizes.Large ? Colors.white : Colors.red[800],
              ),
        body: Stack(
          children: [
            ListView(
              children: [
                SizedBox(
                  height: screenSize == Sizes.Large ? 60 : 5,
                ),
                Container(
                  child: Flex(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    direction: screenSize == Sizes.Large
                        ? Axis.horizontal
                        : Axis.vertical,
                    children: [
                      Obx(
                        () => Container(
                          width: screenSize == Sizes.Large
                              ? Get.width * 0.6
                              : Get.width,
                          child: DataTable(
                            dataRowHeight: screenSize == Sizes.Large ? 100 : 50,
                            sortAscending: false,
                            columnSpacing: screenSize == Sizes.Large ? 20 : 6,
                            columns: [
                              DataColumn(
                                  label: Center(
                                child: Text("Artikal",
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                        fontSize: screenSize == Sizes.Large
                                            ? 20
                                            : 10)),
                              )),
                              DataColumn(
                                  label: Center(
                                child: Text("Naziv artikla",
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                        fontSize: screenSize == Sizes.Large
                                            ? 20
                                            : 10)),
                              )),
                              DataColumn(
                                  label: Center(
                                child: Text("Cijena",
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                        fontSize: screenSize == Sizes.Large
                                            ? 20
                                            : 10)),
                              )),
                              DataColumn(
                                  label: Center(
                                child: Text("Brisanje",
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                        fontSize: screenSize == Sizes.Large
                                            ? 20
                                            : 10)),
                              )),
                            ],
                            rows: (userController.userData.value.cart ?? [])
                                .map(
                                  (cartItem) => DataRow(cells: <DataCell>[
                                    DataCell(
                                      Image.network(
                                        cartItem?.image ?? "",
                                        height: screenSize == Sizes.Large
                                            ? 100
                                            : 50,
                                        width: screenSize == Sizes.Large
                                            ? 120
                                            : 50,
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                          padding: EdgeInsets.only(
                                              right: screenSize == Sizes.Large
                                                  ? 1
                                                  : 0),
                                          child: CustomText(
                                            size: screenSize == Sizes.Large
                                                ? 20
                                                : 12,
                                            text: cartItem?.name,
                                          )),
                                    ),
                                    DataCell(
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: screenSize == Sizes.Large
                                                ? 25
                                                : 17),
                                        child: CustomText(
                                          size: screenSize == Sizes.Large
                                              ? 20
                                              : 12,
                                          text: cartItem.price.toString(),
                                          weight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: screenSize == Sizes.Large
                                                ? 17
                                                : 0),
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.remove,
                                              color: Colors.red,
                                              size: 30,
                                            ),
                                            onPressed: () {
                                              cartController
                                                  .removeCartItem(cartItem);
                                            }),
                                      ),
                                    ),
                                  ]),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height:
                            screenSize == Sizes.Large ? 0 : Get.height * 0.3,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Container(
                          height: screenSize == Sizes.Large ? 200 : 200,
                          width: screenSize == Sizes.Large ? 300 : Get.width,
                          color: Colors.grey.withOpacity(0.6),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CustomText(
                                size: screenSize == Sizes.Large ? 20 : 12,
                                text: "Iznos",
                                weight: FontWeight.bold,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  CustomText(
                                    size: screenSize == Sizes.Large ? 20 : 12,
                                    text: "Total Price",
                                  ),
                                  Obx(
                                    () => CustomText(
                                      size: screenSize == Sizes.Large ? 20 : 12,
                                      text:
                                          " (\$${cartController.totalCartPrice.value.toStringAsFixed(2) == 0.toString() ? "pending" : cartController.totalCartPrice.value.toStringAsFixed(2)})",
                                      weight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(8.0),
                                  child: Obx(
                                    () => CustomButton(
                                        text:
                                            "Order (\$${cartController?.totalCartPrice?.value?.toStringAsFixed(2) ?? ""})",
                                        onTap: () {
                                          // convert each item to a string by using JSON encoding
                                          final jsonList = userController
                                              .userData.value.cart
                                              .map((item) => jsonEncode(item))
                                              .toList();

                                          // using toSet - toList strategy
                                          final uniqueJsonList =
                                              jsonList.toSet().toList();

                                          // convert each item back to the original form using JSON decoding
                                          final myOrders = uniqueJsonList
                                              .map((item) => jsonDecode(item))
                                              .toList();
                                          print(myOrders);

                                          orderController.createOrder(
                                            itemInfo: myOrders,
                                            orderPrice: cartController
                                                .totalCartPrice.value
                                                .toStringAsFixed(2),
                                          );

                                          //paymentsController.createPaymentMethod();
                                        }),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (screenSize == Sizes.Large)
              Positioned(
                top: 0,
                right: 0,
                child: NavBar(
                  // this is to make login button round on the left when background color is white so it looks more beautiful
                  roundLoginButton: true,
                  color: Colors.white,
                ),
              )
          ],
        ),
      ),
    );
  }
}
