part of dcache;

typedef LoaderFunc<K, V> = FutureOr<V> Function(K key, V? oldValue);
typedef OnEvict<K, V> = void Function(K k, V? v);

abstract class Cache<K, V> {
  /// if onEvict is set that method is called whenever an entry is removed from the queue.
  /// At the time the method is called the entry is already removed.
  OnEvict<K, V>? onEvict;
  Storage<K, V> _internalStorage;
  LoaderFunc<K, V>? _loaderFunc;
  Duration? _expiration;

  /// Determine if the loading function in case of "refreshing", would be waited or not
  /// In some case we are more interested by the quick answer than a accurate one
  bool _syncValueReloading;

  Cache(Storage<K, V> storage, {this.onEvict}) : _internalStorage = storage,  _syncValueReloading = true;

  /// return the element identify by [key]
  V? get(K key) {
    if (_loaderFunc != null && !containsKey(key)) {
      if (_internalStorage.length >= _internalStorage.capacity) {
        var garbage = _collectGarbage(_internalStorage.length - _internalStorage.capacity + 1);
        if (onEvict != null) {
          for (var e in garbage) {
            onEvict!(e.key, e.value);
          }
        }
        for (var e in garbage) {
          _internalStorage.remove(e.key);
        }
      }
      _loadFirstValue(key);
    }
    var entry = _get(key);
    if (entry == null) {
      return null;
    }

    // Check if the value hasn't expired
    if (_expiration != null && DateTime.now().difference(entry.insertTime) >= _expiration!) {
      if (_syncValueReloading) {
        _loadValue(entry);
        entry = _get(key);
      } else {
        // Non blocking
        Future(() => _loadValue(entry!));
      }
    }

    entry?.use++;
    entry?.updateUseTime();
    return entry?.value;
  }

  // Load a new value and insert in the cache
  void _loadValue(CacheEntry<K, V> entry) {
    if (_loaderFunc != null && !entry.updating) {
      entry.updating = true;
      // Prevent double calls
      _set(entry.key, _loaderFunc!(entry.key, entry.value));
    }
  }

  void _loadFirstValue(K key) {
    if (_loaderFunc != null) {
      // Prevent double calls
      _set(key, _loaderFunc!(key, null));
    }
  }

  /// internal [get]
  CacheEntry<K, V>? _get(K key) => _internalStorage[key];

  /// add [element] in the cache at [key]
  Cache<K, V> set(K key, V element) {
    return _set(key, element);
  }

  /// internal [set]
  Cache<K, V> _set(K key, FutureOr<V> element) {
    CacheEntry<K, V> entry;
    if (element is Future<V>) {
      entry = CacheEntry<K, V>(key, null, DateTime.now());
      entry.updating = true;
      element.then((e) {
        entry.updating = false;
        entry.value = e;
      });
    } else {
      entry = CacheEntry<K, V>(key, element, DateTime.now());
    }
    _internalStorage[key] = entry;
    return this;
  }

  /// clear elements to let new element being inserted
  List<CacheEntry<K, V>> _collectGarbage(int size);

  /// return the number of element in the cache
  int get length => _internalStorage.length;

  // Check if the cache contains a specific entry
  bool containsKey(K key) => _internalStorage.containsKey(key);

  /// return the value at [key]
  V? operator [](K key) {
    return get(key);
  }

  /// assign [element] for [key]
  void operator []=(K key, V element) {
    set(key, element);
  }

  /// remove all the entry inside the cache
  void clear() => _internalStorage.clear();

  set loader(LoaderFunc<K, V> loadFunc) {
    _loaderFunc = loadFunc;
  }

  set storage(Storage<K, V> storage) {
    _internalStorage = storage;
  }

  set expiration(Duration duration) {
    _expiration = duration;
  }

  set syncLoading(bool syncLoading) {
    _syncValueReloading = syncLoading;
  }
}
