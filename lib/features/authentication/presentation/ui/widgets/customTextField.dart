import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/Responsive/ui_component/info_widget.dart';
import '../../../../../core/theming/colors.dart';
import '../../logic/password_visiblity_bloc.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final bool isPassword;
  final String? Function(String?)? formValidator;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.formValidator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late GlobalKey<FormState> _formKey;
  String? _errorMessage;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void _validate() {
      widget.formValidator?.call(widget.controller.text);
      setState(() {
        _errorMessage = widget.formValidator?.call(widget.controller.text);
      });
    }

    return BlocProvider(
      create: (_) => PasswordVisibilityCubit(),
      child: InfoWidget(
        builder: (context, info) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: BlocBuilder<PasswordVisibilityCubit, bool>(
                  builder: (context, isHidden) {
                    return Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 4),
                            color: Colors.black45,
                            spreadRadius: info.screenWidth * 0.001,
                            blurRadius: info.screenWidth * 0.03,
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: widget.controller,
                        validator: widget.formValidator,
                        onChanged: (value) {
                          if (widget.formValidator != null) {
                            _validate();
                          }
                        },
                        obscureText: widget.isPassword ? isHidden : false,
                        decoration: InputDecoration(
                          label: Text(
                            widget.label,
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: info.screenWidth * 0.035,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          hintText: widget.hintText,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(
                              info.screenWidth * 0.04,
                            ),
                          ),
                          enabledBorder:
                              _errorMessage == null
                                  ? OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(
                                      info.screenWidth * 0.04,
                                    ),
                                  )
                                  : OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: info.screenWidth * 0.003,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      info.screenWidth * 0.04,
                                    ),
                                  ),
                          focusedBorder:
                              _errorMessage == null
                                  ? OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: ColorsManager.primaryColor,
                                      width: info.screenWidth * 0.003,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      info.screenWidth * 0.04,
                                    ),
                                  )
                                  : OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: info.screenWidth * 0.003,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      info.screenWidth * 0.04,
                                    ),
                                  ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          suffixIcon:
                              widget.isPassword
                                  ? IconButton(
                                    icon: Icon(
                                      isHidden
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed:
                                        () =>
                                            context
                                                .read<PasswordVisibilityCubit>()
                                                .toggleVisibility(),
                                  )
                                  : null,
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                    );
                  },
                ),
              ),
              if (_errorMessage != null)
                Container(
                  margin: EdgeInsetsDirectional.only(
                    top: info.screenHeight * 0.006,
                    start: info.screenWidth * 0.03,
                  ),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: info.screenWidth * 0.034,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
