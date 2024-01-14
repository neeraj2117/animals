import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:straybud/resources/auth_methods.dart';
import 'package:straybud/responsive/mobile_screen_layout.dart';
import 'package:straybud/responsive/responsive_layout.dart';
import 'package:straybud/responsive/web_screen_layout.dart';
import 'package:straybud/screens/login_screen.dart';
import 'package:straybud/utils/colors.dart';
import 'package:straybud/utils/my_textfield.dart';
import 'package:straybud/utils/utils.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // signup user using our authmethodds
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!);
    // if string returned is sucess, user has been created
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            ),
          ),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      if (context.mounted) {
        showSnackBar(context, res);
      }
    }
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: Container(),
              ),
              Text(
                'StrayBud',
                style: GoogleFonts.barlow(
                    color: Colors.black,
                    fontSize: 60,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 40,
              ),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                          backgroundColor: Colors.red,
                        )
                      : const CircleAvatar(
                          radius: 75,
                          backgroundImage: NetworkImage(
                              'https://i.stack.imgur.com/l60Hf.png'),
                          backgroundColor: Colors.red,
                        ),
                  Positioned(
                    bottom: -10,
                    left: 110,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: Icon(
                        Icons.add_a_photo,
                        color: Colors.grey[700],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 60,
              ),
              // TextFieldInput(
              //   hintText: 'Enter your username',
              //   textInputType: TextInputType.text,
              //   textEditingController: _usernameController,
              // ),
              MyTextField(
                  controller: _usernameController,
                  hintText: 'Enter your username',
                  obscureText: false,
                  textInputType: TextInputType.text,
                  isPass: false),
              const SizedBox(
                height: 14,
              ),
              MyTextField(
                  controller: _emailController,
                  hintText: 'Enter your email',
                  obscureText: false,
                  textInputType: TextInputType.emailAddress,
                  isPass: false),
              // TextFieldInput(
              //   hintText: 'Enter your email',
              //   textInputType: TextInputType.emailAddress,
              //   textEditingController: _emailController,
              // ),
              const SizedBox(
                height: 14,
              ),
              MyTextField(
                  controller: _passwordController,
                  hintText: 'Enter your password',
                  obscureText: false,
                  textInputType: TextInputType.text,
                  isPass: false),
              // TextFieldInput(
              //   hintText: 'Enter your password',
              //   textInputType: TextInputType.text,
              //   textEditingController: _passwordController,
              //   isPass: true,
              // ),
              const SizedBox(
                height: 14,
              ),
              // TextFieldInput(
              //   hintText: 'Enter your bio',
              //   textInputType: TextInputType.text,
              //   textEditingController: _bioController,
              // ),
              MyTextField(
                  controller: _bioController,
                  hintText: 'Enter your bio',
                  obscureText: false,
                  textInputType: TextInputType.text,
                  isPass: false),
              const SizedBox(
                height: 40,
              ),
              InkWell(
                onTap: signUpUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    color: blueColor,
                  ),
                  child: !_isLoading
                      ? const Text(
                          'Sign Up',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        )
                      : const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
                            
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: const Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        ' Login.',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



