part of dcache;

class LFU<K, V> implements Storage<K, V> {
  Map<K, CacheEntry<K, V>> _internalMap;
  int _size;

  SimpleStorage({int size}) {
    this._size = size;
    this._internalMap = new LinkedHashMap();
  }

  @override
  CacheEntry<K, V> operator [](K key) {
    return this._internalMap[key];
  }

  @override
  void operator []=(K key, CacheEntry<K, V> value) {
    // Remove the first key to respect the size, no time logic here.
    // It's a wanted simple and not smart implementation
    if (!this._internalMap.containsKey(key) && this._internalMap.length >= _size) {
      this._internalMap.remove(this._internalMap.keys.first);
    }
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


  @override
  bool contains(K key) {}
}
