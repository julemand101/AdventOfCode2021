import 'dart:io';

void main() {
  const prefix = 'MYOS_2025_W2_';
  final regExp = RegExp(prefix + r'(\d+).png');

  for (final file in Directory(r"D:\Mega\PNG\").listSync().whereType<File>()) {
    final number = regExp.firstMatch(file.path)![1]!;

    if (number.length < 3) {
      final newName =
          r"D:\Mega\PNG\"
          '$prefix${number.padLeft(3, '0')}.png';
      print('$file => $newName');
      file.rename(newName);
    }
  }
}
