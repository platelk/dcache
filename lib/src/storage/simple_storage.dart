part of dcache;

class SimpleStorage<K, V> implements Storage<K, V> {
  Map<K, CacheEntry<K, V>> _internalMap;
  int _size;

  SimpleStorage({@required int size}) {
    this._size = size;
    this._internalMap = new LinkedHashMap();
  }

  @override
  CacheEntry<K, V> operator [](K key) {
    var ce = this._internalMap[key];
    return ce;
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
  CacheEntry<K, V> remove(K key) {
    return this._internalMap.remove(key);
  }

  @override
  int get length => this._internalMap.length;

  @override
  bool containsKey(K key) {
    return this._internalMap.containsKey(key);
  }

  @override
  List<K> get keys => this._internalMap.keys.toList(growable: true);

  @override
  List<CacheEntry<K, V>> get values => this._internalMap.values.toList(growable: true);

  @override
  int get capacity => this._size;
}
