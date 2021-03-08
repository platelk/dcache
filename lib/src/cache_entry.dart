part of dcache;

class CacheEntry<K, V> {
  DateTime insertTime;
  K key;
  V? value;
  bool updating = false;
  DateTime lastUse = DateTime.now();
  int use = 0;

  CacheEntry(this.key, this.value, this.insertTime) {
    lastUse = insertTime;
  }

  void updateUseTime() {
    lastUse = DateTime.now();
  }
}
