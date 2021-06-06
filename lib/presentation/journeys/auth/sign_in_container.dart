import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coddr/common/constants/size_constants.dart';
import 'package:coddr/dependencies/get_it.dart';
import 'package:coddr/presentation/blocs/authentication/authentication_bloc.dart';
import 'package:coddr/presentation/blocs/login/login_bloc.dart';
import 'package:coddr/presentation/journeys/auth/validators.dart';
import 'package:coddr/presentation/journeys/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogInContainer extends StatefulWidget {
  @override
  _LogInContainerState createState() => _LogInContainerState();
}

class _LogInContainerState extends State<LogInContainer> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  // Future<void> _signIn() async {
  //   var _auth = FirebaseAuth.instance;
  //   try {
  //     UserCredential userCredential = await _auth.signInWithEmailAndPassword(
  //       email: _authData['email'],
  //       password: _authData['password'],
  //     );
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
    print("submit");
    _formKey.currentState.save();
    _onFormSubmitted(context);
    // _signIn();
  }

  // void _onEmailChanged() {
  //   _loginBloc.add(
  //     EmailChangedEvent(email: _authData['email']),
  //   );
  // }

  // void _onPasswordChanged() {
  //   _loginBloc.add(
  //     PasswordChangedEvent(password: _authData['password']),
  //   );
  // }

  void _onFormSubmitted(BuildContext context) {
    print("login event added");
    BlocProvider.of<LoginBloc>(context).add(
      LoginWithCredentialsPressedEvent(
        email: _authData['email'],
        password: _authData['password'],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return BlocConsumer<LoginBloc, LoginState>(
      bloc: BlocProvider.of<LoginBloc>(context),
      listener: (context, state) {
        if (state is LoginStateFaliure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Login Falied')));
        } else if (state is LoginStateSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(SiggnedInEvent());
          Navigator.of(context).pop();
          // Navigator.of(context).pushNamed(HomeScreen.routeName);
        }
      },
      builder: (context, state) {
        bool isLoading = false;
        if (state is LoginStateLoding)
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
                      decoration: InputDecoration(labelText: 'E-Mail'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        bool check = Validators.isValidEmail(value);
                        if (check) return null;
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
                padding: const EdgeInsets.only(
                  left: Sizes.dimen_10,
                  top: Sizes.dimen_10,
                  right: Sizes.dimen_10,
                ),
                child: Card(
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
                        // bool check = Validators.isValidPassword(value);
                        // if (check) return null;
                        // return "INVALID_PASSWORD";
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
                    Navigator.of(context).pushNamed(HomeScreen.routeName);
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
                      onPressed: isLoading ? null : () => _submit(context),
                      child: isLoading
                          ? Center(child: CircularProgressIndicator())
                          : Text('Sign In'),
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
