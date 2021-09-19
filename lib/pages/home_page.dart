// @dart=2.9
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wings_hq/helper/helper_functions.dart';
import 'package:wings_hq/services/database_service.dart';
import 'package:wings_hq/services/health_news_api.dart';
import 'package:wings_hq/widgets/home_page_group_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  FirebaseUser _user;
  String _userName = '';

  _getCurrentUserNameAndUid() async {
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      _userName = value;
    });
    _user = await FirebaseAuth.instance.currentUser();
  }  

  @override
  void initState() {    
    super.initState();
    _getCurrentUserNameAndUid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffcf9f3),   
      body: Container(
        width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height,
        // padding: EdgeInsets.only(left: 16),
        color: Color(0xfffcf9f3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text('New Groups 🚀', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),),
            ),
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 200,
                child: StreamBuilder(
                  stream: DatabaseService().getRecentGroupsCreated(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      return ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),                      
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {                          
                          return HomePageGroupTile(
                            groupId: snapshot.data.documents[index]['groupId'],
                            groupName: snapshot.data.documents[index]['groupName'],
                            groupDescription: snapshot.data.documents[index]['groupDescription'],
                            admin: snapshot.data.documents[index]['admin'],                            
                            userName: _userName,
                            user: _user,
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 4),
              child: Text('Health News', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),),
            ),
            Expanded(
              flex: 2,
              // child: FutureBuilder<List>(
              //   future: HealthNewsApi().getHealthNews(),
              //   builder: (context, snapshot) {
              //     if(snapshot.hasData) {
              //       // print(snapshot);
              //       return ListView.builder(
              //         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              //         physics: BouncingScrollPhysics(),
              //         itemCount: 10,
              //         itemBuilder: (context, index) {
              //           return Container(
              //             margin: EdgeInsets.symmetric(vertical: 8),
              //             height: 220,
              //             width: 200,
              //             decoration: BoxDecoration(
              //               image: DecorationImage(
              //                 image: NetworkImage(snapshot.data[index]['image']),
              //                 fit: BoxFit.cover
              //               ),
              //               borderRadius: BorderRadius.circular(15)
              //             ),
              //             child: Container(
              //               padding: EdgeInsets.all(16),
              //               height: 300,
              //               width: 200,
              //               decoration: BoxDecoration(
              //                 gradient: LinearGradient(
              //                   colors: [
              //                     Colors.transparent,
              //                     Colors.black
              //                   ],
              //                   begin: Alignment.topCenter,
              //                   end: Alignment.bottomCenter
              //                 ),
              //                 borderRadius: BorderRadius.circular(15)
              //               ),
              //               child: Column(
              //                 mainAxisAlignment: MainAxisAlignment.end,
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Text(
              //                     snapshot.data[index]['title'],
              //                     style: TextStyle(color: Colors.white, fontSize: 18),
              //                   ),
              //                   SizedBox(height: 4,),                                
              //                   Row(
              //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                     crossAxisAlignment: CrossAxisAlignment.center,
              //                     children: [
              //                       Text(
              //                         'Source: ${snapshot.data[index]['source']['name']}',
              //                         style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              //                       ),
              //                       GestureDetector(
              //                         onTap: () {
              //                           launch(snapshot.data[index]['url']);
              //                         },
              //                         child: Text(
              //                           'See more',
              //                           style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           );
              //         },
              //       );
              //     } else {
              //       return Center(
              //         child: CircularProgressIndicator(),
              //       );
              //     }
              //   },
              // ),
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                physics: BouncingScrollPhysics(),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    height: 220,
                    width: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage('https://mediaproxy.salon.com/width/1200/https://media.salon.com/2021/09/gettyimages-1232223062.jpg'),
                        fit: BoxFit.cover
                      ),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      height: 300,
                      width: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(                          
                          colors: [
                            Colors.transparent,
                            Colors.black
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter
                        ),
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,                        
                        children: [
                          Text(
                            'Georgia Gov. Brian Kemp keeps mentioning failed AIDS vaccine mandates. But there is no AIDS vaccine',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          SizedBox(height: 4,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Source: Salon',
                                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                onTap: () {
                                  print('Redirect');
                                },
                                child: Text(
                                  'See more',
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      )
    );
  }
}