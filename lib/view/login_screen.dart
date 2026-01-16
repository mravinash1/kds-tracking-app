import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          child: Icon(Icons.person_2, size: 40),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Log in",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),

                        /// Login As Dropdown
                        DropdownButtonFormField<String>(
                          value: controller.loginRole,
                          dropdownColor: Colors.black,
                          decoration: InputDecoration(
                            labelText: "Login As",
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          items: ['Admin', 'User']
                              .map(
                                (role) => DropdownMenuItem(
                                  value: role,
                                  child: Text(role,
                                      style: TextStyle(color: Colors.white)),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) controller.setLoginRole(value);
                          },
                        ),
                        const SizedBox(height: 15),

                        /// Email or Narration Field
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: controller.emailController,
                          decoration: InputDecoration(
                            labelText: controller.loginRole == 'Admin'
                                ? "Email"
                                : "Narration",
                            labelStyle: TextStyle(color: Colors.white),
                            hintText: controller.loginRole == 'Admin'
                                ? 'Enter email'
                                : 'Enter narration (e.g. 87_ARJUN)',
                            hintStyle: TextStyle(color: Colors.white70),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            suffixIcon:
                                Icon(Icons.email_outlined, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 15),

                        /// Password Field
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: controller.passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(color: Colors.white),
                            hintText: 'Enter password',
                            hintStyle: TextStyle(color: Colors.white70),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            suffixIcon: Icon(Icons.lock, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 20),

                        /// Buttons: Login & Cancel
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            controller.isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : ElevatedButton(
                                    onPressed: () {
                                      controller.loginData();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 12),
                                    ),
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                            TextButton(
                              onPressed: () {
                                controller.emailController.clear();
                                controller.passwordController.clear();
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
