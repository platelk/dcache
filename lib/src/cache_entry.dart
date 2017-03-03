part of dcache;

class CacheEntry<K, V> {
  DateTime insertTime;
  K key;
  V value;
  bool updating = false;
  DateTime lastUse;
  int use = 0;

  CacheEntry(this.key, this.value, this.insertTime) {
    this.lastUse = this.insertTime;
  }

  void updateUseTime() {
    this.lastUse = new DateTime.now();
  }
}
