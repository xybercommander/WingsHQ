// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:wings_hq/services/database_service.dart';
import 'package:wings_hq/widgets/professional_tile.dart';

class ProfessionalsPage extends StatefulWidget {
  const ProfessionalsPage({ Key key }) : super(key: key);

  @override
  _ProfessionalsPageState createState() => _ProfessionalsPageState();
}

class _ProfessionalsPageState extends State<ProfessionalsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffcf9f3),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
          stream: DatabaseService().getProfessionals(),
          // ignore: missing_return
          builder: (context, snapshot) {
            if(snapshot.hasData) {              
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return ProfessionalTile(
                    fullName: snapshot.data.documents[index]['fullName'],
                    imgUrl: snapshot.data.documents[index]['imgUrl'],
                    profession: snapshot.data.documents[index]['profession'],
                    about: snapshot.data.documents[index]['about'],
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }
        ),
      ),
    );
  }
}