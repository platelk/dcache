part of dcache;

class SimpleStorage<K, V> implements Storage<K, V> {
  Map<K, CacheEntry<K, V>> _internalMap = {};

  @override
  CacheEntry<K, V> operator [](K key) {
    return this._internalMap[key];
  }

  @override
  void operator []=(K key, CacheEntry<K, V> value) {
    this._internalMap[key] = value;
  }

  @override
  void clear() {
    this._internalMap.clear();
  }

  @override
  CacheEntry<K, V> get(K key) {
    return this[key];
  }

  @override
  Storage set(K key, CacheEntry<K, V> value) {
    this[key] = value;
    return this;
  }

  @override
  int get length => this._internalMap.length;
}