import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/error.dart';
import '../models/request/ActivityRequest.dart';
import '../models/response/activity.dart';
import 'remote_api.dart';

const String apiUrl =
    'https://runbackendrun.onrender.com/api/private/activity/';

final activityApiProvider = Provider<ActivityApi>((ref) => ActivityApi());

class ActivityApi extends RemoteApi {
  ActivityApi() : super(apiUrl);

  Future<List<ActivityResponse>> getActivities() async {
    try {
      await setJwt();
      final response = await dio.get('${apiUrl}all');

      if (response.statusCode == 200) {
        final data = List<Map<String, dynamic>>.from(response.data);
        if (data.isNotEmpty) {
          return data.map((e) => ActivityResponse.fromMap(e)).toList();
        }
      }
      return [];
    } catch (err) {
      if (err is DioError) {
        if (err.response?.statusCode == 401) {
          final response = await handleUnauthorizedError(err, {}, {});
          final data = List<Map<String, dynamic>>.from(response?.data ?? []);
          if (data.isNotEmpty) {
            return data.map((e) => ActivityResponse.fromMap(e)).toList();
          }
        }
        throw Failure(
            message: err.response?.statusMessage ?? 'Something went wrong!');
      } else if (err is SocketException) {
        throw const Failure(message: 'Please check your connection.');
      } else {
        rethrow;
      }
    }
  }

  Future<ActivityResponse> getActivityById(String id) async {
    try {
      await setJwt();
      final response = await dio.get('$apiUrl$id');

      if (response.statusCode == 200) {
        if (response.data.isNotEmpty) {
          return ActivityResponse.fromMap(response.data);
        }
      }
      throw const Failure(message: 'Activity not found');
    } catch (err) {
      if (err is DioError) {
        if (err.response?.statusCode == 401) {
          final response = await handleUnauthorizedError(err, {}, {});
          if (response?.statusCode == 200) {
            if (response?.data.isNotEmpty) {
              return ActivityResponse.fromMap(response?.data);
            }
          }
        }
        throw Failure(
            message: err.response?.statusMessage ?? 'Something went wrong!');
      } else if (err is SocketException) {
        throw const Failure(message: 'Please check your connection.');
      } else {
        rethrow;
      }
    }
  }

  Future<String> removeActivity(String id) async {
    try {
      await setJwt();
      final response = await dio.delete(
        apiUrl,
        queryParameters: {'id': int.parse(id)},
      );

      if (response.statusCode == 200) {
        return response.data.toString();
      }
      throw const Failure(message: 'Remove activity failed');
    } catch (err) {
      if (err is DioError) {
        if (err.response?.statusCode == 401) {
          final response =
              await handleUnauthorizedError(err, {}, {'id': int.parse(id)});
          if (response?.statusCode == 200) {
            return response!.data.toString();
          }
        }
        throw Failure(
            message: err.response?.statusMessage ?? 'Something went wrong!');
      } else if (err is SocketException) {
        throw const Failure(message: 'Please check your connection.');
      } else {
        rethrow;
      }
    }
  }

  Future<ActivityResponse> addActivity(ActivityRequest request) async {
    try {
      await setJwt();
      final response = await dio.post(apiUrl, data: request.toMap());

      if (response.statusCode == 200) {
        if (response.data.isNotEmpty) {
          return ActivityResponse.fromMap(response.data);
        }
      }
      throw const Failure(message: 'Activity not created');
    } catch (err) {
      if (err is DioError) {
        if (err.response?.statusCode == 401) {
          final response =
              await handleUnauthorizedError(err, request.toMap(), {});
          if (response != null &&
              response.data != null &&
              response.data.isNotEmpty) {
            return ActivityResponse.fromMap(response.data);
          }
        }
        throw Failure(
            message: err.response?.statusMessage ?? 'Something went wrong!');
      } else if (err is SocketException) {
        throw const Failure(message: 'Please check your connection.');
      } else {
        rethrow;
      }
    }
  }

  Future<ActivityResponse> editActivity(ActivityRequest request) async {
    try {
      await setJwt();
      final response = await dio.put(apiUrl, data: request.toMap());

      if (response.statusCode == 200) {
        if (response.data.isNotEmpty) {
          return ActivityResponse.fromMap(response.data);
        }
      }
      throw const Failure(message: 'Activity not found');
    } catch (err) {
      if (err is DioError) {
        if (err.response?.statusCode == 401) {
          final response =
              await handleUnauthorizedError(err, request.toMap(), {});
          if (response?.statusCode == 200) {
            if (response?.data.isNotEmpty) {
              return ActivityResponse.fromMap(response?.data);
            }
          }
        }
        throw Failure(
            message: err.response?.statusMessage ?? 'Something went wrong!');
      } else if (err is SocketException) {
        throw const Failure(message: 'Please check your connection.');
      } else {
        rethrow;
      }
    }
  }
}
