import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:openflutter/BottomNav.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import './auth/auth.dart';
import 'OurVision.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'DevloperProfile.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
bool isLoggedIn = false;

void onTapToolbar(int n, BuildContext context) {
  if (n == 1) {
    if (context.toString().contains('MainNavDrawer')) {
      print('Already There');
    } else {
      Navigator.pushReplacementNamed(context, _HomeContentState().rtName);
    }
  } else if (n == 2) {
    if (context.toString().contains('Gallery')) {
      print('Already There');
    } else {
      Navigator.pushReplacementNamed(context, _GalleryState().rtName);
    }
  } else if (n == 3) {
    if (context.toString().contains('AboutUs')) {
      print('Already There');
    } else {
      Navigator.pushReplacementNamed(context, _AboutUsState().rtName);
    }
  } else if (n == 4) {
    if (context.toString().contains('OurVision')) {
      print('Already There');
    } else {
      Navigator.pushReplacementNamed(context, OurVision().rtName);
    }
  }
}

Drawer appToolbar(BuildContext context) {
  return Drawer(
    child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/homeBG.jpeg"),
                        fit: BoxFit.fill
                    ),
                  ),
                  //color: Color.fromRGBO(160, 204, 57, 2),
                  alignment: Alignment.topLeft,
                  //color: Color.fromRGBO(160, 204, 57, 2) ,
                  height: 150,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 50,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Image(
                              image: AssetImage('images/logomain.png'),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('OPEN UPES',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),),
                        ),
                      ],
                    ),
                  ),
                ),
                createDrawerItem(
                    icon: Icons.home, text: 'Home', n: 1, context: context),
                createDrawerItem(
                    icon: Icons.photo, text: 'Gallery', n: 2, context: context),
                createDrawerItem(
                    icon: Icons.info, text: 'About Us', n: 3, context: context),
                createDrawerItem(
                    icon: Icons.remove_red_eye,
                    text: 'Our Vision',
                    n: 4,
                    context: context),


              ],
            ),
          ),
          /*Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              color: Color.fromRGBO(160, 204, 57, 2),
              splashColor: Colors.blue,
              animationDuration: Duration(milliseconds: 10),
              onPressed: (){
                    Navigator.pushNamed(context, '/developerInfo');
              },
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
              ),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage('images/developer.png'),
                      width: 25,
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text('Maintainer Info',
                      style: TextStyle(
                        color: Colors.white
                      ),),
                    ),
                  ],
                ),
            ),
          )*/
        ],
      ),
    ),
  );
}

Widget createDrawerItem(
    {IconData icon,
    String text,
    GestureTapCallback onTap,
    int n,
    BuildContext context}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(text),
        )
      ],
    ),
    onTap: () {
      onTapToolbar(n, context);
    },
  );
}

Image carouselImg(String url) {
  return Image(
    image: NetworkImage(url),
    fit: BoxFit.cover,
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

void main() {
  runApp(MaterialApp(
    home: SplashScreen(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Demo',
      home: MyHomePage(title: 'Firebase Auth Demo'),
    );
  }
}

TextStyle defaultTextStyle(double size) {
  return TextStyle(
    color: Colors.black,
    decoration: TextDecoration.none,
    fontSize: size,
  );
}

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  String rtName = '/AboutUs';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: aboutUs(),
        drawer: appToolbar(context),
        appBar: AppBar(
          title: Text('About Us'),
          backgroundColor: Color.fromRGBO(160, 204, 57, 2),
        ),
      ),
    );
  }

  Container aboutUs() {
    return Container(
      height: MediaQuery.of(context).size.height,
        child: ListView(
          children: <Widget>[
            Column(
              children: [
                Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/bottomBG.jpeg"),
                          fit: BoxFit.fill
                      ),
                    ),
                    width: double.infinity,
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Aware',
                          style: defaultTextStyle(30),
                        ),

                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage(
                              'images/educate.png'),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 10),
                          width: 200,
                          child: Text(
                            'We aim at spreading awareness about the advantages of using Open source softwares over conventional proprietary softwares.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.blueGrey),
                          ),
                        ),
                      ],
                    ),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.all(7),
                ),
                Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/bottomBG.jpeg"),
                          fit: BoxFit.fill
                      ),
                    ),
                    width: double.infinity,
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Adopt',
                          style: defaultTextStyle(30),
                        ),

                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage(
                              'images/adopt.png'),
                        ),

                        Container(
                          padding: EdgeInsets.only(bottom: 10),
                          width: 200,
                          child: Text(
                            'Spreading awareness is futile until and unless we motivate people to adopt the prevailing open source softwares in their work environment.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.blueGrey),
                          ),
                        ),

                      ],
                    ),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.all(7),
                ),
                Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/bottomBG.jpeg"),
                          fit: BoxFit.fill
                      ),
                    ),
                    width: double.infinity,
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Contribute',
                          style: defaultTextStyle(30),
                        ),
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage(
                              'images/contribute.png'),
                        ),

                        Container(
                          padding: EdgeInsets.only(bottom: 10),
                          width: 200,
                          child: Text(
                            'The whole concept of open source revolves around community which uses it and contributing to the community is always a matter of prestige.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.blueGrey),
                          ),
                        ),

                      ],
                    ),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.all(7),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(
                      width: 30,
                      child: FlatButton(
                        padding: EdgeInsets.all(0),
                        onPressed: (){
                          _launchURL('https://www.linkedin.com/company/open-community/');
                        },
                        child: Image(
                          image: AssetImage('images/linkedin.png'),
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                      child: FlatButton(
                        padding: EdgeInsets.all(0),
                        onPressed: (){
                          _launchURL('https://github.com/upes-open');
                        },
                        child: Image(
                          image: AssetImage('images/github.png'),
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                      child: FlatButton(
                        padding: EdgeInsets.all(0),
                        onPressed: (){
                          _launchURL('https://www.instagram.com/_o.p.e.n_/');
                        },
                        child: Image(
                          image: AssetImage('images/instagram.png'),
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                      child: FlatButton(
                        padding: EdgeInsets.all(0),
                        onPressed: (){
                          _launchURL('https://twitter.com/UpesOpen');
                        },
                        child: Image(
                          image: NetworkImage('https://cdn4.iconfinder.com/data/icons/materia-flat-social-free/24/038_003_twitter_social_network_android_material-512.png'),
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                      child: FlatButton(
                        padding: EdgeInsets.all(0),
                        onPressed: (){
                          _launchURL('https://www.facebook.com/upesopen');
                        },
                        child: Image(
                          image: NetworkImage('https://facebookbrand.com/wp-content/uploads/2019/04/f_logo_RGB-Hex-Blue_512.png?w=512&h=512'),
                          height: 25,
                          width: 25,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                      child: FlatButton(
                        padding: EdgeInsets.all(0),
                        onPressed: (){
                          _launchURL('http://upesopen.org/');
                        },
                        child: Icon(Icons.language , color: Colors.green, size: 30,),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ));
  }
}
_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 1), () {
      print("Hii");
      // runApp(MaterialApp(home: MyHomePage(title: 'Firebase Auth Demo')));
      runApp(MaterialApp(
          home: MainNavDrawer(),
          routes: {
            '/main': (context) => MainNavDrawer(),
            '/signIn': (context) => SignInPage(),
            '/AboutUs': (context) => AboutUs(),
            '/gallery': (context) => Gallery(),
            '/ourVision': (context) => OurVision(),
            '/homeBottomNav': (context) => HomeBottomNav(),
            '/developerInfo': (context) => DeveloperInfo(),
          },
          theme: ThemeData(
              // primaryColor: Color(0XFF212845),
              //scaffoldBackgroundColor: Color(0XFF212845),
              primarySwatch: Colors.green,
              buttonColor: Color.fromRGBO(160, 204, 57, 2),
              textTheme: TextTheme(
                  button: TextStyle(
                color: Color.fromRGBO(160, 204, 57, 2), // This is not working.
                //fontSize: 30.0,
              )))));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Color.fromRGBO(160, 204, 57, 2)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 100,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Image(
                          image: AssetImage('images/logomain.png'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                    ),
                    Text(
                      'OPEN UPES',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                    ),
                    Text(
                      'Aware | Adopt | Contribute',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseUser user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: RaisedButton(
              child: const Text('Test SignIn/SignOut'),
              onPressed: () => _pushPage(context, SignInPage()),
            ),
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
          ),
        ],
      ),
    );
  }

  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }
}

class MainNavDrawer extends StatefulWidget {
  @override
  _MainNavDrawerState createState() => _MainNavDrawerState();
}

class _MainNavDrawerState extends State<MainNavDrawer> {

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        FirebaseAuth.instance.signOut();
        isLoggedIn = false;
        Alert(context: context, title: "Log out Successful !",
          buttons: [
            DialogButton(
              child: Text(
                "Okay",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              color: Color.fromRGBO(0, 179, 134, 1.0),
              radius: BorderRadius.circular(0.0),
            ),
          ],).show();
        break;
      case 'Dev':
        showModalBottomSheet(context: context, builder: (BuildContext bc){
          return mainContainer();
        });
        break;
      case 'Login':
        Navigator.pushNamed(context, '/signIn');
        break;
      case 'Feedback':
        _launchURL('https://github.com/upes-open/Open-Mobile/issues');
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OPEN UPES'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {isLoggedIn ? 'Logout' : 'Login', 'Dev' , 'Feedback'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
        backgroundColor: Color.fromRGBO(160, 204, 57, 2),
      ),
      drawer: appToolbar(context),
      body: HomeContent(),
    );
  }
}

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String rtName = '/main';


  @override
  void initState() {
    // TODO: implement initState
    FirebaseAuth.instance.currentUser().then((user) => user != null
        ? setState(() {
            isLoggedIn = true;
          })
        : null);
    super.initState();
  }

  List<String> carouselImages = ['https://www.upesopen.org/b.png','https://www.upesopen.org/b.png','https://www.upesopen.org/b.png','https://www.upesopen.org/b.png'];
  Future<String> loadImge() async {
    carouselImages[0] = ((await FirebaseDatabase.instance.reference().child("carouselImg/Img1").once()).value.toString());
    carouselImages[1] = ((await FirebaseDatabase.instance.reference().child("carouselImg/Img2").once()).value.toString());
    carouselImages[2] = ((await FirebaseDatabase.instance.reference().child("carouselImg/Img3").once()).value.toString());
    carouselImages[3] = ((await FirebaseDatabase.instance.reference().child("carouselImg/Img4").once()).value.toString());

  }
  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.currentUser().then((user) => user != null
        ? setState(() {
            isLoggedIn = true;
          })
        : null);
    loadImge();
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("images/homeBG.jpeg"),
            fit: BoxFit.fill
        ),
      ),
      child: Column(children: <Widget>[
        Expanded(
            flex: 1,
            child: Carousel(
              images: [
                carouselImg(carouselImages[0]),
                carouselImg(carouselImages[1]),
                carouselImg(carouselImages[2]),
                carouselImg(carouselImages[3]),
                // ExactAssetImage("assets/images/LaunchImage.jpg")
              ],
              dotSize: 4.0,
              dotSpacing: 15.0,
              dotColor: Colors.lightGreenAccent,
              indicatorBgPadding: 5.0,
              dotBgColor: Colors.purple.withOpacity(0.0),
              borderRadius: true,
              moveIndicatorFromBottom: 180.0,
              noRadiusForIndicator: true,
            )),
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: [
                  Image.asset(
                    'images/logomain.png',
                    height: 120,
                  ),
                  Text(
                    'AWARE | ADOPT | CONTRIBUTE',
                    style: TextStyle(
                      color: Color.fromRGBO(160, 204, 57, 2),
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Text(
                'In association with :',
                style: defaultTextStyle(15),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(child: Image.asset('images/linuxfoundation.png')),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(child: Image.asset('images/ibm.png')),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(child: Image.asset('images/upes.png')),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(child: Image.asset('images/xebia.png')),
                  ],
                ),
              ),

              RaisedButton(
                onPressed: () {
                  onClickButton(!isLoggedIn);
                },
                textColor: Colors.white,
                padding: EdgeInsets.all(10),
                child: Text('Member Login',
                  style: TextStyle(fontSize: 20),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ],

          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Icon(Icons.mail , color: Colors.white, size: 15,),
                          Padding(
                            padding: EdgeInsets.only(left: 6.0),
                            child: Text(
                              'contact@upesopen.org',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.my_location , color: Colors.white, size: 15,),
                        Padding(
                          padding: EdgeInsets.only(left: 6.0),
                          child: Text(
                            'UPES, Dehradun',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),/*
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.my_location , color: Colors.pink, size: 20,),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text('Dehradun, Uttrakhand'),
                      ),
                    ],
                  )
                ),
                Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.contact_mail , color: Colors.black, size: 20,),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text('contact@upesopen.org'),
                        ),
                      ],
                    )
                )*/
              ],
            ),
          ),
        ),
      ]),
    );
  }

  void onClickButton(bool authStatus) {
    if (authStatus) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
      );
    } else {
      Navigator.pushNamed(context, '/homeBottomNav');
    }
  }
}

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  int selectedIndex = 0;
  String rtName = '/gallery';

  @override
  void initState() {
    fbSetup();
    feedItem = FeedItem('', '', '');
    // TODO: implement initState

    communityPosts = db.reference().child('Gallery');

    communityPosts.onChildAdded.listen(_onEntryAdded);
    communityPosts.onChildChanged.listen(_onEntryChanged);

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
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: appToolbar(context),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(160, 204, 57, 2),
        title: Text('Gallery'),
      ),
      body: Center(
        child: homeContainer(),
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

    child: FirebaseAnimatedList(
        query: FirebaseDatabase.instance.reference().child("Gallery"),
        reverse: false,
        itemBuilder:
            (_, DataSnapshot snapshot, Animation<double> animation, int x) {
          FeedItem f = FeedItem.fromSnapshot(snapshot);
          print(f.title);
          return Card(
            margin: EdgeInsets.only(top: 10, left: 10, right: 10),
            elevation: 5,
            child: Column(
              children: <Widget>[
                loadImg(f.postImgUrl),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    f.title,
                    textAlign: TextAlign.center,
                    style: TextStyle( fontSize: 20),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(f.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blueGrey
                    ),),),
              ],
            ),
          );
        }),
  );
}


Image loadImg(String url) {
  return Image(
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
