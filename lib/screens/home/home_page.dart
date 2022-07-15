// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:dapp/screens/admin/admin_page.dart';
import 'package:dapp/screens/user/user_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:web3dart/web3dart.dart';
import 'package:dapp/screens/election/election_page.dart';
import 'package:dapp/services/functions.dart';
import 'package:dapp/utils/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Client httpClient;
  late Web3Client ethClient;
  TextEditingController nameController = TextEditingController();
  late ProgressDialog progressDialog;

  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(infuraUrl, httpClient);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          centerTitle: true,
          title: const Text(
            'Welcome to Election Dapp',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/india_flag.jpg'),
                  fit: BoxFit.cover)),
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => AdminPage(
                                    ethClient: ethClient,
                                    electionName: 'MLA',
                                  )));
                        },
                        child: const Text(
                          'Admin',
                          style: TextStyle(color: Colors.black),
                        )),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => UserPage(ethClient: ethClient)));
                        },
                        child: const Text(
                          'User',
                          style: TextStyle(color: Colors.black),
                        ))
                  ],
                ),
              )),
        ));
  }
}
