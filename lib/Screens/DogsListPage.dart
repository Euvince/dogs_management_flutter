import 'package:dogs_sqlite/Models/Dog.dart';
import 'package:dogs_sqlite/Screens/DogDetailsPage.dart';
import 'package:dogs_sqlite/Screens/UpdateDogPage.dart';
import 'package:dogs_sqlite/Widgets/MyAppBar.dart';
import 'package:dogs_sqlite/Widgets/MyFloatingActionButton.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DogsListPage extends StatefulWidget {
  const DogsListPage({super.key});

  @override
  State<DogsListPage> createState() => _DogsListPage();
}

class _DogsListPage extends State<DogsListPage> {

  final List<Map<String, dynamic>> _dogs_example = [
    { 'id' : '1', 'name' : 'Bobby le méchant', 'old' : '2' },
    { 'id' : '2', 'name' : 'Doggy le violent', 'old' : '4' },
    { 'id' : '3', 'name' : 'Toupas le gamin', 'old' : '1' },
  ];

  DogProvider _dogProvider = new DogProvider();

  bool _loading = false;
  List<Dog> _dogs = [];

  void _loadDogs () async {
    _dogs = await _dogProvider.getDogs();
    setState(() {});
  }

  _displayCard (BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Suppression d'un chien", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppins"),),
          content: Text("Êtes-vous sûr de vouloir supprimer ce chien ?", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppins"),),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Annuler", style: TextStyle(color: Colors.blue),)
            ),
            TextButton(
                onPressed: () async {

                },
                child: Text("Supprimer", style: TextStyle(color: Colors.red),)
            )
          ],
        );
      }
    );
  }

  @override
  void initState() {
    super.initState();

    _loadDogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Liste des chiens"),
      floatingActionButton: MyFloatingActionButton(icon: Icons.add,),
      body: _dogs.length > 0 ?
        _loading
        ? Center(
            child: CircularProgressIndicator(
            color: Colors.red,
            strokeWidth: 6,
          ),
        )
        : ListView.builder(
            itemCount: _dogs.length,
            itemBuilder: (context, int index) {
              final _dog = _dogs[index];
              final int? _id = _dog.id;
              final String _old = _dog.old;
              final String _name = _dog.name;

              return Container(
                margin: EdgeInsets.all(2),
                child: Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.catching_pokemon_rounded),
                          title: Text("$_id- $_name"),
                          subtitle: Text("$_old ans"),
                          iconColor: Colors.blue,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => DogDetailsPage(id: _id!,))
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => DogDetailsPage(id: _id!,))
                                  );
                                },
                                child: Text("Détails", style: TextStyle(color: Colors.green),)
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => UpdateDogPage(dog: _dog,))
                                  );
                                },
                                child: Text("Modifier", style: TextStyle(color: Colors.blue),)
                            ),
                            TextButton(
                                onPressed: () async {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Suppression d'un chien", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppins"),),
                                          content: Text("Êtes-vous sûr de vouloir supprimer ce chien ?", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppins"),),
                                          actions: [
                                            TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: Text("Annuler", style: TextStyle(color: Colors.blue),)
                                            ),
                                            TextButton(
                                                onPressed: () async {
                                                  await _dogProvider.deleteDog(_id!);
                                                  setState(() {
                                                    _loading = true;
                                                  });
                                                  Future.delayed(const Duration(seconds : 3), () {
                                                    setState(() {
                                                      _loading = false;
                                                      Fluttertoast.showToast(
                                                        msg: "Chien supprimé avec succès.",
                                                        gravity: ToastGravity.BOTTOM,
                                                        toastLength: Toast.LENGTH_LONG,
                                                        backgroundColor: Colors.blue,
                                                        textColor: Colors.white,
                                                      );
                                                    });
                                                  });
                                                  _loadDogs();
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Supprimer", style: TextStyle(color: Colors.red),)
                                            )
                                          ],
                                        );
                                      }
                                  );
                                },
                                child: Text("Supprimer", style: TextStyle(color: Colors.red),)
                            ),
                            SizedBox(width: 8.0,),
                          ],
                        )
                      ],
                    )
                ),
              );
            }
        )
        : Center(
          child: Text(
            "Aucun chien en base de données",
            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppins"),
          ),
        ),
    );
  }
}
