import '../../../modul_04/models/announcement.dart';
import '../datasources/announcement_remote_datasource.dart';
import 'announcement_repository.dart';

class AnnouncementRepositoryImpl
    implements AnnouncementRepository {
  AnnouncementRepositoryImpl({
    AnnouncementRemoteDataSource? dataSource,
  }) : _dataSource =
            dataSource ?? AnnouncementRemoteDataSource();

  final AnnouncementRemoteDataSource _dataSource;

  @override
  Future<List<Announcement>> getAnnouncements({
    String? category,
  }) {
    return _dataSource.getAnnouncements(
      category: category,
    );
  }

  @override
  Future<Announcement> addAnnouncement(
    Announcement announcement,
  ) {
    return _dataSource.addAnnouncement(
      announcement,
    );
  }
}