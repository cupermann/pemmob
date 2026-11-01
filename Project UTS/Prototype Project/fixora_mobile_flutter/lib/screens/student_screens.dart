import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../core/theme.dart';
import '../models/app_state.dart';
import '../widgets/ui.dart';
import 'auth_screens.dart';

void infoDialog(BuildContext context,String title,String content){
  showDialog<void>(context:context,builder:(context)=>AlertDialog(
    title:Text(title),content:Text(content),
    actions:[TextButton(onPressed:()=>Navigator.pop(context),child:const Text('Tutup'))]));
}

class StudentShell extends StatelessWidget {
  const StudentShell({super.key});
  @override Widget build(BuildContext context)=>AnimatedBuilder(animation:store,
    builder:(context,_)=>Scaffold(
      body:IndexedStack(index:store.selectedTab,children:const [
        StudentHomePage(),HistoryPage(),StudentProfilePage()]),
      bottomNavigationBar:FxBottomNav(index:store.selectedTab,onSelect:store.setTab),
    ));
}

class FxBottomNav extends StatelessWidget{
  final int index;final ValueChanged<int> onSelect;
  const FxBottomNav({super.key,required this.index,required this.onSelect});
  @override Widget build(BuildContext context)=>SafeArea(top:false,
    child:Container(padding:const EdgeInsets.symmetric(vertical:8,horizontal:14),
      decoration:const BoxDecoration(color:Colors.white,border:Border(
        top:BorderSide(color:Color(0xFFEAECF6)))),
      child:Row(children:[
        _item(0,Icons.home_outlined,Icons.home,'Beranda'),
        _item(1,Icons.receipt_long_outlined,Icons.receipt_long,'Riwayat'),
        _item(2,Icons.person_outline,Icons.person,'Profil'),
      ])));
  Widget _item(int i,IconData icon,IconData selected,String title)=>Expanded(
    child:InkWell(onTap:()=>onSelect(i),borderRadius:BorderRadius.circular(18),
      child:Column(mainAxisSize:MainAxisSize.min,children:[
        Container(padding:const EdgeInsets.symmetric(vertical:5,horizontal:20),
          decoration:BoxDecoration(color:index==i?Fx.lightBlue:Colors.transparent,
            borderRadius:BorderRadius.circular(24)),
          child:Icon(index==i?selected:icon,color:index==i?Fx.primary:Fx.ink,size:22)),
        const SizedBox(height:4),Text(title,style:TextStyle(
          fontSize:11,fontWeight:index==i?FontWeight.w800:FontWeight.w500,
          color:index==i?Fx.primary:Fx.ink)),
      ])));
}

class FxTopBar extends StatelessWidget implements PreferredSizeWidget {
  final bool back;
  const FxTopBar({super.key,this.back=false});
  @override Size get preferredSize=>const Size.fromHeight(62);
  @override Widget build(BuildContext context)=>AppBar(
    automaticallyImplyLeading:back,
    title:Row(mainAxisSize:MainAxisSize.min,children:[
      Container(padding:const EdgeInsets.all(7),decoration:BoxDecoration(
        gradient:Fx.blueGradient,borderRadius:BorderRadius.circular(11)),
        child:const Icon(Icons.build_circle_outlined,size:22,color:Colors.white)),
      const SizedBox(width:8),const Text('Fixora',style:TextStyle(
        fontWeight:FontWeight.w900,fontSize:21)),
    ]),actions:[
      IconButton(onPressed:()=>infoDialog(context,'Notifikasi',
        'Tidak ada notifikasi baru. Fitur notifikasi real-time menunggu integrasi backend.'),
        icon:const Icon(Icons.notifications_none_rounded)),
      Padding(padding:const EdgeInsets.only(right:12),child:IconButton(
        onPressed:(){Navigator.of(context).popUntil((r)=>r.isFirst);store.setTab(2);},
        icon:const CircleAvatar(backgroundColor:Fx.primary,
          child:Icon(Icons.person_outline,color:Colors.white,size:20)))),
    ]);
}

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:const FxTopBar(),
    body:AnimatedBuilder(animation:store,builder:(context,_)=>
      SingleChildScrollView(physics:const BouncingScrollPhysics(),
        child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
          _hero(context),
          Transform.translate(offset:const Offset(0,-22),child:Padding(
            padding:const EdgeInsets.symmetric(horizontal:20),
            child:FxButton(text:'Buat Laporan',orange:true,icon:Icons.add_circle,
              onPressed:()=>Navigator.push(context,
                MaterialPageRoute(builder:(_)=>const CreateReportPage()))))),
          Padding(padding:const EdgeInsets.symmetric(horizontal:20),child:Column(
            crossAxisAlignment:CrossAxisAlignment.stretch,children:[
              Row(children:[
                Expanded(child:_shortcut(context,Icons.assignment_outlined,'Riwayat\nLaporan',
                  Fx.primary,()=>store.setTab(1))),
                const SizedBox(width:14),
                Expanded(child:_shortcut(context,Icons.support_agent,'Kontak\nLayanan',
                  Fx.orange,()=>infoDialog(context,'Kontak Layanan',
                    'Hubungi layanan sarana dan prasarana kampus melalui kontak resmi institusi.\n\nNomor WhatsApp dan email layanan belum dikonfigurasi pada versi demo.'))),
              ]),
              const SizedBox(height:20),
              Container(padding:const EdgeInsets.all(16),
                decoration:BoxDecoration(color:const Color(0xFFEEF0FE),
                  borderRadius:BorderRadius.circular(18)),
                child:Row(children:[
                  Container(padding:const EdgeInsets.all(11),
                    decoration:BoxDecoration(color:const Color(0xFFDBE3FF),
                      borderRadius:BorderRadius.circular(12)),
                    child:const Icon(Icons.bolt,color:Fx.primary)),
                  const SizedBox(width:13),
                  const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,
                    children:[Text('Pemberitahuan Tim Sarpras',
                      style:TextStyle(fontSize:13,fontWeight:FontWeight.w800)),
                      SizedBox(height:4),Text('Pemeliharaan jaringan Wi-Fi Gedung B berlangsung hari ini pukul 16.00 WIB.',
                        style:TextStyle(fontSize:11,color:Fx.muted,height:1.5))])),
                  const Text('Baru',style:TextStyle(color:Fx.primary,fontSize:11,
                    fontWeight:FontWeight.w700)),
                ])),
              const SizedBox(height:24),
              Row(children:[
                const Text('Laporan Terbaru',style:TextStyle(fontSize:19,fontWeight:FontWeight.w900)),
                const SizedBox(width:9),
                Container(padding:const EdgeInsets.symmetric(horizontal:9,vertical:3),
                  decoration:BoxDecoration(color:Fx.lightBlue,borderRadius:BorderRadius.circular(10)),
                  child:Text('${store.activeCount} Aktif',
                    style:const TextStyle(fontWeight:FontWeight.w800,fontSize:11))),
                const Spacer(),TextButton(onPressed:()=>store.setTab(1),
                  child:const Text('Lihat Semua ›',style:TextStyle(color:Fx.primary,fontSize:11))),
              ]),
              const SizedBox(height:7),
              ...store.reports.take(3).map((r)=>ReportCard(report:r,
                onTap:()=>Navigator.push(context,MaterialPageRoute(
                  builder:(_)=>ReportDetailPage(report:r))))),
              const SizedBox(height:16),
              const Row(children:[Expanded(child:Text('Dokumentasi Perbaikan',
                style:TextStyle(fontWeight:FontWeight.w900,fontSize:17))),
                Text('Update Tim Sarpras',style:TextStyle(color:Fx.muted,fontSize:11))]),
              const SizedBox(height:12),
              Row(children:[
                Expanded(child:_docPhoto('assets/images/dokumentasi_ac.jpg',
                  'AC Gedung A','Selesai diperiksa')),
                const SizedBox(width:12),
                Expanded(child:_docPhoto('assets/images/lab_komputer.jpg',
                  'Lab Komputer B-3','Kelistrikan normal')),
              ]),
              const SizedBox(height:20),
              InkWell(onTap:()=>infoDialog(context,'Panduan Pelaporan',
                '1. Login ke akun mahasiswa.\n2. Pilih Buat Laporan.\n3. Pilih gedung, ruangan dan kategori.\n4. Isi judul, deskripsi, prioritas dan unggah foto.\n5. Kirim laporan dan pantau progres melalui Riwayat.'),
                borderRadius:BorderRadius.circular(18),
                child:const FxPanel(child:Row(children:[
                  Icon(Icons.help_outline,color:Fx.primary,size:32),SizedBox(width:12),
                  Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                    Text('Panduan Pelaporan',style:TextStyle(fontWeight:FontWeight.w800)),
                    SizedBox(height:3),Text('Ketahui alur pelaporan fasilitas',
                      style:TextStyle(color:Fx.muted,fontSize:11)),
                  ])),Icon(Icons.arrow_forward,color:Fx.primary),
                ]))),
              const SizedBox(height:24),
            ])),
        ]))));

  Widget _hero(BuildContext context)=>Container(
    constraints:const BoxConstraints(minHeight:215),
    padding:const EdgeInsets.fromLTRB(22,18,22,44),
    decoration:const BoxDecoration(gradient:Fx.blueGradient,
      borderRadius:BorderRadius.vertical(bottom:Radius.circular(30))),
    child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Row(crossAxisAlignment:CrossAxisAlignment.center,children:[
        Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Text('Halo, ${store.firstName}! 👋',style:const TextStyle(color:Colors.white,
            fontSize:20,fontWeight:FontWeight.w900)),
          const SizedBox(height:12),
          const Text('Laporkan kerusakan fasilitas kampus dengan mudah dan pantau progresnya.',
            style:TextStyle(color:Colors.white,fontSize:12,height:1.55)),
        ])),
        const SizedBox(width:12),
        const SizedBox(width:100,height:110,child:CampusArt()),
      ]),
      const SizedBox(height:13),
      Divider(color:Colors.white.withValues(alpha:.3)),
      const SizedBox(height:11),
      const Row(children:[Icon(Icons.verified_user_outlined,color:Colors.white,size:17),
        SizedBox(width:8),Expanded(child:Text('Fakultas Ilmu Komputer',
          style:TextStyle(color:Colors.white,fontSize:11,fontWeight:FontWeight.w600))),
        Icon(Icons.circle,color:Color(0xFF1FE29B),size:8),SizedBox(width:4),
        Text('Layanan Aktif',style:TextStyle(color:Colors.white,fontSize:10)),
      ]),
    ]));

  Widget _shortcut(BuildContext context,IconData icon,String label,Color color,VoidCallback onTap)=>
    InkWell(onTap:onTap,borderRadius:BorderRadius.circular(18),
      child:FxPanel(child:Row(children:[
        Container(padding:const EdgeInsets.all(12),decoration:BoxDecoration(
          color:color.withValues(alpha:.13),borderRadius:BorderRadius.circular(13)),
          child:Icon(icon,color:color,size:23)),
        const SizedBox(width:10),Expanded(child:Text(label,
          style:const TextStyle(fontSize:12,fontWeight:FontWeight.w700))),
        const Icon(Icons.chevron_right,color:Fx.muted,size:18),
      ])));

  Widget _docPhoto(String asset,String title,String caption)=>ClipRRect(
    borderRadius:BorderRadius.circular(18),child:SizedBox(height:126,
      child:Stack(fit:StackFit.expand,children:[
        Image.asset(asset,fit:BoxFit.cover),
        const DecoratedBox(decoration:BoxDecoration(gradient:LinearGradient(
          begin:Alignment.topCenter,end:Alignment.bottomCenter,
          colors:[Colors.transparent,Color(0xC9000000)]))),
        Positioned(left:9,right:5,bottom:10,child:Column(
          crossAxisAlignment:CrossAxisAlignment.start,children:[
            Text(title,style:const TextStyle(color:Colors.white,
              fontSize:12,fontWeight:FontWeight.w800)),
            Text(caption,style:const TextStyle(color:Colors.white70,fontSize:10)),
          ])),
      ])));
}

class CampusArt extends StatelessWidget {
  const CampusArt({super.key});
  @override Widget build(BuildContext context)=>Stack(children:[
    Positioned(bottom:8,right:0,width:99,height:62,child:Container(
      decoration:const BoxDecoration(color:Color(0xFF13C48C),
        borderRadius:BorderRadius.only(topLeft:Radius.circular(80),topRight:Radius.circular(80))))),
    Positioned(bottom:8,left:14,width:65,height:82,child:Container(
      decoration:const BoxDecoration(color:Colors.white,borderRadius:BorderRadius.only(
        topLeft:Radius.circular(8),topRight:Radius.circular(8))),
      child:Center(child:Container(width:21,height:43,
        decoration:const BoxDecoration(color:Fx.primary,borderRadius:BorderRadius.vertical(
          top:Radius.circular(15))))))),
    Positioned(bottom:89,left:7,child:Container(width:78,height:11,
      decoration:BoxDecoration(color:const Color(0xFFFF9A36),borderRadius:BorderRadius.circular(3)))),
  ]);
}

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});
  @override State<HistoryPage> createState()=>_HistoryPageState();
}
class _HistoryPageState extends State<HistoryPage>{
  String filter='Semua';
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:const FxTopBar(),
    body:AnimatedBuilder(animation:store,builder:(context,_) {
      final list=store.reports.where((r)=>filter=='Semua'||r.status==filter).toList();
      return SingleChildScrollView(padding:const EdgeInsets.fromLTRB(20,14,20,30),
        child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
          const Text('Riwayat Laporan Saya',style:TextStyle(fontWeight:FontWeight.w900,fontSize:20)),
          const SizedBox(height:16),
          SingleChildScrollView(scrollDirection:Axis.horizontal,child:Row(children:
            ['Semua','Diajukan','Diverifikasi','Ditugaskan','Diproses','Selesai','Ditolak'].map((s)=>
              Padding(padding:const EdgeInsets.only(right:7),child:ChoiceChip(label:Text(s),
                selected:filter==s,onSelected:(_)=>setState(()=>filter=s),
                selectedColor:Fx.primary,
                labelStyle:TextStyle(color:filter==s?Colors.white:Fx.ink,fontSize:11,
                  fontWeight:FontWeight.w700),
                showCheckmark:false,side:BorderSide.none,
                backgroundColor:Colors.white))).toList())),
          const SizedBox(height:22),
          if(list.isEmpty) const FxPanel(child:Column(children:[
            Icon(Icons.folder_off_outlined,size:48,color:Fx.muted),SizedBox(height:12),
            Text('Tidak Ada Laporan',style:TextStyle(fontWeight:FontWeight.w800)),
            SizedBox(height:8),
            Text('Belum ada tiket laporan pada status yang dipilih.',
              textAlign:TextAlign.center,style:TextStyle(color:Fx.muted)),
          ])),
          ...list.map((r)=>ReportCard(report:r,onTap:()=>Navigator.push(context,
            MaterialPageRoute(builder:(_)=>ReportDetailPage(report:r))))),
        ]));
    }));
}

class CreateReportPage extends StatefulWidget {
  const CreateReportPage({super.key});
  @override State<CreateReportPage> createState()=>_CreateReportPageState();
}
class _CreateReportPageState extends State<CreateReportPage>{
  final form=GlobalKey<FormState>();
  final title=TextEditingController(),description=TextEditingController();
  String? building,room,category;
  String priority='Sedang';
  String? photoPath;
  bool useDemoPhoto=false;
  final picker=ImagePicker();
  final buildings={'Gedung A':['A-203 (Ruang Kelas)','A-101 (Lab Komputer)','Toilet Lantai 2 Barat'],
    'Gedung B':['Koridor Barat','B-101 (Ruang Kelas)','B-202 (Laboratorium)'],
    'Gedung C':['Ruang Teater C-101','C-202 (Ruang Kelas)'],
    'Perpustakaan Pusat':['Lantai 1','Lantai 2']};
  final categories=['Kelistrikan & AC','Perabotan / Meja Kursi','Sanitasi & Pipa Air',
    'Pintu, Jendela & Plafon','Jaringan Internet','Lainnya'];
  @override void dispose(){title.dispose();description.dispose();super.dispose();}
  Future<void> choosePhoto(ImageSource source) async{
    try{
      final picked=await picker.pickImage(source:source,imageQuality:75,maxWidth:1600);
      if(picked!=null && mounted){setState((){photoPath=picked.path;useDemoPhoto=false;});}
    }catch(_){if(mounted)fxMessage(context,'Kamera/galeri tidak tersedia pada perangkat ini.');}
  }
  void photoOptions(){showModalBottomSheet<void>(context:context,showDragHandle:true,
    builder:(context)=>SafeArea(child:Column(mainAxisSize:MainAxisSize.min,children:[
      const ListTile(title:Text('Pilih Foto Kerusakan',
        style:TextStyle(fontWeight:FontWeight.w800))),
      ListTile(leading:const Icon(Icons.camera_alt_outlined),title:const Text('Ambil dari Kamera'),
        onTap:(){Navigator.pop(context);choosePhoto(ImageSource.camera);}),
      ListTile(leading:const Icon(Icons.photo_library_outlined),title:const Text('Pilih dari Galeri'),
        onTap:(){Navigator.pop(context);choosePhoto(ImageSource.gallery);}),
      ListTile(leading:const Icon(Icons.image_outlined),
        title:const Text('Gunakan Foto Contoh (Demo)'),
        onTap:(){Navigator.pop(context);setState((){useDemoPhoto=true;photoPath=null;});}),
      const SizedBox(height:16),
    ])));
  }
  void submit(){
    if(!form.currentState!.validate())return;
    if(building==null||room==null||category==null){
      fxMessage(context,'Lengkapi gedung, ruangan, dan kategori kerusakan.');return;
    }
    if(photoPath==null&&!useDemoPhoto){
      fxMessage(context,'Lampirkan foto kerusakan terlebih dahulu.');return;
    }
    final item=store.submit(title:title.text.trim(),building:building!,room:room!,
      category:category!,description:description.text.trim(),priority:priority,
      photoPath:photoPath,demoPhoto:useDemoPhoto);
    Navigator.pushReplacement(context,MaterialPageRoute(
      builder:(_)=>ReportSuccessPage(report:item)));
  }
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:const ScreenHeader(title:'Buat Laporan',showProfile:true),
    body:SafeArea(child:SingleChildScrollView(
      padding:const EdgeInsets.fromLTRB(20,20,20,32),
      child:Center(child:ConstrainedBox(constraints:const BoxConstraints(maxWidth:560),
        child:Form(key:form,child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
          _dropdown('Pilih Gedung',Icons.apartment_outlined,building,buildings.keys.toList(),(v){
            setState((){building=v;room=null;});}),
          const SizedBox(height:14),
          _dropdown('Pilih Ruangan',Icons.meeting_room_outlined,room,
            building==null?[]:buildings[building]!,
            (v)=>setState(()=>room=v)),
          const SizedBox(height:14),
          _dropdown('Kategori Kerusakan',Icons.layers_outlined,category,categories,
            (v)=>setState(()=>category=v)),
          const SizedBox(height:14),
          FxTextField(controller:title,hint:'Judul Laporan',icon:Icons.title,
            validator:(v)=>v==null||v.trim().length<5?'Judul minimal 5 karakter':null),
          const SizedBox(height:14),
          FxTextField(controller:description,hint:'Deskripsi Kerusakan',
            icon:Icons.notes_rounded,maxLines:4,
            validator:(v)=>v==null||v.trim().length<10?'Deskripsi minimal 10 karakter':null),
          const SizedBox(height:22),
          const Text('Prioritas',style:TextStyle(fontSize:14,fontWeight:FontWeight.w900)),
          const SizedBox(height:9),
          Wrap(spacing:8,runSpacing:9,children:['Rendah','Sedang','Tinggi','Darurat'].map((p){
            final active=priority==p;
            final accent=p=='Darurat'?const Color(0xFFDC4545):
              p=='Tinggi'?Fx.orange:Fx.primary;
            return ChoiceChip(label:Text(p),selected:active,
              selectedColor:accent,backgroundColor:const Color(0xFFE8ECFF),
              showCheckmark:false,side:BorderSide.none,
              labelStyle:TextStyle(color:active?Colors.white:Fx.primary,fontSize:12,
                fontWeight:FontWeight.w800),onSelected:(_)=>setState(()=>priority=p));
          }).toList()),
          const SizedBox(height:22),
          const Text('Foto Bukti',style:TextStyle(fontWeight:FontWeight.w900,fontSize:14)),
          const SizedBox(height:10),
          InkWell(onTap:photoOptions,borderRadius:BorderRadius.circular(18),
            child:Container(height:170,
              decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(18),
                border:Border.all(color:const Color(0xFFDDE5FF),width:1.5)),
              child:photoPath!=null?ClipRRect(borderRadius:BorderRadius.circular(17),
                child:Image.file(File(photoPath!),fit:BoxFit.cover)):
                useDemoPhoto?ClipRRect(borderRadius:BorderRadius.circular(17),
                  child:Image.asset('assets/images/ac_ruang_kelas.jpg',fit:BoxFit.cover)):
                const Column(mainAxisAlignment:MainAxisAlignment.center,children:[
                  CircleAvatar(backgroundColor:Fx.lightBlue,radius:25,
                    child:Icon(Icons.add_a_photo_outlined,color:Fx.primary)),
                  SizedBox(height:11),
                  Text('Unggah Foto Kerusakan',style:TextStyle(fontWeight:FontWeight.w800)),
                  SizedBox(height:4),
                  Text('Pilih dari Galeri atau Kamera',
                    style:TextStyle(color:Fx.muted,fontSize:12)),
                ])),
          ),
          if(photoPath!=null||useDemoPhoto) TextButton.icon(
            onPressed:photoOptions,icon:const Icon(Icons.edit_outlined,size:16),
            label:const Text('Ganti foto')),
          const SizedBox(height:22),
          FxButton(text:'Kirim Laporan',icon:Icons.send_outlined,onPressed:submit),
          const SizedBox(height:14),
          const Text('Mode demo: laporan disimpan di memori aplikasi, bukan ke server.',
            textAlign:TextAlign.center,
            style:TextStyle(color:Fx.muted,fontSize:11)),
        ])))))),
  );
  Widget _dropdown(String placeholder,IconData icon,String? selected,
    List<String> items,ValueChanged<String?> callback)=>Container(
      padding:const EdgeInsets.symmetric(horizontal:12),
      decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(16)),
      child:Row(children:[Icon(icon,color:Fx.primary,size:21),const SizedBox(width:11),
        Expanded(child:DropdownButtonHideUnderline(child:DropdownButton<String>(
          value:selected,isExpanded:true,hint:Text(placeholder,
            style:const TextStyle(color:Fx.muted,fontSize:13)),
          items:items.map((v)=>DropdownMenuItem(value:v,child:Text(v,
            overflow:TextOverflow.ellipsis,style:const TextStyle(fontSize:12)))).toList(),
          onChanged:items.isEmpty?null:callback))),
      ]));
}

class ReportSuccessPage extends StatelessWidget {
  final ReportItem report;
  const ReportSuccessPage({super.key,required this.report});
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:const ScreenHeader(title:'Laporan Terkirim'),
    body:SafeArea(child:Padding(padding:const EdgeInsets.all(25),
      child:Center(child:ConstrainedBox(constraints:const BoxConstraints(maxWidth:440),
        child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[
          const Icon(Icons.check_circle_rounded,color:Fx.green,size:90),
          const SizedBox(height:20),
          const Text('Laporan Berhasil Dikirim!',textAlign:TextAlign.center,
            style:TextStyle(fontSize:23,fontWeight:FontWeight.w900)),
          const SizedBox(height:12),
          const Text('Laporan kamu tercatat dengan status Diajukan. Pantau progresnya pada Riwayat.',
            textAlign:TextAlign.center,style:TextStyle(color:Fx.muted,height:1.5)),
          const SizedBox(height:18),
          FxPanel(child:Column(children:[const Text('NOMOR LAPORAN',
            style:TextStyle(fontSize:11,color:Fx.muted)),const SizedBox(height:7),
            Text(report.id,style:const TextStyle(fontSize:23,
              color:Fx.primary,fontWeight:FontWeight.w900))])),
          const SizedBox(height:22),
          FxButton(text:'Lihat Detail Laporan',onPressed:()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:(_)=>ReportDetailPage(report:report)))),
          const SizedBox(height:14),
          TextButton(onPressed:(){Navigator.popUntil(context,(r)=>r.isFirst);
            store.setTab(1);},child:const Text('Ke Riwayat Laporan')),
        ]))))),
  );
}

class ReportDetailPage extends StatelessWidget {
  final ReportItem report;
  const ReportDetailPage({super.key,required this.report});
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:const ScreenHeader(title:'Detail Laporan',showProfile:true),
    body:SingleChildScrollView(padding:const EdgeInsets.fromLTRB(20,18,20,34),
      child:Center(child:ConstrainedBox(constraints:const BoxConstraints(maxWidth:560),
        child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
          Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(
            gradient:Fx.blueGradient,borderRadius:BorderRadius.circular(18),boxShadow:Fx.shadow),
            child:Row(children:[Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,
              children:[const Text('NOMOR LAPORAN',
                style:TextStyle(color:Colors.white70,fontSize:10,fontWeight:FontWeight.w800)),
                const SizedBox(height:5),Text(report.id,
                  style:const TextStyle(color:Colors.white,fontSize:21,fontWeight:FontWeight.w900))])),
              FxStatus(report.status)])),
          const SizedBox(height:20),
          FxPanel(child:Column(children:[
            _field(Icons.apartment_outlined,'Gedung',report.building),
            _field(Icons.meeting_room_outlined,'Ruangan',report.room),
            _field(Icons.layers_outlined,'Kategori',report.category),
            _field(Icons.flag_outlined,'Prioritas',report.priority),
            _field(Icons.title,'Laporan',report.title),
            _field(Icons.notes,'Deskripsi',report.description),
          ])),
          const SizedBox(height:24),
          Row(children:[const Text('Foto Kerusakan',style:TextStyle(fontSize:18,
            fontWeight:FontWeight.w900)),const Spacer(),
            Text(report.photoPath==null&&!report.demoPhoto?'Tidak ada foto':'1 Lampiran',
              style:const TextStyle(color:Fx.muted,fontSize:11))]),
          const SizedBox(height:12),
          ClipRRect(borderRadius:BorderRadius.circular(18),child:SizedBox(height:205,
            child:report.photoPath!=null?Image.file(File(report.photoPath!),fit:BoxFit.cover):
              report.demoPhoto?Image.asset('assets/images/ac_ruang_kelas.jpg',fit:BoxFit.cover):
              Container(color:Fx.lightBlue,child:const Center(child:Icon(Icons.image_outlined,
                color:Fx.primary,size:65))))),
          const SizedBox(height:26),
          Row(children:[const Expanded(child:Text('Progress Perbaikan',
            style:TextStyle(fontSize:18,fontWeight:FontWeight.w900))),
            Text(report.status=='Selesai'?'Tuntas':'Dipantau',
              style:const TextStyle(color:Fx.primary,fontWeight:FontWeight.w700,fontSize:11))]),
          const SizedBox(height:12),
          FxPanel(child:Column(children:[
            for(var i=0;i<5;i++) _progressRow(i,
              ['Diajukan','Diverifikasi','Ditugaskan','Diproses','Selesai'][i]),
          ])),
          const SizedBox(height:20),
          FxPanel(child:Row(children:[const CircleAvatar(backgroundColor:Fx.lightBlue,
              child:Icon(Icons.engineering_outlined,color:Fx.primary)),
            const SizedBox(width:12),Expanded(child:Column(
              crossAxisAlignment:CrossAxisAlignment.start,children:[
                const Text('Teknisi Bertugas',
                  style:TextStyle(color:Fx.muted,fontWeight:FontWeight.w700,fontSize:11)),
                const SizedBox(height:4),Text(report.status=='Diajukan'||report.status=='Diverifikasi'?
                  'Belum ditugaskan':'Pak Budi (Divisi Sarpras)',
                  style:const TextStyle(fontWeight:FontWeight.w700,fontSize:13)),
              ]))])),
          if(report.status=='Ditolak')...[
            const SizedBox(height:14),const FxPanel(child:Text('Laporan ditolak. Alasan admin akan tampil setelah backend terintegrasi.')),
          ],
          if(report.status=='Selesai')...[
            const SizedBox(height:14),const FxPanel(child:Text('Perbaikan selesai. Terima kasih telah melaporkan kerusakan fasilitas kampus.')),
          ],
          const SizedBox(height:18),
          const Text('Progres pada data contoh merupakan simulasi, bukan perubahan status real-time.',
            style:TextStyle(color:Fx.muted,fontSize:10),textAlign:TextAlign.center),
        ])))),
    bottomNavigationBar:FxBottomNav(index:1,onSelect:(tab){
      Navigator.popUntil(context,(r)=>r.isFirst);store.setTab(tab);
    }),
  );
  Widget _field(IconData icon,String key,String value)=>Padding(
    padding:const EdgeInsets.symmetric(vertical:7),
    child:Row(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Icon(icon,color:Fx.primary,size:18),const SizedBox(width:10),
      SizedBox(width:79,child:Text(key,style:const TextStyle(color:Fx.muted,fontSize:12))),
      const Text(':  ',style:TextStyle(color:Fx.muted)),
      Expanded(child:Text(value,style:const TextStyle(fontSize:12,fontWeight:FontWeight.w700))),
    ]));
  Widget _progressRow(int index,String title){
    const stages=['Diajukan','Diverifikasi','Ditugaskan','Diproses','Selesai'];
    final current=stages.indexOf(report.status);
    final done=index<=current && current>=0;
    final currentStep=index==current;
    return Row(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Column(children:[
        Container(width:28,height:28,decoration:BoxDecoration(shape:BoxShape.circle,
          color:done?currentStep?const Color(0xFF6A8CEB):Fx.primary:
            const Color(0xFFE5E8F4)),
          child:Icon(done?Icons.check:Icons.circle,
            size:done?16:9,color:done?Colors.white:const Color(0xFFB6C1D7))),
        if(index<4) Container(width:2,height:30,color:done?Fx.primary:
          const Color(0xFFDFE4F4)),
      ]),const SizedBox(width:14),
      Expanded(child:Padding(padding:const EdgeInsets.only(top:5),
        child:Text(title,style:TextStyle(fontSize:12,
          color:currentStep?Fx.primary:Fx.ink,
          fontWeight:currentStep?FontWeight.w900:FontWeight.w600)))),
      if(index==0||done)
        Padding(padding:const EdgeInsets.only(top:6),
          child:Text(index==0?dateId(report.created):
            report.demoPhoto?(['','31 Okt 2026 10:20','31 Okt 2026 11:00',
              '31 Okt 2026 13:30','31 Okt 2026 17:00'][index]):'-',
            style:TextStyle(fontSize:9,color:currentStep?Fx.primary:Fx.muted))),
    ]);
  }
}

class StudentProfilePage extends StatelessWidget {
  const StudentProfilePage({super.key});
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:const FxTopBar(),
    body:AnimatedBuilder(animation:store,builder:(context,_)=>
      SingleChildScrollView(padding:const EdgeInsets.fromLTRB(20,14,20,26),
        child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
          const Text('Profil Saya',style:TextStyle(fontSize:21,fontWeight:FontWeight.w900)),
          const SizedBox(height:20),
          Center(child:Column(children:[
            Container(width:94,height:94,decoration:const BoxDecoration(
              color:Fx.lightBlue,shape:BoxShape.circle),
              child:const Icon(Icons.person_rounded,color:Fx.primary,size:63)),
            const SizedBox(height:12),
            Text(store.currentUser?.name??'Mahasiswa',
              style:const TextStyle(fontWeight:FontWeight.w900,fontSize:20)),
            Text('NIM ${store.currentUser?.nim??'-'}',
              style:const TextStyle(color:Fx.muted,fontSize:12)),
            const SizedBox(height:8),
            const Text('● Mahasiswa Aktif • Teknik Informatika',
              style:TextStyle(fontWeight:FontWeight.w700,fontSize:11,color:Fx.primary)),
          ])),
          const SizedBox(height:22),
          Row(children:[
            _stat('${store.reports.length}','Total Lapor',Fx.primary),
            const SizedBox(width:10),
            _stat('${store.activeCount}','Diproses',Fx.orange),
            const SizedBox(width:10),
            _stat('${store.completedCount}','Selesai',Fx.green),
          ]),
          const SizedBox(height:22),
          _item(Icons.email_outlined,'Email Kampus',store.currentUser?.email??'-'),
          _item(Icons.school_outlined,'NIM',store.currentUser?.nim??'-'),
          _item(Icons.apartment_outlined,'Fakultas','Ilmu Komputer'),
          const SizedBox(height:18),
          const Text('BANTUAN & PREFERENSI',
            style:TextStyle(color:Fx.muted,fontSize:10,fontWeight:FontWeight.w800)),
          const SizedBox(height:9),
          _link(context,Icons.notifications_active_outlined,'Notifikasi Perbaikan',
            'Notifikasi akan aktif setelah backend terintegrasi.'),
          _link(context,Icons.support_agent,'Pusat Layanan Fasilitas',
            'Kontak layanan kampus belum disetel pada mode demo.'),
          _link(context,Icons.policy_outlined,'Syarat & Ketentuan Kampus',
            'Aplikasi ini merupakan prototype proyek mata kuliah Mobile Programming.'),
          const SizedBox(height:20),
          OutlinedButton.icon(onPressed:()=>showDialog<void>(context:context,
            builder:(dialogContext)=>AlertDialog(title:const Text('Keluar dari Fixora?'),
              content:const Text('Kamu akan kembali ke halaman pembuka.'),actions:[
                TextButton(onPressed:()=>Navigator.pop(dialogContext),
                  child:const Text('Batal')),
                TextButton(onPressed:(){Navigator.pop(dialogContext);store.logout();
                  toWelcome(context);},child:const Text('Keluar'))])),
            icon:const Icon(Icons.logout_rounded),label:const Text('Keluar'),
            style:OutlinedButton.styleFrom(foregroundColor:const Color(0xFFE45A2A),
              backgroundColor:const Color(0xFFFFEAE5),side:BorderSide.none,
              minimumSize:const Size(double.infinity,48))),
          const SizedBox(height:16),
          const Text('Fixora Mobile v1.0 • Prototype Akademik',
            textAlign:TextAlign.center,style:TextStyle(color:Fx.muted,fontSize:10)),
        ]))));
  Widget _stat(String value,String label,Color color)=>Expanded(
    child:FxPanel(padding:const EdgeInsets.symmetric(vertical:14,horizontal:3),
      child:Column(children:[Text(value,style:TextStyle(color:color,
        fontSize:20,fontWeight:FontWeight.w900)),
        Text(label,style:const TextStyle(color:Fx.muted,fontSize:10))])));
  Widget _item(IconData icon,String title,String value)=>Padding(
    padding:const EdgeInsets.only(bottom:10),child:FxPanel(child:Row(children:[
      Icon(icon,color:Fx.primary,size:21),const SizedBox(width:11),
      Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Text(title,style:const TextStyle(color:Fx.muted,fontSize:10)),
        const SizedBox(height:3),Text(value,style:const TextStyle(fontSize:12,
          fontWeight:FontWeight.w800))])),
    ])));
  Widget _link(BuildContext context,IconData icon,String title,String info)=>Padding(
    padding:const EdgeInsets.only(bottom:10),child:InkWell(
      onTap:()=>infoDialog(context,title,info),
      borderRadius:BorderRadius.circular(18),
      child:FxPanel(child:Row(children:[Icon(icon,color:Fx.muted,size:19),
        const SizedBox(width:12),Expanded(child:Text(title,
          style:const TextStyle(fontSize:12,fontWeight:FontWeight.w700))),
        const Icon(Icons.chevron_right,color:Fx.muted,size:18)]))));
}
