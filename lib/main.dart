import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:form_ui/form_ui.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
// ignore: implementation_imports
import 'package:form_ui/src/theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Path Convert',
      debugShowCheckedModeBanner: false,
      theme: FormTheme.lightTheme,
      darkTheme: FormTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Path Convert'),
          ),
          body: HomeBody()),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FormPrimaryButton(
        onPressed: () async {
          try {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['path'],
            );

            if (result != null) {
              File file = File(result.files.single.path!);
              String content = await file.readAsString();
              String updatedContent = content.replaceAll(
                  'idealStartingState', 'previewStartingState');

              Directory? appDocDir = await getDownloadsDirectory();
              String appDocPath = appDocDir!.path;
              String newFilePath = '$appDocPath/${result.files.single.name}';
              File newFile = File(newFilePath);
              await newFile.writeAsString(updatedContent);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('File saved to $newFilePath'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          } catch (e) {
            debugPrint(e.toString());
          }
        },
        child: const Text('Select and Convert File'),
      ),
    );
  }
}
