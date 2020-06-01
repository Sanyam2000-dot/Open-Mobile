import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:twitter_api/twitter_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insta_html_parser/insta_html_parser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;



FirebaseApp app;
DatabaseReference db;
FeedItem feedItem;
List<FeedItem> items = List();
DatabaseReference communityPosts;
double itemWidth;
bool postsLoaded = false;

var _scaffoldKey = new GlobalKey<ScaffoldState>();
TextEditingController _profileUrlController = TextEditingController();
TextEditingController _postUrlController = TextEditingController();
TextStyle _textStyleBold = TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold);
TextStyle _textStyleUrl = TextStyle(fontSize: 16.0);
List<Widget> _parsedWidgets = [];

Future<void> fbSetup() async {
  WidgetsFlutterBinding.ensureInitialized();
  db = FirebaseDatabase.instance.reference();
  print(db.reference().child('messages').key);
}

class HomeBottomNav extends StatefulWidget {
  @override
  _HomeBottomNavState createState() => _HomeBottomNavState();
}

class _HomeBottomNavState extends State<HomeBottomNav> {


  int selectedIndex = 0;

  final widgetOptions = [
    homeContainer(),
    socialContainer(),
    githubContainer()
  ];



  @override
  void initState() {
    fbSetup();
    feedItem = FeedItem('', '', '');
    // TODO: implement initState
    communityPosts = db.reference().child('CommunityPosts');

    communityPosts.onChildAdded.listen(_onEntryAdded);
    communityPosts.onChildChanged.listen(_onEntryChanged);
    _profileUrlController.text = 'https://www.instagram.com/_o.p.e.n_/';
    _postUrlController.text = 'https://www.instagram.com/_o.p.e.n_/';
    allAsyncTasks();

    super.initState();
  }

  _onEntryAdded(Event event) {
    setState(() {
      items.add(FeedItem.fromSnapshot(event.snapshot));
    });
  }

  _onEntryChanged(Event event) {
    var old = items.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      items[items.indexOf(old)] = FeedItem.fromSnapshot(event.snapshot);
    });
  }

  @override
  Widget build(BuildContext context) {
    itemWidth = MediaQuery.of(context).size.width*.7;

    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: Text('OPEN UPES'),
        backgroundColor: Color.fromRGBO(160, 204, 57, 2),
      ),
      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.rss_feed), title: Text('Social')),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment), title: Text('Projects')),
        ],
        currentIndex: selectedIndex,
        fixedColor: Color.fromRGBO(160, 204, 57, 2),
        onTap: onItemTapped,
      ),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}

Container homeContainer() {
  return Container(
    color: Color.fromRGBO(160, 204, 57, 2),
    child: FirebaseAnimatedList(
        query: FirebaseDatabase.instance.reference().child("CommunityPosts"),
        reverse: false,
        itemBuilder:
            (_, DataSnapshot snapshot, Animation<double> animation, int x) {
          FeedItem f = FeedItem.fromSnapshot(snapshot);
          print(f.title);
          return Card(
            margin: EdgeInsets.only(top: 1, left: 1, right: 1),
            elevation: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: itemWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 10, bottom: 5, right: 10, left: 10),
                        child: Text(
                          f.title,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 20),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 12, bottom: 10),
                          child: Text(f.description,style: TextStyle(color: Colors.blueGrey),)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image(
                    height: 100,
                    width: 100,
                    image: NetworkImage(f.postImgUrl),
                    fit: BoxFit.fitHeight,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }),
  );
}

List<String> imgUrls = [];
List<String> postString = [];
List<String> _postsUrls = [];
Future<void> allAsyncTasks() async {
  _postsUrls = await InstaParser.postsUrlsFromProfile('https://www.instagram.com/_o.p.e.n_/');
  print(_postsUrls);
  //print('hii');
  imgUrls.clear();

  for(int i =0; i< _postsUrls.length ; i++) {
    Map<String, String> photosUrls = await InstaParser.photoUrlsFromPost('${_postsUrls[i]}');
    imgUrls.add(photosUrls['large']);
 }
  //print(imgUrls);
  postsLoaded = true;
  print(imgUrls);
 

}

Container socialContainer() {
  return Container(
    child: FirebaseAnimatedList(
      query: FirebaseDatabase.instance.reference().child("Social"),
        reverse: false,
        itemBuilder:
            (_, DataSnapshot snapshot, Animation<double> animation, int x) {
              FeedItemNews s = FeedItemNews.fromSnapshot(snapshot);
              print("github");
              return FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: (){
                  _launchURL(_postsUrls[x]);
                },
                child: Container(
                  height: 450,
                  child: Card(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image(
                                    image: AssetImage('images/logomain.png'),
                                    width: 30,
                                    height: 30,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text('_o.p.e.n_'),
                                  ),
                                ],
                              ),
                              Image(
                                image: AssetImage('images/instagram.png'),
                                width: 25,
                                height: 25,
                              ),
                            ],
                          ),
                        ),
                            Image(
                              height: 395,
                              //width: 100,
                              image: NetworkImage(imgUrls[x]),
                              fit: BoxFit.fitHeight,
                              loadingBuilder:
                                  (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes
                                        : null,
                                  ),
                                );
                              },
                            ),
                       // Text(s.description),
                      ],
                    ),
                  ),
                ),
              );
            }),
  );
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}


Container githubContainer() {
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
          image: AssetImage('images/homeBG.jpeg'),
          fit: BoxFit.fitHeight
      ),
    ),
    child: FirebaseAnimatedList(
        query: FirebaseDatabase.instance.reference().child("Github"),
        reverse: false,
        itemBuilder:
            (_, DataSnapshot snapshot, Animation<double> animation, int x) {
          FeedItemGithub n = FeedItemGithub.fromSnapshot(snapshot);
          print("github");
          return FlatButton(
            color: Colors.transparent,
            padding: EdgeInsets.all(0),
            onPressed: (){
              _launchURL('https://github.com/' + n.full_name);
            },
            child: Card(
              color: Colors.transparent,
              margin: EdgeInsets.only(top: 1, left: 1, right: 1),
              elevation: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: itemWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 10, bottom: 5, right: 10, left: 10),
                          child: Text(
                            n.name,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 20),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 12, bottom: 10),
                            child: Text(n.description,style: TextStyle(color: Colors.black),)),
                        Padding(
                          padding: EdgeInsets.only(left: 12, bottom: 10),
                          child: Row(
                            children: [
                              Text('Last Updated : '),
                              Text(n.lastUpdated),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Image.asset('images/fork.png' , width: 30 , height:  30,),
                            Text(n.fork.toString()),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(Icons.star_border),
                            Text(n.stars.toString()),
                          ],
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          );
        }),
  );
}


/*
ListView recyclerList() {
  List<FeedItem> feedList = [];
  feedList.add(FeedItem('Title', 'description',
      'https://thecsrjournal.in/wp-content/uploads/2018/10/speed-post.png'));
  feedList.add(FeedItem('Title2', 'description2',
      'https://thecsrjournal.in/wp-content/uploads/2018/10/speed-post.png'));
  feedList.add(FeedItem('Title3', 'description3',
      'https://thecsrjournal.in/wp-content/uploads/2018/10/speed-post.png'));
  feedList.add(FeedItem('Title4', 'description4',
      'https://thecsrjournal.in/wp-content/uploads/2018/10/speed-post.png'));

  return ListView.builder(
    itemBuilder: (context, position) {
      return Card(
        margin: EdgeInsets.all(10),
        elevation: 5,
        child: Column(
          children: <Widget>[
            loadImg(feedList[position].postImgUrl),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                feedList[position].title,
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(feedList[position].description)),
          ],
        ),
      );
    },
    itemCount: feedList.length,
  );
}
*/


class FeedItemNews {
  String key;
 // String title;
  String description;
 // String postImgUrl;

  //FeedItemNews(this.title, this.description, this.postImgUrl);
  FeedItemNews( this.description,);

  FeedItemNews.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
 //       title = snapshot.value["title"],
        description = snapshot.value["description"];
   //     postImgUrl = snapshot.value["postImgUrl"];

  toJson() {
    return {
     // "title": title,
      "description": description,
    //  "postImgUrl": postImgUrl,
    };
  }
}

class FeedItemGithub {
  String key;
  String name;
  String description;
  int fork;
  String lastUpdated;
  int stars;
  String full_name;

  FeedItemGithub(this.name, this.description, this.fork , this.lastUpdated , this.stars , this.full_name);


  FeedItemGithub.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        name = snapshot.value["name"],
        full_name = snapshot.value["full_name"],
        description = snapshot.value["description"],
        fork = snapshot.value["fork"],
        stars = snapshot.value["stars"],
        lastUpdated = snapshot.value['lastUpdated'];

  toJson() {
    return {
      "name": name,
      "full_name": full_name,
      "description": description,
      "lastUpdated": lastUpdated,
      "stars": stars,
      "fork": fork,
    };
  }
}



class FeedItem {
  String key;
  String title;
  String description;
  String postImgUrl;

  FeedItem(this.title, this.description, this.postImgUrl);
  String fbString() {
    return "{ 'title': '$title', 'description': '$description' , 'postImgUrl': '$postImgUrl' }";
  }

  FeedItem.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        title = snapshot.value["title"],
        description = snapshot.value["description"],
        postImgUrl = snapshot.value["postImgUrl"];

  toJson() {
    return {
      "title": title,
      "description": description,
      "postImgUrl": postImgUrl,
    };
  }
}

Image loadImg(String url) {
  return Image(
   // height: 100,
    //width: 100,
    image: NetworkImage(url),
    fit: BoxFit.fitHeight,
    loadingBuilder:
        (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
      if (loadingProgress == null) return child;
      return Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes
              : null,
        ),
      );
    },
  );
}
