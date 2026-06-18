import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xlapparals_app/core/constants/app_constants.dart';
import 'package:xlapparals_app/core/routes/route_name.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
import 'package:xlapparals_app/core/utils/validators.dart';

import 'package:xlapparals_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:xlapparals_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:xlapparals_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:xlapparals_app/shared/widgets/app_button.dart';
import 'package:xlapparals_app/shared/widgets/app_textformfield.dart';
import 'package:xlapparals_app/shared/widgets/app_toast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginRequested(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listenWhen: (previous, current) {
          return previous.runtimeType != current.runtimeType;
        },
        listener: (context, state) {
          if (state is AuthSuccess) {
            AppToast.show(
              context,
              message: "Login Successful",
              type: ToastType.success,
            );
            if (state.authUser.role == "AGENT") {
              context.go(RouteNames.agentHome);
            }
          }

          if (state is AuthError) {
            AppToast.show(
              context,
              message: state.message,
              type: ToastType.error,
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(40),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 40,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadius,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 25,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadius,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadius,
                            ),
                            child: Image.asset(
                              'assets/icon/icon.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        Text(
                          "XL Apparels",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppConstants.fontFamily,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "ORDER MANAGEMENT",
                          style: TextStyle(fontSize: 12),
                        ),

                        const SizedBox(height: 30),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Email address",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontFamily: AppConstants.fontFamily,
                            ),
                          ),
                        ),

                        AppTextFormField(
                          controller: emailController,
                          hintText: "",
                          keyboardType: TextInputType.emailAddress,
                          validator: Validators.email,
                        ),

                        const SizedBox(height: 20),

                        // Password
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Password",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontFamily: AppConstants.fontFamily,
                            ),
                          ),
                        ),

                        AppTextFormField(
                          hintText: "",
                          controller: passwordController,
                          obscureText: state.obscurePassword,
                          keyboardType: TextInputType.name,
                          validator: Validators.password,
                          suffixIcon: IconButton(
                            icon: Icon(
                              state.obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () {
                              context.read<AuthBloc>().add(
                                TogglePasswordVisibility(),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 5),
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {},
                            child: const Text(
                              "Forgot password?",
                              style: TextStyle(
                                color: AppColors.orange,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        AppButton(
                          onPressed: _login,
                          text: "Sign in",
                          icon: Icons.login,
                          isLoading: state is AuthLoading,
                        ),
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
  }
}
