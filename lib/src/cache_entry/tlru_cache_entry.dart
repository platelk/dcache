part of dcache;

class TlruCacheEntry<K, V> extends CacheEntry<K, V> {
  Duration expiration;

  static bool hasExpired(TlruCacheEntry entry) =>
      DateTime.now().difference(entry.insertTime) > entry.expiration;

  int compare(TlruCacheEntry other) {
    final thisExpired = hasExpired(this);
    final otherExpired = hasExpired(other);

    if (thisExpired && otherExpired) {
      return 0;
    } else if (thisExpired) {
      return -1;
    } else if (otherExpired) {
      return 1;
    } else {
      return 0;
    }
  }

  TlruCacheEntry(K key, V? value, DateTime insertTime, this.expiration)
      : super(key, value, insertTime);
}
