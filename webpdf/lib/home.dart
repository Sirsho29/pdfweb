import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './search_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController text1;
  List<String> searches = [];
  String curSearch = "";
  @override
  void initState() {
    text1 = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    text1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: mq.height,
        width: mq.width,
        decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Colors.orange[500], Colors.orange[200]]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: "website",
              child: Text(
                "Website.",
                style: GoogleFonts.raleway(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 50),
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
                controller: text1,
                decoration: InputDecoration(
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: IconButton(
                        icon: Icon(
                          Icons.add,
                          size: 30,
                        ),
                        onPressed: () {
                          if (curSearch != "") {
                            setState(() {
                              searches.add(curSearch);
                              text1.clear();
                              curSearch = "";
                            });
                            print(searches);
                          }
                        }),
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: IconButton(
                        icon: Icon(
                          Icons.search,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed(SearchPage.routeName,
                              arguments: searches);
                        }),
                  ),
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
            SizedBox(
              height: 50,
            ),
            Container(
              alignment: Alignment.center,
              height: mq.height / 3,
              width: mq.width * 0.75,
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
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      deleteIcon: Icon(
                        Icons.close,
                        color: Colors.black87,
                        size: 20,
                      ),
                      onDeleted: () {
                        setState(() {
                          searches.removeAt(index);
                        });
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
