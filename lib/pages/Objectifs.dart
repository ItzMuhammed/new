


// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:new_projet/sqldb.dart';

class Objectifs extends StatefulWidget {
  final int stageId; // Stage ID
  final bool isProfesseur; // Flag to determine if user is Professeur

  // ignore: use_key_in_widget_constructors, prefer_const_constructors_in_immutables
  Objectifs({required this.stageId, required this.isProfesseur});

  @override
  _ObjectifsState createState() => _ObjectifsState();
}

class _ObjectifsState extends State<Objectifs> {
  late Future<List<Map<String, dynamic>>> _objectifsFuture;
  late TextEditingController _objectifController;

  @override
  void initState() {
    super.initState();
    _objectifsFuture = _getObjectifs(widget.stageId);
    _objectifController = TextEditingController();
  }

  Future<List<Map<String, dynamic>>> _getObjectifs(int stageId) async {
    List<Map<String, dynamic>> objectifs = await SqlDb().getObjectifs(stageId);
    return objectifs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.withOpacity(0.5),
        title: Text('Objectifs pour Stage ${widget.stageId}'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _objectifsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          List<Map<String, dynamic>>? objectifs = snapshot.data;
          if (objectifs == null || objectifs.isEmpty) {
            return Center(child: Text('No Objectifs found.'));
          }
          return ListView.builder(
            itemCount: objectifs.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
                child: _buildObjectifItem(objectifs[index]),
              );
            },
          );
        },
      ),
      floatingActionButton: Visibility(
        visible: widget.isProfesseur,
        child: FloatingActionButton(
          onPressed: () {
            _showObjectifForm(context);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildObjectifItem(Map<String, dynamic> objectif) {
    return Card(
      color: Colors.blue[100],
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(objectif['Text_Objectif'] , style: TextStyle(fontWeight: FontWeight.bold),),
        trailing: IconButton(
          icon: Icon(Icons.delete , color: Colors.red,),
          onPressed: () {
            _deleteObjectif(objectif['id']); // Call the delete function with the objectif id
          },
        ),
      ),
    );
  }

  void _showObjectifForm(BuildContext context) {
    String objectifText = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Objectif'),
          content: TextField(
            onChanged: (value) {
              objectifText = value;
            },
            controller: _objectifController,
            decoration: InputDecoration(labelText: 'Text Objectif'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Save the Objectif text to the database
                await SqlDb().insertObjectif(widget.stageId, objectifText);

                // Close the dialog
                Navigator.of(context).pop();

                // Update the list of Objectifs
                setState(() {
                  _objectifsFuture = _getObjectifs(widget.stageId);
                });
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteObjectif(int objectId) async {
    await SqlDb().deleteObjectif(objectId);
    setState(() {
      _objectifsFuture = _getObjectifs(widget.stageId);
    });
  }
}
