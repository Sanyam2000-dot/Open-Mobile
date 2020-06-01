import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';



class DeveloperInfo extends StatefulWidget {
  @override
  _DeveloperInfoState createState() => _DeveloperInfoState();
}

class _DeveloperInfoState extends State<DeveloperInfo> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromRGBO(160, 204, 57, 2),
        body: SafeArea(
            child: mainContainer()
        ),
      ),
    );
  }

}
Container mainContainer(){
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
          image: AssetImage("images/homeBG.jpeg"),
          fit: BoxFit.fill
      ),
    ),
    child: Column(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Maintained by :',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'IndieFlower',
                  ),
                ),
                Column(
                  children: [
                    Text(
                      'Akash Saini',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.black,
                        //fontWeight: FontWeight.bold,
                        fontFamily: 'IndieFlower',
                      ),
                    ),

                    FlatButton(
                      onPressed: (){
                        _launchURL('mailto:akash2237778@gmail.com');
                      },
                      child: Card(
                        elevation: 5,
                          color: Colors.white,
                          child: ListTile(
                            leading: Icon(
                                Icons.email
                            ),
                            title: Text('akash2237778@gmail.com'),
                          )
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(10),
            alignment: FractionalOffset.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FlatButton(
                  onPressed: (){
                    _launchURL('https://www.linkedin.com/in/akash-saini-ak7778/');
                  },
                  child: Image(
                    image: AssetImage('images/linkedin.png'),
                    height: 40,
                    width: 40,
                  ),
                ),
                FlatButton(
                  onPressed: (){
                    _launchURL('https://github.com/akash2237778');
                  },
                  child: Image(
                    image: AssetImage('images/github.png'),
                    height: 40,
                    width: 40,
                  ),
                ),
                FlatButton(
                  onPressed: (){
                    _launchURL('https://www.instagram.com/akash_saini7778/');
                  },
                  child: Image(
                    image: AssetImage('images/instagram.png'),
                    height: 40,
                    width: 40,
                  ),
                ),

              ],
            ),
          ),
        ),
      ],
    ),
  );
}
_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}


