import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:firebase_admob/firebase_admob.dart';


void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    var title = 'Instabook';
    return new MaterialApp(
      title: title,
      home: new MyAppHomePage(),
    );
  }
}

class MyAppHomePage extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

const String flutterUrl = "https://www.instagram.com";
const String wikiUrl = "https://m.facebook.com";



class _MyAppState extends State<MyAppHomePage> {
  WebViewController _controller;

  static MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['insurance', 'mortgage'],
    childDirected: false,
    testDevices: <String>[], // Android emulators are considered test devices
  );

  BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-5366182682228329/7430785073',
    size: AdSize.banner,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("BannerAd event is $event");
    },
  );

  InterstitialAd myInterstitial = InterstitialAd(
    adUnitId: 'ca-app-pub-5366182682228329/2186197254',
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("InterstitialAd event is $event");
    },
  );

  _back() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
    }
  }

  _forward() async {
    if (await _controller.canGoForward()) {
      await _controller.goForward();
    }
  }

  _loadPage() async {
    var url = await _controller.currentUrl();
    _controller.loadUrl(
      url == "https://www.instagram.com"
          ? 'https://www.facebook.com'
          : "https://www.instagram.com",
    );
     myInterstitial..show();
    print(url);
  }



  @override
  Widget build(BuildContext context) {
    myBanner..show(anchorType: AnchorType.top,);

    return Scaffold(
      appBar: AppBar(
        title: Text('Instabook'),
        actions: <Widget>[
          IconButton(
            onPressed: _back,
            icon: Icon(Icons.arrow_back_ios),
          ),
          IconButton(
            onPressed: _forward,
            icon: Icon(Icons.arrow_forward_ios),
          ),
          SizedBox(width: 10),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadPage,

        child: Icon(Icons.refresh),
      ),
      body: SafeArea(
        child: WebView(
          key: Key("webview"),
          initialUrl: flutterUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller = webViewController;
          },
        ),
      ),
    );

  }

  @override
  void initState() {
    FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-2167932603142585~4600569619');
    super.initState();
    myBanner..load();
    myInterstitial..load();
  }


//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//        appBar: AppBar(
//          title: Text("Sample App"),
//        ),
//        body: new Center(
//          child: new RaisedButton(
//              child: Text('Open Link'),
//              onPressed: () {
//                _opennewpage();
//              }
//          ) ,
//        )
//    );
//  }
//    // Open Page Function
//  void _opennewpage() {
//    Navigator.of(context).pushNamed('/widget');
//  }

//  routes: {
//        '/widget': (_) => new WebviewScaffold(
//          url: "https:\\FlutterCentral.com",
//          appBar: new AppBar(
//            title: const Text('Widget Webview'),
//          ),
//          withZoom: false,
//          withLocalStorage: true,
//        )
//      },


}