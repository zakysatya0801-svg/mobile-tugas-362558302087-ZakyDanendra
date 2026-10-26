import 'package:dio/dio.dart';

import '../../../modul_04/models/announcement.dart';

class AnnouncementRemoteDataSource {
  AnnouncementRemoteDataSource({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://jsonplaceholder.typicode.com',
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
                headers: <String, String>{
                  'Accept': 'application/json',
                  'User-Agent': 'PoliwangiMobileApp/1.0',
                },
              ),
            ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          handler.next(options);
        },
        onError: (DioException error, handler) {
          handler.next(error);
        },
      ),
    );
  }

  final Dio _dio;

  Future<List<Announcement>> getAnnouncements({
    String? category,
  }) async {
    try {
      final Response<dynamic> response = await _dio.get('/posts');

      final dynamic data = response.data;

      if (data is! List) {
        return <Announcement>[];
      }

      List<Announcement> announcements = data.map((dynamic item) {
        final Map<String, dynamic> json =
            Map<String, dynamic>.from(item as Map);

        return Announcement(
          id: json['id'] as int? ?? 0,
          title: json['title'] as String? ?? 'Tanpa Judul',
          content: json['body'] as String? ?? '',
          author: 'Admin Jurusan',
          category: _kategoriDariId(json['id']),
          date: '2026-09-01',
          readCount: 0,
        );
      }).toList();

      if (category != null &&
          category.isNotEmpty &&
          category.toLowerCase() != 'semua') {
        announcements = announcements
            .where(
              (Announcement announcement) =>
                  announcement.category.toLowerCase() ==
                  category.toLowerCase(),
            )
            .toList();
      }

      return announcements;
    } on DioException catch (e) {
      String errorMessage;

      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          errorMessage =
              'Koneksi ke server timeout. Periksa sambungan internet Anda.';
          break;

        case DioExceptionType.connectionError:
          errorMessage =
              'Gagal terhubung ke server. Periksa koneksi data atau Wi-Fi Anda.';
          break;

        case DioExceptionType.badResponse:
          errorMessage =
              'Server merespons dengan kesalahan (${e.response?.statusCode}).';
          break;

        default:
          errorMessage =
              'Terjadi kendala jaringan: ${e.message ?? 'Kesalahan tidak diketahui'}';
      }

      throw Exception(errorMessage);
    }
  }

  Future<Announcement> addAnnouncement(
    Announcement announcement,
  ) async {
    try {
      final Response<dynamic> response = await _dio.post(
        '/posts',
        data: announcement.toJson(),
      );

      final dynamic data = response.data;

      if (data is! Map) {
        throw Exception('Respons server tidak valid.');
      }

      final Map<String, dynamic> json =
          Map<String, dynamic>.from(data);

      return Announcement.fromJson({
        ...announcement.toJson(),
        ...json,
      });
    } on DioException catch (e) {
      String errorMessage;

      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          errorMessage =
              'Koneksi ke server timeout. Periksa sambungan internet Anda.';
          break;

        case DioExceptionType.connectionError:
          errorMessage =
              'Gagal terhubung ke server. Periksa koneksi data atau Wi-Fi Anda.';
          break;

        case DioExceptionType.badResponse:
          errorMessage =
              'Server merespons dengan kesalahan (${e.response?.statusCode}).';
          break;

        default:
          errorMessage =
              'Terjadi kendala jaringan: ${e.message ?? 'Kesalahan tidak diketahui'}';
      }

      throw Exception(errorMessage);
    }
  }

  String _kategoriDariId(dynamic id) {
    if (id is! int) {
      return 'Akademik';
    }

    switch (id % 4) {
      case 0:
        return 'Prestasi';
      case 1:
        return 'Akademik';
      case 2:
        return 'Kegiatan';
      case 3:
        return 'Beasiswa';
      default:
        return 'Akademik';
    }
  }
}