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

class AR3DView extends StatefulWidget {
  AR3DView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AR3DViewState createState() => _AR3DViewState();
}

class _AR3DViewState extends State<AR3DView> with WidgetsBindingObserver{

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
    WidgetsBinding.instance.addObserver(this);

    List<String> features = ["image_tracking", "geo"];
    Future<WikitudeResponse> response = isFeatureSupported(features);


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
          this.architectWidget.setLocation(6.9149771, 79.9785114, 100, 0.5);
          this.architectWidget.pause();
        }
        break;
      case AppLifecycleState.resumed:
        if (this.architectWidget != null) {
          this.architectWidget.setLocation(6.9149771, 79.9785114, 100, 0.5);
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


    this.architectWidget.load('assets/3dModelAtGeoLocation/index.html', onLoadSuccess,  onLoadFailed);

    String url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=6.9130779,79.9724734&radius=1500&key=AIzaSyBLcIpermU2uTd2ny81zbPVoWXNwQ8_6JU";



    this.architectWidget.setLocation(6.9149771, 79.9785114, 100, 0.5);


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
            title: Text("TourGuru AR 3D View"),
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
          ),
          body: architectWidget,
        );
  }
}
