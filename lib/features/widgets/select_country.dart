import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SelectCountry extends StatefulWidget {
  const SelectCountry({Key? key}) : super(key: key);

  @override
  _SelectCountryState createState() => _SelectCountryState();
}

class _SelectCountryState extends State<SelectCountry> {
  List<dynamic>? dataRetrieved; // data decoded from the json file
  List<dynamic>? data; // data to display on the screen
  var searchController = TextEditingController();
  var searchValue = "";
  @override
  // ignore: must_call_super
  void initState() {
    _getData();
  }

  Future _getData() async {
    final String response =
        await rootBundle.loadString('assets/CountryCodes.json');
    dataRetrieved = await json.decode(response) as List<dynamic>;
    setState(() {
      data = dataRetrieved;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(slivers: [
        const CupertinoSliverNavigationBar(
          largeTitle: Text("Select Country"),
          previousPageTitle: "Edit Number",
        ),
        SliverToBoxAdapter(
          child: CupertinoSearchTextField(
            onChanged: (value) {
              setState(() {
                searchValue = value;
              });
            },
            controller: searchController,
          ),
        ),
        ListView(
          children: data != null
              ? data!
                  .where((e) => e['name']
                      .toString()
                      .toLowerCase()
                      .contains(searchValue.toLowerCase()))
                  .map((e) => ListTile(
                        onTap: () {
                          Navigator.pop(context,
                              {"name": e['name'], "code": e['dial_code']});
                        },
                        title: Text(e['name']),
                        trailing: Text(e['dial_code']),
                      ))
                  .toList()
              : [
                  const Center(
                    child: Text("Loading"),
                  ),
                ],
        ),
      ]),
    );
  }
}
