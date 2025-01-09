import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final directoryProvider = StateNotifierProvider<DirectoryProvider, String>(
    (ref) => DirectoryProvider());

class DirectoryProvider extends StateNotifier<String> {
  DirectoryProvider() : super('');

  void getProjectDirectory() async {
    String? directory = await FilePicker.platform.getDirectoryPath();
    if (directory != null) {
      state = directory;
    } else {
      state = 'Please Select Project Directory';
    }
  }
}
