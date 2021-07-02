import 'package:aewebshop/model/product.dart';
import 'package:aewebshop/routes.dart';
import 'package:aewebshop/screens/widget/nav_bar.dart';
import 'package:aewebshop/widgets/custom_btn.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'constants/sizes.dart';
import 'controllers/cart_controller.dart';
import 'controllers/user_controller.dart';
import 'controllers/order_controller.dart';

class DetailWidget extends StatefulWidget {
  DetailWidget({
    Key key,
    @required this.productId,
  }) : super(key: key);
  String productId;

  @override
  _DetailWidgetState createState() => _DetailWidgetState();
}

class _DetailWidgetState extends State<DetailWidget> {
  var i = 0;
  UserController userController = Get.find();
  List<String> arrayList;
  String naziv;
  String marka;
  String model;
  String katBr;
  String price;
  String cijena;
  String kolicina;
  String lokacija;
  String opis;
  ProductDetailModel productModel;
  CartController cartController = Get.find();
  OrderController orderController = Get.find();
  @override
  void initState() {
    super.initState();
    getProduct();
  }

  getProduct() async {
    try {
      BotToast.showLoading();
      final result = await cartController.getProductDetails(widget.productId);

      if (result == null) {
        Get.defaultDialog(
            title: "Artikal nije pronađen.",
            content: Text("Artikal sa ID " +
                (widget.productId?.toString() ?? " no id ") +
                " nije pronađen"));
        Get.toNamed(Flurorouter.shop);
        return;
      } else {
        if (mounted)
          setState(() {
            this.productModel = result;
          });
      }
    } catch (e) {
      Get.defaultDialog(
          title: "Artikal nije pronađen.",
          content: Text("Artikal sa ID " +
              (widget.productId?.toString() ?? " no id ") +
              " nije pronađen"));
      Get.toNamed(Flurorouter.shop);
      return;
    }

    BotToast.closeAllLoading();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final screenSize = WindowSizes.size(width);
    return Title(
      color: Colors.red[800],
      title: this.productModel?.name ?? "product",
      child: Scaffold(
          backgroundColor: Colors.white,
          drawer: screenSize == Sizes.Large
              ? null
              : NavBar(
                  size: screenSize,
                ),
          appBar: screenSize == Sizes.Large
              ? null
              : AppBar(
                  title: Text(
                    'Detaljnije o artiklu',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  centerTitle: true,
                  elevation: 0.0,
                  backgroundColor: screenSize == Sizes.Large
                      ? Colors.white
                      : Colors.red[800],
                ),
          body: this.productModel == null
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.red[800],
                  ),
                )
              : Stack(
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height - 100,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: screenSize == Sizes.Large
                                    ? 150
                                    : screenSize == Sizes.Medium
                                        ? 50
                                        : 10,
                              ),
                              Flex(
                                direction: screenSize == Sizes.Large
                                    ? Axis.horizontal
                                    : Axis.vertical,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: screenSize == Sizes.Large
                                            ? 100
                                            : 0),
                                    child: Column(
                                      children: [
                                        Container(
                                          child: Center(
                                              child: Image.network(
                                                  this.productModel.images[i],
                                                  fit: BoxFit.cover,
                                                  width: 500)),
                                        ),
                                        Container(
                                          width: 500,
                                          height: 100,
                                          child: CarouselSlider(
                                            options: CarouselOptions(
                                              scrollDirection: Axis.horizontal,
                                              enableInfiniteScroll: false,
                                              viewportFraction: 0.2,
                                            ),
                                            items: this
                                                .productModel
                                                .images
                                                .map((item) => Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            i = this
                                                                .productModel
                                                                .images
                                                                .indexOf(item);
                                                          });
                                                        },
                                                        child: Container(
                                                          child: Opacity(
                                                            opacity: i ==
                                                                    this
                                                                        .productModel
                                                                        .images
                                                                        .indexOf(
                                                                            item)
                                                                ? 0.5
                                                                : 1,
                                                            child: Center(
                                                                child: Image.network(
                                                                    item,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    width:
                                                                        100)),
                                                          ),
                                                        ),
                                                      ),
                                                    ))
                                                .toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: screenSize == Sizes.Large
                                            ? 100
                                            : 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 20.0),
                                            Center(
                                              child: Text(
                                                "${this.productModel.naziv}",
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.clip,
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(height: 50),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Marka : ",
                                                  textAlign: TextAlign.center,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: screenSize ==
                                                            Sizes.Large
                                                        ? 18.0
                                                        : 14,
                                                  ),
                                                ),
                                                Text(
                                                  " ${this.productModel.marka}",
                                                  textAlign: TextAlign.center,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                    fontSize: screenSize ==
                                                            Sizes.Large
                                                        ? 18.0
                                                        : 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 30),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Model :  ",
                                                  textAlign: TextAlign.center,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                      fontSize: screenSize ==
                                                              Sizes.Large
                                                          ? 18.0
                                                          : 14,
                                                      color: Colors.grey),
                                                ),
                                                Text(
                                                  "${this.productModel.model}",
                                                  textAlign: TextAlign.center,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                    fontSize: screenSize ==
                                                            Sizes.Large
                                                        ? 18.0
                                                        : 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 30),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Kataloski broj :  ",
                                                  textAlign: TextAlign.center,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                      fontSize: screenSize ==
                                                              Sizes.Large
                                                          ? 18.0
                                                          : 14,
                                                      color: Colors.grey),
                                                ),
                                                Text(
                                                  "${this.productModel.katBr}",
                                                  textAlign: TextAlign.center,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                    fontSize: screenSize ==
                                                            Sizes.Large
                                                        ? 18.0
                                                        : 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 30),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Opis :  ",
                                                  textAlign: TextAlign.center,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                      fontSize: screenSize ==
                                                              Sizes.Large
                                                          ? 18.0
                                                          : 14,
                                                      color: Colors.grey),
                                                ),
                                                Text(
                                                  "${this.productModel.opis}",
                                                  textAlign: TextAlign.center,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                    fontSize: screenSize ==
                                                            Sizes.Large
                                                        ? 18.0
                                                        : 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 20.0),
                                          ],
                                        ),
                                        Divider(
                                          color: Colors.grey,
                                          thickness: 0.5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Cijena : ",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize:
                                                      screenSize == Sizes.Large
                                                          ? 18.0
                                                          : 14,
                                                  color: Colors.grey),
                                            ),
                                            Text(
                                              this.productModel.cijena == "1"
                                                  ? "Po dogovoru"
                                                  : "${this.productModel.cijena} KM",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize:
                                                    screenSize == Sizes.Large
                                                        ? 18.0
                                                        : 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 30.0),
                                        Center(
                                          child: CustomButton(
                                              bgColor: Colors.red[800],
                                              onTap: () {
                                                print(this.productModel.id);
                                                cartController.addProductToCart(
                                                    this.productModel);
                                                orderController.requestPrice(productModel: this.productModel);
                                              },
                                              text: ("Dodaj artikal u korpu")),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                    if (screenSize == Sizes.Large)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: NavBar(
                          // this is to make login button round on the left when background color is white so it looks more beautiful
                          roundLoginButton: true,
                          color: Colors.white,
                        ),
                      ),
                  ],
                )),
    );
  }
}
