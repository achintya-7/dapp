import 'package:dapp/services/functions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:web3dart/web3dart.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({
    Key? key,
    required this.electionName,
    required this.ethClient,
  }) : super(key: key);

  final String electionName;
  final Web3Client ethClient;

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController addCandidateController = TextEditingController();
    TextEditingController authorizeVoterController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: Text(
          widget.electionName,
          style: const TextStyle(color: Colors.black),
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      FutureBuilder<List>(
                          future: getCandidatesNum(widget.ethClient),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return Text(
                              snapshot.data?[0].toString() ?? '0',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            );
                          }),
                      const Text('Total Candinates')
                    ],
                  ),
                  Column(
                    children: [
                      FutureBuilder<List>(
                          future: getTotalVotes(widget.ethClient),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return Text(
                              snapshot.data?[0].toString() ?? '0',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            );
                          }),
                      const Text('Total Votes')
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: addCandidateController,
                      decoration:
                          const InputDecoration(hintText: 'Add Candinate Name'),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          if (addCandidateController.text.isNotEmpty) {
                            await addCandidate(
                                addCandidateController.text, widget.ethClient);
                            setState(() {});
                          }
                        } on Exception catch (e) {
                          print('Error : $e');
                        }
                      },
                      child: const Text(
                        'Add Candinate',
                        style: TextStyle(color: Colors.black),
                      )),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: authorizeVoterController,
                      decoration: const InputDecoration(
                          hintText: 'Enter Voter address'),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          await authorizeVoter(
                              authorizeVoterController.text, widget.ethClient);
                           ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('User Added')));
                        } on Exception catch (e) {
                          print('Error : $e');
                        } finally {
                          authorizeVoterController.clear();
                        }
                      },
                      child: const Text(
                        'Add Voter',
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(
                thickness: 1,
              ),
              const SizedBox(
                height: 20,
              ),
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
                                  return Container(
                                    child: ListTile(
                                      title: Text(
                                          'Name: ${candidatesnapshot.data![0][0]}'),
                                      subtitle: Text(
                                          'Votes: ${candidatesnapshot.data![0][1]}'),
                                      // trailing: ElevatedButton(
                                      //     onPressed: () {
                                      //       vote(i, widget.ethClient);
                                      //     },
                                      //     child: const Text('Vote')),
                                    ),
                                  );
                                }
                              })
                      ],
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
