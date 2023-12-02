import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class Node {
  String? nodeAddress;
  bool online = false;
  int height = 0;
  List<dynamic> wallets = [];

  Future<int> getUptime() async {
    print("Uptime check");
    try {
      final uri = Uri.parse("http://$nodeAddress/uptime");
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        online = false;
        throw const HttpException("uptime failed");
      }
      online = true;
      return json.decode(response.body)['uptime'];
    } catch (e) {
      online = false;
      print(e.toString());
    }
    return 0;
  }

  Future<String> stop() async {
    print("Stop");
    try {
      final uri = Uri.parse("http://$nodeAddress/stop");
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        online = false;
        throw const HttpException("stop failed");
      }
      online = true;
      print(json.decode(response.body)['response']['result']);
      return json.decode(response.body)['response']['result'];
    } catch (e) {
      online = false;
    }
    return "";
  }

  Future<int> blockchainHeight() async {
    print("blockchain height");
    try {
      final uri = Uri.parse("http://$nodeAddress/height");
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        online = false;
        throw const HttpException("height failed");
      }
      online = true;
      print(json.decode(response.body)['height']);
      return json.decode(response.body)['height'];
    } catch (e) {
      online = false;
    }
    return 0;
  }

  Future<Map> getblock(String blockHash) async {
    print("getblock $blockHash");
    try {
      final uri = Uri.parse("http://$nodeAddress/getblock/$blockHash");
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        online = false;
        throw const HttpException("getblock failed");
      }
      online = true;
      var map = json.decode(response.body);
      map["BTCmovement"] = await getTotalTransferAmount(blockHash);
      return map;
    } catch (e) {
      print(e.toString());
      online = false;
    }
    return {};
  }

  Future<String> getTotalTransferAmount(String blockHash) async {
    print("getTotalTransferAmount $blockHash");
    try {
      final uri =
          Uri.parse("http://$nodeAddress/totaltransferamount/$blockHash");
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        online = false;
        throw const HttpException("getblock failed");
      }
      online = true;
      return json.decode(response.body)['sum'].toString();
    } catch (e) {
      print(e.toString());
      online = false;
    }
    return "-1";
  }

  Future<List> getWallets() async {
    print("getWallets");
    try {
      final uri = Uri.parse("http://$nodeAddress/wallets");
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        online = false;
        throw const HttpException("getwallets failed");
      }
      online = true;
      print(json.decode(response.body));
      return json.decode(response.body);
    } catch (e) {
      print(e.toString());
      online = false;
    }
    return ["-1"];
  }

  Future<Map> getWalletInfo(walletName) async {
    print("getWalletInfo");
    try {
      final uri = Uri.parse("http://$nodeAddress/wallets/$walletName");

      final response = await http.get(uri);
      if (response.statusCode != 200) {
        online = false;
        throw const HttpException("getwalletinfo failed");
      }
      online = true;
      print(json.decode(response.body));
      return json.decode(response.body);
    } catch (e) {
      print(e.toString());
      online = false;
    }
    return {};
  }
}
