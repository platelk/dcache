library dcache;

import 'dart:collection';
import 'dart:async';

import 'package:meta/meta.dart';

// common
part 'src/cache.dart';
part 'src/storage.dart';
part 'src/cache_entry.dart';

// Cache
//   - Simple cache (FIFO)
part 'src/cache/simple_cache.dart';
//   - LRU
part 'src/cache/lru_cache.dart';
//   - LFU
part 'src/cache/lfu_cache.dart';

// Storage
//   - Simple storage
part 'src/storage/simple_storage.dart';
