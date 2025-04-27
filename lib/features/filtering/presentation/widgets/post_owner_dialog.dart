import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/features/filtering/presentation/cubit/filtered_users/filtered_users_cubit.dart';

import '../../../../core/Responsive/Models/device_info.dart';
import '../../../../core/Responsive/ui_component/info_widget.dart';
import '../../../../core/theming/colors.dart' show ColorsManager;
import '../../../../core/theming/styles.dart' show formInputStyle;
import '../../../../core/userMainDetails/userMainDetails_cubit.dart';

class PostOwnerDialog extends StatefulWidget {
  final double width;
  final double height;
  final TextEditingController parentController;
  final TextEditingController dialogController;
  final BuildContext context;
  final FilteredUsersCubit filteredUsersCubit;
  final Function(String)
  onPostOwnerSelected; // Callback to return the selected ID
  const PostOwnerDialog({
    super.key,
    required this.width,
    required this.height,
    required this.parentController,
    required this.context,
    required this.filteredUsersCubit,
    required this.dialogController,
    required this.onPostOwnerSelected, // Add this callback
  });

  @override
  State<PostOwnerDialog> createState() => _PostOwnerDialogState();
}

class _PostOwnerDialogState extends State<PostOwnerDialog> {
  Timer? debounceTimer;
  String? selectedPostOwnerId; // Store the selected post owner's ID
  String? selectedPostOwnerName; // Store the selected post owner's full name

  @override
  void dispose() {
    debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.filteredUsersCubit,
      child: InfoWidget(
        builder: (BuildContext context, DeviceInfo deviceInfo) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    bottom: deviceInfo.screenHeight * 0.02,
                  ),
                  child: TextField(
                    controller: widget.dialogController,
                    decoration: formInputStyle(
                      label: 'Post Owner',
                      hintText: 'Enter a name',
                      onPressed: () {
                        widget.dialogController.clear();
                      },
                      controller: widget.dialogController,
                    ),
                    onChanged: (value) {
                      debounceTimer?.cancel();
                      debounceTimer = Timer(const Duration(seconds: 1), () {
                        widget.dialogController.text = value;
                        widget.filteredUsersCubit.loadFilteredUsers(
                          queryParameters: {'fullName': value},
                          token:
                              context.read<userMainDetailsCubit>().state.token!,
                        );
                      });
                    },
                  ),
                ),
                BlocBuilder<FilteredUsersCubit, FilteredUsersState>(
                  builder: (context, state) {
                    if (state is FilteredUsersLoaded) {
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: false,
                          padding: EdgeInsets.all(8),
                          itemCount: state.filteredUsers.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(state.filteredUsers[index].fullName),
                              onTap: () {
                                // Store the selected post owner's ID and full name
                                selectedPostOwnerId =
                                    state.filteredUsers[index].id.toString();
                                selectedPostOwnerName =
                                    state.filteredUsers[index].fullName;
                                if (mounted) {
                                  widget.dialogController.text =
                                      selectedPostOwnerName!;
                                }
                                // Update the dialog and parent text fields
                                widget.dialogController.text =
                                    selectedPostOwnerName!;
                                widget.parentController.text =
                                    selectedPostOwnerName!;

                                // Pass the selected ID back to the parent
                                widget.onPostOwnerSelected(
                                  selectedPostOwnerId!,
                                );

                                // Close the dialog and clear the dialog controller reference
                                Navigator.pop(context, selectedPostOwnerId);
                              },
                            );
                          },
                        ),
                      );
                    } else if (state is FilteredUsersLoading) {
                      return const CircularProgressIndicator(
                        color: ColorsManager.primaryColor,
                      );
                    } else if (state is FilteredUsersError) {
                      return Center(child: Text('an error occurred '));
                    } else {
                      return Center(child: Text('enter a name'));
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
