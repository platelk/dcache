part of dcache;

class SimpleCache<K, V> extends Cache<K, V> {
  Storage<K, V> _internalStorage;

  SimpleCache(int size) {
    this._internalStorage = new SimpleStorage(size: size);
  }

  @override
  V _get(K key) {
    return this._internalStorage[key].value;
  }

  @override
  SimpleCache _set(K key, V element) {
    this._internalStorage[key] = new CacheEntry(key, element, null);
    return this;
  }

  @override
  SimpleCache clear() {
    this._internalStorage.clear();
    return this;
  }

  @override
  int get length => this._internalStorage.length;
}
