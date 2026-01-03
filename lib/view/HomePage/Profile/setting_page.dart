
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final List<Locale> supportedLocales = EasyLocalization.of(
      context,
    )!.supportedLocales;

    Locale valueLocale = supportedLocales.firstWhere(
      (l) => l.languageCode == context.locale.languageCode &&
          (l.countryCode == context.locale.countryCode ||
              l.countryCode == null ||
              context.locale.countryCode == null),
      orElse: () => supportedLocales.first,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff2D5C7A),
        title: Text('Settings'.tr(),style: TextStyle(
            color: Colors.white
        ),),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: Icon(Icons.settings, color: Colors.white),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: Icon(
                HousingApp.isDarkMode.value ? Icons.dark_mode : Icons.light_mode,
                color: const Color(0xff2D5C7A),
              ),
              title: HousingApp.isDarkMode.value ? Text('Dark Mode'.tr()) : Text('Light Mode'.tr()),
              trailing: Switch(
                value: HousingApp.isDarkMode.value,
                onChanged: (value) {
                  setState(() {
                    HousingApp.isDarkMode.value = value;
                  });
                },
              ),
            ),
          ),

          const SizedBox(height: 4),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text('language'.tr()),
              leading: const Icon(Icons.language, color: Colors.black),
              trailing: DropdownButton<Locale>(
                value: valueLocale,
                items: supportedLocales.map((local) {
                  String label;
                  if (local.languageCode == 'en')
                  {
                    label = 'English';
                  }
                  else if (local.languageCode == 'ar') {
                    label = 'العربية';
                  }
                  else 
                  {
                    label = local.toString();
                  }
                  return DropdownMenuItem<Locale>(
                    value: local,
                    child: Text(label),
                  );
                }).toList(),
                onChanged: (Locale? newLocale) {
                  if (newLocale != null) {
                    context.setLocale(newLocale).then((_) {
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
