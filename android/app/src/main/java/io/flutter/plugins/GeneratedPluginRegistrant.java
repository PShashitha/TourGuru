package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import com.flutter.text_to_speech.FlutterTextToSpeechPlugin;
import com.tundralabs.fluttertts.FlutterTtsPlugin;
import io.flutter.plugins.googlemaps.GoogleMapsPlugin;
import com.lyokone.location.LocationPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    FlutterTextToSpeechPlugin.registerWith(registry.registrarFor("com.flutter.text_to_speech.FlutterTextToSpeechPlugin"));
    FlutterTtsPlugin.registerWith(registry.registrarFor("com.tundralabs.fluttertts.FlutterTtsPlugin"));
    GoogleMapsPlugin.registerWith(registry.registrarFor("io.flutter.plugins.googlemaps.GoogleMapsPlugin"));
    LocationPlugin.registerWith(registry.registrarFor("com.lyokone.location.LocationPlugin"));
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
