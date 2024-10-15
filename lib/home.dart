import 'package:flutter/material.dart';
import 'package:nkauj_qhuas_vajtswv/detail.dart';

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
              Text(
                'Nkauj Qhuas Vajtswv',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Phau Ntawv Nkauj 47:6 ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600)),
                    TextSpan(
                        text:
                            'Cia li hu nkauj qhuas Vajtswv, hu nkauj qhuas peb tus vajntxwv',
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
                        'Phau Nkauj Phau 45',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      songWidget("assets/images/image2.jpeg",
                          "Phau Nkauj Phau 45", "45"),
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
                      songWidget("assets/images/image3.jpeg",
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
                builder: (context) => Detail(title: title, type: type),
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
