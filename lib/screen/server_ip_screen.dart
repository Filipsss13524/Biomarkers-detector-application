import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class ServerIpScreen extends StatefulWidget {
  final Function(String, String, String, String, String, int) onAddressChanged;
  final Function(Locale) onLanguageChanged;
  final Locale currentLocale;
  final String currentAddress;
  final String currentPort;
  final String currentngrokAddress;
  final String currentngrokAddressIp;
  final String currentDomain;
  final int currentChosenAddressType;

  const ServerIpScreen({
    super.key, 
    required this.onLanguageChanged, 
    required this.currentLocale, 
    required this.onAddressChanged, 
    required this.currentAddress, 
    required this.currentPort, 
    required this.currentngrokAddress, 
    required this.currentngrokAddressIp, 
    required this.currentDomain,
    required this.currentChosenAddressType});

  @override
  State<ServerIpScreen> createState() => _ServerIpScreenState();
}

class _ServerIpScreenState extends State<ServerIpScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _ip_server;
  late final TextEditingController _port;
  late final TextEditingController _ip_ngrok_address;
  late final TextEditingController _ngrok_ip_server;
  late final TextEditingController _domain;
  late int _ip_server_type = widget.currentChosenAddressType;

  @override
  void initState() {
    super.initState();
    // Inicjalizowanie kontrolera w initState
    _ip_server = TextEditingController(text: widget.currentAddress);
    _port = TextEditingController(text: widget.currentPort);
    _ip_ngrok_address = TextEditingController(text: widget.currentngrokAddress);
    _ngrok_ip_server = TextEditingController(text: widget.currentngrokAddressIp);
    _domain = TextEditingController(text: widget.currentDomain);
    _ip_server_type = widget.currentChosenAddressType;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc!.serverIp),
        backgroundColor: Colors.blue,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: 'Change language',
            onPressed: () {
                  final newLocale = widget.currentLocale.languageCode == 'en'
                      ? const Locale('pl')
                      : const Locale('en');
                  widget.onLanguageChanged(newLocale);
                },
            ),
        ]
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _ip_server,
                decoration: InputDecoration(
                  labelText: loc.serverIp,
                  hintText: "XXX.XXX.XXX.XXX",
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return loc.serverhelp;
                  }
                  final ipRegExp = RegExp(
                      r'^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$');
                  if (!ipRegExp.hasMatch(value)) {
                    return loc.servervalid;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _port,
                decoration: InputDecoration(
                  labelText: loc.port,
                  hintText: "XXXX",
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return loc.porthelp;
                  }
                  final ipRegExp = RegExp(r'^\d+$');
                  if (!ipRegExp.hasMatch(value)) {
                    return loc.portvalid;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _ip_ngrok_address,
                decoration: InputDecoration(
                  labelText: loc.addressngrok,
                  hintText: "XXXX",
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return loc.addressngrokhelp;
                  }
                  final ipRegExp = RegExp(r'^.{4}$');
                  if (!ipRegExp.hasMatch(value)) {
                    return loc.addressngrokvalid;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _ngrok_ip_server,
                decoration: InputDecoration(
                  labelText: loc.addressIPngrok,
                  hintText: "XXX-XXX-XXX-XXX",
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d-]')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return loc.addressIPngrokhelp;
                  }
                  final ipRegExp = RegExp(
                      r'^(?:[0-9]{1,3}\-){3}[0-9]{1,3}$');
                  if (!ipRegExp.hasMatch(value)) {
                    return loc.addressIPngrokvalid;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _domain,
                decoration: InputDecoration(
                  labelText: loc.domain,
                  hintText: loc.domainhint,
                  border: const OutlineInputBorder(),
                ),
              ),
              Row(children: [
                Text(loc.servertype + '${_ip_server_type == 0 ? loc.globaldomain : _ip_server_type == 1 ? loc.global : loc.local}'),
                const Spacer(),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _ip_server_type = (_ip_server_type + 1) % 3;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(color: Colors.black)
                    ),
                    child: Text(
                          loc.changest, 
                    )),
              ],),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final String newCurrentAddress = _ip_server.text;
                    final String newCurrentPort = _port.text;
                    final String newCurrentNgrokAddress = _ip_ngrok_address.text;
                    final String newCurrentNgrokAddressIp = _ngrok_ip_server.text;
                    final String newCurrentDomain = _domain.text;
                    final int newCurrentAddressType = _ip_server_type;
                    widget.onAddressChanged(newCurrentAddress, newCurrentPort, newCurrentNgrokAddress, newCurrentNgrokAddressIp, newCurrentDomain, newCurrentAddressType);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(loc.savecomfirmed)),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 16
                      ),
                ),
                child: Text(
                      loc.save, 
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16
                        ))
              ),
            ],
          ),
        ),
      ),
    );
  }
}

