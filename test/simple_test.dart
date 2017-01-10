import 'package:test/test.dart';

import 'package:dcache/dcache.dart';

void main() {
  test("Test cache initialization", () {
    var cache = new SimpleCache();
    expect(cache, isNotNull)
  });
}