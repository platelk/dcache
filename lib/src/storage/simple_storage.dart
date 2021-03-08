part of dcache;

class InMemoryStorage<K, V> implements Storage<K, V> {
  final Map<K, CacheEntry<K, V>> _internalMap;
  final int _size;

  InMemoryStorage(int size): _size = size, _internalMap = {};

  @override
  CacheEntry<K, V>? operator [](K key) {
    var ce = _internalMap[key];
    return ce;
  }

  @override
  void operator []=(K key, CacheEntry<K, V> value) {
    _internalMap[key] = value;
  }

  @override
  void clear() {
    _internalMap.clear();
  }

  @override
  CacheEntry<K, V>? get(K key) {
    return _internalMap[key];
  }

  @override
  Storage set(K key, CacheEntry<K, V> value) {
    this[key] = value;
    return this;
  }

  @override
  void remove(K key) {
    _internalMap.remove(key);
  }

  @override
  int get length => _internalMap.length;

  @override
  bool containsKey(K key) {
    return _internalMap.containsKey(key);
  }

  @override
  List<K> get keys => _internalMap.keys.toList(growable: true);

  @override
  List<CacheEntry<K, V>> get values =>
      _internalMap.values.toList(growable: true);

  @override
  int get capacity => _size;
}
