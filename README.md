# Dcache

Dcache is a simple library to implement application caching in `dart` inspired by [gcache](https://github.com/bluele/gcache)

## Feature

* Supports expirable Cache, LFU, LRU.
* Support eviction
* Automatically load cache if it doesn't exists. (Optional)
* Async loading of expirate value
* Callback for evicted items to perform cleanup (Optional)

## Example

### Simple use case

```dart
import 'package:dcache/dcache.dart';

void main() {
  Cache c = new SimpleCache(storage: new SimpleStorage(20));

    c.set("key", 42);
    print(c.get("key")); // 42
    print(c.containsKey("unknown_key")); // false
    print(c.get("unknown_key")); // nil
}
```

### Evict items

```dart
import 'package:dcache/dcache.dart';

void main() {
  Cache c = new SimpleCache(storage: new SimpleStorage(20), onEvict: (key, value) {value.dispose();});

    c.set("key", 42);
    print(c.get("key")); // 42
    print(c.containsKey("unknown_key")); // false
    print(c.get("unknown_key")); // nil
}
```


### Loading function

```dart
import 'package:dcache/dcache.dart';

void main() {
  Cache c = new SimpleCache<int, int>(storage: new SimpleStorage(20))
    ..loader = (key, oldValue) => key*10
  ;

    print(c.get(4)); // 40
    print(c.get(5)); // 50
    print(c.containsKey(6)); // false
}
```

## Author

*Kevin PLATEL*

* mail : <platel.kevin@gmail.com>
* github : <http://github.com/platelk>
* twitter : <https://twitter.com/kevinplatel>