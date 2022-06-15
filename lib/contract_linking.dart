import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class ContractLinking extends ChangeNotifier {
  final String _rpcUrl = "http://10.0.2.2:7545";
  final String _wsUrl = "ws://10.0.2.2:7545";
  final String _privateKey =
      "541ab4f25d343e1f50752619cfdcbd9449ae1b77c54e9c85efd384f0d4dfb5a6";

  // establish connection with Ethereum and rpc node
  Web3Client? _web3client;
  bool isLoading = true;

  // reads contract i.e. HelloWorld.json
  String? _abiCode;
  // contract address
  EthereumAddress? _contractAddress;

  Credentials? _credentials;

  // where is the contract declared
  DeployedContract? _contract;

  // functions in smart contract
  ContractFunction? _message;
  ContractFunction? _setMessage;

  // smart contract name
  String? deployedName;

  ContractLinking() {
    setup();
  }

  setup() async {
    _web3client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });

    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    String abiStringFile =
        await rootBundle.loadString('build/contracts/HelloWorld.json');
    final jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi['abi']);

    // we need that address
    _contractAddress =
        EthereumAddress.fromHex(jsonAbi['networks']['5777']['address']);
    print("Contract Address : $_contractAddress");
  }

  Future<void> getCredentials() async {
    _credentials = EthPrivateKey.fromHex(_privateKey);
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode!, "HelloWorld"), _contractAddress!);

    _message = _contract!.function('message');
    _setMessage = _contract!.function("setMessage");
    print('Doing Stuff 1');
    getMessage();
  }

  getMessage() async {
    print('Starting Server');
    final myMessage = await _web3client!
        .call(contract: _contract!, function: _message!, params: []);
    print('Doing Stuff 2');
    deployedName = myMessage[0];
    isLoading = false;
    notifyListeners();
  }

  setMessage(String message) async {
    isLoading = true;
    notifyListeners();
    await _web3client!.sendTransaction(
        _credentials!,
        Transaction.callContract(
            contract: _contract!,
            function: _setMessage!,
            parameters: [message]));
    getMessage();
  }
}
