import 'package:test/test.dart';
import 'dart:async';
import 'dart:io';

import 'package:dcache/dcache.dart';

void main() {
  test("Test cache initialization", () {
    Cache cache = new SimpleCache(storage: new SimpleStorage(size: 20));
    expect(cache, isNotNull);
  });
  //
  test("Test simple insert/get", () {
    Cache c = new SimpleCache(storage: new SimpleStorage(size: 20));

    c.set("key", 42);
    expect(c.get("key"), equals(42));
  });
  test("Test simple loader function", () {
    Cache<int, int> c =
        new SimpleCache<int, int>(storage: new SimpleStorage(size: 20))
          ..loader = (int k, _) => k * 10;
    expect(c.get(4), equals(40));
    expect(c.get(5), equals(50));
  });
  test("Test simple loader function", () {
    Cache<int, int> c =
        new SimpleCache<int, int>(storage: new SimpleStorage(size: 20))
          ..syncLoading = true
          ..expiration = const Duration(seconds: 3)
          ..loader = (int k, int oldValue) {
            oldValue ??= k;
            var v = oldValue * 10;
            sleep(const Duration(seconds: 1));
            return v;
          };

    expect(c.get(4), equals(40));
    expect(c.get(4), equals(40));
    sleep(const Duration(seconds: 3));

    expect(c.get(4), equals(400));
  });
  test("Test simple loader function", () {
    Cache<int, int> c =
        new SimpleCache<int, int>(storage: new SimpleStorage(size: 20))
          ..syncLoading = false
          ..expiration = const Duration(seconds: 3)
          ..loader = (int k, int oldValue) {
            oldValue ??= k;
            var v = oldValue * 10;
            sleep(const Duration(seconds: 1));
            return v;
          };

    expect(c.get(4), equals(40));
    expect(c.get(4), equals(40));
    sleep(const Duration(seconds: 3));

    expect(c.get(4), equals(40));
  });
  test("Test simple eviction", () {
    Cache<int, int> c =
        new SimpleCache<int, int>(storage: new SimpleStorage(size: 3))
          ..loader = (int k, _) {
            return k * 10;
          };

    expect(c.get(4), equals(40));
    expect(c.get(5), equals(50));
    expect(c.get(6), equals(60));
    expect(c.get(7), equals(70));
    expect(c.containsKey(4), equals(false));
  });
  test("Test LRU eviction", () {
    Cache<int, int> c =
        new LruCache<int, int>(storage: new SimpleStorage(size: 3))
          ..loader = (int k, _) {
            return k * 10;
          };

    expect(c.get(4), equals(40));
    expect(c.get(5), equals(50));
    expect(c.get(6), equals(60));
    sleep(const Duration(seconds: 1));
    expect(c.get(4), equals(40));
    expect(c.get(6), equals(60));
    expect(c.get(7), equals(70));
    expect(c.containsKey(5), equals(false));
  });
  test("Test LFU eviction", () {
    Cache<int, int> c =
        new LfuCache<int, int>(storage: new SimpleStorage(size: 3))
          ..loader = (int k, _) {
            return k * 10;
          };

    expect(c.get(4), equals(40));
    expect(c.get(5), equals(50));
    expect(c.get(6), equals(60));
    expect(c.get(4), equals(40));
    expect(c.get(6), equals(60));
    expect(c.get(7), equals(70));
    print(c.storage.keys);
    expect(c.containsKey(5), equals(false));
  });
}
