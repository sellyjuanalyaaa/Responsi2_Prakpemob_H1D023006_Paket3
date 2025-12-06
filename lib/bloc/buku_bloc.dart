import 'dart:convert';

import 'package:responsi2mobilepaket3h1d023006/helpers/api.dart';
import 'package:responsi2mobilepaket3h1d023006/helpers/api_url.dart';
import 'package:responsi2mobilepaket3h1d023006/model/buku.dart';

class BukuBloc {
  static Future<List<Buku>> getBukus() async {
    String apiUrl = ApiUrl.listBuku;
    var response = await Api().get(apiUrl);
    print('Get Bukus Response: ${response.body}'); // Debug
    var jsonObj = json.decode(response.body);
    
    // CI4 respond() returns {status: 200, data: [...]}
    if (jsonObj is Map && jsonObj.containsKey('data')) {
      final list = jsonObj['data'] as List<dynamic>;
      return list.map<Buku>((e) => Buku.fromJson(e)).toList();
    }
    // Direct array from CI4 index
    if (jsonObj is List) {
      return jsonObj.map<Buku>((e) => Buku.fromJson(e)).toList();
    }
    return [];
  }

  static Future<Buku> showBuku({required int id}) async {
    String apiUrl = ApiUrl.showBuku(id);
    var response = await Api().get(apiUrl);
    print('Show Buku Response: ${response.body}'); // Debug
    var jsonObj = json.decode(response.body);
    
    // CI4 respond() returns {status: 200, data: {...}}
    if (jsonObj is Map && jsonObj.containsKey('data')) {
      return Buku.fromJson(jsonObj['data']);
    }
    // Direct object
    return Buku.fromJson(jsonObj);
  }

  static Future<bool> addBuku({required Buku buku}) async {
    String apiUrl = ApiUrl.createBuku;
    var body = {
      "judul": buku.judul,
      "harga": buku.harga,
      "jumlah": buku.jumlah,
      "tanggal_masuk": buku.tanggalMasuk,
      "volume": buku.volume,
      "penulis": buku.penulis,
      "penerbit": buku.penerbit,
    };
    print('Create Buku Body: $body'); // Debug
    var response = await Api().postJson(apiUrl, body);
    print('Create Buku Response: ${response.body}'); // Debug
    return true; // CI4 respondCreated returns 201, caught by _returnResponse
  }

  static Future<bool> updateBuku({required Buku buku}) async {
    String apiUrl = ApiUrl.updateBuku(int.parse(buku.id!));
    var body = {
      "judul": buku.judul,
      "harga": buku.harga,
      "jumlah": buku.jumlah,
      "tanggal_masuk": buku.tanggalMasuk,
      "volume": buku.volume,
      "penulis": buku.penulis,
      "penerbit": buku.penerbit,
    };
    print('Update Buku Body: $body'); // Debug
    var response = await Api().putJson(apiUrl, body);
    print('Update Buku Response: ${response.body}'); // Debug
    return true; // CI4 respond() returns 200, caught by _returnResponse
  }

  static Future<bool> deleteBuku({required int id}) async {
    String apiUrl = ApiUrl.deleteBuku(id);
    var response = await Api().delete(apiUrl);
    print('Delete Buku Response: ${response.body}'); // Debug
    return true; // CI4 respondDeleted returns 200, caught by _returnResponse
  }
}
