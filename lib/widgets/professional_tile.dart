import 'package:flutter/material.dart';
import 'package:hackmit/pages/hire_professional_page.dart';

class ProfessionalTile extends StatelessWidget {
  final String fullName;
  final String imgUrl;
  final String profession;
  final String about;

  const ProfessionalTile({ Key key, this.fullName, this.imgUrl, this.profession, this.about }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => HireProfessionalPage(
              name: fullName,
              imgUrl: imgUrl,
              profession: profession,
              about: about,
            )
          ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        margin: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30.0,
            backgroundColor: Color(0xff950ddb),
            backgroundImage: imgUrl != "" || imgUrl != null ? NetworkImage(imgUrl) : AssetImage('images/doctor.png'),
          ),
          title: Text(fullName, style: TextStyle(fontSize:21, color: Colors.black)),
          subtitle: Text(profession, style: TextStyle(fontSize: 13.0,fontFamily:"SF Pro", color: Colors.black)),
        ),
      ),
    );
  }
}