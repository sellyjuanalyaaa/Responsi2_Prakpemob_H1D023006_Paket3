import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'app_exception.dart';

class Api {
  Future<String?> _getToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('token');
  }

  Future<dynamic> postJson(dynamic url, dynamic data) async {
    var token = await _getToken();
    var responseJson;
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(data),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          if (token != null) HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> putJson(dynamic url, dynamic data) async {
    var token = await _getToken();
    var responseJson;
    try {
      final response = await http.put(
        Uri.parse(url),
        body: json.encode(data),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          if (token != null) HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(dynamic url, dynamic data) async {
    var token = await _getToken();
    var responseJson;
    try {
      final response = await http.post(
        Uri.parse(url),
        body: data,
        headers: {if (token != null) HttpHeaders.authorizationHeader: "Bearer $token"},
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> get(dynamic url) async {
    var token = await _getToken();
    var responseJson;
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {if (token != null) HttpHeaders.authorizationHeader: "Bearer $token"},
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> put(dynamic url, dynamic data) async {
    var token = await _getToken();
    var responseJson;
    try {
      final response = await http.put(
        Uri.parse(url),
        body: data,
        headers: {
          if (token != null) HttpHeaders.authorizationHeader: "Bearer $token",
          HttpHeaders.contentTypeHeader: "application/json",
        },
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> delete(dynamic url) async {
    var token = await _getToken();
    var responseJson;
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {if (token != null) HttpHeaders.authorizationHeader: "Bearer $token"},
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return response;
      case 201:
        return response;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 422:
        throw InvalidInputException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}',
        );
    }
  }
}
