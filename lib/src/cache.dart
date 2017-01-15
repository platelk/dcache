part of dcache;

typedef V LoaderFunc<K, V>(K key);

class Cache<K, V> {
  Storage<K, V> _internalStorage;
  LoaderFunc _loaderFunc;
  Duration _expiration;

  /// Determine if the loading function in case of "refreshing", would be waited or not
  /// In some case we are more interested by the quick answer than a accurate one
  bool _syncValueLoading;

  Cache({@required Storage<K, V> storage}) {
    this._internalStorage = storage;
  }

  /// retun the element identify by [key]
  V get(K key) {
    // Note: I redo a null check here to avoid a O(n) iteration if the _loaderFunc is null
    if (this._loaderFunc != null && !this._internalStorage.containsKey(key)) {
      this._loadValue(key);
    }

    CacheEntry<K, V> entry = this._get(key);
    if (entry == null) {
      return null;
    }
    // Check if the value hasn't expired
    if (this._expiration != null && entry.insertTime.difference(new DateTime.now()) >= this._expiration) {
      if (_syncValueLoading) {
        this._loadValue(key);
      } else {
        // Non blocking
        new Future(() => this._loadValue(key));
      }
    }
    return entry.value;
  }

  // Load a new value and insert in the cache
  void _loadValue(K key) {
    if (this._loaderFunc != null) {
      this._set(key, this._loaderFunc(key));
    }
  }

  /// internal [get]
  CacheEntry<K, V> _get(K key) => this._internalStorage[key];

  /// add [element] in the cache at [key]
  Cache set(K key, V element) {
    return this._set(key, element);
  }

  /// internal [set]
  Cache _set(K key, V element) {
    this._internalStorage[key] =
        new CacheEntry(key, element, new DateTime.now());
    return this;
  }

  /// return the number of element in the cache
  int get length => this._internalStorage.length;

  // Check if the cache contains a specific entry
  bool containsKey(K key) => this._internalStorage.containsKey(key);

  /// return the value at [key]
  dynamic operator [](K key) {
    return this.get(key);
  }

  /// assign [element] for [key]
  void operator []=(K key, V element) {
    this.set(key, element);
  }

  /// remove all the entry inside the cache
  void clear() => this._internalStorage.clear();

  void set loader(LoaderFunc<K, V> loadFunc) {
    this._loaderFunc = loadFunc;
  }

  void set storage(Storage<K, V> storage) {
    this._internalStorage = storage;
  }

  void set expiration(Duration duration) {
    this._expiration = duration;
  }
}

class CacheEntry<K, V> {
  DateTime insertTime;
  K key;
  V value;

  CacheEntry(this.key, this.value, this.insertTime);
}
