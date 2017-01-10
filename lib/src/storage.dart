part of dcache;

abstract class Storage<K, V> {
  CacheEntry<K, V> get(K key);
  Storage set(K key, CacheEntry<K, V> value);

  void clear();
  int get length;

  CacheEntry<K, V> operator [](K key);
  void operator []=(K key, CacheEntry<K, V> value);
}