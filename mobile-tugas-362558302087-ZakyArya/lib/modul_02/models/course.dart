class Course {
  final String name;
  final String waktu;
  final String room;
  final String status;
  final String? note;

  Course({
    required this.name,
    required this.waktu,
    required this.room,
    required this.status,
    this.note,
  });

  static List<Course> getSampleCourses() {
    return [
      Course(
        name: 'Mobile Programming',
        waktu: '08.00 – 10.00',
        room: 'Lab 1',
        status: 'Berlangsung',
        note: 'Sedang digunakan oleh praktikan',
      ),
      Course(
        name: 'Rekayasa Perangkat Lunak',
        waktu: '10.00 – 12.00',
        room: 'Lab 2',
        status: 'Akan datang',
        note: 'Sesi akan dimulai sebentar lagi',
      ),
      Course(
        name: 'Basis Data',
        waktu: '13.00 – 15.00',
        room: 'Lab 3',
        status: 'Selesai',
        note: 'Sesi telah selesai',
      ),
      Course(
        name: 'Lab 2',
        waktu: '',
        room: 'Ruang tersedia di luar jadwal sesi',
        status: 'Tersedia',
        note: 'Siap digunakan untuk praktikum lain',
      ),
    ];
  }
}
