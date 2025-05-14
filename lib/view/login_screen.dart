import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/login_controller.dart';

class LoginScreen extends StatelessWidget {
const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
        builder: (controller){
        return Scaffold(
          backgroundColor: Colors.black,
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                          ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              child: Icon(Icons.person_2,size: 40,),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Log in",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold,color: Colors.white),
                            ),
                            const SizedBox(height: 20),
                            DropdownButtonFormField<String>(
                              
                              decoration: InputDecoration(
                                labelText: "Login As",labelStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)
                                ),

                              ),
                              items: ['Admin', 'User', 'Waiter']
                                  .map((role) => DropdownMenuItem(
                                value: role,
                                child: Text(role),
                              ))
                                  .toList(),
                              onChanged: (value) {},
                            ),
                            const SizedBox(height: 15),

                            TextFormField(
                              style: TextStyle(color: Colors.white),

                              controller:controller.emailController ,
                              decoration: InputDecoration(
                                
                                labelText: "Email",
                                labelStyle: TextStyle(color: Colors.white),
                                hintText: 'Enter user name',
                                hintStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)

                                ),
                                suffixIcon: Icon(Icons.email_outlined,color: Colors.white,),
                              ),
                            ),
                            const SizedBox(height: 15),


                              TextFormField(
                                style: TextStyle(color: Colors.white),
                              controller: controller.passwordController,
                              decoration: InputDecoration(

                                labelText: "Password",
                                labelStyle: TextStyle(color: Colors.white),
                                hintText: 'Enter password',
                                hintStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)

                                ),
                                suffixIcon: Icon(Icons.lock,color: Colors.white,),
                              ),
                            ),
                            
                            const SizedBox(height: 15),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Row(
                            //       children: [
                            //         Checkbox(value: false, onChanged: (val) {},checkColor: Colors.white,),
                            //         const Text("Remember me",style: TextStyle(color: Colors.white),),
                            //       ],
                            //     ),
                            //     TextButton(
                            //       onPressed: () {

                            //       },
                            //       child: const Text("Forgot Password?",style: TextStyle(color: Colors.grey),),
                            //     ),
                            //   ],
                            // ),


                            const SizedBox(height: 15),


    //   controller.isLoading
    // ? CircularProgressIndicator(
    //     color: Colors.white,
    //   )
    // : ElevatedButton(
    //     onPressed: () {
    //       controller.loginData();
    //     },
    //     child: Text(
    //       'Login',
    //       style: TextStyle(
    //           color: Colors.black,
    //           fontWeight: FontWeight.bold,
    //           fontSize: 15),
    //     ),
    //   ),



                               Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [

                                controller.isLoading?CircularProgressIndicator(
                                  color: Colors.white,
                                ):

                                   ElevatedButton(onPressed: (){


                                  controller.loginData();
 

                                }, child: Text('Login ',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),)),

                               
                                TextButton(onPressed: (){
                                  
                                     
                                }, child: Text('Cancel',style: TextStyle(color: Colors.white),))


                              ],
                            ),

                            const SizedBox(height: 10),

                            // TextButton(
                            //   onPressed: () {},
                            //   child: const Text("+ Create new account",style: TextStyle(color: Colors.black),),
                            // ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );

        });

  }
}