import 'package:audio_record_app/l10n/l10n.dart';
import 'package:audio_record_app/screen/home_screen.dart';
import 'package:audio_record_app/screen/person_screen.dart';
import 'package:audio_record_app/screen/record_screen.dart';
import 'package:audio_record_app/screen/result_screen.dart';
import 'package:audio_record_app/screen/server_ip_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('pl');
  String _address_ip = '192.168.0.183';
  String _port = '5000';
  String _ngrok_address = '1942';
  String _ngrok_address_ip = '178-159-129-139';
  String _domain = 'greatly-fond-dogfish';
  int _choosen_adress_type = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }


  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
    _save();

  }

  void _changeAddressIP(String address_ip, String port, String ngrok_address, String ngrok_address_ip, String domain, int choosen_adress_type) {
    setState(() {
      _address_ip = address_ip;
      _port = port;
      _ngrok_address = ngrok_address;
      _ngrok_address_ip = ngrok_address_ip;
      _domain = domain;
      _choosen_adress_type = choosen_adress_type;
    });
    _save();
  }
  
  void _save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', _locale.languageCode);
    await prefs.setString('address_ip', _address_ip);
    await prefs.setString('port', _port);
    await prefs.setString('ngrok_address', _ngrok_address);
    await prefs.setString('ngrok_address_ip', _ngrok_address_ip);
    await prefs.setString('domain', _domain);
    await prefs.setInt('choosen_adress_type', _choosen_adress_type);
  }

  void _load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? localeCode = prefs.getString('locale');
    if (localeCode != null) {
      setState(() {
      _locale = Locale(localeCode);
      _address_ip = prefs.getString('address_ip') ?? '192.168.0.183';
      _port = prefs.getString('port') ?? '5000';
      _ngrok_address = prefs.getString('ngrok_address') ?? '1942';
      _ngrok_address_ip = prefs.getString('ngrok_address_ip') ?? '178-159-129-139';
      _domain = prefs.getString('domain') ?? 'greatly-fond-dogfish';
      _choosen_adress_type = prefs.getInt('choosen_adress_type') ?? 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Record and Player',
      initialRoute: "/",
      routes:{
        "/": (context) => HomeScreen(onLanguageChanged: _changeLanguage),
        "/server_ip_screen": (context) => ServerIpScreen(
          onLanguageChanged: _changeLanguage, 
          currentLocale: _locale, 
          onAddressChanged: _changeAddressIP, 
          currentAddress: _address_ip, 
          currentPort: _port, 
          currentngrokAddress: _ngrok_address, 
          currentngrokAddressIp: _ngrok_address_ip, 
          currentDomain: _domain,
          currentChosenAddressType: _choosen_adress_type),
        "/person_screen": (context) => PersonData(
          onLanguageChanged: _changeLanguage, 
          currentLocale: _locale),
        "/audio_screen": (context) => AudioPage(
          onLanguageChanged: _changeLanguage, 
          currentLocale: _locale),
        "/result_screen": (context) => ResultScreen(
          currentLocale: _locale, 
          currentAddress: _address_ip,
          currentPort: _port,  
          currentngrokAddress: _ngrok_address, 
          currentngrokAddressIp: _ngrok_address_ip, 
          currentDomain: _domain,
          currentChosenAddressType: _choosen_adress_type)
      },
      theme: ThemeData(
        primarySwatch:  Colors.blue,
      ),
      supportedLocales: L10n.all,
      // ignore: prefer_const_literals_to_create_immutables
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      locale: _locale,
    );
  }
}