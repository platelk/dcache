part of dcache;

class CacheEntry<K, V> {
  final DateTime insertTime;
  final K key;
  final V value;
  bool updating = false;
  DateTime lastUse;
  int use = 0;

  CacheEntry(this.key, this.value) : insertTime = DateTime.now() {
    lastUse = insertTime;
  }

  void updateUseTime() {
    lastUse = DateTime.now();
  }
}
