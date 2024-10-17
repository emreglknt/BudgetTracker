import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_langugage_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    var d = AppLocalizations.of(context)!;
    var appLanguage = Provider.of<AppLanguageProvider>(context);

    return   Scaffold(
      appBar: AppBar(
        title: Text(d.profile_title),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 4), // İkon ile metin arasında boşluk
              Text(
                "Change Language",
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ],
          ),
          PopupMenuButton<int>(
            icon: Icon(Icons.language, color: Colors.orange),
            iconSize: 33,
            color: Colors.orangeAccent,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.abc, color: Colors.indigo),
                    SizedBox(width: 10),
                    Text("English"),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 2,
                child: Row(
                  children: [
                    Icon(Icons.language, color: Colors.indigo),
                    SizedBox(width: 10),
                    Text("Türkçe"),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 3,
                child: Row(
                  children: [
                    Icon(Icons.language, color: Colors.indigo),
                    SizedBox(width: 10),
                    Text("Deutsch"),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 1) {
                appLanguage.changeLanguage(const Locale("en"));
              } else if (value == 2) {
                appLanguage.changeLanguage(const Locale("tr"));
              } else if (value == 3) {
                appLanguage.changeLanguage(const Locale("de"));
              }
            },
          ),
        ],
      ),




    );
  }
}
