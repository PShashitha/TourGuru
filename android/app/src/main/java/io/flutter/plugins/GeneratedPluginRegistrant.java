package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import com.wikitude.wikitude_plugin.WikitudePlugin;
import com.tundralabs.fluttertts.FlutterTtsPlugin;
import io.flutter.plugins.googlemaps.GoogleMapsPlugin;
import com.lyokone.location.LocationPlugin;
import io.flutter.plugins.webviewflutter.WebViewFlutterPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    WikitudePlugin.registerWith(registry.registrarFor("com.wikitude.wikitude_plugin.WikitudePlugin"));
    FlutterTtsPlugin.registerWith(registry.registrarFor("com.tundralabs.fluttertts.FlutterTtsPlugin"));
    GoogleMapsPlugin.registerWith(registry.registrarFor("io.flutter.plugins.googlemaps.GoogleMapsPlugin"));
    LocationPlugin.registerWith(registry.registrarFor("com.lyokone.location.LocationPlugin"));
    WebViewFlutterPlugin.registerWith(registry.registrarFor("io.flutter.plugins.webviewflutter.WebViewFlutterPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
