import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:straybud/providers/user_provider.dart';
import 'package:straybud/resources/firestore_methods.dart';
import 'package:straybud/utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void postImage(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadPost(
        _descriptionController.text,
        _file!,
        uid,
        username,
        profImage,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        if (context.mounted) {
          showSnackBar(
            context,
            'Posted!',
          );
        }
        clearImage();
      } else {
        if (context.mounted) {
          showSnackBar(context, res);
        }
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return _file == null
        ? Center(
            //   child: IconButton(
            //     icon: const Icon(
            //       Icons.upload,
            //       color: Colors.black,
            //       size: 50,
            //     ),
            //     onPressed: () => _selectImage(context),
            //   ),
            // )
            child: Center(
            child: GestureDetector(
              onTap: () => _selectImage(context),
              child: Column(
                children: [
                  const SizedBox(
                    height: 230,
                  ),
                  Lottie.asset(
                    'lib/animations/upload1.json',
                    height: 300,
                    reverse: true,
                    repeat: true,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 10), // Adjust the height as needed
                  Text(
                    'Tap to Upload',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ))
        : Scaffold(
            appBar: AppBar(
              elevation: 1,
              backgroundColor: Colors.blue,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: clearImage,
              ),
              title: const Text(
                'Post to',
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: false,
              actions: const <Widget>[
                // TextButton(
                //   onPressed: () => postImage(
                //     userProvider.getUser.uid,
                //     userProvider.getUser.username,
                //     userProvider.getUser.photoUrl,
                //   ),
                //   child: const Text(
                //     "Post",
                //     style: TextStyle(
                //         color: Colors.pink,
                //         fontWeight: FontWeight.bold,
                //         fontSize: 16.0),
                //   ),
                // )
              ],
            ),

            // POST FORM
            body: Column(
              children: <Widget>[
                isLoading
                    ? const LinearProgressIndicator(color: Colors.white)
                    : const Padding(padding: EdgeInsets.only(top: 0.0)),
                const Divider(),
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: <Widget>[
                //     CircleAvatar(
                //       backgroundImage: NetworkImage(
                //         userProvider.getUser.photoUrl,
                //       ),
                //     ),
                //     SizedBox(
                //       width: MediaQuery.of(context).size.width * 0.6,
                //       child: TextField(
                //         controller: _descriptionController,
                //         decoration: const InputDecoration(
                //           hintText: "Write a caption...",
                //           border: InputBorder.none,
                //           hintStyle: TextStyle(color: Colors.black),
                //         ),
                //         maxLines: 8,
                //       ),
                //     ),
                //     SizedBox(
                //       height: 400.0,
                //       width: 410.0,
                //       child: AspectRatio(
                //         aspectRatio: 487 / 451,
                //         child: ClipRRect(
                //           borderRadius: BorderRadius.circular(
                //               10.0), // Adjust the radius as needed
                //           child: Container(
                //             decoration: BoxDecoration(
                //               image: DecorationImage(
                //                 fit: BoxFit.fill,
                //                 alignment: FractionalOffset.topCenter,
                //                 image: MemoryImage(_file!),
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //     )
                //   ],
                // ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              userProvider.getUser.photoUrl,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15.0,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextField(
                              controller: _descriptionController,
                              style: const TextStyle(color: Colors.black),
                              decoration: const InputDecoration(
                                hintText: "Write a caption...",
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                              maxLines: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 410.0,
                      width: 400.0,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust the radius as needed
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                alignment: FractionalOffset.topCenter,
                                image: MemoryImage(_file!),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30.0,
                ),
                ElevatedButton(
                  onPressed: () => postImage(
                    userProvider.getUser.uid,
                    userProvider.getUser.username,
                    userProvider.getUser.photoUrl,
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    "Post",
                    style: TextStyle(fontSize: 19),
                  ),
                ),

                const Divider(),
              ],
            ),
          );
  }
}
