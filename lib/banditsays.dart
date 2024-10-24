import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as img;
import 'package:enough_ascii_art/enough_ascii_art.dart' as art;

List<String> files = [];

void banditsays() async {
  // Run the fortune command and get the stderr output
  ProcessResult result = Process.runSync('fortune', ['-f']);

  // Extract the path from the stderr output
  String fortuneLoc = result.stderr.toString().split('\n').first;
  fortuneLoc = fortuneLoc.split(' ').firstWhere((element) => element.startsWith('/'));

  // Call visit function on the extracted path
  visit(fortuneLoc);
  // print(files);
  randomFile();
}

void visit(String path) {
  final directory = Directory(path);

  if (!directory.existsSync()) {
    print('Directory does not exist: $path');
    return;
  }

  final List<FileSystemEntity> entities = directory.listSync(recursive: false);

  for (var entity in entities) {
    // Check if the path contains '/off/'
    if (entity.path.contains('/off/')) {
      continue; // Skip paths with '/off/'
    }

    // Check if the entity is a file
    if (entity is File) {
      // Skip files with .dat extension
      if (entity.path.endsWith('.dat')) {
        continue;
      }
      if (entity.path.endsWith('.u8')) {
        continue;
      }

      // Add the file path to the list
      files.add(entity.path);
    }

    // If it's a directory, recurse into it
    if (entity is Directory) {
      visit(entity.path); // Recursive call for directories
    }
  }
}

void randomFile() {
  // Get a random file from the list
  final random = Random();
  final randomIndex = random.nextInt(files.length);
  final randomFile = files[randomIndex];

  // Print the random file
  // print(randomFile);

  // Read the contents of the file
  final file = File(randomFile);
  final contents = file.readAsStringSync();

  final byte = File('bandit.jpeg');
  final image = img.decodeImage(byte.readAsBytesSync());
  var ascii = art.convertImage(image!, maxWidth: 50,maxHeight: 50, invert: false);
 

  print(contents.split('%')[random.nextInt(contents.split('%').length)]);
 print(ascii);
}
