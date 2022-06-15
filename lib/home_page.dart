import 'package:dapp/contract_linking.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contractLink = Provider.of<ContractLinking>(context);
    TextEditingController messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text('Flutter Dapp'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: contractLink.isLoading
              ? const CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Form(
                      child: Column(
                    children: [
                      Text('Welcome to ${contractLink.deployedName}'),

                      TextFormField(
                        controller: messageController,
                        decoration:
                            const InputDecoration(hintText: "Enter Message"),
                      ),

                      const SizedBox(height: 20),
                      
                      ElevatedButton(
                          onPressed: () {
                            contractLink.setMessage(messageController.text);
                            messageController.clear();
                          },
                          child: const Text('Set Message'))
                    
                    ],
                  )),
                ),
        ),
      ),
    );
  }
}
