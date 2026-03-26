import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/app_constants.dart';
import '../data/fitness_repository.dart';
import '../widgets/profile_user_avatar.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({super.key, required this.repository});

  final FitnessRepository repository;

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  late final TextEditingController _nicknameController;
  late final TextEditingController _signatureController;
  String? _pendingAvatarRelativePath;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(text: widget.repository.profileNickname);
    _signatureController = TextEditingController(text: widget.repository.profileSignature);
    _pendingAvatarRelativePath = widget.repository.profileAvatarRelativePath;
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 88);
    if (picked == null || !mounted) {
      return;
    }
    final dir = await getApplicationDocumentsDirectory();
    final avDir = Directory('${dir.path}/avatars');
    if (!avDir.existsSync()) {
      await avDir.create(recursive: true);
    }
    final name = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final dest = File('${avDir.path}/$name');
    final bytes = await File(picked.path).readAsBytes();
    await dest.writeAsBytes(bytes, flush: true);
    setState(() {
      _pendingAvatarRelativePath = 'avatars/$name';
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await widget.repository.saveUserProfile(
      nickname: _nicknameController.text,
      signature: _signatureController.text,
      avatarRelativePath: _pendingAvatarRelativePath,
    );
    if (!mounted) {
      return;
    }
    setState(() => _saving = false);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Information'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickAvatar,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      _EditorAvatarPreview(
                        repository: widget.repository,
                        pendingRelativePath: _pendingAvatarRelativePath,
                      ),
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _pickAvatar,
                  child: const Text('Choose photo'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Nickname',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _nicknameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Display name',
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Signature',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _signatureController,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'A short bio or motto',
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _saving ? null : _save,
              style: FilledButton.styleFrom(
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: _saving
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditorAvatarPreview extends StatelessWidget {
  const _EditorAvatarPreview({
    required this.repository,
    required this.pendingRelativePath,
  });

  final FitnessRepository repository;
  final String? pendingRelativePath;

  @override
  Widget build(BuildContext context) {
    if (pendingRelativePath == null || pendingRelativePath!.isEmpty) {
      return ProfileUserAvatar(repository: repository, radius: 48);
    }
    return FutureBuilder<Directory>(
      future: getApplicationDocumentsDirectory(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const CircleAvatar(radius: 48, child: CircularProgressIndicator(strokeWidth: 2));
        }
        final file = File('${snap.data!.path}/${pendingRelativePath!}');
        if (!file.existsSync()) {
          return const CircleAvatar(
            radius: 48,
            backgroundImage: AssetImage(AppConstants.defaultAvatarAsset),
          );
        }
        return CircleAvatar(
          radius: 48,
          backgroundImage: FileImage(file),
        );
      },
    );
  }
}
