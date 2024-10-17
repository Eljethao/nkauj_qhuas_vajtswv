import 'package:flutter/material.dart';
import 'package:nkauj_qhuas_vajtswv/fifty_detail.dart';
import 'package:nkauj_qhuas_vajtswv/hundred_detail.dart';
import 'package:nkauj_qhuas_vajtswv/hundred_old_detail.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 20,
              ),
              const Text(
                'Nkauj Qhuas Vajtswv',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Kaulauxais 3:16 ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600)),
                    TextSpan(
                        text:
                            'Thaum nej hu nkauj, tsis hais tej nkauj uas Daviv sau lossis tej nkauj qhuas Vajtswv lossis tej nkauj uas cov ntseeg ibtxwm hu qhuas Vajtswv, nej yuav tsum zoo siab hlo ua Vajtswv tsaug',
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.grey.shade800)),
                  ],
                ),
              ),
              const Divider(),
              Container(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Phau Nkauj 100 Qub',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: songWidget("assets/images/image1.jpeg",
                            "Phau Nkauj 100 Qub", "qub"),
                      ),
                    ],
                  ),
                  Container(width: 35),
                  Column(
                    children: [
                      const Text(
                        'Phau Nkauj Phau 50',
                        style: TextStyle( 
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      songFiftyWidget("assets/images/image2.jpeg",
                          "Phau Nkauj Phau 50", "50"),
                    ],
                  )
                ],
              ),
              Container(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Phau Nkauj 100 Tshiab',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      songNewHundredWidget("assets/images/image3.jpeg",
                          "Phau Nkauj 100 Tshiab", "tshiab"),
                    ],
                  ),
                  Container(width: 40),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget songWidget(String image, String title, String type) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HundredOldDetail(title: title, type: type),
              ));
        },
        child: Container(
          width: 150,
          height: 150,
          margin: const EdgeInsets.only(top: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              image,
              fit: BoxFit.fill,
            ),
          ),
        ));
  }


  Widget songFiftyWidget(String image, String title, String type) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FiftyDetail(title: title, type: type),
              ));
        },
        child: Container(
          width: 150,
          height: 150,
          margin: const EdgeInsets.only(top: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              image,
              fit: BoxFit.fill,
            ),
          ),
        ));
  }

  Widget songNewHundredWidget(String image, String title, String type) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HundredDetail(title: title, type: type),
              ));
        },
        child: Container(
          width: 150,
          height: 150,
          margin: const EdgeInsets.only(top: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              image,
              fit: BoxFit.fill,
            ),
          ),
        ));
  }


}


