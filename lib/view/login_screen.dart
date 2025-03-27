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
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
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
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: "Login As",labelStyle: TextStyle(color: Colors.black),
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
                              controller:controller.emailController ,
                              decoration: InputDecoration(

                                labelText: "Email",
                                labelStyle: TextStyle(color: Colors.black),
                                hintText: 'Enter user name',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)

                                ),
                                suffixIcon: Icon(Icons.email_outlined,color: Colors.black,),
                              ),
                            ),
                            const SizedBox(height: 15),


                              TextFormField(
                              controller: controller.passwordController,
                              decoration: InputDecoration(

                                labelText: "Password",
                                labelStyle: TextStyle(color: Colors.black),
                                hintText: 'Enter password',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)

                                ),
                                suffixIcon: Icon(Icons.lock,color: Colors.black,),
                              ),
                            ),
                            
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(value: false, onChanged: (val) {}),
                                    const Text("Remember me"),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {

                                  },
                                  child: const Text("Forgot Password?"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),

                               Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                   TextButton(onPressed: (){
                                  controller.loginData();
 

                                }, child: Text('Login ',style: TextStyle(color: Colors.blue),)),

                               
                                TextButton(onPressed: (){
                                  
                                     
                                }, child: Text('Cancel',style: TextStyle(color: Colors.black),))


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