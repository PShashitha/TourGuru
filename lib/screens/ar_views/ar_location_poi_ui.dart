import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';

import 'package:augmented_reality_plugin_wikitude/architect_widget.dart';
import 'package:augmented_reality_plugin_wikitude/startupConfiguration.dart';
import 'package:augmented_reality_plugin_wikitude/wikitude_plugin.dart';
import 'package:augmented_reality_plugin_wikitude/wikitude_response.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
// import 'package:webview_flutter/webview_flutter.dart';



class ARPOIView extends StatefulWidget {
  ARPOIView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ARPOIViewState createState() => _ARPOIViewState();
}



class _ARPOIViewState extends State<ARPOIView> with WidgetsBindingObserver{

  ArchitectWidget architectWidget;

  final String wikitudeTrialLicenseKey = "fj76LC1eXmnJcC5Mhl9ctO1NYWc5khDJ2Mn"
      "ZbFAXvmLz4WJv2bvCRIDoKJYJmDqBsqBd25HZ2Quw5Ict7qTIPb4cQG7d+opfPn1Xvm1IRq"
      "/VUAzHJ4+ULMN8wRPHpVC/TAb8F66KTZZa7XqhqXx8/iWyF1awapfh3CzjTVToNnJTYWx"
      "0ZWRfX1wxXYOB05vA6/j9VkCE/IGJxBwZxJRPBtSAeBxS7IZLeFbf72BtwzIm/Tss34LRz"
      "VuM98tNA5k/CdaYtGOjX01VgYCchFFAaAg+xBkFdtyqOnGf3pTTPKjSXAl1Q86dS6jLerm"
      "cBloxWxgL0ltn7161OFmAcmDWrynqq9r3CRrVx0pevSwf3EZJNLmHsBJHZFyL9xWoImxyalL"
      "/awD1oPdZKHsSHWC9M01BX7Y6pXaVAzBfQ9os6cHHWF4DxBCtGvsW6pBE16gsahOf3TXK89"
      "s57NO3BlkrsjFTWanp3s3h1ochs7H2Y7qBSjHLbrCAOMqbGY5eTLAoqIvuzsFdMJtDZG9bZ"
      "R4JIaAQQfQCIBaXygHNQSm26C3f4m25ivvH5dVdlKvRu+VUMlLtTyNPz6Fd06SG/4j+KK1Ga"
      "t2Pkat3dHuEFri3+DHB5Zl8KtJcaEdcbPQmTFGMNsnb0u7bw5BazcwlfQm8eN9Xm+o0xmUP"
      "ikOrPGF7T9WubR5taG3NBU0OC3EpjLfSwdpXjOAIcFpuqNCLzqN6hfx+nS/1jK0elvRSG"
      "AqK3s91g94XS8KujCZxseW+My/OTLtAMJvKOqy5WFEswl+LSutbIBlOrDtcBvHwdAhg7nk"
      "q7mrw7s+mIQu03uUDZTd45ltw0V5QyBYoz1mPj5vUPA==";


  dynamic onLoadFailed(String a) => log(a);

  // final Completer<WebViewController> _controller =
  // Completer<WebViewController>();




  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);

//    List<String> features = ["image_tracking", "geo"];
    // Future<WikitudeResponse> response = isFeatureSupported(features);


    architectWidget = new ArchitectWidget(
      onArchitectWidgetCreated: onArchitectWidgetCreated,
      licenseKey: wikitudeTrialLicenseKey,
      startupConfiguration: StartupConfiguration(
        cameraFocusMode: CameraFocusMode.CONTINUOUS,
        cameraPosition: CameraPosition.BACK,
        cameraResolution: CameraResolution.AUTO
      ),
      features: [ "image_tracking", "geo" ],
    );


    this.architectWidget.setLocation(6.9130779, 79.9724734, 0, 0.1);
  }

  Future<WikitudeResponse> isFeatureSupported(List<String> features) async{
    return await WikitudePlugin.isDeviceSupporting(features);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        if (this.architectWidget != null) {
//          this.architectWidget.setLocation(6.9149771, 79.9785114, 100, 0.5);
          this.architectWidget.pause();
        }
        break;
      case AppLifecycleState.resumed:
        if (this.architectWidget != null) {
//          this.architectWidget.setLocation(6.9149771, 79.9785114, 100, 0.5);
          this.architectWidget.resume();
        }
        break;

      default:
    }
  }

  @override
  void dispose() {
    if (this.architectWidget != null) {
      this.architectWidget.pause();
      this.architectWidget.destroy();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> onArchitectWidgetCreated() async {


    this.architectWidget.load('assets/BrowsingPois/index.html', onLoadSuccess,  onLoadFailed);

    String url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=6.9130779,79.9724734&radius=1500&key=AIzaSyBLcIpermU2uTd2ny81zbPVoWXNwQ8_6JU";



//    this.architectWidget.setLocation(6.9149771, 79.9785114, 100, 0.5);


    this.architectWidget.resume();
  }

  onLoadSuccess(){
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text("AR Load Success"),
    ));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("POI AR Labeling View"),
    // Here we take the value from the MyHomePage object that was created by
    // the App.build method, and use it to set our appbar title.
    ),
    body: architectWidget
    );
  }
}

enum MenuOptions {
  showUserAgent,
  listCookies,
  clearCookies,
  addToCache,
  listCache,
  clearCache,
  navigationDelegate,
}

// class SampleMenu extends StatelessWidget {
//   SampleMenu(this.controller);

//   final Future<WebViewController> controller;
//   final CookieManager cookieManager = CookieManager();

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<WebViewController>(
//       future: controller,
//       builder:
//           (BuildContext context, AsyncSnapshot<WebViewController> controller) {
//         return PopupMenuButton<MenuOptions>(
//           onSelected: (MenuOptions value) {
//             switch (value) {
//               case MenuOptions.showUserAgent:
//                 _onShowUserAgent(controller.data, context);
//                 break;
//               case MenuOptions.listCookies:
//                 _onListCookies(controller.data, context);
//                 break;
//               case MenuOptions.clearCookies:
//                 _onClearCookies(context);
//                 break;
//               case MenuOptions.addToCache:
//                 _onAddToCache(controller.data, context);
//                 break;
//               case MenuOptions.listCache:
//                 _onListCache(controller.data, context);
//                 break;
//               case MenuOptions.clearCache:
//                 _onClearCache(controller.data, context);
//                 break;
//               case MenuOptions.navigationDelegate:
//                 _onNavigationDelegateExample(controller.data, context);
//                 break;
//             }
//           },
//           itemBuilder: (BuildContext context) => <PopupMenuItem<MenuOptions>>[
//             PopupMenuItem<MenuOptions>(
//               value: MenuOptions.showUserAgent,
//               child: const Text('Show user agent'),
//               enabled: controller.hasData,
//             ),
//             const PopupMenuItem<MenuOptions>(
//               value: MenuOptions.listCookies,
//               child: Text('List cookies'),
//             ),
//             const PopupMenuItem<MenuOptions>(
//               value: MenuOptions.clearCookies,
//               child: Text('Clear cookies'),
//             ),
//             const PopupMenuItem<MenuOptions>(
//               value: MenuOptions.addToCache,
//               child: Text('Add to cache'),
//             ),
//             const PopupMenuItem<MenuOptions>(
//               value: MenuOptions.listCache,
//               child: Text('List cache'),
//             ),
//             const PopupMenuItem<MenuOptions>(
//               value: MenuOptions.clearCache,
//               child: Text('Clear cache'),
//             ),
//             const PopupMenuItem<MenuOptions>(
//               value: MenuOptions.navigationDelegate,
//               child: Text('Navigation Delegate example'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _onShowUserAgent(
//       WebViewController controller, BuildContext context) async {
//     // Send a message with the user agent string to the Toaster JavaScript channel we registered
//     // with the WebView.
//     controller.evaluateJavascript(
//         'Toaster.postMessage("User Agent: " + navigator.userAgent);');
//   }

//   void _onListCookies(
//       WebViewController controller, BuildContext context) async {
//     final String cookies =
//     await controller.evaluateJavascript('document.cookie');
//     Scaffold.of(context).showSnackBar(SnackBar(
//       content: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           const Text('Cookies:'),
//           _getCookieList(cookies),
//         ],
//       ),
//     ));
//   }

//   void _onAddToCache(WebViewController controller, BuildContext context) async {
//     await controller.evaluateJavascript(
//         'caches.open("test_caches_entry"); localStorage["test_localStorage"] = "dummy_entry";');
//     Scaffold.of(context).showSnackBar(const SnackBar(
//       content: Text('Added a test entry to cache.'),
//     ));
//   }

//   void _onListCache(WebViewController controller, BuildContext context) async {
//     await controller.evaluateJavascript('caches.keys()'
//         '.then((cacheKeys) => JSON.stringify({"cacheKeys" : cacheKeys, "localStorage" : localStorage}))'
//         '.then((caches) => Toaster.postMessage(caches))');
//   }

//   void _onClearCache(WebViewController controller, BuildContext context) async {
//     await controller.clearCache();
//     Scaffold.of(context).showSnackBar(const SnackBar(
//       content: Text("Cache cleared."),
//     ));
//   }

//   void _onClearCookies(BuildContext context) async {
//     final bool hadCookies = await cookieManager.clearCookies();
//     String message = 'There were cookies. Now, they are gone!';
//     if (!hadCookies) {
//       message = 'There are no cookies.';
//     }
//     Scaffold.of(context).showSnackBar(SnackBar(
//       content: Text(message),
//     ));
//   }

//   void _onNavigationDelegateExample(
//       WebViewController controller, BuildContext context) async {
//     final String contentBase64 =
//     base64Encode(const Utf8Encoder().convert(kNavigationExamplePage));
    
//     controller.loadUrl('data:text/html;base64,$contentBase64');
//   }

//   Widget _getCookieList(String cookies) {
//     if (cookies == null || cookies == '""') {
//       return Container();
//     }
//     final List<String> cookieList = cookies.split(';');
//     final Iterable<Text> cookieWidgets =
//     cookieList.map((String cookie) => Text(cookie));
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.end,
//       mainAxisSize: MainAxisSize.min,
//       children: cookieWidgets.toList(),
//     );
//   }
// }

// class NavigationControls extends StatelessWidget {
//   const NavigationControls(this._webViewControllerFuture)
//       : assert(_webViewControllerFuture != null);

//   final Future<WebViewController> _webViewControllerFuture;

//   @override
//   Widget build(BuildContext context) {

//     return FutureBuilder<WebViewController>(
//       future: _webViewControllerFuture,
//       builder:
//           (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
//         final bool webViewReady =
//             snapshot.connectionState == ConnectionState.done;
//         final WebViewController controller = snapshot.data;
//         return Row(
//           children: <Widget>[

//             IconButton(
//               icon: const Icon(Icons.arrow_back_ios),
//               onPressed: !webViewReady
//                   ? null
//                   : () async {
//                 if (await controller.canGoBack()) {
//                   controller.goBack();
//                 } else {
//                   Scaffold.of(context).showSnackBar(
//                     const SnackBar(content: Text("No back history item")),
//                   );
//                   return;
//                 }
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.arrow_forward_ios),
//               onPressed: !webViewReady
//                   ? null
//                   : () async {
//                 if (await controller.canGoForward()) {
//                   controller.goForward();
//                 } else {
//                   Scaffold.of(context).showSnackBar(
//                     const SnackBar(
//                         content: Text("No forward history item")),
//                   );
//                   return;
//                 }
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.replay),
//               onPressed: !webViewReady
//                   ? null
//                   : () {
//                 controller.reload();
//               },
//             ),


//           ],
//         );
//       },
//     );
//   }
// }
