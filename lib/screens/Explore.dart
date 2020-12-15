import 'package:flutter/material.dart';

class Explore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      children: [
        Column(children: [
          Container(
            height: 350,
            margin: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
            child: Container(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Container(
                    width: 160,
                    color: Colors.red,
                  ),
                  Container(
                    width: 160.0,
                    color: Colors.blue,
                  ),
                  Container(
                    width: 160.0,
                    color: Colors.green,
                  ),
                  Container(
                    width: 160.0,
                    color: Colors.yellow,
                  ),
                  Container(
                    width: 160.0,
                    color: Colors.orange,
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 350,
            margin: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
            child: Container(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Container( width:300,child: CustomCard()),
                  Container(
                    width: 160.0,
                    color: Colors.green,
                  ),
                  Container(
                    width: 160.0,
                    color: Colors.blue,
                  ),
                  Container(
                    width: 160.0,
                    color: Colors.yellow,
                  ),
                  Container(
                    width: 160.0,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ),
        ])
      ],
    );
  }
}


class CustomCard extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CustomCard();
  }

}




class _CustomCard extends State<CustomCard> {



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  GestureDetector(
      onTap: ((){
        print('card tapped');
        setState(() {

        });
      }),
      child: Card(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(onTap:(
                      (){
                    print('hello');
                    setState(() {

                    });
                  }
              ),child: Icon(Icons.cancel)),
            ),
            SizedBox(
              height: 2,
            ),
            Container(
              margin: EdgeInsets.only(left: 10,right: 10),
              child:  Text("Testing asdasdasasdasdsadasasdasdaasdasdasd",style: TextStyle(fontSize: 18,fontStyle: FontStyle.italic),textAlign: TextAlign.center,), ),

            Row( children: [
              Container(margin: EdgeInsets.only(left: 20),child: Align(
                  alignment: Alignment.centerLeft,
                  child:Icon(Icons.touch_app_sharp)),),
              Container(
                  margin: EdgeInsets.only(top: 15,left: 30),
                  width: 150,
                  height: 150,
                  child: Image(
                    alignment: Alignment.centerRight,
                    image: NetworkImage(
                        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                  )),

            ]),
            Container(
              margin: EdgeInsets.only(left: 10,right: 10,top: 10),
              child:  Text("Testing asdasdasasdasdsadasasdasdaasdasdasd",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),textAlign: TextAlign.center), ),


          ],
        )),);
  }
}
