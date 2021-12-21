// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:final_training_aia/config/routers.dart';
import 'package:final_training_aia/constants/colors.dart';
import 'package:final_training_aia/constants/constants.dart';
import 'package:final_training_aia/helpers/helper.dart';
import 'package:final_training_aia/page/authen/sign_up/bloc/signup_bloc.dart';
import 'package:final_training_aia/session/session.dart';
import 'package:final_training_aia/widgets/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupBloc(),
      child: SignUpView(),
    );
  }
}

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  final GlobalKey<FormState> _nameKeyForm = GlobalKey();
  final GlobalKey<FormState> _emailKeyForm = GlobalKey();
  final GlobalKey<FormState> _passwordKeyForm = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignUpState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state.status == SignUpStatus.Processing) {
            Helpers.shared.showDialogProgress(context);
          } else if (state.status == SignUpStatus.Failed) {
            Helpers.shared.hideDialogProgress(context);
            Helpers.shared.showDialogConfirm(context,message: (ApplicationSesson.shared.isOnline ? (state.error ?? 'An error occured' ) : 'Check wifi connection'));
          } else if (state.status == SignUpStatus.Success) {
            // Store credential in local
            state.data?.storeCredential();
            Helpers.shared.hideDialogProgress(context);
            Navigator.pushReplacementNamed(context, Routers.onBoarding);
          }
        },
        child: Scaffold(
            // resizeToAvoidBottomInset: false,
            body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/img_bg/bg_signin.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: _nameKeyForm,
                child: TextFieldInput(
                    label: "Name",
                    controllerText: _controllerName,
                    validation: (value) {
                      if (value == null || value == "") {
                        return "Do not empty";
                      }
                    }),
              ),
              SizedBox(
                height: 30,
              ),
              Form(
                key: _emailKeyForm,
                child: TextFieldInput(
                  label: "Email",
                  controllerText: _controllerEmail,
                  validation: (value) {
                    if (value == null || value == "") {
                      return "Do not empty";
                    }
                    RegExp regex = RegExp(Constants.patternEmail);
                    if (!regex.hasMatch(value) ||
                        regex.firstMatch(value)?.group(0) != value) {
                      // handle case tâm@gmail.com.
                      return "Wrong format Email";
                    }

                    // case tam_-_@gmail.com
                    RegExp invalidSpecialKeyRegex =
                        RegExp(Constants.patternEmailInvalidSpecialKey);
                    if (invalidSpecialKeyRegex.hasMatch(value)) {
                      return "Wrong format Email";
                    }
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Form(
                key: _passwordKeyForm,
                child: TextFieldInput(
                    label: "Password",
                    controllerText: _controllerPassword,
                    passwordField: true,
                    validation: (value) {
                      if (value == null || value == "") {
                        return "Do not empty";
                      }
                      if (value.length < 6) {
                        return "Password length must >= 6";
                      }
                    }),
              ),
              SizedBox(
                height: 40,
              ),
              InkWell(
                onTap: () {
                  // Navigator.pushReplacementNamed(context, Routers.onBoarding);
                  signUp();
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.colorFFFFFF,
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                  height: 50,
                  child: Center(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          fontSize: 16,
                          color: AppColors.colorFF671B,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(
                      color: AppColors.colorFFF5F0.withOpacity(0.5),
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, Routers.signIn);
                    },
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        color: AppColors.colorFFFFFF,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )));
  }

  void signUp() {
    if (_nameKeyForm.currentState!.validate() &&
        _passwordKeyForm.currentState!.validate() &&
        _emailKeyForm.currentState!.validate()) {
      _nameKeyForm.currentState!.save();
      _passwordKeyForm.currentState!.save();
      _emailKeyForm.currentState!.save();

      final bloc = context.read<SignupBloc>();
      bloc.add(SignUp(_controllerEmail.text, _controllerPassword.text,_controllerName.text));
    }
  }
}
