```typescript
const cache: MemoryCache<string> = new MemoryCache({
  countLimit: 500 // 缓存最大容量
});

// 设置缓存
cache.set('key1', 'a');

// 获取缓存
cache.get('key1');

// 判断缓存是否存在
cache.has('key1');

// 删除缓存
cache.remove('key1');

// 清空缓存
cache.clean(); 
```