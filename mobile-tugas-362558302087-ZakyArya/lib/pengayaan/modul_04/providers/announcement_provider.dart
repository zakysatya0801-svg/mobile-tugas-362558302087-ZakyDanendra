import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../modul_04/models/announcement.dart';
import '../repositories/announcement_repository.dart';
import '../repositories/announcement_repository_impl.dart';

class SampleAnnouncementRepository
    implements AnnouncementRepository {
  @override
  Future<List<Announcement>> getAnnouncements({
    String? category,
  }) async {
    final List<Announcement> data =
        Announcement.getSampleAnnouncements();

    if (category == null ||
        category.isEmpty ||
        category.toLowerCase() == 'semua') {
      return data;
    }

    return data
        .where(
          (Announcement announcement) =>
              announcement.category.toLowerCase() ==
              category.toLowerCase(),
        )
        .toList();
  }

  @override
  Future<Announcement> addAnnouncement(
    Announcement announcement,
  ) async {
    return announcement;
  }
}

// ================================================================
// REPOSITORY
// ================================================================

final announcementRepositoryProvider =
    Provider<AnnouncementRepository>((ref) {
  const bool simulasi = bool.fromEnvironment(
    'SIMULASI',
    defaultValue: false,
  );

  if (simulasi) {
    return SampleAnnouncementRepository();
  }

  return AnnouncementRepositoryImpl();
});

// ================================================================
// KATEGORI TERPILIH
// ================================================================

final selectedCategoryProvider =
    StateProvider<String?>((ref) {
  return null;
});

// ================================================================
// DATA PENGUMUMAN
// ================================================================

final announcementsProvider =
    FutureProvider<List<Announcement>>((ref) async {
  final AnnouncementRepository repository =
      ref.watch(announcementRepositoryProvider);

  final String? category = ref.watch(
    selectedCategoryProvider,
  );

  return repository.getAnnouncements(
    category: category,
  );
});