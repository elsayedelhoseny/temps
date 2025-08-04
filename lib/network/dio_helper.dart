import 'dart:convert';
import 'dart:isolate';
import 'package:archive/archive.dart';
import 'package:dio/dio.dart';


class DioHelper {
  static Dio? dio;

  static init() async {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://otp.trujena.com/',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  // Function to fetch data from the API in an isolate
  static Future<Map<String, dynamic>> getAppModelDataInIsolate({required String apiKey}) async {
    return await Isolate.run(() async {
      // Initialize Dio inside the isolate to ensure it's available
      Dio dioInIsolate = Dio(
        BaseOptions(
          receiveDataWhenStatusError: true,
        ),
      );

      try {
            // Make the request
            final response = await dioInIsolate.get<List<int>>(
              'https://server.trujena.com/api/store-data/$apiKey/data/',
              options: Options(
                responseType: ResponseType.bytes, // Ensure response is received as bytes
              ),
            );

            // Decompress the GZipped response
            final decompressedData = GZipDecoder().decodeBytes(response.data!);

            // Convert the decompressed bytes to a JSON string
            final jsonString = utf8.decode(decompressedData);

            // Parse the JSON string into a Map
            final Map<String, dynamic> jsonMap = json.decode(jsonString);

            return jsonMap;
      } catch (error) {
        print('Error in isolate while fetching app model data: $error');
        throw Exception('Failed to fetch app model data in isolate');
      }
    });
  }

  // Function to check for updates
  static Future<Response> checkForUpdates({required String apiKey}) async {
    Dio dioInIsolate = Dio(
      BaseOptions(
        receiveDataWhenStatusError: true,
      ),
    );

    return await dioInIsolate.get('https://server.trujena.com/api/store-data/$apiKey/check/').catchError((error) {
      print('Dio Get checkForUpdates error ======> ${error.toString()}');
    });
  }
  // static Future<Map<String, dynamic>> getAppModelData({required String apiKey}) async {
  //   try {
  //     // Make the request
  //     final response = await appModelDio!.get<List<int>>(
  //       'https://server.trujena.com/api/store-data/$apiKey/data/',
  //       options: Options(
  //         responseType: ResponseType.bytes, // Ensure response is received as bytes
  //       ),
  //     );
  //
  //     // Decompress the GZipped response
  //     final decompressedData = GZipDecoder().decodeBytes(response.data!);
  //
  //     // Convert the decompressed bytes to a JSON string
  //     final jsonString = utf8.decode(decompressedData);
  //
  //     // Parse the JSON string into a Map
  //     final Map<String, dynamic> jsonMap = json.decode(jsonString);
  //
  //     return jsonMap;
  //   } catch (error) {
  //     print('Error while fetching or decoding data: $error');
  //     throw Exception('Failed to fetch or decode data');
  //   }
  // }
  // static Future<Response> checkForUpdates({required String apiKey}) async {
  //   return await appModelDio!.get('https://server.trujena.com/api/store-data/$apiKey/check/').catchError((error) {
  //     print('Dio Get checkForUpdates error ======> ${error.toString()}');
  //
  //   });
  // }
  static Future<Response> getData(
      {required String url, Map<String, dynamic>? query, String? token}) async {
    // dio!.options.headers = {
    //   // 'Content-Type': 'application/json',
    //   // 'Accept': '*/*',
    //   // 'Authorization': 'Bearer $token'
    // };
    return await dio!.get(url, queryParameters: query).catchError((error) {
      print('Dio Get Data error ======> ${error.toString()}');
      // errorResponse = error.response.data['message'];
      //
      // print(errorResponse);
    });
  }

  // static Future<Response> uploadImage({
  //   required String url,
  //   required String imagePath,
  //   String? token,
  // })
  // async {
  //   FormData formData = FormData.fromMap({
  //     'image': await MultipartFile.fromFile(
  //       imagePath,
  //       contentType: MediaType('image', 'jpg'),
  //     ),
  //   });
  //   dio!.options.headers = {
  //     'Content-Type': 'multipart/form-data',
  //     'Accept': 'application/json',
  //     'Authorization': 'Bearer $token'
  //   };
  //
  //   return await dio!.patch(url, data: formData).catchError((error) {
  //     print('Dio upload image error ======> ${error.toString()}');
  //     // errorResponse = error.response.data['message'];
  //     //
  //     // print(errorResponse);
  //   });
  // }

  static Future<Response> deleteImage({
    required String url,
    String? token,
  }) async {
    dio!.options.headers = {'Authorization': 'Bearer $token'};

    return await dio!
        .delete(
      url,
    )
        .catchError((error) {
      print('Dio upload image error ======> ${error.toString()}');
      // errorResponse = error.response.data['message'];
      //
      // print(errorResponse);
    });
  }

  static Future<Response> patchData(
      {required String url,
      Map<String, dynamic>? requestedBody,
      Map<String, dynamic>? query,
      String? token}) async {
    dio!.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    return await dio!.patch(url, data: requestedBody,queryParameters: query).catchError((error) {
      print('Dio Patch Data error ======> ${error.toString()}');
      // errorResponse = error.response.data['message'];
      //
      // print(errorResponse);
    });
  }

  static Future<Response> deleteData(
      {required String url, Map<String, dynamic>? body, String? token}) async {
    dio!.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    return await dio!.delete(url, data: body).catchError((error) {
      print('Dio Delete Data error ======> ${error.toString()}');
      // errorResponse = error.response.data['message'];
      // print(errorResponse);
    });
  }

  static Future<Response> postData({
    required String url,
    String? token,
    required Map<String, dynamic> requestedBody,
  }) async {
    dio!.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    return await dio!.post(url, data: requestedBody).catchError((error) {
      print('Dio Post Data error ======> ${error.toString()}');
      // errorResponse = error.response.data['message'];
      // print(errorResponse);
    });
  }
}
