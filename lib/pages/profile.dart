// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:new_projet/pages/EditProfileDialog.dart';



class ProfilePage extends StatefulWidget {
final Map<String, dynamic> userData;

  // ignore: use_super_parameters
  const ProfilePage({Key? key, required this.userData}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue.withOpacity(0.5),
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon(Icons.person, size: 180, color: Colors.white,),
               Image.asset('lib/images/profileUser.png' , height: 180, width:300),
              SizedBox(height: 50,),
          
              // Image.asset('lib/images/login.png' , height: 180, width:300),
              
              UserInfoTile(label: 'Nom', value: widget.userData['nom_utilisateur']),
              UserInfoTile(label: 'Prénom', value: widget.userData['prenom_utilisateur']),
              UserInfoTile(label: 'Email', value: widget.userData['email']),
              UserInfoTile(label: 'Rôle', value: widget.userData['Role']),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        showDialog(
          context: context,
          builder: (context) => EditProfileDialog(userData: widget.userData),
        );
      },
        backgroundColor: Colors.blue.withOpacity(0.5), // Couleur du bouton flottant
        child: Icon(Icons.edit , color: Colors.white,), // Icône du bouton flottant
      ),
    );
  }
}

class UserInfoTile extends StatelessWidget {
  final String label;
  final String value;

  // ignore: use_key_in_widget_constructors
  const UserInfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
