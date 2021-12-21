import 'dart:convert';

import 'package:final_training_aia/session/session.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Networking {
  static const apiUrl = 'api.themoviedb.org';

  Future<void> executeRequest(RequestConfiguration configuration,
      ValueSetter<ServerResponse> completion) async {
    configuration.headers = _defaultHeaders();

    print(configuration.headers);
    print(configuration.params);
    print(configuration.path);

    switch (configuration.method) {
      case HTTPMethod.Get:
        final url = Uri.https(apiUrl, configuration.path, configuration.params);
        await http
            .get(url, headers: configuration.headers)
            .then((value) => _handleResponse(value, completion))
            .onError((error, stackTrace) => _handleError(error, completion))
            .timeout(Duration(seconds: 20), onTimeout: () {
          _handleError(Error(), completion);
        });
        break;
      case HTTPMethod.Post:
        final url = Uri.http(apiUrl, configuration.path);
        await http
            .post(url,
                body: json.encode(configuration.params),
                headers: configuration.headers)
            .then((value) => _handleResponse(value, completion))
            .onError((error, stackTrace) => _handleError(error, completion))
            .timeout(Duration(seconds: 30), onTimeout: () {
          _handleError(Error(), completion);
        });
        break;
      case HTTPMethod.Delete:
        final url = Uri.http(apiUrl, configuration.path);
        await http
            .delete(url, headers: configuration.headers)
            .then((value) => _handleResponse(value, completion))
            .onError((error, stackTrace) => _handleError(error, completion))
            .timeout(Duration(seconds: 30), onTimeout: () {
          _handleError(Error(), completion);
        });
        break;
      default:
        print("Didn't implement this method");
        break;
    }
  }

  void _handleResponse(
      http.Response response, ValueSetter<ServerResponse> completion) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      final bodyJson = json.decode(response.body);
      print(bodyJson);
      completion(ServerResponse(bodyJson, null));
    } else {
      final errorJson = json.decode(response.body);
      print(errorJson);
      final error = ServerError.fromJson(errorJson);
      completion(ServerResponse(null, error));
    }
  }

  void _handleError(Object? error, ValueSetter<ServerResponse> completion) {
    // Log.e(error!.toString());
    var e = ServerError.internalError();
    if (ApplicationSesson.shared.isOnline == false) {
      e = ServerError.internetConnectionError();
    }

    completion(ServerResponse(null, e));
  }

  Map<String, String> _defaultHeaders() {
    return {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
      "Access-Control-Allow-Origin": "*"
    };
  }
}

class ServerResponse {
  ServerError? error;
  dynamic data;
  ServerResponse(this.data, this.error);
}

class ServerError extends Error {
  int? status;
  String code;
  String message;
  ServerError({
    required this.code,
    required this.message,
    this.status,
  });

  factory ServerError.fromJson(Map<String, dynamic> json) {
    var statusCode = 400;
    var code = "INTERNAL_ERROR";
    const message = "An error has occurred";
    if (json["status"] != null) {
      statusCode = json["status"] as int;
    }
    if (json["errorCode"] != null) {
      code = json["errorCode"] as String;
    }
    if (json["code"] != null) {
      code = json["code"] as String;
    }
    final error = ServerError(code: code, message: message);
    error.status = statusCode;
    return error;
  }

  factory ServerError.internalError() {
    return ServerError(
        code: "INTERNAL_ERROR", message: "An error has occurred");
  }

  factory ServerError.internetConnectionError() {
    return ServerError(
        code: "InternetConnection", message: "Check Internet Connection");
  }
}

enum HTTPMethod { Get, Post, Put, Delete }

class RequestConfiguration {
  final HTTPMethod method;
  final String path;
  Map<String, String>? headers;
  Map<String, dynamic>? params;

  RequestConfiguration(this.method, this.path, this.headers, this.params);
}
