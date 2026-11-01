import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../models/app_state.dart';
import '../widgets/ui.dart';
import 'student_screens.dart';

void toWelcome(BuildContext context) => Navigator.of(context).pushAndRemoveUntil(
  MaterialPageRoute(builder:(_)=>const WelcomePage()),(r)=>false);
void toHome(BuildContext context) => Navigator.of(context).pushAndRemoveUntil(
  MaterialPageRoute(builder:(_)=>const StudentShell()),(r)=>false);

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});
  @override Widget build(BuildContext context)=>Scaffold(
    body:LayoutBuilder(builder:(context,c)=>Container(
      width:double.infinity,height:c.maxHeight,
      decoration:const BoxDecoration(gradient:LinearGradient(
        begin:Alignment.topLeft,end:Alignment.bottomRight,
        colors:[Color(0xFF0057CB),Color(0xFF2563EB),Color(0xFF1741B8)])),
      child:Stack(clipBehavior:Clip.hardEdge,children:[
        Positioned(top:-145,left:-110,width:340,height:360,
          child:DecoratedBox(decoration:BoxDecoration(shape:BoxShape.circle,
            gradient:RadialGradient(colors:[const Color(0xFFFFA369).withValues(alpha:.96),
              const Color(0xFFFF7A2F).withValues(alpha:.56),Colors.transparent])))),
        Positioned(bottom:-145,right:-110,width:360,height:380,
          child:DecoratedBox(decoration:BoxDecoration(shape:BoxShape.circle,
            gradient:RadialGradient(colors:[const Color(0xFFFF8738).withValues(alpha:.95),
              const Color(0xFFFF8738).withValues(alpha:.3),Colors.transparent])))),
        SafeArea(child:Center(child:ConstrainedBox(
          constraints:const BoxConstraints(maxWidth:470),
          child:Padding(padding:const EdgeInsets.symmetric(horizontal:30),
            child:Column(children:[
              const Spacer(flex:3),
              Container(width:94,height:94,decoration:BoxDecoration(color:Colors.white,
                borderRadius:BorderRadius.circular(25),boxShadow:Fx.shadow),
                child:const Icon(Icons.handyman_rounded,color:Fx.primary,size:46)),
              const SizedBox(height:24),
              const Text('Fixora',style:TextStyle(fontSize:35,fontWeight:FontWeight.w900,
                color:Colors.white,letterSpacing:-1.4)),
              const SizedBox(height:7),
              const Text('Pelaporan & Pemantauan Perbaikan\nFasilitas Kampus',
                textAlign:TextAlign.center,style:TextStyle(fontSize:13,color:Colors.white,
                  height:1.5,fontWeight:FontWeight.w500)),
              const SizedBox(height:21),
              Container(padding:const EdgeInsets.symmetric(horizontal:15,vertical:7),
                decoration:BoxDecoration(color:Colors.white.withValues(alpha:.2),
                  borderRadius:BorderRadius.circular(40),
                  border:Border.all(color:Colors.white.withValues(alpha:.18))),
                child:const Row(mainAxisSize:MainAxisSize.min,children:[
                  Icon(Icons.circle,color:Color(0xFF30DB8D),size:9),
                  SizedBox(width:8),Text('KAMPUS AKTIF TERINTEGRASI',
                    style:TextStyle(color:Colors.white,fontSize:10,fontWeight:FontWeight.w800))])),
              const Spacer(flex:4),
              FxButton(text:'Masuk',orange:true,
                onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const LoginPage()))),
              const SizedBox(height:12),
              FxButton(text:'Daftar',outlined:true,
                onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const RegisterPage()))),
              const SizedBox(height:18),
              const Text('Sistem Resmi Sarana & Prasarana Kampus',
                style:TextStyle(fontSize:10,color:Colors.white70)),
              const SizedBox(height:22),
            ])))))
      ]))));
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override State<LoginPage> createState()=>_LoginPageState();
}
class _LoginPageState extends State<LoginPage>{
  final form=GlobalKey<FormState>();
  final email=TextEditingController(),pass=TextEditingController();
  bool hide=true;
  @override void dispose(){email.dispose();pass.dispose();super.dispose();}
  void submit(){
    if(!form.currentState!.validate())return;
    final err=store.login(email.text,pass.text);
    if(err!=null){fxMessage(context,err);return;}
    toHome(context);
  }
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:const ScreenHeader(title:''),
    body:SafeArea(child:SingleChildScrollView(padding:const EdgeInsets.all(24),
      child:Center(child:ConstrainedBox(constraints:const BoxConstraints(maxWidth:480),
        child:Form(key:form,child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
          const SizedBox(height:24),
          Center(child:Container(padding:const EdgeInsets.all(18),
            decoration:BoxDecoration(color:Fx.lightBlue,borderRadius:BorderRadius.circular(22)),
            child:const Icon(Icons.lock_person_outlined,color:Fx.primary,size:34))),
          const SizedBox(height:24),
          const Text('Selamat Datang Kembali',textAlign:TextAlign.center,
            style:TextStyle(fontSize:24,fontWeight:FontWeight.w900)),
          const SizedBox(height:10),
          const Text('Masuk ke akun Fixora kamu untuk melapor & memantau perbaikan fasilitas kampus.',
            textAlign:TextAlign.center,style:TextStyle(color:Fx.muted,height:1.5,fontSize:13)),
          const SizedBox(height:36),
          const Text('Email Mahasiswa',style:TextStyle(fontWeight:FontWeight.w700,fontSize:13)),
          const SizedBox(height:9),
          FxTextField(controller:email,hint:'nama@kampus.ac.id',icon:Icons.email_outlined,
            keyboardType:TextInputType.emailAddress,
            validator:(v)=>v==null||!v.contains('@')?'Masukkan email yang valid':null),
          const SizedBox(height:20),
          const Text('Password',style:TextStyle(fontWeight:FontWeight.w700,fontSize:13)),
          const SizedBox(height:9),
          FxTextField(controller:pass,hint:'Masukkan password',icon:Icons.lock_outline,
            obscure:hide,validator:(v)=>v==null||v.isEmpty?'Password wajib diisi':null,
            suffix:IconButton(onPressed:()=>setState(()=>hide=!hide),
              icon:Icon(hide?Icons.visibility_outlined:Icons.visibility_off_outlined))),
          Align(alignment:Alignment.centerRight,child:TextButton(onPressed:()=>
            Navigator.push(context,MaterialPageRoute(builder:(_)=>const ForgotPasswordPage())),
            child:const Text('Lupa Password?',style:TextStyle(color:Fx.orange,fontSize:12)))),
          const SizedBox(height:14),
          FxButton(text:'Masuk',icon:Icons.arrow_forward_rounded,onPressed:submit),
          const SizedBox(height:22),
          Center(child:TextButton(onPressed:()=>Navigator.push(context,
            MaterialPageRoute(builder:(_)=>const RegisterPage())),
            child:const Text('Belum punya akun? Daftar',
              style:TextStyle(color:Fx.primary,fontWeight:FontWeight.w600)))),
          const SizedBox(height:20),
          FxPanel(child:Column(children:[
            const Text('MODE DEMO — TANPA BACKEND',
              style:TextStyle(color:Fx.primary,fontWeight:FontWeight.w800,fontSize:11)),
            const SizedBox(height:8),
            const Text('Akun contoh: muhammadyusuf@kampus.ac.id\nPassword: Fixora123!',
              textAlign:TextAlign.center,style:TextStyle(fontSize:11,color:Fx.muted)),
            TextButton(onPressed:(){email.text='muhammadyusuf@kampus.ac.id';
              pass.text='Fixora123!';fxMessage(context,'Akun demo terisi. Tekan Masuk.');},
              child:const Text('Isi Akun Demo')),
          ])),
        ])))))),
  );
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override State<RegisterPage> createState()=>_RegisterPageState();
}
class _RegisterPageState extends State<RegisterPage>{
  final form=GlobalKey<FormState>();
  final name=TextEditingController(),nim=TextEditingController(),
    email=TextEditingController(),pass=TextEditingController(),confirm=TextEditingController();
  bool hide=true;
  @override void dispose(){for(final c in [name,nim,email,pass,confirm]){c.dispose();}super.dispose();}
  void submit(){
    if(!form.currentState!.validate())return;
    final err=store.register(name.text,nim.text,email.text,pass.text);
    if(err!=null){fxMessage(context,err);return;}
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Pendaftaran berhasil. Silakan login.')));
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(_)=>const LoginPage()));
  }
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:const ScreenHeader(title:''),
    body:SafeArea(child:SingleChildScrollView(padding:const EdgeInsets.fromLTRB(24,12,24,28),
      child:Center(child:ConstrainedBox(constraints:const BoxConstraints(maxWidth:480),
        child:Form(key:form,child:Column(children:[
          Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(
            color:Fx.lightBlue,borderRadius:BorderRadius.circular(18)),
            child:const Icon(Icons.how_to_reg_rounded,color:Fx.primary,size:28)),
          const SizedBox(height:14),
          const Text('Daftar Akun',style:TextStyle(fontSize:25,fontWeight:FontWeight.w900)),
          const SizedBox(height:5),
          const Text('Buat akun mahasiswa untuk melapor\nkerusakan fasilitas.',
            textAlign:TextAlign.center,style:TextStyle(color:Fx.muted,fontSize:12)),
          const SizedBox(height:28),
          FxTextField(controller:name,hint:'Nama Lengkap',icon:Icons.person_outline,
            validator:(v)=>v==null||v.trim().length<3?'Nama minimal 3 karakter':null),
          const SizedBox(height:12),
          FxTextField(controller:nim,hint:'NIM (Nomor Induk Mahasiswa)',icon:Icons.school_outlined,
            keyboardType:TextInputType.number,
            validator:(v)=>v==null||v.trim().length<5?'NIM minimal 5 karakter':null),
          const SizedBox(height:12),
          FxTextField(controller:email,hint:'Email Mahasiswa',icon:Icons.email_outlined,
            keyboardType:TextInputType.emailAddress,
            validator:(v)=>v==null||!v.contains('@')?'Email tidak valid':null),
          const SizedBox(height:12),
          FxTextField(controller:pass,hint:'Password',icon:Icons.lock_outline,
            obscure:hide,validator:(v)=>v==null||v.length<8?'Password minimal 8 karakter':null,
            suffix:IconButton(onPressed:()=>setState(()=>hide=!hide),
              icon:Icon(hide?Icons.visibility_outlined:Icons.visibility_off_outlined))),
          const SizedBox(height:12),
          FxTextField(controller:confirm,hint:'Konfirmasi Password',icon:Icons.lock_reset,
            obscure:hide,validator:(v)=>v!=pass.text?'Konfirmasi password tidak sama':null),
          const SizedBox(height:16),
          const FxPanel(child:Row(crossAxisAlignment:CrossAxisAlignment.start,children:[
            Icon(Icons.verified_user_outlined,size:18,color:Fx.primary),SizedBox(width:10),
            Expanded(child:Text('Gunakan identitas resmi akademik untuk mempermudah verifikasi pelaporan ruang kelas atau laboratorium.',
              style:TextStyle(fontSize:11,color:Fx.muted,height:1.45)))])),
          const SizedBox(height:20),
          FxButton(text:'Daftar',icon:Icons.arrow_forward,onPressed:submit),
          const SizedBox(height:8),
          TextButton(onPressed:()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:(_)=>const LoginPage())),
            child:const Text('Sudah punya akun? Masuk')),
          const Text('Registrasi ini simulasi dan tidak memvalidasi NIM dengan SIAKAD.',
            textAlign:TextAlign.center,style:TextStyle(fontSize:10,color:Fx.muted)),
        ])))))),
  );
}

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  @override State<ForgotPasswordPage> createState()=>_ForgotPasswordPageState();
}
class _ForgotPasswordPageState extends State<ForgotPasswordPage>{
  final email=TextEditingController();bool sent=false;
  @override void dispose(){email.dispose();super.dispose();}
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:const ScreenHeader(title:''),
    body:SafeArea(child:SingleChildScrollView(padding:const EdgeInsets.all(24),
      child:Center(child:ConstrainedBox(constraints:const BoxConstraints(maxWidth:480),
        child:Column(children:[
          const SizedBox(height:38),
          Container(padding:const EdgeInsets.all(20),decoration:BoxDecoration(
            color:const Color(0xFFFFEDE5),borderRadius:BorderRadius.circular(22)),
            child:const Icon(Icons.lock_reset_rounded,color:Fx.orange,size:42)),
          const SizedBox(height:22),
          const Text('Lupa Password?',style:TextStyle(fontSize:25,fontWeight:FontWeight.w900)),
          const SizedBox(height:12),
          const Text('Masukkan email yang terdaftar untuk mengatur ulang password akun Fixora kamu.',
            textAlign:TextAlign.center,style:TextStyle(color:Fx.muted,fontSize:13,height:1.5)),
          const SizedBox(height:30),
          if(sent)...[
            const FxPanel(child:Row(children:[Icon(Icons.check_circle,color:Fx.green),
              SizedBox(width:12),Expanded(child:Text('Simulasi berhasil: belum ada email reset yang dikirim. Hubungkan ke Laravel API untuk mengaktifkannya.'))])),
            const SizedBox(height:18),
          ],
          FxTextField(controller:email,hint:'Email Mahasiswa Terdaftar',
            icon:Icons.email_outlined,keyboardType:TextInputType.emailAddress),
          const SizedBox(height:14),
          const FxPanel(child:Row(children:[Icon(Icons.info_outline,color:Fx.primary,size:20),
            SizedBox(width:9),Expanded(child:Text('Fitur reset password masih berupa simulasi UI dan tidak mengirim email.',
              style:TextStyle(fontSize:12,color:Fx.muted)))])),
          const SizedBox(height:22),
          FxButton(text:'Kirim Tautan Reset',icon:Icons.send_outlined,onPressed:(){
            if(!email.text.contains('@')){fxMessage(context,'Masukkan alamat email valid.');return;}
            setState(()=>sent=true);
          }),
          const SizedBox(height:18),
          TextButton(onPressed:()=>Navigator.of(context).pop(),
            child:const Text('← Kembali ke Login')),
        ]))))),
  );
}
