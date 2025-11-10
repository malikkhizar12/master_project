import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:focus/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:focus/features/profile/domain/entities/user_profile.dart';
import 'package:focus/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:focus/features/profile/presentation/cubit/profile_state.dart';

class EditProfilePage extends StatefulWidget {
  final UserProfile? initialProfile;

  const EditProfilePage({
    super.key,
    this.initialProfile,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _universityController = TextEditingController();
  final _educationalDetailsController = TextEditingController();
  
  File? _profileImage;
  String? _profileImageUrl;
  final List<String> _selectedInterests = [];
  
  final List<String> _availableInterests = [
    'Programming',
    'Design',
    'Business',
    'Data Science',
    'Machine Learning',
    'Web Development',
    'Mobile Development',
    'UI/UX',
    'Marketing',
    'Finance',
    'Photography',
    'Writing',
    'Music',
    'Art',
    'Science',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialProfile != null) {
      _fullNameController.text = widget.initialProfile!.fullName ?? '';
      _universityController.text = widget.initialProfile!.university ?? '';
      _educationalDetailsController.text =
          widget.initialProfile!.educationalDetails ?? '';
      _selectedInterests.addAll(widget.initialProfile!.interests);
      _profileImageUrl = widget.initialProfile!.profilePictureUrl;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _universityController.dispose();
    _educationalDetailsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
        _profileImageUrl = null; // Clear URL when new image is selected
      });
    }
  }

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
        _profileImageUrl = null;
      });
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _takePicture();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authState = context.read<AuthCubit>().state;
    final user = authState.user;
    if (user == null) return;

    final profileCubit = context.read<ProfileCubit>();
    String? imageUrl = _profileImageUrl;

    // Upload new image if selected
    if (_profileImage != null) {
      final uploadedUrl = await profileCubit.uploadProfilePicture(
        user.id,
        _profileImage!.path,
      );
      if (uploadedUrl != null) {
        imageUrl = uploadedUrl;
      }
    }

    final profile = UserProfile(
      userId: user.id,
      email: user.email,
      fullName: _fullNameController.text.trim().isEmpty
          ? null
          : _fullNameController.text.trim(),
      university: _universityController.text.trim().isEmpty
          ? null
          : _universityController.text.trim(),
      educationalDetails: _educationalDetailsController.text.trim().isEmpty
          ? null
          : _educationalDetailsController.text.trim(),
      interests: _selectedInterests,
      profilePictureUrl: imageUrl,
      createdAt: widget.initialProfile?.createdAt,
    );

    await profileCubit.saveProfile(profile);

    if (mounted) {
      if (profileCubit.state.status == ProfileStatus.saved) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved successfully!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              profileCubit.state.errorMessage ?? 'Failed to save profile',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileState = context.watch<ProfileCubit>().state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: profileState.status == ProfileStatus.saving
                ? null
                : _saveProfile,
            child: profileState.status == ProfileStatus.saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : (_profileImageUrl != null
                              ? NetworkImage(_profileImageUrl!)
                              : null) as ImageProvider?,
                      child: _profileImage == null && _profileImageUrl == null
                          ? Icon(
                              Icons.person,
                              size: 60,
                              color: theme.colorScheme.primary,
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, color: Colors.white),
                          onPressed: _showImageSourceDialog,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Full Name
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Enter your full name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),

              // University
              TextFormField(
                controller: _universityController,
                decoration: const InputDecoration(
                  labelText: 'University / Institution',
                  hintText: 'Enter your university or institution',
                  prefixIcon: Icon(Icons.school),
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),

              // Educational Details
              TextFormField(
                controller: _educationalDetailsController,
                decoration: const InputDecoration(
                  labelText: 'Educational Details',
                  hintText: 'Degree, Major, Year, etc.',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 24),

              // Interests
              Text(
                'Interests',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableInterests.map((interest) {
                  final isSelected = _selectedInterests.contains(interest);
                  return FilterChip(
                    label: Text(interest),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedInterests.add(interest);
                        } else {
                          _selectedInterests.remove(interest);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

