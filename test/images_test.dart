import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:themoviedb/ui/resources/resources.dart';

void main() {
  test('images assets test', () {
    expect(File(AppImages.moviePlaceholder).existsSync(), isTrue);
  });
}
