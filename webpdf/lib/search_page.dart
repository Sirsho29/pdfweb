import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models/data.dart';

class SearchPage extends StatefulWidget {
  static const routeName = "/search";
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController text;
  List<String> searches = [];
  String curSearch = "";
  String pdfUrl = "";
  String txt;
  PDFDocument document;
  bool loader = false;

  @override
  void initState() {
    text = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> searchWords =
        ModalRoute.of(context).settings.arguments as List<String>;
    searchWords.forEach((element) {
      searches.add(element);
    });
    searchWords.clear();
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: mq.height,
        width: mq.width,
        decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Colors.orange[500], Colors.orange[200]]),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20),
              Hero(
                tag: "website",
                child: Text(
                  "Website.",
                  style: GoogleFonts.raleway(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                width: mq.width / 2,
                child: TextField(
                  onChanged: (val) {
                    setState(() {
                      curSearch = val;
                    });
                  },
                  keyboardType: TextInputType.number,
                  controller: text,
                  decoration: InputDecoration(
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: IconButton(
                          icon: Icon(
                            Icons.add,
                            size: 20,
                          ),
                          onPressed: () {
                            if (curSearch != "") {
                              setState(() {
                                searches.add(curSearch);
                                text.clear();
                                curSearch = "";
                              });
                              print(searches);
                            }
                          }),
                    ),
                    // prefixIcon: Padding(
                    //   padding: const EdgeInsets.all(10.0),
                    //   child: IconButton(
                    //       icon: Icon(
                    //         Icons.search,
                    //         size: 20,
                    //       ),
                    //       onPressed: null),
                    // ),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                    ),
                  ),
                ),
              ),
              //Text(curSearch),
              // SizedBox(
              //   height: 30,
              // ),
              Container(
                alignment: Alignment.center,
                height: mq.height / 5,
                width: mq.width * 0.6,
                child: GridView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: searches.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: 5,
                      crossAxisSpacing: 0.5,
                      mainAxisSpacing: 2,
                    ),
                    itemBuilder: (context, index) {
                      return Chip(
                        label: Text(
                          searches[index],
                          style: GoogleFonts.raleway(
                            color: Colors.black87,
                            fontSize: 12,
                            //fontWeight: FontWeight.bold
                          ),
                        ),
                        deleteIcon: Icon(
                          Icons.close,
                          color: Colors.black87,
                          size: 15,
                        ),
                        onDeleted: () {
                          setState(() {
                            searches.removeAt(index);
                          });
                        },
                      );
                    }),
              ),
              // SizedBox(
              //   height: 20,
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: mq.height / 1.7,
                    width: mq.width / 2 - 100,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: StreamBuilder(
                        stream:
                            Firestore.instance.collection('pdfs').snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          List<Data> data = [];
                          final userData = snapshot.data.documents;
                          for (var eachData in userData) {
                            //final name = eachData.data['name'];
                            bool check = false;
                            searches.forEach((element) {
                              String s = eachData.data['text']
                                  .toString()
                                  .trim()
                                  .toLowerCase();
                              if (s.contains(element.toLowerCase())) {
                                check = true;
                              } else if (element
                                      .toLowerCase()
                                      .contains("AND") &&
                                  (s.contains(element
                                          .toLowerCase()
                                          .split("AND ")[0]) &&
                                      s.contains(element
                                          .toLowerCase()
                                          .split("AND ")[1]))) {
                                check = true;
                              } else if (element.toLowerCase().contains("OR") &&
                                  (s.contains(element
                                          .toLowerCase()
                                          .split("OR ")[0]) ||
                                      s.contains(element
                                          .toLowerCase()
                                          .split("OR ")[1]))) {
                                check = true;
                              } else if (searches.length == 0) {
                                check = true;
                              } else {
                                check = false;
                              }
                            });
                            if (check) {
                              data.add(Data(
                                  text: eachData.data['text'].toString().trim(),
                                  url: eachData.data['url'].toString().trim(),
                                  number: eachData.data['name'].toString()));
                            }
                          }
                          return Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Scrollbar(
                              thickness: 1.5,
                              radius: Radius.circular(25),
                              child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  itemCount: data.length,
                                  itemBuilder: (context, i) {
                                    return Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: MaterialButton(
                                        hoverColor: Colors.lightBlue,
                                        child: Text(
                                          data[i].number.toString() + ".pdf",
                                          style: GoogleFonts.raleway(
                                            color: Colors.deepOrange,
                                            fontSize: 30,
                                            //fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),

                                        focusColor: Colors.lightBlue,
                                        //selected: true,
                                        onPressed: () async {
                                          setState(() {
                                            pdfUrl = data[i].url;
                                            txt = data[i].text;
                                            loader = true;
                                          });
                                          document = await PDFDocument.fromURL(
                                                  "https://storage.googleapis.com/websitepdf.appspot.com/1")
                                              .whenComplete(() {
                                            setState(() {
                                              loader = false;
                                            });
                                          });
                                        },
                                      ),
                                    );
                                  }),
                            ),
                          );
                        }),
                  ),
                  Container(
                    height: mq.height / 1.7,
                    width: mq.width / 2 - 100,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                    ),
                    child: (txt != null)
                        ?
                        // ? (loader)
                        //     ? CircularProgressIndicator(
                        //         strokeWidth: 1,
                        //       )
                        Scrollbar(
                            child: SingleChildScrollView(
                                child: Column(children: [
                              Text(txt,
                                  style: GoogleFonts.abel(
                                      color: Colors.black,
                                      fontSize: 15,
                                      backgroundColor: Colors.white
                                      //fontWeight: FontWeight.bold
                                      ))
                            ])),
                          ) //PDFViewer(document: document)
                        : Center(
                            child: Text(
                              "Select a document ...",
                              style: GoogleFonts.raleway(
                                color: Colors.white,
                                fontSize: 30,
                                //fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
