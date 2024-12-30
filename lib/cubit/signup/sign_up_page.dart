import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_homecare/route/app_routes.dart';
import 'sign_up_cubit.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // String? role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => SignUpCubit(),
        child: BlocConsumer<SignUpCubit, SignUpState>(
          listener: (context, state) {
            if (state is SignUpSuccess) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Registration Successful'),
                    content: Text("Please check your email for verification."),
                    actions: <Widget>[
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          context.go(AppRoutes.home);
                        },
                      ),
                    ],
                  );
                },
              );
            } else if (state is SignUpFailure) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Error'),
                    content: Text(state.error),
                    actions: <Widget>[
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          context.pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF35C5CF), // Turquoise green color
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    "Create an account so you can explore all the\nexisting jobs",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                  ),
                  SizedBox(height: 10),
                  // TextField(
                  //   controller: _emailController,
                  //   keyboardType: TextInputType.emailAddress,
                  //   autofocus: false,
                  //   decoration: InputDecoration(
                  //     hintText: 'Email',
                  //     contentPadding:
                  //         EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  //     border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(32.0)),
                  //   ),
                  // ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 10),
                  // DropdownButtonFormField<String>(
                  //   decoration: InputDecoration(
                  //     hintText: 'Select User Type',
                  //     border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(10.0)),
                  //   ),
                  //   items: <String>['Manufacturer', 'Distributor', 'Healthcare']
                  //       .map<DropdownMenuItem<String>>((String value) {
                  //     return DropdownMenuItem<String>(
                  //       value: value,
                  //       child: Text(value),
                  //     );
                  //   }).toList(),
                  //   onChanged: (String? newValue) {
                  //     role = newValue!;
                  //   },
                  // ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF35C5CF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5.0,
                        side: BorderSide.none,
                        padding: EdgeInsets.all(12.0),
                      ),
                      onPressed: () {
                        context.read<SignUpCubit>().signUp(
                              _emailController.text,
                              _passwordController.text,
                              _usernameController.text,
                              // role?.toLowerCase() ?? 'manufacturer',
                            );
                      },
                      child: Text('Sign Up'),
                    ),
                  ),
                  if (state is SignUpLoading)
                    Center(child: CircularProgressIndicator()),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      context.go(AppRoutes.signIn);
                    },
                    child: Text(
                      'Already have an account',
                      style: TextStyle(color: Color(0xFF35C5CF)),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Or continue with',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Image.asset('assets/icons/ic_fb.png'),
                          iconSize: 40,
                          onPressed: () {
                            // Handle Facebook login
                          },
                        ),
                        SizedBox(width: 16),
                        IconButton(
                          icon: Image.asset('assets/icons/ic_google.png'),
                          iconSize: 40,
                          onPressed: () {
                            // Handle Google login
                          },
                        ),
                        SizedBox(width: 16),
                        IconButton(
                          icon: Image.asset('assets/icons/ic_wechat.png'),
                          iconSize: 40,
                          onPressed: () {
                            // Handle WeChat login
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
