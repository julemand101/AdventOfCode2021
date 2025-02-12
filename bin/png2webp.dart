import 'dart:collection';
import 'dart:io';

import 'package:path/path.dart' as p;

final String cwebpPath =
    Platform.isWindows
        ? r'C:\Tools\libwebp-1.4.0-windows-x64\bin\cwebp.exe'
        : '/usr/bin/cwebp';

final List<String> inputDirPaths =
    Platform.isWindows
        ? const [r'D:\Sync', r'D:\Mega']
        : const ['/home/julemand101/Sync', '/tmp/dl'];

void main() async {
  final filesToConvertQueue = Queue<File>();

  for (final inputDir in inputDirPaths.map(Directory.new)) {
    if (!inputDir.existsSync()) {
      print(':: "${inputDir.absolute.path}" does not exist. Skipped!');
      continue;
    }

    filesToConvertQueue.addAll(
      inputDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((path) => p.extension(path.path).toLowerCase() == '.png'),
    );
  }

  Future<void> handleFile({required int jobId}) async {
    do {
      final pngFile = filesToConvertQueue.removeFirst();
      print(
        ':: [${DateTime.now()}] [${jobId.toString().padLeft(2, '0')}] | '
        'Start handling: ${pngFile.path}',
      );

      await cwebpTask(pngFile);
      print(
        ':: [${DateTime.now()}] [${jobId.toString().padLeft(2, '0')}] | '
        'Done handling: ${pngFile.path}',
      );
    } while (filesToConvertQueue.isNotEmpty);
  }

  for (int i = 0; i < Platform.numberOfProcessors; i++) {
    if (filesToConvertQueue.isNotEmpty) {
      handleFile(jobId: i);
    }
  }
}

// cwebp -lossless -z 9 -m 6 -q 100 image.png -o image.webp
// cwebp -m 6 -q 90 image.png -o image.webp
Future<void> cwebpTask(File pngFile) async {
  final webpPath = p.join(
    p.dirname(pngFile.path),
    '${p.basenameWithoutExtension(pngFile.path)}.webp',
  );

  if (File(webpPath).existsSync()) {
    print(
      'ERROR: "${pngFile.path}" could be be converted '
      'since "$webpPath" already exist!',
    );
    return;
  }

  final processResult = await Process.run(cwebpPath, [
    '-m',
    '6',
    '-q',
    '90',
    pngFile.absolute.path,
    '-o',
    webpPath,
  ]);

  print(processResult.stderr);
  pngFile.delete();
}
