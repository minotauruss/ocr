import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
   String name ;
  VoidCallback buttonAction;
  IconData icon;
  MenuButton({
    Key? key,
    required this.name,
    required this.buttonAction,
    required this.icon,
  }) : super(key: key);

 

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.only(top: 10 ),
      child: ElevatedButton(
        onPressed:() {
          buttonAction();
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          onPrimary: Colors.grey,
          shadowColor: Colors.grey[400],
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0)
          )

        ),
        child: Container(
          
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // ignore: prefer_const_literals_to_create_immutables
            children:  [
              Icon(icon),
              Text(name)
            ],
          ),
        )),
    );
  }
}
