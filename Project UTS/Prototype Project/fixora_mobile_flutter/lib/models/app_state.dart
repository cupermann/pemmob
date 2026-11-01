import 'package:flutter/material.dart';

// Simulasi lokal untuk demonstrasi UI. Tidak menyimpan kata sandi secara aman.
// Ganti seluruh autentikasi dan pembacaan laporan dengan Laravel REST API
// sebelum digunakan dengan data asli.
class StudentAccount {
  final String name, nim, email, password;
  const StudentAccount(this.name, this.nim, this.email, this.password);
}

class ReportItem {
  final String id, title, building, room, category, description, priority;
  final String ownerEmail;
  final DateTime created;
  final String? photoPath;
  final bool demoPhoto;
  String status;
  ReportItem({required this.id, required this.title, required this.building,
    required this.room, required this.category, required this.description,
    required this.priority, required this.created,
    this.ownerEmail = 'muhammadyusuf@kampus.ac.id', this.photoPath,
    this.demoPhoto = false, this.status = 'Diajukan'});
}

class FixoraStore extends ChangeNotifier {
  final List<StudentAccount> _accounts = [
    const StudentAccount('Muhammad Yusuf', '20240801041',
      'muhammadyusuf@kampus.ac.id', 'Fixora123!'),
  ];
  StudentAccount? currentUser;
  int selectedTab = 0;

  final List<ReportItem> _reports = [
    ReportItem(id:'FXR-2026-0017', title:'AC Ruang Kelas Rusak',
      building:'Gedung A', room:'A-203 (Ruang Kelas)',
      category:'Air Conditioner (AC)', description:'AC tidak dingin dan mengeluarkan suara.',
      priority:'Tinggi', status:'Diproses', created:DateTime(2026,10,31,9,15),
      demoPhoto:true),
    ReportItem(id:'FXR-2026-0016', title:'Lampu Koridor Lantai 2 Mati',
      building:'Gedung B', room:'Koridor Barat', category:'Kelistrikan & AC',
      description:'Lampu di koridor lantai dua tidak menyala.',priority:'Sedang',
      status:'Diverifikasi',created:DateTime(2026,10,30,14,20)),
    ReportItem(id:'FXR-2026-0015',title:'Kursi Kuliah Sandaran Patah',
      building:'Gedung C',room:'Ruang Teater C-101',category:'Perabotan / Meja Kursi',
      description:'Sandaran kursi sudah patah.',priority:'Rendah',
      status:'Selesai',created:DateTime(2026,10,28,8,0)),
  ];

  List<ReportItem> get reports => List.unmodifiable(_reports.where(
    (report)=>currentUser!=null && report.ownerEmail.toLowerCase()==currentUser!.email.toLowerCase()));
  bool get isLoggedIn => currentUser != null;
  String get firstName => currentUser?.name.split(' ').first ?? 'Mahasiswa';
  int get activeCount => reports.where((e)=>e.status!='Selesai' && e.status!='Ditolak').length;
  int get completedCount => reports.where((e)=>e.status=='Selesai').length;

  String? login(String email, String password) {
    final normalized = email.trim().toLowerCase();
    for (final user in _accounts) {
      if(user.email.toLowerCase() == normalized && user.password == password) {
        currentUser = user; selectedTab = 0;notifyListeners();return null;
      }
    }
    return 'Email atau password salah. Gunakan akun demo atau daftar terlebih dahulu.';
  }

  String? register(String name,String nim,String email,String password) {
    if(_accounts.any((u)=>u.email.toLowerCase()==email.toLowerCase())) {
      return 'Email sudah digunakan.';
    }
    if(_accounts.any((u)=>u.nim==nim)) return 'NIM sudah digunakan.';
    _accounts.add(StudentAccount(name.trim(),nim.trim(),email.trim(),password));
    notifyListeners(); return null;
  }

  void logout(){currentUser=null;selectedTab=0;notifyListeners();}
  void setTab(int tab){selectedTab=tab;notifyListeners();}
  ReportItem submit({required String title,required String building,
    required String room, required String category,required String description,
    required String priority,String? photoPath,bool demoPhoto=false}) {
    final now=DateTime.now();
    final id='FXR-${now.year}-${(now.microsecondsSinceEpoch%10000).toString().padLeft(4,'0')}';
    final item=ReportItem(id:id,title:title,building:building,room:room,
      category:category,description:description,priority:priority,
      created:now,photoPath:photoPath,demoPhoto:demoPhoto,
      ownerEmail:currentUser?.email ?? '');
    _reports.insert(0,item); notifyListeners();return item;
  }
}
final store = FixoraStore();

String dateId(DateTime date) {
  const months = ['Jan','Feb','Mar','Apr','Mei','Jun','Jul','Agu','Sep','Okt','Nov','Des'];
  return '${date.day} ${months[date.month-1]} ${date.year}';
}

String timeId(DateTime date) => '${date.hour.toString().padLeft(2,'0')}:${date.minute.toString().padLeft(2,'0')}';
