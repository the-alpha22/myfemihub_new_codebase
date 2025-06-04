import 'dart:io';
import 'dart:math';
import 'package:bridge_ai/constants/app_constants.dart';
import 'package:bridge_ai/widgets/helpers/showLoading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProduct();
}

class _AddProduct extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _name = TextEditingController();

  TextEditingController _description = TextEditingController();

  TextEditingController _id = TextEditingController();

  TextEditingController _brand = TextEditingController();

  TextEditingController _price = TextEditingController();

  TextEditingController _category = TextEditingController();
  TextEditingController _bp = TextEditingController();
  TextEditingController _size = TextEditingController();

  String selectedCategory = "";
  String selectedsubCategory = "";

  var image;

  Future<void> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  var image2;

  Future<void> pickImage2() async {
    try {
      final image2 = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image2 == null) return;
      final image2Temporary = File(image2.path);
      setState(() => this.image2 = image2Temporary);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Random random = new Random();
  String? _myActivity;
  String? _myActivity2;
  List sizes = [];
  List<String> categories = [
    'food',
    'essential',
    "baby products",
    "hair products",
    "pregnancy wear",
    "tabs & suppliments",
    "body products"
  ];
  List<String> usercategories = [
    'Pregnant',
    'A Mother',
    "Not Yet Pregnant",
  ];

  @override
  void initState() {
    super.initState();
    _myActivity = null;
    _myActivity2 = null;
  }

  void _submit() {
    // you can write your
    // own code according to
    // whatever you want to submit;
    _name.clear();
    _description.clear();
    _id.clear();
    _brand.clear();
    _category.clear();
    _price.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Add Product",
            style: GoogleFonts.openSans(color: Colors.white, fontSize: 14)),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 600,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Text("Adding Product",
                            style: GoogleFonts.montserrat(
                                fontSize: 30, color: Colors.black)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text("All fields should be filled",
                            style: GoogleFonts.montserrat(
                              fontSize: 19,
                              color: Colors.black.withOpacity(0.7),
                              height: 1.5,
                            )),
                      ),
                      Center(
                        child: Row(
                          children: [
                            image != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.file(
                                      image,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Center(
                                    child: GestureDetector(
                                        onTap: () => pickImage(),
                                        child: Container(
                                          height: 120,
                                          width: 120,
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 240, 240, 240),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child:
                                              Center(child: Text("Add Image")),
                                        ))),
                            SizedBox(
                              width: 10,
                            ),
                            image2 != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.file(
                                      image2,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Center(
                                    child: GestureDetector(
                                        onTap: () => pickImage2(),
                                        child: Container(
                                          height: 120,
                                          width: 120,
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 240, 240, 240),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Center(
                                              child: Text("Add another image")),
                                        ))),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      // Add TextFormFields and ElevatedButton here.
                      Container(
                        color: Color.fromARGB(255, 240, 240, 240),
                        child: TextFormField(
                          controller: _name,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              labelText: 'Name*',
                              labelStyle: GoogleFonts.montserrat(
                                  color: Colors.black.withOpacity(0.6),
                                  fontSize: 12),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter name';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        color: Color.fromARGB(255, 240, 240, 240),
                        child: SingleChildScrollView(
                          child: TextFormField(
                            controller: _description,
                            keyboardType: TextInputType.text,
                            maxLines: null,
                            decoration: InputDecoration(
                                labelText: 'Description*',
                                labelStyle: GoogleFonts.montserrat(
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: 12),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              } else if (value.length < 20) {
                                return 'Please enter description';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      FormField(
                        builder: (FormFieldState state) {
                          return InputDecorator(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 15.0),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.3)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: primaryColor.withOpacity(0.4)),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: SingleChildScrollView(
                                child: DropdownButton<String>(
                                    value: _myActivity,
                                    isDense: true,
                                    onChanged: (value) {
                                      setState(() {
                                        _myActivity = value;
                                      });
                                    },
                                    items: [
                                      DropdownMenuItem(
                                        value:
                                            null, // Set the value to null for the hint
                                        child: Text(
                                          'Product Category',
                                          style: GoogleFonts.montserrat(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              fontSize: 14),
                                        ),
                                      ),
                                      ...categories.map((value) {
                                        return DropdownMenuItem(
                                          onTap: () {
                                            setState(() {
                                              _myActivity = value;
                                            });
                                          },
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ]),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FormField(
                        builder: (FormFieldState state) {
                          return InputDecorator(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 15.0),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.3)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: primaryColor.withOpacity(0.4)),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: SingleChildScrollView(
                                child: DropdownButton<String>(
                                    value: _myActivity2,
                                    isDense: true,
                                    onChanged: (value) {
                                      setState(() {
                                        _myActivity2 = value;
                                      });
                                    },
                                    items: [
                                      DropdownMenuItem(
                                        value:
                                            null, // Set the value to null for the hint
                                        child: Text(
                                          'User Category',
                                          style: GoogleFonts.montserrat(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              fontSize: 14),
                                        ),
                                      ),
                                      ...usercategories.map((value) {
                                        return DropdownMenuItem(
                                          onTap: () {
                                            setState(() {
                                              _myActivity2 = value;
                                            });
                                          },
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ]),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            color: Color.fromARGB(255, 240, 240, 240),
                            child: TextFormField(
                              onFieldSubmitted: (value) {
                                sizes.addIf(
                                    !sizes.contains(
                                        _size.text.toUpperCase().trim()),
                                    _size.text.toUpperCase().trim());
                                setState(() {
                                  sizes.addIf(
                                      !sizes.contains(
                                          _size.text.toUpperCase().trim()),
                                      _size.text.toUpperCase().trim());
                                });

                                _size.clear();
                              },
                              controller: _size,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  labelText: 'Available sizes if any*',
                                  labelStyle: GoogleFonts.montserrat(
                                      color: Colors.black.withOpacity(0.6),
                                      fontSize: 12),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none)),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                sizes.addIf(
                                    !sizes.contains(
                                        _size.text.toUpperCase().trim()),
                                    _size.text.toUpperCase().trim());
                                setState(() {
                                  sizes.addIf(
                                      !sizes.contains(
                                          _size.text.toUpperCase().trim()),
                                      _size.text.toUpperCase().trim());
                                });

                                _size.clear();
                              },
                              icon: Icon(Icons.add)),
                          IconButton(
                              onPressed: () {
                                sizes = [];
                                setState(() {
                                  sizes = [];
                                });
                              },
                              icon: Icon(Icons.close))
                        ],
                      ),
                      Text("$sizes"),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        color: Color.fromARGB(255, 240, 240, 240),
                        child: TextFormField(
                          controller: _brand,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              labelText: 'Brand*',
                              labelStyle: GoogleFonts.montserrat(
                                  color: Colors.black.withOpacity(0.6),
                                  fontSize: 12),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      Container(
                        color: Color.fromARGB(255, 240, 240, 240),
                        child: TextFormField(
                          controller: _bp,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: 'Price*',
                              labelStyle: GoogleFonts.montserrat(
                                  color: Colors.black.withOpacity(0.6),
                                  fontSize: 12),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter price';
                            } else if (value.length < 3) {
                              return 'Please enter valid amount';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                          onTap: () async {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState!.validate()) {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              showLoading(context);
                              print(_myActivity);
                              if (_myActivity != null) {
                                final name = _name.text.trim();
                                final description = _description.text;
                                final category = _myActivity;
                                final brand = _brand.text;
                                final search = name.trim().replaceAll(' ', '');

                                final bp = int.parse(_bp.text.toString());
                                int roundToNearestHundred(int number) {
                                  int remainder = number % 100;
                                  int roundedNumber = number - remainder;

                                  if (remainder >= 50) {
                                    roundedNumber += 100;
                                  }

                                  return roundedNumber;
                                }

                                List<String> splitList = search.split(' ');
                                List<String> indexList = [];

                                for (int i = 0; i < splitList.length; i++) {
                                  for (int j = 0;
                                      j < splitList[i].length + i;
                                      j++) {
                                    indexList.add(splitList[i]
                                        .substring(0, j)
                                        .toLowerCase());
                                  }
                                }
                                final imageName =
                                    '$name${random.nextInt(1000)}.png';
                                final firebaseStorageRef = FirebaseStorage
                                    .instance
                                    .ref()
                                    .child('$name/$imageName');
                                final uploadTask =
                                    firebaseStorageRef.putFile(image);
                                final _fileURL = await (await uploadTask)
                                    .ref
                                    .getDownloadURL();
                                final fileUrl = _fileURL.toString();
                                final image2Name =
                                    '$name${random.nextInt(1000)}2.png';
                                final firebaseStorageRef2 = FirebaseStorage
                                    .instance
                                    .ref()
                                    .child('$name/$image2Name');
                                final uploadTask2 =
                                    firebaseStorageRef2.putFile(image2);
                                final _fileURL2 = await (await uploadTask2)
                                    .ref
                                    .getDownloadURL();
                                final fileUrl2 = _fileURL2.toString();
                                final idNumb =
                                    random.nextInt(1000000).toString();
                                final idnumb = "idxx$idNumb";

                                Map<String, dynamic> data = {
                                  "name": name,
                                  "image": fileUrl,
                                  "image2": fileUrl2,
                                  "description": description,
                                  "category": category,
                                  "usercategory": _myActivity2,
                                  "price": bp,
                                  "bp": bp,
                                  "brand": brand,
                                  "searchIndex": indexList,
                                  "id": idnumb,
                                  "sizes": sizes,
                                  "country": "uganda",
                                  "purchases": 0,
                                  "rating": 0
                                };
                                FirebaseFirestore.instance
                                    .collection("products")
                                    .add(data);
                                _submit();
                                dismissLoadingWidget();
                                Get.snackbar(
                                    "Successfully Submitted", "Product added");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Successfully Submitted')),
                                );
                                Get.back();
                              } else {
                                dismissLoadingWidget();
                                Get.snackbar("Missing detail",
                                    "Category or subcategory not selected");
                              }
                            } else {
                              Get.snackbar("Try Again", "Product Not Added");
                              dismissLoadingWidget();
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Text(
                                "Submit",
                                style: GoogleFonts.montserrat(
                                    color: Colors.white, fontSize: 12),
                              ),
                            )),
                          )),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
