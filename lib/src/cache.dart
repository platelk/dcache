part of dcache;

typedef V LoaderFunc<K, V>(K key);

abstract class Cache<K, V> {
  LoaderFunc _loaderFunc;

  /// retun the element identify by [key]
  V get(K key) {
    return this._get(key);
  }

  /// internal [get]
  V _get(K key);

  /// add [element] in the cache at [key]
  Cache set(K key, V element) {
    return this._set(key, element);
  }

  /// internal [set]
  Cache _set(K key, V element);

  /// return the number of element in the cache
  int get length;

  /// return the value at [key]
  dynamic operator [](K key) {
    return this.get(key);
  }

  /// assign [element] for [key]
  void operator []=(K key, V element) {
    this.set(key, element);
  }

  /// remove all the entry inside the cache
  Cache clear();
}

class CacheEntry<K, V> {
  DateTime insertTime;
  K key;
  V value;

  CacheEntry(this.key, this.value, this.insertTime);
}
