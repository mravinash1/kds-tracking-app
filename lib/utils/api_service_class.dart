import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

  class HttpService {
  final String baseUrl;

  // Constructor to initialize base URL
  HttpService({this.baseUrl = 'https://hotelserver.billhost.co.in/'});

  // GET request
  Future<dynamic> get(String endpoint) async {
    debugPrint('get Url======>$baseUrl$endpoint');
    var connectivityResult = await Connectivity().checkConnectivity();
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      if (connectivityResult
              .toString()
              .replaceAll('[', '')
              .replaceAll(']', '') ==
          ConnectivityResult.none.toString()) {
        Get.snackbar(
            'No internet connection', "Please Check Your internet connection");
        return null;
      } else {
        final response = await http.get(url,headers: {});
        return _handleResponse(response);
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  // POST request
  Future<Map<String, dynamic>?> post(
      String endpoint, Map<String, dynamic> data) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      if (connectivityResult
              .toString()
              .replaceAll('[', '')
              .replaceAll(']', '') ==
          ConnectivityResult.none.toString()) {
        Get.snackbar(
            'No internet connection', "Please Check Your internet connection");
        return null;
      } else {
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(data),
        );
        return _handleResponse(response);
      }
    } catch (e) {
      throw Exception('Failed to post data: $e');
    }
  }


  // PUT request
  Future<Map<String, dynamic>?> put(
      String endpoint, Map<String, dynamic> data) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      if (connectivityResult
              .toString()
              .replaceAll('[', '')
              .replaceAll(']', '') ==
          ConnectivityResult.none.toString()) {
        Get.snackbar(
            'No internet connection', "Please Check Your internet connection");
        return null;
      } else {
        final response = await http.put(
          url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(data),
        );
        return _handleResponse(response);
      }
    } catch (e) {
      throw Exception('Failed to update data: $e');
    }
  }


  // DELETE request
  Future<Map<String, dynamic>?> delete(String endpoint) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      if (connectivityResult
              .toString()
              .replaceAll('[', '')
              .replaceAll(']', '') ==
          ConnectivityResult.none.toString()) {
        Get.snackbar(
            'No internet connection', "Please Check Your internet connection");
        return null;
      } else {
        final response = await http.delete(url);
        return _handleResponse(response);
      }
    } catch (e) {
      throw Exception('Failed to delete data: $e');
    }
  }

  // PATCH request
  Future<Map<String, dynamic>?> patch(
      String endpoint, Map<String, dynamic> data) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      if (connectivityResult
              .toString()
              .replaceAll('[', '')
              .replaceAll(']', '') ==
          ConnectivityResult.none.toString()) {
        Get.snackbar(
            'No internet connection', "Please Check Your internet connection");
        return null;
      } else {
        final response = await http.patch(
          url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(data),
        );
        return _handleResponse(response);
      }
    } catch (e) {
      throw Exception('Failed to patch data: $e');
    }
  }

  // Handling responses based on status code
  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        // OK (successful GET, PUT, or PATCH)
        return _parseResponse(response.body);
      case 201:
        // Created (successful POST)
        return _parseResponse(response.body);
      case 204:
        // No Content (successful DELETE)
        return {"message": "No content"};
      case 400:
        // Bad Request
        throw Exception('Bad request: ${response.body}');
      case 401:
        // Unauthorized
        throw Exception('Unauthorized: ${response.body}');
      case 403:
        // Forbidden
        throw Exception('Forbidden: ${response.body}');
      case 404:
        // Not Found

        return _parseResponse(response.body);
      case 500:
        // Internal Server Error
        throw Exception('Internal server error: ${response.body}');
      default:
        // Other cases
        throw Exception(
            'Unexpected error: ${response.statusCode} - ${response.body}');
    }
  }

  // Parse response body
  dynamic _parseResponse(String responseBody) {
    try {
      return json.decode(responseBody);
    } catch (e) {
      throw Exception('Failed to parse response body: $e');
    }
  }
}
