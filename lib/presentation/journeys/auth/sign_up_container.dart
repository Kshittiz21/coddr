import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coddr/common/constants/size_constants.dart';
import 'package:coddr/presentation/blocs/authentication/authentication_bloc.dart';
import 'package:coddr/presentation/blocs/signup/signup_bloc.dart';
import 'package:coddr/presentation/journeys/auth/validators.dart';
import 'package:coddr/presentation/journeys/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpContainer extends StatefulWidget {
  @override
  _SignUpContainerState createState() => _SignUpContainerState();
}

class _SignUpContainerState extends State<SignUpContainer> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, String> _authData = {
    'username': '',
    'email': '',
    'password': '',
  };

  // Future<void> _signUp() async {
  //   var _auth = FirebaseAuth.instance;
  //   try {
  //     UserCredential userCredential =
  //         await _auth.createUserWithEmailAndPassword(
  //       email: _authData['email'],
  //       password: _authData['password'],
  //     );

  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userCredential.user.uid)
  //         .set({
  //       'username': _authData['username'],
  //       'email': _authData['email'],
  //     });
  //     Navigator.of(context).pushNamed(HomeScreen.routeName);
  //   } catch (err) {
  //     var message = 'An error occured, please check your credentials!';

  //     if (err.message != null) {
  //       message = err.message;
  //     }

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(message),
  //         backgroundColor: Theme.of(context).errorColor,
  //       ),
  //     );
  //   }
  // }

  void _submit(BuildContext context) {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    _onFormSubmitted(context);
  }

  void _onFormSubmitted(BuildContext context) {
    print("SignUp event added");
    BlocProvider.of<SignUpBloc>(context).add(
      SignUpWithCredentialsPressedEvent(
        email: _authData['email'],
        password: _authData['password'],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return BlocConsumer<SignUpBloc, SignUpState>(
      bloc: BlocProvider.of<SignUpBloc>(context),
      listener: (context, state) {
        if (state is SignUpStateFaliure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('SignUp Falied')));
        } else if (state is SignUpStateSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(SiggnedInEvent());
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        bool isLoading = false;
        if (state is SignUpStateLoding)
          isLoading = true;
        else
          isLoading = false;
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.dimen_10),
                child: Card(
                  //color: Colors.green.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Sizes.dimen_10),
                  ),
                  elevation: Sizes.dimen_8,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: Sizes.dimen_10),
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'username'),
                      validator: (value) {
                        if (value.length < 3) {
                          return 'Name should be at least of 3 characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['username'] = value;
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                // padding: const EdgeInsets.symmetric(horizontal: Sizes.dimen_10),
                padding: const EdgeInsets.only(
                  left: Sizes.dimen_10,
                  top: Sizes.dimen_10,
                  right: Sizes.dimen_10,
                ),
                child: Card(
                  //color: Colors.green.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Sizes.dimen_10),
                  ),
                  elevation: Sizes.dimen_8,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: Sizes.dimen_10),
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'E-Mail'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        bool check = Validators.isValidEmail(value);
                        if (check)
                          return null;
                        else
                          return "INVALID_EMAIL";
                      },
                      onSaved: (value) {
                        _authData['email'] = value;
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                //padding: const EdgeInsets.symmetric(horizontal: Sizes.dimen_10),
                padding: const EdgeInsets.only(
                  left: Sizes.dimen_10,
                  top: Sizes.dimen_10,
                  right: Sizes.dimen_10,
                ),
                child: Card(
                  //color: Colors.green.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Sizes.dimen_10),
                  ),
                  elevation: Sizes.dimen_8,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: Sizes.dimen_10),
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      // controller: _passwordController,
                      validator: (value) {
                        if (value.isEmpty || value.length <= 5) {
                          return 'Password is too short';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['password'] = value;
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: Sizes.dimen_8),
                child: TextButton(
                  onPressed: () {
                    //Navigator.of(context).pushNamed(HomeScreen.routeName);
                  },
                  child: Text('Forgot Your Password?'),
                ),
              ),
              Center(
                child: Container(
                  width: deviceSize.width * 0.7,
                  height: deviceSize.height * 0.07,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Sizes.dimen_10),
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              _submit(context);
                            },
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Text('Sign Up'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.orange.shade400),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
