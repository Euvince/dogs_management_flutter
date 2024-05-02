import 'package:flutter/material.dart';
import 'package:dogs_sqlite/Models/Dog.dart';
import 'package:dogs_sqlite/Widgets/MyAppBar.dart';
import 'package:dogs_sqlite/Widgets/MyDrawer.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddDogPage extends StatefulWidget {
  const AddDogPage({super.key});

  @override
  State<AddDogPage> createState() => _AddDogPageState();
}

class _AddDogPageState extends State<AddDogPage> {

  final _formKey = new GlobalKey<FormState>();

  final _nameController = new TextEditingController();
  final _oldController = new TextEditingController();

  final DogProvider _dogProvider = new DogProvider();

  bool _loading = false;

  @override
  void dispose() {
    super.dispose();

    _nameController.dispose();
    _oldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Ajouter un chien"),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Informations sur le chien",
                    style: TextStyle(color: Colors.blue, fontFamily: "Poppins", fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Image.asset("assets/images/ori_logo.png"),
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(
                          label: Text("Nom du chien*", style: TextStyle(color: Colors.blue),),
                          hintText: "Nom du chien*",
                          icon: Icon(Icons.catching_pokemon_rounded, color: Colors.black,),
                          //border: OutlineInputBorder()
                        ),
                        controller: _nameController,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Ce champ est requis";
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(12),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(
                          label: Text("Âge du chien(ans)*", style: TextStyle(color: Colors.blue),),
                          hintText: "Âge du chien(ans)*",
                          icon: Icon(Icons.catching_pokemon_rounded, color: Colors.black,),
                          //border: OutlineInputBorder()
                        ),
                        controller: _oldController,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Ce champ est requis";
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                FocusScope.of(context).requestFocus(FocusNode());
                                Dog dog = new Dog();
                                dog.old = _oldController.text;
                                dog.name = _nameController.text;
                                await _dogProvider.insertDog(dog);
                                setState(() {
                                  _loading = true;
                                });
                                Future.delayed(const Duration(seconds : 3), () {
                                  setState(() {
                                    _loading = false;
                                    Fluttertoast.showToast(
                                      msg: "Chien enrégistré avec succès.",
                                      gravity: ToastGravity.BOTTOM,
                                      toastLength: Toast.LENGTH_LONG,
                                      backgroundColor: Colors.blue,
                                      textColor: Colors.white,
                                    );
                                  });
                                });
                                _oldController.text = "";
                                _nameController.text = "";
                              }
                              print("Chien enrégistré avec succès.");
                            },
                            child: Text("Enrégistrer", style: TextStyle(color: Colors.white),),
                            style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(Colors.blue),
                            ),
                          ),
                          SizedBox(width: 8.0,),
                          _loading ? CircularProgressIndicator(
                            color: Colors.blue,
                            strokeWidth: 6,
                          ) : SizedBox()
                        ],
                      ),
                    ),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}
