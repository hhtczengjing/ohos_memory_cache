import { MemoryCache } from '@devzeng/memory_cache';

@Extend(Text)
function headerStyle() {
  .textAlign(TextAlign.Start)
  .width('100%')
  .padding({ left: 16, right: 16 })
  .fontSize(16)
  .fontColor('#7E8388')
}

@Extend(TextArea)
function inputStyle() {
  .width('100%')
  .padding({ left: 16, right: 16 })
  .borderRadius(0)
  .fontSize(16)
  .fontColor('#020F22')
}

@Extend(Text)
function outputStyle() {
  .textAlign(TextAlign.Start)
  .width('100%')
  .padding({ left: 16, right: 16 })
  .fontSize(16)
  .fontColor('#020F22')
}

@Extend(Button)
function btnStyle() {
  .fontSize(16)
  .fontWeight(FontWeight.Regular)
  .backgroundColor('#344F9C')
  .width('35%')
}

@Extend(List)
function separatorStyle() {
  .divider({
    strokeWidth: 0.5,
    startMargin: 16,
    endMargin: 0,
    color: '#E3E6ED'
  })
}

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State logs: string[] = [];
  private cache: MemoryCache<string> = new MemoryCache({
    countLimit: 200
  });

  build() {
    Column({ space: 10 }) {
      Text('Input Message: ')
        .headerStyle()

      TextArea({ text: this.message })
        .inputStyle()
        .height('10%')
        .onChange((value) => {
          this.message = value;
        })

      Row() {
        Button('写入缓存')
          .btnStyle()
          .onClick(() => {
            for (let index = 0; index < 500; index++) {
              const key = `key-${index}`;
              const value = `${this.message}-${index}`;
              this.cache.put(key, value);
              this.logs.push(`put ${key} -> ${value}`);
            }
          })

        Button('读取缓存')
          .btnStyle()
          .onClick(() => {
            for (let index = 0; index < 500; index++) {
              const key = `key-${index}`;
              const value = this.cache.get(key);
              this.logs.push(`get ${key} -> ${value}`);
            }
          })
      }
      .padding({ left: 16, right: 16 })
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Top)

      Row() {
        Button('All Keys')
          .btnStyle()
          .onClick(() => {
            const keys = this.cache.keys();
            for (let index = 0; index < keys.length; index++) {
              const key = keys[index];
              this.logs.push(`key ${key}`);
            }
          })

        Button('All Values')
          .btnStyle()
          .onClick(() => {
            const values = this.cache.values();
            for (let index = 0; index < values.length; index++) {
              const value = values[index];
              this.logs.push(`value ${value}`);
            }
          })
      }
      .padding({ left: 16, right: 16 })
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Top)

      if (this.logs && this.logs.length > 0) {
        Column() {
          Text('Output Logs: ')
            .headerStyle()

          List() {
            ForEach(this.logs, (item: string) => {
              ListItem() {
                Text(`${item}`)
                  .outputStyle()
                  .margin({ top: 5 })
              }
              .width('100%')
              .height(44)
            })
          }
          .separatorStyle()
        }
        .margin({ top: 20, bottom: 40 })
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Start)
      }
    }
    .margin({ top: 10 })
    .width('100%')
    .padding({ left: 10, right: 10 })
    .height('100%')
    .width('100%')
    .expandSafeArea([SafeAreaType.SYSTEM])
  }
}