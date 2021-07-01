import 'package:aewebshop/constants/sizes.dart';
import 'package:aewebshop/controllers/cart_controller.dart';
import 'package:aewebshop/controllers/user_controller.dart';
import 'package:aewebshop/model/product.dart';
import 'package:aewebshop/screens/orders.dart';
import 'package:aewebshop/screens/shopping_cart.dart';
import 'package:aewebshop/screens/widget/nav_bar.dart';
import 'package:aewebshop/widgets/custom_btn.dart';
import 'package:algolia/algolia.dart';
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
  List<String> items = <String>[
    'Sve kategorije',
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
  ];
  List<String> itemlist = [
    'Naziv dijela',
    'Kataloški broj',
    'Brend vozila',
    'Model vozila'
  ];
  String selectedItem = "Naziv dijela";
  String searchhint = "Pretraživanje po nazivu dijela";
  TextEditingController searchtextEditingController =
      new TextEditingController();

  get documentSnapshot => null;

  List<DocumentSnapshot> products = []; // stores fetched products

  List<AlgoliaObjectSnapshot> algoliaObjects = [];

  int _currentPage = 0;

  bool isLoading = false; // track if products fetching

  bool hasMore = true; // flag for more products available or not

  int documentLimit = 10; // documents to be fetched per request

  DocumentSnapshot
      lastDocument; // flag for last document from where next 10 records to be fetched

  bool addedLastDoc = false;
  bool queryInitiated = false;

  ScrollController _scrollController =
      ScrollController(); // listener for listview scrolling
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    //fetchData();
    //fetchDataFromFireStore();
    // getProducts(searchtextEditingController.text.trim(), 's_name', false);
    _search('', false);

    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        String searchBy = "s_name";
        if (selectedItem == "Kataloški broj") {
          searchBy = "s_catalogue";
        } else if (selectedItem == "Brend vozila") {
          searchBy = "s_model";
        } else if (selectedItem == "Model vozila") {
          searchBy = "s_brand";
        }
        addedLastDoc = false;
        _searchType = searchBy;
        _search(searchtextEditingController.text.trim(), false);
        // getProducts(searchtextEditingController.text.trim(), searchBy, false);
      }
    });
  }

  String _chosenValue = 'Sve kategorije';
  String _searchType = 's_name';

  _search(String searchText, bool hasSearchChanged) async {
    print("=============================================================");
    print("search text => " + searchText);
    print("search type => " + _searchType);
    print("search facet => " + _chosenValue);
    if (hasSearchChanged) {
      algoliaObjects = [];
      _currentPage = 0;
    }
    Algolia algolia = Algolia.init(
      applicationId: 'BEC9YCR77A',
      apiKey: 'a49b2ed8678f29432c3296fa360b47e1',
    );

    AlgoliaQuery query = algolia.instance
        .index('artikli')
        .setHitsPerPage(100)
        .query(searchText)
        .setPage(_currentPage)
        .setRestrictSearchableAttributes([_searchType]).facetFilter(
            _chosenValue == 'Sve kategorije' ? '' : ['k:$_chosenValue']);

    try{
              final results = await query.getObjects();
    final hits = results.hits;
    setState(() {
      algoliaObjects.addAll(hits);
    });
    print(
        'data: ${results.nbHits} ${results.nbPages} ${hits.length} ${results.facets} ${results.facetsStats}');
    _currentPage++;
    if (_currentPage == results.nbPages) {
      hasMore = false;
    }
            } catch(err){
              throw err;
            }
  }

  // getProducts(
  //     String search_text, String search_type, bool hasSearchChanged) async {
  //   print("=============================================================");
  //   print("search text => " + search_text);
  //   print("search type => " + search_type);
  //   QuerySnapshot querySnapshot;

  //   if (search_text.length == 0) {
  //     if (!hasMore) {
  //       print('No More Products');
  //       return;
  //     }
  //     if (isLoading) {
  //       return;
  //     }
  //     setState(() {
  //       isLoading = true;
  //     });

  //     if (hasSearchChanged) {
  //       products = [];
  //     }
  //     if (lastDocument == null) {
  //       print('Initial DOC');
  //       if (_chosenValue == 'All') {
  //         queryInitiated = true;
  //         querySnapshot = await firestore
  //             .collection('artikli')
  //             .orderBy('s_name')
  //             .limit(documentLimit)
  //             .get();
  //       } else {
  //         print("CHOOSEN VALUE 1 => " + _chosenValue);
  //         queryInitiated = true;
  //         querySnapshot = await firestore
  //             .collection('artikli')
  //             .where('k', isEqualTo: _chosenValue)
  //             .orderBy('s_name')
  //             .limit(documentLimit)
  //             .get();
  //       }
  //     } else {
  //       print('Pagination DOC');
  //       if (_chosenValue == 'All') {
  //         queryInitiated = true;
  //         querySnapshot = await firestore
  //             .collection('artikli')
  //             .orderBy('s_name')
  //             .limit(documentLimit)
  //             .startAfterDocument(lastDocument)
  //             .get();
  //       } else {
  //         print("CHOOSEN VALUE 2 => " + _chosenValue);
  //         queryInitiated = true;
  //         querySnapshot = await firestore
  //             .collection('artikli')
  //             .where('k', isEqualTo: _chosenValue)
  //             .orderBy('s_name')
  //             .limit(documentLimit)
  //             .startAfterDocument(lastDocument)
  //             .get();
  //       }
  //     }
  //   } else {
  //     if (hasSearchChanged) {
  //       lastDocument = null;
  //       products = [];
  //     } else {
  //       setState(() {
  //         isLoading = true;
  //       });
  //     }
  //     if (lastDocument == null) {
  //       print('SEARCH: Initial DOC');
  //       if (_chosenValue == 'All') {
  //         queryInitiated = true;
  //         querySnapshot = await firestore
  //             .collection('artikli')
  //             .where(search_type,
  //                 isGreaterThanOrEqualTo: search_text.toLowerCase())
  //             .where(search_type,
  //                 isLessThanOrEqualTo: search_text.toLowerCase() + 'z')
  //             .orderBy(search_type)
  //             .limit(documentLimit)
  //             .get();
  //       } else {
  //         print("CHOOSEN VALUE 3 => " + _chosenValue);
  //         queryInitiated = true;
  //         querySnapshot = await firestore
  //             .collection('artikli')
  //             .where(search_type,
  //                 isGreaterThanOrEqualTo: search_text.toLowerCase())
  //             .where(search_type,
  //                 isLessThanOrEqualTo: search_text.toLowerCase() + 'z')
  //             .where('k', isEqualTo: _chosenValue)
  //             .orderBy(search_type)
  //             .limit(documentLimit)
  //             .get();
  //       }
  //     } else {
  //       print('SEARCH: Pagination DOC');
  //       if (_chosenValue == 'All') {
  //         queryInitiated = true;
  //         querySnapshot = await firestore
  //             .collection('artikli')
  //             .where(search_type,
  //                 isGreaterThanOrEqualTo: search_text.toLowerCase())
  //             .where(search_type,
  //                 isLessThanOrEqualTo: search_text.toLowerCase() + 'z')
  //             .orderBy(search_type)
  //             .limit(documentLimit)
  //             .startAfterDocument(lastDocument)
  //             .get();
  //       } else {
  //         print("CHOOSEN VALUE 4 => " + _chosenValue);
  //         queryInitiated = true;
  //         querySnapshot = await firestore
  //             .collection('artikli')
  //             .where(search_type,
  //                 isGreaterThanOrEqualTo: search_text.toLowerCase())
  //             .where(search_type,
  //                 isLessThanOrEqualTo: search_text.toLowerCase() + 'z')
  //             .where('k', isEqualTo: _chosenValue)
  //             .orderBy(search_type)
  //             .limit(documentLimit)
  //             .startAfterDocument(lastDocument)
  //             .get();
  //       }
  //     }
  //   }

  //   /*if (lastDocument == null) {
  //     print('Initial DOC');
  //     querySnapshot = await firestore
  //         .collection('artikli')
  //         //.where(search_type, isGreaterThanOrEqualTo: search_text).where(search_type, isLessThanOrEqualTo: search_text+'z')
  //         .orderBy(search_type)
  //         .limit(documentLimit)
  //         .get();
  //   } else {
  //     print('Pagination DOC');
  //     querySnapshot = await firestore
  //         .collection('artikli').where(search_type, isGreaterThanOrEqualTo: search_text).where(search_type, isLessThanOrEqualTo: search_text+'z')
  //         .orderBy(search_type)
  //         .limit(documentLimit)
  //         .startAfterDocument(lastDocument)
  //         .get();
  //   }*/
  //   var articleArray = querySnapshot.docs;
  //   if (articleArray.length < documentLimit) {
  //     hasMore = false;
  //     //lastDocument = null;
  //   }
  //   if (articleArray.length > 0 && !addedLastDoc) {
  //     print("Added LAST DOCUMENT");
  //     addedLastDoc = true;
  //     lastDocument = articleArray[articleArray.length - 1];

  //     if (queryInitiated) {
  //       print("Adding All ITEM ==> BEFORE :" + products.length.toString());
  //       products.addAll(articleArray);
  //       print("AFTER :" + products.length.toString());
  //       queryInitiated = false;
  //     }
  //   }

  //   if (products.length == 0 && queryInitiated) {
  //     print("Adding All ITEM ==> BEFORE :" + products.length.toString());
  //     products.addAll(articleArray);
  //     print("AFTER :" + products.length.toString());

  //     print("Added LAST DOCUMENT");
  //     addedLastDoc = true;
  //     lastDocument = articleArray[articleArray.length - 1];

  //     queryInitiated = false;
  //   }

  //   setState(() {
  //     isLoading = false;
  //   });
  // }

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
      if (selectedItem == "Kataloški broj") {
        searchBy = "s_catalogue";
      } else if (selectedItem == "Brend vozila") {
        searchBy = "s_model";
      } else if (selectedItem == "Model vozila") {
        searchBy = "s_brand";
      }
    }
    // products = [];
    algoliaObjects = [];
    addedLastDoc = true;
    _searchType = searchBy;
    _search(value, true);
    // getProducts(value, searchBy, true);
  }

  CartController cartController = Get.find();
  UserController userController = Get.find();
  ProductModel productModel = ProductModel();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final size = WindowSizes.size(width);
    return Title(
      title: "Pregled artikala - AE Web shop",
      color: Colors.red[800],
      child: Container(
        width: Get.width,
        height: Get.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              appBar: size == Sizes.Large ? null : buildAppBar(size),
              drawer: size == Sizes.Large
                  ? null
                  : NavBar(
                      size: size,
                    ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size == Sizes.Large ? 100 : 20),
                  // size == Sizes.Large || size == Sizes.Medium
                  // ?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: buildFirstDropDownList()),
                      Expanded(child: buildSecondsDropDownList()),
                    ],
                  ),
                  // : Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: [
                  //       buildFirstDropDownList(),
                  //       buildSecondsDropDownList(),
                  //     ],
                  //   ),
                  SizedBox(height: 10),
                  Center(
                    child: buildSearch(),
                  ),
                  SizedBox(height: 30),
                  Expanded(
                    child: //RefreshIndicator ( child:

                        Column(children: [
                      Expanded(
                          child: algoliaObjects.length == 0
                              ? buildNoDataDisplay(context)
                              : buildGrid(context, size)),
                      isLoading ? buildLoading(context) : Container()
                    ]),
                    //   onRefresh: () async {
                    //     //refreshChangeListener.refreshed = true;
                    // },
                    // )
                  )
                ],
              ),
            ),
            if (size == Sizes.Large)
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
        ),
      ),
    );
  }

  AppBar buildAppBar(Sizes size) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      title: Text(
        'A R T I K L I',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      elevation: 0.0,
      backgroundColor: Colors.red[800],
    );
  }

  Padding buildFirstDropDownList() {
    return Padding(
      padding: EdgeInsets.only(left: WindowSizes.size(Get.width) == Sizes.Large ? MediaQuery.of(context).size.width/4 : 20, right: 10.0),
      child: Container(
        width: Get.width * 0.4,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.white,
            border: Border.all(color: Colors.red[800], width: 1.5)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            hint: Text(
              'Izaberite vrstu pretrage',
              style: TextStyle(
                  fontSize:
                      WindowSizes.size(Get.width) == Sizes.Large ? 16 : 14),
            ),
            isExpanded: true,
            isDense: false,
            iconEnabledColor: Colors.black,
            underline: SizedBox(),
            value: selectedItem,
            onChanged: (newValue) {
              setState(() {
                selectedItem = newValue;
                if (selectedItem == "Part Name") {
                  searchhint = "Unesite naziv artikla";
                } else if (selectedItem == "Catalogue Number") {
                  searchhint = "Unesite kataloški broj artikla";
                } else if (selectedItem == "Car Brand") {
                  searchhint = "Unesite brend vozila";
                } else if (selectedItem == "Car Model") {
                  searchhint = "Unesite model vozila";
                }
                print(selectedItem);
                searchtextEditingController.text = "";
              });
            },
            style: TextStyle(
                fontSize: WindowSizes.size(Get.width) == Sizes.Large ? 16 : 14),
            items: itemlist.map((location) {
              return DropdownMenuItem(
                child: new Container(
                  child: Text(
                    location,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: WindowSizes.size(Get.width) == Sizes.Large
                            ? 16
                            : 14),
                  ),
                ),
                value: location,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Padding buildSecondsDropDownList() {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: WindowSizes.size(Get.width) == Sizes.Large ? MediaQuery.of(context).size.width/4 : 20),
      child: Container(
        width: Get.width * 0.4,
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
            style: TextStyle(
                fontSize: WindowSizes.size(Get.width) == Sizes.Large ? 16 : 12),
            iconEnabledColor: Colors.black,
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    value,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: WindowSizes.size(Get.width) == Sizes.Large
                            ? 16
                            : 14),
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
                  fontSize:
                      WindowSizes.size(Get.width) == Sizes.Large ? 16 : 12,
                ),
              ),
            ),

            onChanged: (String value) {
              setState(() {
                _chosenValue = value;
                print(_chosenValue);
                addedLastDoc = true;
                _search(searchtextEditingController.text, true);
                // getProducts("", "", true);
              });
            },
          ),
        ),
      ),
    );
  }

  Container buildLoading(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(5),
      //color: Colors.yellowAccent,
      child: SpinKitFadingCircle(
        color: Colors.red,
        size: 20,
      ),
    );
  }

  Padding buildGrid(BuildContext context, size) {
    return Padding(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width / 9,
          right: MediaQuery.of(context).size.width / 9),
      child: Container(
        width: double.infinity,
        child: GridView.count(
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            controller: _scrollController,
            crossAxisCount: size == Sizes.Large
                ? 4
                : size == Sizes.Medium
                    ? 2
                    : 1,
            children: new List<Widget>.generate(algoliaObjects.length, (index) {
              String title = algoliaObjects[index].data["n"];
              String subTitle = algoliaObjects[index].data["m"];
              String imageUrl = "";
              List<String> arrayList =
                  List.from(algoliaObjects[index].data["u"]);
              if (arrayList != null && arrayList.length > 0) {
                setState(() {
                  imageUrl = arrayList[0];
                });
              }
              return InkWell(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.fill)),
                  height: size == Sizes.Large
                      ? 100
                      : size == Sizes.Medium
                          ? 250
                          : 200,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                      child: Container(
                        height: size == Sizes.Large
                            ? 80.0
                            : size == Sizes.Medium
                                ? 80
                                : 100,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(0, 0, 0, 0.8),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15)
                          )
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "$title",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size == Sizes.Large
                                      ? 17.0
                                      : size == Sizes.Medium
                                          ? 15
                                          : 20,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text("$subTitle",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size == Sizes.Large
                                          ? 17.0
                                          : size == Sizes.Medium
                                              ? 15
                                              : 20,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                    ),
                  ),
                  // child: CachedNetworkImage(
                  //   imageUrl: imageUrl,
                  //   width: size == Sizes.Large
                  //       ? Get.width * 0.15
                  //       : size == Sizes.Medium
                  //           ? Get.width * 0.2
                  //           : Get.width * 0.5,

                  //   progressIndicatorBuilder: (context, url,
                  //           downloadProgress) =>
                  //       SpinKitFadingCircle(color: Colors.red, size: 20),
                  //   //placeholder: (context, url) => CircularProgressIndicator(),
                  //   errorWidget: (context, url, error) =>
                  //       Icon(Icons.error),
                  // ),
                ),
                // FadeInImage(
                //   placeholder: AssetImage("assets/img/car.png"),
                //   image: NetworkImage(imageUrl),
                //   fit: BoxFit.cover,
                // ),),

                // Text("${imageUrl}",
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //     color : Colors.black,
                //     fontWeight: FontWeight.bold,
                //     fontSize: 17.0,
                //   ),),

                onTap: () {
                  String naziv = algoliaObjects[index].data["n"].toString();
                  String marka = algoliaObjects[index].data["m"].toString();
                  String model = algoliaObjects[index].data["mo"].toString();
                  String katBr = algoliaObjects[index].data["kb"].toString();
                  String id = algoliaObjects[index].data["id"].toString();
                  String cijena = algoliaObjects[index].data["c"].toString();
                  String kolicina = algoliaObjects[index].data["ko"].toString();
                  String lokacija = algoliaObjects[index].data["l"].toString();
                  String opis = algoliaObjects[index].data["o"].toString();

                  List<String> arrayList =
                      List.from(algoliaObjects[index].data["u"]);
                  productModel.brand = marka;
                  productModel.id = id;
                  productModel.name = naziv;
                  productModel.price = double.parse(cijena);
                  productModel.model = model;
                  productModel.image = arrayList[0];
                  Get.toNamed('/artikal/' + algoliaObjects[index].objectID);
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => DetailWidget(
                  //               productId: id,
                  //             )));
                },
              );
            })),
      ),
    );
  }

  Center buildNoDataDisplay(BuildContext context) {
    return Center(
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
          : Text('Nema artikala za prikaz!'),
    );
  }

  Container buildSearch() {
    return Container(
      width: 820,
      height: 45,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.red[800], width: 1.5),
          borderRadius: BorderRadius.all(Radius.circular(6))),
      margin: EdgeInsets.only(left: 20, right: 20),
      child: ListTile(
        contentPadding: EdgeInsets.only(
            left: 10.0,
            right: 10.0,
            bottom: WindowSizes.size(Get.width) == Sizes.Large ? 18.0 : 14),
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
    );
  }
}
