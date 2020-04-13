import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/article.dart';
import 'models/article.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue, primaryColor: Color(0xFF104B92)),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double top = 0.0, _opacity = 0.0;
  final Firestore _firestore = Firestore.instance;
  final _articles = articles;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onVerticalDragDown: (x) {
        print(top);
        if ((top >= 83.5 && top <= 100) || top >= 312) {
          setState(() {
            _opacity = 1.0;
            print("1.0");
          });
        } else {
          setState(() {
            _opacity = 0.0;
            print("0.0");
          });
        }
      },
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height / 2.5,
                leading: IconButton(
                    icon: Icon(Icons.menu, color: Colors.black45, size: 25),
                    onPressed: () {}),
                floating: false,
                pinned: true,
                flexibleSpace: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  top = constraints.biggest.height;

                  return FlexibleSpaceBar(
                    title: AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        //opacity: top == 80.0 ? 1.0 : 0.0,
                        opacity: _opacity,
                        child: Text("Latest Articles")),
                    background: Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          "assets/spe_logo.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            blurRadius: 40,
                            color: Colors.black45,
                            offset: Offset(4, 4))
                      ]),
                    ),
                  );
                })),
          ];
        },
        body: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('articles').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            return ListView.builder(
              itemCount: 4,
              itemBuilder: (ctx, index) => Container(
                  padding: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
                        
                          child: Image.network(
                        _articles[index].imagePath,
                        fit: BoxFit.fill,
                      )),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.black45, blurRadius: 4)
                            ]),

                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 5.2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(_articles[index].title),
                            Text("By: ${_articles[index].authorName}"),
                            FlatButton(
                              onPressed: () {},
                              child: Text(_articles[index].tags[0]),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: BorderSide(
                                      color: Theme.of(context).primaryColor)),
                            ),
                            Text(_articles[index].duration),
                          ],
                        ),
                      )
                    ],
                  )),
            );
          },
        ),
      ),
    ));
  }
}
