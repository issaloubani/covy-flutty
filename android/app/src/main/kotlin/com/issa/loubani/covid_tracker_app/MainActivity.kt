package com.issa.loubani.covid_tracker_app

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;

class MainActivity: FlutterActivity() , PluginRegistrantCallback{
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
       // createChannel()
        FlutterFirebaseMessagingService.setPluginRegistrant(this)
       // BackgroundFetchPlugin.setPluginRegistrant(this)

    }

    override fun registerWith(registry: PluginRegistry?) {
        // registry?.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin");
        io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin.registerWith(registry?.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
      //  com.transistorsoft.flutter.backgroundfetch.BackgroundFetchPlugin.registerWith(registry?.registrarFor("com.transistorsoft.flutter.backgroundfetch.BackgroundFetchPlugin"))
    }
}
