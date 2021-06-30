import 'package:aewebshop/controllers/cart_controller.dart';
import 'package:aewebshop/controllers/user_controller.dart';
import 'package:aewebshop/model/product.dart';
import 'package:aewebshop/screens/orders.dart';
import 'package:aewebshop/screens/profile.dart';
import 'package:aewebshop/screens/shopping_cart.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PregledArtikala extends StatefulWidget {
  @override
  _PregledArtikalaState createState() => _PregledArtikalaState();
}

class _PregledArtikalaState extends State<PregledArtikala> {
  //PaginateRefreshedChangeListener refreshChangeListener = PaginateRefreshedChangeListener();
  bool isSearching = false;
  var firebase =
      "https://frizerski-58338-default-rtdb.firebaseio.com/artikli.json";
  var hrana;
  bool isSearchtext = true;
  String searchtext = "";
  List<String> itemlist = [
    'Part Name',
    'Catalogue Number',
    'Car Brand',
    'Car Model'
  ];
  String selectedItem = "Part Name";
  String searchhint = "Search by Part Name";
  TextEditingController searchtextEditingController =
      new TextEditingController();

  get documentSnapshot => null;

  List<DocumentSnapshot> products = []; // stores fetched products

  bool isLoading = false; // track if products fetching

  bool hasMore = true; // flag for more products available or not

  int documentLimit = 10; // documents to be fetched per request

  DocumentSnapshot
      lastDocument; // flag for last document from where next 10 records to be fetched

  ScrollController _scrollController =
      ScrollController(); // listener for listview scrolling
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    //fetchData();
    //fetchDataFromFireStore();
    getProducts(searchtextEditingController.text.trim(), 's_name', false);

    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        String searchBy = "s_name";
        if (selectedItem == "Catalogue Number") {
          searchBy = "s_catalogue";
        } else if (selectedItem == "Car Brand") {
          searchBy = "s_model";
        } else if (selectedItem == "Car Model") {
          searchBy = "s_brand";
        }
        getProducts(searchtextEditingController.text.trim(), searchBy, false);
      }
    });
  }

  getProducts(
      String search_text, String search_type, bool hasSearchChanged) async {
    print("search text => " + search_text);
    print("search type => " + search_type);
    QuerySnapshot querySnapshot;

    if (search_text.length == 0) {
      if (!hasMore) {
        print('No More Products');
        return;
      }
      if (isLoading) {
        return;
      }
      setState(() {
        isLoading = true;
      });

      if (hasSearchChanged) {
        products = [];
      }
      if (lastDocument == null) {
        print('Initial DOC');
        querySnapshot = await firestore
            .collection('artikli')
            //.where(search_type, isGreaterThanOrEqualTo: search_text).where(search_type, isLessThanOrEqualTo: search_text+'z')
            .orderBy('s_name')
            .limit(documentLimit)
            .get();
      } else {
        print('Pagination DOC');
        querySnapshot = await firestore
            .collection('artikli')
            //.where(search_type, isGreaterThanOrEqualTo: search_text).where(search_type, isLessThanOrEqualTo: search_text+'z')
            .orderBy('s_name')
            .limit(documentLimit)
            .startAfterDocument(lastDocument)
            .get();
      }
    } else {
      if (hasSearchChanged) {
        lastDocument = null;
        products = [];
      } else {
        setState(() {
          isLoading = true;
        });
      }
      if (lastDocument == null) {
        print('SEARCH: Initial DOC');
        querySnapshot = await firestore
            .collection('artikli')
            .where(search_type,
                isGreaterThanOrEqualTo: search_text.toLowerCase())
            .where(search_type,
                isLessThanOrEqualTo: search_text.toLowerCase() + 'z')
            .orderBy(search_type)
            .limit(documentLimit)
            .get();
      } else {
        print('SEARCH: Pagination DOC');
        querySnapshot = await firestore
            .collection('artikli')
            .where(search_type,
                isGreaterThanOrEqualTo: search_text.toLowerCase())
            .where(search_type,
                isLessThanOrEqualTo: search_text.toLowerCase() + 'z')
            .orderBy(search_type)
            .limit(documentLimit)
            .startAfterDocument(lastDocument)
            .get();
      }
    }

    if (querySnapshot.docs.length < documentLimit) {
      hasMore = false;
      //lastDocument = null;
    }
    if (querySnapshot.docs.length > 0) {
      lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    }
    products.addAll(querySnapshot.docs);
    setState(() {
      isLoading = false;
    });
  }

  String _chosenValue;

  @override
  void dispose() {
    super.dispose();
  }

  onSearchTextchanged(String value) async {
    print("Inside ONCHANGE => " + value);
    String searchBy = "s_name";
    searchtext = value;
    if (searchtext.length == 0) {
      //Refresh all data
      isSearching = false;
      hasMore = true;
    } else {
      isSearching = true;
      //Query based on keyword
      if (selectedItem == "Catalogue Number") {
        searchBy = "s_catalogue";
      } else if (selectedItem == "Car Brand") {
        searchBy = "s_model";
      } else if (selectedItem == "Car Model") {
        searchBy = "s_brand";
      }
    }
    getProducts(value, searchBy, true);
  }

  CartController cartController = Get.find();
  UserController userController = Get.find();
  ProductModel productModel = ProductModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Pregled artikala',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                userController.userData.value.cart != null
                    ? showBarModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                          color: Colors.white,
                          child: ShoppingCartWidget(),
                        ),
                      )
                    : Get.snackbar(
                        "Notice!", "Cart is Empty, Add Item to view");
              }),
          IconButton(
            icon: Icon(Icons.notification_add, color: Colors.black),
            onPressed: ()=> Get.to(UserOrder()),
          ),
          IconButton(
            icon: Icon(Icons.person, color: Colors.black),
            onPressed: ()=> Get.to(ProfilePage()),
          ),
               Container(
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    child: Obx(
                      () => Text(
                        // _auth.isLogged ? _auth.userEmail : "Login",
                        userController.userData.value.name ?? "no name",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
        ],
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 40.0, right: 10.0),
                child: Container(
                  width: 400,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.white,
                      border: Border.all(color: Colors.red[800], width: 1.5)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint: Text('Please choose a type'),
                      isExpanded: true,
                      isDense: false,
                      iconEnabledColor: Colors.black,
                      underline: SizedBox(),
                      value: selectedItem,
                      onChanged: (newValue) {
                        setState(() {
                          selectedItem = newValue;
                          if (selectedItem == "Part Name") {
                            searchhint = "Search by Part Name";
                          } else if (selectedItem == "Catalogue Number") {
                            searchhint = "Search by Catalogue Number";
                          } else if (selectedItem == "Car Brand") {
                            searchhint = "Search by Car Brand";
                          } else if (selectedItem == "Car Model") {
                            searchhint = "Search by Car Model";
                          }
                          print(selectedItem);
                          searchtextEditingController.text = "";
                        });
                      },
                      items: itemlist.map((location) {
                        return DropdownMenuItem(
                          child: new Container(
                            child: Text(
                              location,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          value: location,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 40.0),
                child: Container(
                  width: 400,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.white,
                      border: Border.all(color: Colors.red[800], width: 1.5)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      focusColor: Colors.white,
                      value: _chosenValue,
                      //elevation: 5,
                      style: TextStyle(color: Colors.white),
                      iconEnabledColor: Colors.black,
                      items: <String>[
                        'ABS sistemi',
                        'Airbagovi',
                        'Akumulatori',
                        'Alnaseri',
                        'Alternatori',
                        'Amortizeri i opruge',
                        'Automobili u dijelvima',
                        'Autokozmetika',
                        'Auto klime',
                        'Branici karambolke i spojleri',
                        'Brave za paljenje i kljucevi',
                        'Blatobrani',
                        'Brisaci',
                        'Bobine',
                        'Bregaste osovine',
                        'CD\/DVD\/MC\/Radio player',
                        'Crijeva',
                        'Cepovi za felge',
                        'Dizne',
                        'Diskovi\/Plocice',
                        'Diferencijali',
                        'Dobosi tocka\/kocioni',
                        'Displej',
                        'Elektronika i Akustika',
                        'Farovi',
                        'Felge s gumama',
                        'Felge',
                        'Filteri',
                        'Gume',
                        'Glavcine',
                        'Glavamotora',
                        'Grijaci',
                        'Hladnjaci',
                        'Haube',
                        'Instrument table',
                        'Izduvni sistemi',
                        'Kilometar satovi',
                        'Kocioni cilindri',
                        'Kompresori',
                        'Kvacila i dijelovi istih',
                        'Kablovi i konektori',
                        'Karteri',
                        'Kineticki zglobovi',
                        'Kardan',
                        'Kozice mjenjaca',
                        'Krajnice',
                        'Karburatori',
                        'Kederi',
                        'Klipovi',
                        'Kuciste osiguraca',
                        'Limarija',
                        'Letve volana',
                        'Lajsne i pragovi',
                        'Lafete',
                        'Lazajevi',
                        'Lamele',
                        'Motori',
                        'Mjenjaci',
                        'Maske',
                        'Maglenke',
                        'Motorici i klapne grijanja',
                        'Nosaci motora\/mjenjaca',
                        'Navigacija\/GPS',
                        'Nosaci i koferi',
                        'Naslonjaci',
                        'Osovine\/Mostovi',
                        'Ostalo',
                        'Prekidaci',
                        'Pumpe',
                        'Podizaci stakala',
                        'Plastika',
                        'Patosnice\/Podmetaci',
                        'Posude za tecnosti',
                        'Papucice',
                        'Protokomjeri zraka',
                        'Pakne',
                        'Pojasevi sigurnosni',
                        'Retrovizori',
                        'Ratkape',
                        'Remenovi',
                        'Rucice mjenjaca',
                        'Releji',
                        'Rezervoari',
                        'Rucice brisaca - zmigavaca - tempomat',
                        'Razni prekidaci',
                        'Radio i oprema',
                        'Sajbe i prozori',
                        'Senzori',
                        'Sijalice',
                        'Sjedista',
                        'Spaneri\/Remenice',
                        'Sajle',
                        'Stabilizatori',
                        'Stopke',
                        'Spulne',
                        'Turbine',
                        'Tuning',
                        'Tapacirung',
                        'Termostati',
                        'Unutrasnji izgled',
                        'Usisne grane',
                        'Vrata',
                        'Ventilatori',
                        'Volani',
                        'Ventili',
                        'Zmigavci',
                        'Znakovi',
                        'Zvucnici',
                        'Zamajci',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              value,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ),
                        );
                      }).toList(),
                      hint: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Izaberite kategoriju dijela",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      onChanged: (String value) {
                        setState(() {
                          _chosenValue = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Center(
            child: Container(
              width: 820,
              height: 45,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.red[800], width: 1.5),
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              margin: EdgeInsets.only(left: 10, right: 10),
              child: ListTile(
                contentPadding:
                    EdgeInsets.only(left: 10.0, right: 10.0, bottom: 18.0),
                //contentPadding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 0.0),
                dense: true,
                horizontalTitleGap: -5.0,
                leading: Icon(Icons.search, color: Colors.grey, size: 24),
                title: TextField(
                  controller: searchtextEditingController,
                  maxLines: 1,
                  cursorColor: Colors.grey,
                  enabled: true,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: searchhint,
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  onChanged: (value) async {
                    onSearchTextchanged(value);
                  },
                  //onSubmitted: onSearchTextchanged,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                trailing: searchtext.toString().trim().length > 0
                    ? InkWell(
                        onTap: () {
                          setState(() {
                            searchtextEditingController.clear();
                            onSearchTextchanged('');
                            searchtext = "";
                          });
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.grey,
                          size: 24,
                        ),
                      )
                    : SizedBox(),
              ),
            ),
          ),
          SizedBox(height: 30),
          Expanded(
            child: //RefreshIndicator ( child:

                Column(children: [
              Expanded(
                  child: products.length == 0
                      ? Center(
                          child: isLoading
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(5),
                                  //color: Colors.yellowAccent,
                                  child: SpinKitFadingCircle(
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                )
                              : Text('No Data to display!'),
                        )
                      : Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width / 5,
                              right: MediaQuery.of(context).size.width / 5),
                          child: GridView.count(
                              controller: _scrollController,
                              crossAxisCount: 4,
                              children: new List<Widget>.generate(
                                  products.length, (index) {
                                String title = products[index].get("n");
                                String Sub_title = products[index].get("m");
                                String image_url = "";
                                List<String> array_list =
                                    List.from(products[index].get("u"));
                                if (array_list != null &&
                                    array_list.length > 0) {
                                      setState(() {
                                        image_url = array_list[0];
                                      });
                                  
                                }
                                return InkWell(
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 150,
                                          child: CachedNetworkImage(
                                            imageUrl: image_url,
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                SpinKitFadingCircle(
                                              color: Colors.red,
                                              size: 20,
                                            ),
                                            //placeholder: (context, url) => CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
                                        ),
                                        // FadeInImage(
                                        //   placeholder: AssetImage("assets/img/car.png"),
                                        //   image: NetworkImage(image_url),
                                        //   fit: BoxFit.cover,
                                        // ),),
                                        SizedBox(height: 20),
                                        // Text("${image_url}",
                                        //   textAlign: TextAlign.center,
                                        //   style: TextStyle(
                                        //     color : Colors.black,
                                        //     fontWeight: FontWeight.bold,
                                        //     fontSize: 17.0,
                                        //   ),),
                                        Text(
                                          "${title}",
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17.0,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "${Sub_title}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                  ),
                                  onTap: () {
                                    String naziv =
                                        products[index].get("n").toString();
                                    String marka =
                                        products[index].get("m").toString();
                                    String model =
                                        products[index].get("mo").toString();
                                    String katBr =
                                        products[index].get("kb").toString();
                                    String id =
                                        products[index].get("id").toString();
                                    String cijena =
                                        products[index].get("c").toString();
                                    String kolicina =
                                        products[index].get("ko").toString();
                                    String lokacija =
                                        products[index].get("l").toString();
                                    String opis =
                                        products[index].get("o").toString();

                                    List<String> array_list =
                                        List.from(products[index].get("u"));
                                    productModel.brand = marka;
                                    productModel.id = id;
                                    productModel.name = naziv;
                                    productModel.price = double.parse(cijena);
                                    productModel.model = model;
                                    productModel.image = array_list[0];
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Scaffold(
                                                  backgroundColor: Colors.white,
                                                  appBar: AppBar(
                                                    actions: [
                                                      IconButton(
                                                          icon: Icon(
                                                              Icons
                                                                  .shopping_cart,
                                                              color:
                                                                  Colors.black),
                                                          onPressed: () {
                                                            userController
                                                                        .userData
                                                                        .value
                                                                        .cart !=
                                                                    null
                                                                ? showBarModalBottomSheet(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) =>
                                                                            Container(
                                                                      color: Colors
                                                                          .white,
                                                                      child:
                                                                          ShoppingCartWidget(),
                                                                    ),
                                                                  )
                                                                : Get.snackbar(
                                                                    "Notice!",
                                                                    "Add Item to cart to view");
                                                          }),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.amber,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                vertical: 15,
                                                                horizontal: 30),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 15,
                                                                horizontal: 30),
                                                        child: 
                                                           Text(
                                                            // _auth.isLogged ? _auth.userEmail : "Login",
                                                            userController
                                                                    .userData
                                                                    .value
                                                                    .name ??
                                                                "",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                         
                                                        ),
                                                      ),
                                                    ],
                                                    leading: IconButton(
                                                      icon: Icon(
                                                          Icons.arrow_back),
                                                      color: Colors.black,
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    title: Text(
                                                      'Detaljnije o artiklu',
                                                      style: TextStyle(
                                                          color: Colors.black87,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    centerTitle: true,
                                                    elevation: 0.0,
                                                    backgroundColor:
                                                        Colors.white,
                                                  ),
                                                  body: Container(
                                                    child: Center(
                                                      child:
                                                          SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        child: Column(
                                                          children: [
                                                            CarouselSlider(
                                                              options:
                                                                  CarouselOptions(
                                                                height: 400,
                                                                aspectRatio:
                                                                    4 / 3,
                                                                enableInfiniteScroll:
                                                                    false,
                                                              ),
                                                              items: array_list
                                                                  .map((item) =>
                                                                      Container(
                                                                        child: Center(
                                                                            child: Image.network(item,
                                                                                fit: BoxFit.cover,
                                                                                width: 600)),
                                                                      ))
                                                                  .toList(),
                                                            ),
                                                            SizedBox(
                                                                height: 20.0),
                                                            Text(
                                                              "Naziv artikla : $naziv",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                            Text(
                                                              "Marka : $marka",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                            Text(
                                                              "Model : $model",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                            Text(
                                                              "Kataloski broj : $katBr",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                            Text(
                                                              cijena == "1"
                                                                  ? "Cijena : Po dogovoru"
                                                                  : "Cijena : $cijena KM",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                            Text(
                                                              "Kolicina : $kolicina",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                            Text(
                                                              "Lokacija : $lokacija",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                            Text(
                                                              "Opis : $opis",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            TextButton(
                                                                onPressed: () {
                                                                  print(
                                                                      productModel
                                                                          .id);
                                                                  cartController
                                                                      .addProductToCart(
                                                                          productModel);
                                                                },
                                                                child: Text(
                                                                    "Add to Cart")),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )));
                                  },
                                );
                              })),
                        )),
              isLoading
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(5),
                      //color: Colors.yellowAccent,
                      child: SpinKitFadingCircle(
                        color: Colors.red,
                        size: 20,
                      ),
                    )
                  : Container()
            ]),
            //   onRefresh: () async {
            //     //refreshChangeListener.refreshed = true;
            // },
            // )
          )
        ],
      ),
    );
  }
}
