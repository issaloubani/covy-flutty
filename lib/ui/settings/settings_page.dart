import 'package:covid_tracker_app/ui/language/language_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("settings".tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: SettingsList(
          lightBackgroundColor: Colors.white,
          sections: [
            SettingsSection(
              title: 'Common',
              tiles: [
                SettingsTile(
                  title: 'change_language'.tr(),
                  subtitle: "language_name".tr(),
                  leading: Icon(Icons.language),
                  onPressed: changeLanguageOnPressed,
                ),
                SettingsTile.switchTile(
                  title: 'Switch Theme',
                  subtitle: 'Light',
                  leading: Icon(Icons.wb_twighlight),
                  switchValue: true,
                  onToggle: (bool value) {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void changeLanguageOnPressed(BuildContext context) =>
      Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => LanguagePage()));
}
