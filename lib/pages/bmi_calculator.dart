// @dart=2.9
import 'dart:math';
import 'package:flutter/material.dart';

class BmiCalculator extends StatefulWidget {
  const BmiCalculator({ Key key }) : super(key: key);

  @override
  _BmiCalculatorState createState() => _BmiCalculatorState();
}

class _BmiCalculatorState extends State<BmiCalculator> {

  int index=0;
  double result;
  double height=0;
  double weight=0;
  int currentIndex;
  


  // InputController
  TextEditingController heightController= TextEditingController();
  TextEditingController weightController= TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('BMI Calculator', style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 12, right: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Row(
                children:[
                  radioButton("Man",Colors.blue,0),
                  radioButton("Woman",Colors.pink,1),
                ]
              ),
              SizedBox(height:
              20.0),
              Text("Your Height in Cm: ",style: TextStyle(
                color: Colors.black, fontSize: 25.0,fontFamily:"SF Pro")),


//----------------------------- INPUT FIELD---------------------------
              
              
                TextField(
                  keyboardType:TextInputType.number,
                  controller: heightController,
                  textAlign:TextAlign.center,
                  decoration: InputDecoration(
                    hintText:"Your height in Cm: ",
                    filled: true,
                    fillColor: Colors.grey[200], 
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  ),
                  SizedBox(height:30.0),
                  Text("Your Weight in Kg: ",style: TextStyle(
                color: Colors.black, fontSize: 25.0,fontFamily:"SF Pro")),
                

                TextField(
                  keyboardType:TextInputType.number,
                  controller: weightController,
                  textAlign:TextAlign.center,
                  decoration: InputDecoration(
                    hintText:"Your weight in Kg: ",
                    filled: true,
                    fillColor: Colors.grey[200], 
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  ),
                  SizedBox(height:20.0),
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: FlatButton(
                      onPressed: (){
                      setState(() {
                          height=double.parse(heightController.value.text);
                        weight=double.parse(heightController.value.text);
                      });
                        calculateBMI(height,weight);
                      },
                      color: Colors.blue, 
                      child: Text("Calculate",style: TextStyle(color: Colors.white))
                      ),
                  ),
                  SizedBox(height:20.0),
                  Container(
                    width: double.infinity,
                    child: Text("Your BMI is: ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.black,)),
                  ),
                  SizedBox(height:50.0),
                  Container(
                    width: double.infinity,
                    child: Text("$result",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40.0,
                      color: Colors.black,)),
                  )
            ],
          )
        )
      )
    );
  }

void calculateBMI(double height, double weight){
  double finalresult=weight/pow(height/100,2);
  String bmi= finalresult.toStringAsFixed(2);
  setState(() {
    result = 24.2;
  });
}

void changeIndex(int index){
  setState((){
    currentIndex = index;
  });
}

  Widget radioButton(String value,Color color,int index){
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal:12.0),
        child: FlatButton(
          color: currentIndex==index ? color: Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          onPressed:  (){
            changeIndex(index);
          },
          child: Text(value,style: TextStyle(
            color: currentIndex==index ?Colors.white:color,
          ),
          ),
        ),
      ),
    );
  }
}
