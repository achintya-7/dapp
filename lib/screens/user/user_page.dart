import 'package:dapp/services/functions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:web3dart/web3dart.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key, required this.ethClient}) : super(key: key);
  final Web3Client ethClient;

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String ethKey = '';
  TextEditingController keyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(  
            color: Colors.black
          ),
          backgroundColor: Colors.amber,
          centerTitle: true,
          title: const Text(
            'MLA Voting',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
                onPressed: () => setState(() {}),
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.black,
                ))
          ],
        ),
        body: SafeArea(
            child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: keyController,
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  if (keyController.text.isNotEmpty) {
                    ethKey = keyController.text;
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Key Confirmed')));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please provde a key')));
                  }
                },
                child: const Text('confirm')),
            FutureBuilder<List>(
              future: getCandidatesNum(widget.ethClient),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Column(
                    children: [
                      for (int i = 0; i < snapshot.data![0].toInt(); i++)
                        FutureBuilder<List>(
                            future: candidateInfo(i, widget.ethClient),
                            builder: (context, candidatesnapshot) {
                              if (candidatesnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return ListTile(
                                  title: Text(
                                      'Name: ${candidatesnapshot.data![0][0]}'),
                                  subtitle: Text(
                                      'Votes: ${candidatesnapshot.data![0][1]}'),
                                  trailing: ElevatedButton(
                                      onPressed: () async {
                                        print(keyController.text.length);
                                        if (keyController.text.length == 64) {
                                          try {
                                            await vote(i, widget.ethClient,
                                                keyController.text);
                                          } on Exception catch (e) {
                                            print('Error : $e');
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        'You have already voted')));
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      'Please provide a correct key')));
                                        }
                                      },
                                      child: const Text('Vote')),
                                );
                              }
                            })
                    ],
                  );
                }
              },
            ),
          ],
        )));
  }
}
