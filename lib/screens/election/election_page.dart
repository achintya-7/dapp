import 'package:dapp/services/functions.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

class ElectionPage extends StatefulWidget {
  const ElectionPage({
    Key? key, required this.electionName, required this.ethClient,
  }) : super(key: key);

  final String electionName;
  final Web3Client ethClient;

  @override
  State<ElectionPage> createState() => _ElectionPageState();
}

class _ElectionPageState extends State<ElectionPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController addCandidateController = TextEditingController();
    TextEditingController authorizeVoterController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.electionName),
      ),
      body: Container(
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
                          return Text(snapshot.data?[0].toString() ?? '0');
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
                          return Text(snapshot.data?[0].toString() ?? '0');
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
                        if (addCandidateController.text.isNotEmpty)  {
                          await addCandidate(addCandidateController.text, widget.ethClient);
                          setState(() {});
                        }
                      } on Exception catch (e) {
                        print('Error : $e');
                      }
                    },
                    child: const Text('Add Candinate'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
