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
import 'package:tourguru/screens/ar_views/ar3d_view.dart';
import 'package:tourguru/screens/ar_views/ar_plane_placement.dart';

class ARListView extends StatefulWidget {
  ARListView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ARListViewState createState() => _ARListViewState();
}

class _ARListViewState extends State<ARListView> with WidgetsBindingObserver{

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TourGuru AR 3D View"),
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          new ListTile(
            title: new Text(
              'model name'
            ),
            leading:new Icon(Icons.account_balance) ,
            subtitle:new Container(

                child: new ButtonBar(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
//                    new Text('location'),
                    RaisedButton(onPressed: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return AR3DView();
                          }));
                    }, child: new Text('geo AR')),
                    RaisedButton(onPressed: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return ARPlacementView();
                          }));
                    },
                        child: new Text('AR Plane')),
                  ],

                )
            )



            ),

        ],
      ),
    );
  }
}
