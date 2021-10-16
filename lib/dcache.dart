library dcache;

import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:meta/meta.dart';

part 'src/cache.dart';
part 'src/cache/lfu_cache.dart';
part 'src/cache/lru_cache.dart';
part 'src/cache/tlru_cache.dart';
part 'src/cache/simple_cache.dart';
part 'src/cache_entry.dart';
part 'src/cache_entry/tlru_cache_entry.dart';
part 'src/storage.dart';
part 'src/storage/simple_storage.dart';
part 'src/storage/tlru_storage.dart';
// common
// Cache
//   - Simple cache (FIFO)
//   - LRU
//   - LFU
//   - TLRU
// Storage
//   - Simple storage
//   - TLRU storage

