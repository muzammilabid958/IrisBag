import 'dart:async';
import 'dart:convert';

import 'package:IrisBag/constants.dart';
import 'package:IrisBag/screens/category/SearchedProduct.dart';
import 'package:IrisBag/screens/category/product_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../constant/api_services.dart';
import '../../../models/searchProduct.dart';
import '../../details/details_screen.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:async_loader/async_loader.dart';
import 'package:IrisBag/models/Categories.dart' as Category;
import 'package:awesome_loader/awesome_loader.dart';
import 'package:IrisBag/settings/settings.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _typeAheadController =
      new TextEditingController();
  var focusNode = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategoryData();
  }

  Category.Categories categories = Category.Categories(
      data: [],
      meta: Category.Meta(
          currentPage: 0,
          from: 0,
          lastPage: 0,
          link: [],
          path: "",
          perPage: 0,
          to: 0,
          total: 0),
      links: Category.Links(first: "", last: ""));
  getCategoryData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("loggedIntoken").toString();

    dynamic data = await APIService.CategoryList(token);

    categories = Category.Categories.fromJson(data);
  }

  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();
  static const TIMEOUT = const Duration(seconds: 15);

  getMessage() async {
    return new Future.delayed(TIMEOUT, () => {});
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    var _asyncLoader = AsyncLoader(
        key: _asyncLoaderState,
        initState: () async => await getMessage(),
        renderLoad: () => Center(
                child: AwesomeLoader(
              loaderType: AwesomeLoader.AwesomeLoader3,
              color: HexColor(Theme_Settings.loaderColor['color']),
            )),
        renderError: ([error]) => const Text('Something Went Wrong'),
        renderSuccess: ({data}) => categories.data.length > 0
            ? SingleChildScrollView(
                child: Column(children: [
                SizedBox(
                  child: ListTile(
                    onTap: () {},
                    title: const Text(
                      "All Categories",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                for (var i = 0; i < categories.data.length; i++) ...[
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: SizedBox(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CategoryAllProduct(
                                    id: categories.data[i].id.toString())),
                          );
                        },
                        title: Text(categories.data[i].name.toString()),
                        trailing: const Icon(Icons.arrow_forward),
                      ),
                    ),
                  ),
                  Container(
                      width: 350,
                      child: const Divider(
                        thickness: 2,
                        color: Colors.grey,
                      ))
                ]
              ]))
            : const Center(
                child: Text("Empty"),
              ));
    return Scaffold(
      appBar: AppBar(
          // The search area here

          title: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(40)),
              child: Center(
                child: RawKeyboardListener(
                  focusNode: focusNode,
                  onKey: (event) {
                    if (event.isKeyPressed(LogicalKeyboardKey.enter)) {}
                  },
                  child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                          autofocus: true,
                          onSubmitted: (value) => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => SearchedProduct(
                                      query: value.toString()))),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0)),
                          controller: this._typeAheadController),
                      suggestionsCallback: (pattern) async {
                        if (pattern.isNotEmpty) {
                          var i = await APIService.searchProduct(
                              pattern.isNotEmpty ? pattern : "sds");
                          print(i);
                          SearchProduct response = SearchProduct.fromJson(i);
                          List<Data> data = response.data;
                          print(json.encode(data));
                          return data;
                        }
                        return [];
                      },
                      itemBuilder: (context, suggestion) {
                        Data d =
                            Data.fromJson(json.decode(json.encode(suggestion)));

                        return ListTile(
                          leading: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: 44,
                                minHeight: 44,
                                maxWidth: 44,
                                maxHeight: 44,
                              ),
                              child: CachedNetworkImage(
                                  imageUrl: d.images![0].url.toString(),
                                  fit: BoxFit.contain,
                                  height: 140,
                                  placeholder: (context, url) => new Center(
                                          child: CircularProgressIndicator(
                                        color: HexColor("#A47E0F"),
                                      )),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                          'assets/images/Placeholders.png'))),
                          subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              verticalDirection: VerticalDirection.down,
                              textBaseline: TextBaseline.alphabetic,
                              textDirection: TextDirection.ltr,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  d.formatedPrice.toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                if (d.formatedSpecialPrice.toString() !=
                                    "null") ...[
                                  Text(
                                    d.formatedSpecialPrice.toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ]
                              ]),
                          title: Text(d.name.toString()),
                        );
                      },
                      onSuggestionSelected: (suggestion) {
                        Data d =
                            Data.fromJson(json.decode(json.encode(suggestion)));

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                    id: d.id.toString(),
                                  )),
                        );
                      }),
                ),
              ))),
      body: _asyncLoader,
    );
  }
}
