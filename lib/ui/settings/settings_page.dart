import 'package:covid_tracker_app/global/theme/bloc/theme_bloc.dart';
import 'package:covid_tracker_app/global/theme/theme_service.dart';
import 'package:covid_tracker_app/ui/language/language_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    bool switchValue = Theme.of(context).brightness == Brightness.dark ? true : false;
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
              title: 'common'.tr(),
              tiles: [
                SettingsTile(
                  title: 'change_language'.tr(),
                  subtitle: "language_name".tr(),
                  leading: Icon(Icons.language),
                  onPressed: changeLanguageOnPressed,
                ),
                SettingsTile.switchTile(
                  title: 'switch_theme'.tr(),
                  subtitle: switchValue ? 'dark_theme'.tr() : 'light_theme'.tr(),
                  leading: switchValue
                      ? Icon(Icons.nights_stay)
                      : Icon(Icons.wb_twighlight),
                  switchValue: switchValue,
                  onToggle: (bool value) {
                    if (value) {
                      context.bloc<ThemeBloc>().add(ChangeTheme(AppTheme.dark));
                    } else {
                      context
                          .bloc<ThemeBloc>()
                          .add(ChangeTheme(AppTheme.light));
                    }

                    switchValue = value;
                  },
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
