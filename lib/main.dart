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

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  String saveTo = '';

  @override
  void initState() {
    getDownloadsDirectory().then((d) {
      setState(() {
        saveTo = d!.path;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            FormSecondaryButton(
                onPressed: () {
                  FilePicker.platform.getDirectoryPath().then((p) {
                    setState(() {
                      saveTo = p!;
                    });
                  });
                },
                child: Text('Save to $saveTo')),
            FormPrimaryButton(
              onPressed: () async {
                try {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['path'],
                  );

                  if (result != null) {
                    File file = File(result.files.single.path!);
                    String content = await file.readAsString();
                    String updatedContent = content.replaceAll(
                        'idealStartingState', 'previewStartingState');
                    String newFilePath = '$saveTo/${result.files.single.name}';
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
          ],
        ),
      ),
    );
  }
}
