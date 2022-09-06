import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ocr/menubutton.dart';
import 'package:share_plus/share_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  XFile? imagefile;
  String scannedText = "";
  bool isScanneing = false;
  bool _switchValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
            child: Container(
          child: Column(
            children: [
              if(isScanneing)
             const CircularProgressIndicator(),
              if(!isScanneing && imagefile ==null)
              Container(
                height: 400,
                width: 300,
                color: Colors.grey[300],
              ),
              if(imagefile !=null)
               Container(
                height: 400,
                width: 300,
                color: Colors.grey[300],
                child: Image.file(File(imagefile!.path)),
              ),
              
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MenuButton(
                        name: "Galley",
                        buttonAction: (){
                          getGallery();
                        },
                        icon: Icons.image),
                    MenuButton(
                        name: "Camera",
                        buttonAction: (){
                          getCamera();
                        },
                        icon: Icons.camera),
                      
                      Container(
                        child: IconButton(onPressed: (){
                          _onShareWithResult(context);
                        },icon: Icon(Icons.share)),
                      ),
                        Container(
                        child:  CupertinoSwitch(
              value: _switchValue,
              onChanged: (value) {
                setState(() {
                  _switchValue = value;
                  print(_switchValue);
                });
              },
            ),
                      ),
                    
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: 
                Text(scannedText, style: TextStyle(fontSize: 15
                ),),
              )
            ],
          ),
        )),
      ),
    );
  }

  void getGallery() async  {
    try {
      final picker = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picker != null) {
        isScanneing = true;
        imagefile = picker;
        setState(() {});
        getRecognizeText(picker);
      }
    } catch (e) {
      isScanneing = false;
      imagefile = null;
      setState(() {});
      scannedText = "bir hata meydana geldi";
    }
  }

  void getCamera() async {
    try {
      final picker = await ImagePicker().pickImage(source: ImageSource.camera);
      if (picker != null) {
        isScanneing = true;
        imagefile = picker;
        setState(() {});
         getRecognizeText(picker);
      }
    } catch (e) {
      isScanneing = false;
      imagefile = null;
      setState(() {});
      scannedText = "bir hata meydana geldi";
    }
  }

  void _onShareWithResult(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    ShareResult result;
    if (_switchValue) {
      result = await Share.shareFilesWithResult([imagefile!.path],
          text: scannedText,
          subject: scannedText.substring(0,15),
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    } else {
      result = await Share.shareWithResult(scannedText,
          subject: scannedText.substring(0,15),
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Share result: ${result.status}"),
    ));
  }

  void getRecognizeText(XFile image) async{
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
final RecognizedText recognizedText = await textRecognizer.processImage(InputImage.fromFilePath(image.path));
await textRecognizer.close();
scannedText = "";
for (TextBlock block in recognizedText.blocks) {
  for (TextLine line in block.lines) {
      scannedText =  scannedText+ line.text+"\n" ;
}
isScanneing = false;
setState(() {
  
});


  }

  }
}
