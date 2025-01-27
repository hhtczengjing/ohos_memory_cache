# ohos_memory_cache

LRU Memory Cache for HarmonyOS

## 安装

```shell
ohpm i @devzeng/memory_cache
```

OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://ohpm.openharmony.cn/#/cn/help/downloadandinstall)

## 使用

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

// all keys
cache.keys();

// all values
cache.values(); 
```