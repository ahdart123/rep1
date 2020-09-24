import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

enum HttpMethod { GET, PUT, POST, DELETE, PATCH }

class ApiResult<T> {
  T data;
  bool requestSuccessed;
  //lalalala
  //lalalala again

}

class HttpService {
  Map<String, String> headers;
  Map<String, String> parameters;
  Map<String, dynamic> body;
  Duration timeoutDuration = Duration(seconds: 60);

  // the successes status codes
  final List<int> successesCodes = [200, 201, 202, 204];

  Future<http.Response> request({
    HttpMethod method,
    String url,
    Map<String, String> parameters,
  }) async {
    try {
      return _requestInternal(method, url, parameters);
    } catch (ex) {
      rethrow;
    }
  }

  Future<http.Response> _requestInternal(
    HttpMethod method,
    String url,
    Map<String, String> parameters,
  ) async {
    url = attachparametersToUrl(url, parameters);
    switch (method) {
      case HttpMethod.GET:
        return await http.get(
          url,
          headers: headers,
        );
      case HttpMethod.POST:
        return await http.post(url, headers: headers, body: jsonEncode(body));
      case HttpMethod.PATCH:
        return await http.patch(url, headers: headers, body: jsonEncode(body));
      case HttpMethod.PUT:
        return await http
            .put(url, headers: headers, body: jsonEncode(body))
            .timeout(Duration(seconds: 30));
      case HttpMethod.DELETE:
        return await http.delete(url, headers: headers);
      default:
        throw Exception('Unknown mehtod');
    }
  }

  //Get the full Url for the request
  String attachparametersToUrl(String url, [Map<String, String> parameters]) {
    if (parameters == null || parameters.length == 0) {
      return url;
    }
    if (url[url.length - 1] != '?') {
      url += "?";
    }
    parameters.forEach((key, val) => {url += key + "=" + val + "&"});
    return url.substring(0, url.length - 1);
  }
}
