import 'package:test/test.dart';
import 'dart:async';
import 'dart:io';

import 'package:dcache/dcache.dart';

void main() {
  test("Test cache initialization", () {
    Cache cache = new Cache(storage: new SimpleStorage(size: 20));
    expect(cache, isNotNull);
  });
  //
  test("Test simple insert/get", () {
    Cache c = new Cache(storage: new SimpleStorage(size: 20));

    c.set("key", 42);
    expect(c.get("key"), equals(42));
  });
  test("Test simple loader function", () {
    Cache<int, int> c = new Cache<int, int>(
        storage: new SimpleStorage(size: 20))..loader = (int k, _) => k * 10;
    expect(c.get(4), equals(40));
    expect(c.get(5), equals(50));
  });
  test("Test simple loader function", () {
    Cache<int, int> c =
        new Cache<int, int>(storage: new SimpleStorage(size: 20))
          ..syncLoading = true
          ..expiration = const Duration(seconds: 3)
          ..loader = (int k, int oldValue) {
            oldValue ??= k;
            print(oldValue);
            var v = oldValue * 10;
            print(v);
            sleep(const Duration(seconds: 1));
            return v;
          };

    expect(c.get(4), equals(40));
    expect(c.get(4), equals(40));
    sleep(const Duration(seconds: 5));

    expect(c.get(4), equals(400));
  });
    test("Test simple loader function", () {
    Cache<int, int> c =
        new Cache<int, int>(storage: new SimpleStorage(size: 20))
          ..syncLoading = false
          ..expiration = const Duration(seconds: 3)
          ..loader = (int k, int oldValue) {
            oldValue ??= k;
            print(oldValue);
            var v = oldValue * 10;
            print(v);
            sleep(const Duration(seconds: 1));
            return v;
          };

    expect(c.get(4), equals(40));
    expect(c.get(4), equals(40));
    sleep(const Duration(seconds: 5));

    expect(c.get(4), equals(40));
  });
}
