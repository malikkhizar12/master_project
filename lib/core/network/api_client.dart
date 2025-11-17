import 'dart:convert';
import 'package:http/http.dart' as http;
import '../error/failure.dart';

class ApiClient {
  final String baseUrl;
  final http.Client client;
  final Map<String, String>? headers;

  ApiClient({required this.baseUrl, http.Client? client, this.headers})
    : client = client ?? http.Client();

  // Base URL - Update this with your actual API base URL
  static const String defaultBaseUrl = 'https://api.example.com/v1';

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? queryParameters,
    Map<String, String>? customHeaders,
  }) async {
    try {
      final uri = Uri.parse(
        baseUrl + endpoint,
      ).replace(queryParameters: queryParameters);

      final response = await client.get(
        uri,
        headers: _mergeHeaders(customHeaders),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Failure('Network error: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? customHeaders,
  }) async {
    try {
      final uri = Uri.parse(baseUrl + endpoint);

      final response = await client.post(
        uri,
        headers: _mergeHeaders(customHeaders, isJson: true),
        body: body != null ? jsonEncode(body) : null,
      );

      return _handleResponse(response);
    } catch (e) {
      throw Failure('Network error: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? customHeaders,
  }) async {
    try {
      final uri = Uri.parse(baseUrl + endpoint);

      final response = await client.put(
        uri,
        headers: _mergeHeaders(customHeaders, isJson: true),
        body: body != null ? jsonEncode(body) : null,
      );

      return _handleResponse(response);
    } catch (e) {
      throw Failure('Network error: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? customHeaders,
  }) async {
    try {
      final uri = Uri.parse(baseUrl + endpoint);

      final response = await client.delete(
        uri,
        headers: _mergeHeaders(customHeaders),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Failure('Network error: ${e.toString()}');
    }
  }

  Map<String, String> _mergeHeaders(
    Map<String, String>? customHeaders, {
    bool isJson = false,
  }) {
    final mergedHeaders = <String, String>{};

    if (headers != null) {
      mergedHeaders.addAll(headers!);
    }

    if (customHeaders != null) {
      mergedHeaders.addAll(customHeaders);
    }

    if (isJson && !mergedHeaders.containsKey('Content-Type')) {
      mergedHeaders['Content-Type'] = 'application/json';
    }

    return mergedHeaders;
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }
      try {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } catch (e) {
        throw Failure('Invalid JSON response: ${e.toString()}');
      }
    } else {
      throw Failure(
        'Request failed with status ${response.statusCode}: ${response.body}',
        code: response.statusCode.toString(),
      );
    }
  }

  void dispose() {
    client.close();
  }
}
