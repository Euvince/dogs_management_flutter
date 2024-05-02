import 'package:dogs_sqlite/Models/Dog.dart';
import 'package:dogs_sqlite/Screens/DogsListPage.dart';
import 'package:dogs_sqlite/Widgets/MyAppBar.dart';
import 'package:dogs_sqlite/Widgets/MyFloatingActionButton.dart';
import 'package:flutter/material.dart';

class DogDetailsPage extends StatefulWidget {

  final int id;

  const DogDetailsPage({super.key, required this.id});

  @override
  State<DogDetailsPage> createState() => _DogDetailsPageState();
}

class _DogDetailsPageState extends State<DogDetailsPage> {

  final DogProvider _dogProvider = new DogProvider();

  String? _old = "";
  String? _name = "";

  Dog? _dog = new Dog();

  void _loadOneDog () async {
    _dog = await _dogProvider.getDog(widget.id);
    _old = _dog?.old;
    _name = _dog?.name;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _loadOneDog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Détails d'un chien"),
      floatingActionButton: MyFloatingActionButton(icon: Icons.add,),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
                text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(text: "Nom du chien : ", style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: _name ?? "Non défini", style: TextStyle(fontWeight: FontWeight.bold)),
                    ]
                )
            ),
            RichText(
                text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(text: "Âge du chien(ans) : ", style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: _old ?? "Non défini", style: TextStyle(fontWeight: FontWeight.bold)),
                    ]
                )
            ),
            SizedBox(height: 30,),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DogsListPage())
                );
              },
              child: Text("Page précédente", style: TextStyle(color: Colors.white),),
              style: ButtonStyle(
                  padding: MaterialStatePropertyAll(EdgeInsets.all(12)),
                  backgroundColor: MaterialStatePropertyAll(Colors.blue)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
