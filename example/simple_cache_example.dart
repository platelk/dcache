import 'package:dcache/dcache.dart';

void main() {
  Cache c = new SimpleCache(storage: new SimpleStorage(size: 20));

    c.set("key", 42);
    print(c.get("key")); // 42
    print(c.containsKey("unknown_key")); // false
    print(c.get("unknown_key")); // nil
}