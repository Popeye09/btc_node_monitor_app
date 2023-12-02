import 'dart:async';
import 'package:bitcoin_node_monitor_app/main.dart';
import 'package:flutter/material.dart';
import '../node.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool ipAddressPresent = false;
  Node node = Node();
  TextEditingController uriController = TextEditingController();
  TextEditingController blockHashController = TextEditingController();

  int uptime = 0;
  String uptimeFormatted = "";

  Timer? timer;

  void setupTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      uptime += 1;
      if (uptime % 15 == 0) {
        getFormattedUptime().then((value) {
          setState(() {
            uptimeFormatted = value;
          });
        });
      }
      setState(() {
        uptimeFormatted = formatTime(uptime);
      });
    });
  }

  @override
  void initState() {
    node.nodeAddress = preferences!.getString("nodeAddress");

    if (node.nodeAddress == null || node.nodeAddress!.isEmpty) {
      ipAddressPresent = false;
      print("EMPTY");
    } else {
      ipAddressPresent = true;
      getFormattedUptime().then((value) {
        setState(() {
          uptimeFormatted = value;
        });
      });

      setupTimer();
      loadWallets();
    }

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ipAddressPresent ? buildMainPage() : buildWelcomePage();
  }

  Widget buildWelcomePage() {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
          onPressed: () {
            if (uriController.text.isNotEmpty) {
              preferences!.setString("nodeAddress", uriController.text);
              setState(() {
                ipAddressPresent = true;
                node.nodeAddress = uriController.text;
              });
              getFormattedUptime().then((value) {
                setState(() {
                  uptimeFormatted = value;
                });
              });
              setupTimer();
              loadWallets();
            }
            if (uriController.text.isEmpty) {
              print("EMPTY");
            }
          },
          child: Text("Start monitoring")),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Bitcoin Node Monitor"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
              style: Theme.of(context).textTheme.bodySmall,
              controller: uriController,
              keyboardType: TextInputType.url,
              autocorrect: false,
              decoration:
                  InputDecoration(label: Text("Enter node's IP address"))),
        ),
      ),
    );
  }

  Widget buildMainPage() {
    return node.online
        ? Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: ElevatedButton(
                onPressed: () {
                  preferences!.clear();
                  setState(() {
                    ipAddressPresent = false;
                    node.nodeAddress = "";
                  });
                },
                child: Text("Reset")),
            appBar: AppBar(
              centerTitle: true,
              title: Text("Bitcoin Node Monitor"),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(50),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Up for $uptimeFormatted",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      SizedBox(height: 50),
                      ElevatedButton(
                          onPressed: () {
                            node.stop().then((value) {
                              if (value.isNotEmpty) {
                                setState(() {
                                  node.online = false;
                                });
                              }
                            });
                          },
                          child: Text("Stop node")),
                      SizedBox(height: 50),
                      ElevatedButton(
                          onPressed: () {
                            node.blockchainHeight().then((value) {
                              setState(() {
                                node.height = value;
                              });
                            });
                          },
                          child: Text("Get blockchain height")),
                      SizedBox(height: 10),
                      Text(node.height == 0 ? "" : "Height is ${node.height}",
                          style: Theme.of(context).textTheme.bodySmall),
                      SizedBox(height: 50),
                      TextField(
                        style: Theme.of(context).textTheme.bodySmall,
                        controller: blockHashController,
                        decoration: InputDecoration(label: Text("Block hash")),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                          onPressed: () {
                            node
                                .getblock(blockHashController.text)
                                .then((value) {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      title: Text("Block information"),
                                      content: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "hash: ${value["result"]["hash"]}"),
                                          SizedBox(height: 10),
                                          Text(
                                              "height: ${value["result"]["height"]}"),
                                          SizedBox(height: 10),
                                          Text(
                                              "number of transactions: ${value["result"]["nTx"]}"),
                                          SizedBox(height: 10),
                                          Text(
                                              "difficulty: ${value["result"]["difficulty"]}"),
                                          SizedBox(height: 10),
                                          Text(
                                              "total BTC transferred: ${value["BTCmovement"]}"),
                                          SizedBox(height: 10),
                                        ],
                                      ),
                                    );
                                  });
                            });
                          },
                          child: Text("Get block info")),
                      SizedBox(height: 50),
                      ElevatedButton(
                          onPressed: () {
                            node.getWalletInfo("smthy_wallet").then((value) {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      title: Text("Wallet information"),
                                      content: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(value.toString()),
                                        ],
                                      ),
                                    );
                                  });
                            });
                          },
                          child: Text("Get wallet info")),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: ElevatedButton(
                onPressed: () {
                  preferences!.clear();
                  setState(() {
                    ipAddressPresent = false;
                    node.nodeAddress = "";
                  });
                },
                child: Text("Reset")),
            appBar: AppBar(
              centerTitle: true,
              title: Text("Bitcoin Node Monitor"),
            ),
            body: Center(
              child: Text("Node offline",
                  style: Theme.of(context).textTheme.bodySmall),
            ),
          );
  }

  Future<String> getFormattedUptime() {
    return node.getUptime().then((value) {
      uptime = value;
      return formatTime(value);
    });
  }

  String formatTime(int seconds) {
    Duration uptime = Duration(seconds: seconds);
    return "${uptime.inHours} h ${uptime.inMinutes.remainder(60)} m ${uptime.inSeconds.remainder(60)} s";
  }

  void loadWallets() {
    node.getWallets().then((value) {
      setState(() {
        node.wallets = value;
      });
      print(node.wallets);
    });
  }
}
