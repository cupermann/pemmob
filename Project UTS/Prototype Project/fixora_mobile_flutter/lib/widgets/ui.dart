import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../models/app_state.dart';

class FxButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool orange;
  final IconData? icon;
  final bool outlined;
  const FxButton({super.key,required this.text,required this.onPressed,
    this.orange=false,this.icon,this.outlined=false});
  @override
  Widget build(BuildContext context) => SizedBox(width:double.infinity,height:52,
    child:DecoratedBox(
      decoration:BoxDecoration(
        gradient: outlined ? null : orange ? Fx.orangeGradient : Fx.blueGradient,
        color: outlined ? Colors.white : null,
        borderRadius:BorderRadius.circular(15),
        boxShadow:outlined ? null : Fx.shadow,
      ),
      child:Material(color:Colors.transparent,
        child:InkWell(onTap:onPressed,borderRadius:BorderRadius.circular(15),
          child:Row(mainAxisAlignment:MainAxisAlignment.center,children:[
            if(icon!=null)...[Icon(icon,color:outlined?Fx.primary:Colors.white,size:20),const SizedBox(width:9)],
            Text(text,style:TextStyle(color:outlined?Fx.primary:Colors.white,
              fontWeight:FontWeight.w700,fontSize:15)),
          ]))),
    ));
}

class FxPanel extends StatelessWidget {
  final Widget child;final EdgeInsets padding;
  const FxPanel({super.key,required this.child,
    this.padding=const EdgeInsets.all(16)});
  @override Widget build(BuildContext context)=>Container(
    padding:padding,decoration:BoxDecoration(color:Colors.white,
      borderRadius:BorderRadius.circular(18),boxShadow:Fx.shadow),child:child);
}

class ScreenHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;final bool showProfile;
  const ScreenHeader({super.key,required this.title,this.showProfile=false});
  @override Size get preferredSize=>const Size.fromHeight(60);
  @override Widget build(BuildContext context)=>AppBar(
    title:Text(title,style:const TextStyle(fontWeight:FontWeight.w800,fontSize:18)),
    automaticallyImplyLeading:Navigator.of(context).canPop(),
    actions:showProfile?[IconButton(onPressed:(){Navigator.of(context).popUntil((r)=>r.isFirst);store.setTab(2);},
      icon:const CircleAvatar(backgroundColor:Fx.primary,
        child:Icon(Icons.person_outline,color:Colors.white,size:20)))] : null,
  );
}

class FxStatus extends StatelessWidget {
  final String status;
  const FxStatus(this.status,{super.key});
  @override Widget build(BuildContext context){
    Color color, bg;
    switch(status){
      case 'Selesai':color=const Color(0xFF02764B);bg=const Color(0xFFE4FAF0);break;
      case 'Diproses':color=const Color(0xFFB34F00);bg=const Color(0xFFFFF1DF);break;
      case 'Ditolak':color=const Color(0xFFB42525);bg=const Color(0xFFFFE6E6);break;
      case 'Diverifikasi':color=Fx.primary;bg=const Color(0xFFEBF1FF);break;
      case 'Ditugaskan':color=Fx.primary;bg=const Color(0xFFEBF1FF);break;
      default:color=Fx.muted;bg=const Color(0xFFF0F1F6);
    }
    return Container(padding:const EdgeInsets.symmetric(horizontal:10,vertical:5),
      decoration:BoxDecoration(color:bg,borderRadius:BorderRadius.circular(30)),
      child:Text(status,style:TextStyle(color:color,fontSize:10,fontWeight:FontWeight.w800)));
  }
}

class FxTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int maxLines;
  const FxTextField({super.key,required this.controller,required this.hint,
    required this.icon,this.obscure=false,this.suffix,this.validator,
    this.keyboardType,this.maxLines=1});
  @override Widget build(BuildContext context)=>TextFormField(
    controller:controller,obscureText:obscure,
    keyboardType:keyboardType,maxLines:maxLines,
    validator:validator,
    decoration:InputDecoration(hintText:hint,
      hintStyle:const TextStyle(color:Fx.muted,fontSize:13),
      prefixIcon:Icon(icon,size:20,color:Fx.muted),suffixIcon:suffix),
  );
}

class ReportCard extends StatelessWidget {
  final ReportItem report;
  final VoidCallback onTap;
  const ReportCard({super.key,required this.report,required this.onTap});
  @override Widget build(BuildContext context){
    final icon=report.category.contains('AC')?Icons.handyman_outlined:
      report.category.toLowerCase().contains('kursi')?Icons.chair_outlined:Icons.lightbulb_outline;
    return Padding(padding:const EdgeInsets.only(bottom:12),
      child:Material(color:Colors.white,borderRadius:BorderRadius.circular(18),
        child:InkWell(onTap:onTap,borderRadius:BorderRadius.circular(18),
          child:Container(padding:const EdgeInsets.all(15),
            decoration:BoxDecoration(borderRadius:BorderRadius.circular(18),
              boxShadow:Fx.shadow,color:Colors.white),
            child:Row(children:[
              Container(width:52,height:52,decoration:BoxDecoration(
                  color:const Color(0xFFFFE5D6),borderRadius:BorderRadius.circular(14)),
                  child:Icon(icon,color:Fx.orange,size:27)),
              const SizedBox(width:12),
              Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                Row(children:[Expanded(child:Text(report.id,
                  style:const TextStyle(fontSize:12,fontWeight:FontWeight.w800))),
                  FxStatus(report.status)]),
                const SizedBox(height:4),
                Text(report.title,maxLines:2,overflow:TextOverflow.ellipsis,
                  style:const TextStyle(fontSize:13,color:Fx.ink,fontWeight:FontWeight.w500)),
                const SizedBox(height:6),
                Text('${report.building} • ${dateId(report.created)}',
                  style:const TextStyle(fontSize:11,color:Fx.muted)),
              ])),
              const SizedBox(width:3),const Icon(Icons.chevron_right,color:Fx.muted,size:20),
            ]))),
      ));
  }
}

void fxMessage(BuildContext context,String text){
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(text),
    behavior:SnackBarBehavior.floating));
}
