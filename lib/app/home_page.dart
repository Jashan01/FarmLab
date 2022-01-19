
import 'package:farm_lab/custom_widgets/custom_button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isRegister = true;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body:  _buildContainer(context),
    );
  }

  Widget _buildContainer(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 50,),
              Center(
                child: Text(isRegister == true ? 'Create Account' : 'Sign in', style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),),
              ),
              SizedBox(height: 10,),
              Center(
                child: Text(
                  isRegister == true ?
                  'Create your account on FarmLab for free' :
                  'Sign In on FarmLab for free'
                  , style: TextStyle(
                  fontSize: 10,
                  color: Colors.black87,
                  fontWeight: FontWeight.normal,
                ),),
              ),
              SizedBox(height: 50,),
                isRegister == true ? TextField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(
                      color: Colors.black87,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1, color: Colors.black38),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2.0, color: Color(0xFF008B61)),
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                  ),
                ) : SizedBox(height: 0,),
              isRegister==true ? SizedBox(height: 20,) : SizedBox(height: 0,),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(
                    color: Colors.black87,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        width: 1, color: Colors.black38),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFF008B61), width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    color: Colors.black87,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        width: 1, color: Colors.black38),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFF008B61), width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20,),
              isRegister == true ?
              TextField(
                decoration: InputDecoration(
                  labelText: 'Repeat Password',
                  labelStyle: TextStyle(
                    color: Colors.black87,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        width: 1, color: Colors.black38),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFF008B61), width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                ),
                obscureText: true,
              ) : SizedBox(height: 0,),
              isRegister == true ?
              SizedBox(height: 30,) : SizedBox(height: 0,),
              isRegister == false ?
                  Text('or', style: TextStyle(
                    fontSize: 10.0,
                    color: Colors.black87,
                  ), textAlign: TextAlign.center,
                  ): SizedBox(height: 0,),

              isRegister == false ?
                  SizedBox(height: 20,) : SizedBox(height: 0,),
              isRegister == false ?
              CustomButton(
                text: 'Login using Google',
                backgroundColor: Color(0xFF008B61),
                onPressed: () {},
              ) : SizedBox(height: 0,),
              isRegister == false ? SizedBox(height: 20,) : SizedBox(height: 0,),
              CustomButton(
                text: isRegister == true ? 'Create Account' : 'Sign In',
                backgroundColor: Color(0xFF008B61),
                onPressed: () {},
              ),
              SizedBox(height: 30,),
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isRegister == true ? 'Already have an Account?' : "Dont't have an account?", style: TextStyle(
                      color: Colors.black,
                    ),
                    ),
                    FlatButton(
                      child: Text(
                        isRegister == true?
                        'Sign In' : 'Register',
                        style: TextStyle(
                          color: Color(0xFF008B61),
                        ),
                      ),
                      onPressed: _toggleForm,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }

 void _toggleForm() {
    if(isRegister == true){
      setState(() {
        isRegister = false;
      });
    }
    else{
      setState(() {
        isRegister = true;
      });
    }
  }
}
