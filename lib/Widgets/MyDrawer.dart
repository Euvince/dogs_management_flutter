import 'package:dogs_sqlite/Screens/AddDogPage.dart';
import 'package:dogs_sqlite/Screens/DogsListPage.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(
                    color: Colors.blue
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      child: Text("D", style: TextStyle(fontSize: 70),),
                      radius: 50,
                    ),
                    Text("Gestion des chiens", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  ],
                )
            ),
            ListTile(
              title: Text("Ajouter un chien", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
              leading: Icon(Icons.add),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddDogPage())
                );
              },
            ),
            ListTile(
              title: Text("Liste des chiens", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
              leading: Icon(Icons.catching_pokemon_rounded),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DogsListPage())
                );
              },
            ),
            ListTile(
              title: Text("Paramètres", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
              leading: Icon(Icons.settings),
              onTap: () {},
            )
          ],
        )
    );
  }
}
