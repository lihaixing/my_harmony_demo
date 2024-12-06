import { common, Want } from '@kit.AbilityKit';
import { DefaultFruitList, IFruit } from '../util';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { router } from '@kit.ArkUI';

class EventData {
  context: AbilityContext | null = null
  launchWant: Want | null = null
}

interface AbilityContext {
  startAbility(want: Want): void;

  eventHub: EventHub;
}

interface EventHub {
  emit(event: string, ...args: Object[]): void;
}


@Entry({ storage: LocalStorage.getShared() })
@Component
struct Index {
  @State fruit: string = '苹果';
  @StorageProp('fruitList') fruitList: IFruit[] = [];
  @LocalStorageProp('fruitCount') fruitCount: number = DefaultFruitList.length;
  // private context = getContext(this) as common.UIAbilityContext;

  getFruit = (id: string) => {
    const fruitInfo = this.fruitList.find(item => item.id === id);

    return fruitInfo?.text || '没找到水果'
  }

  async aboutToAppear() {

    console.log('detail aboutToAppear');
    const id = (router.getParams() as Record<string, string>)?.id;
    console.log('aboutToAppear id', id)
    if (id) {
      this.fruit = this.getFruit(id)
    } else {
      let context = getContext(this);
      let data: EventData = new EventData();
      context.eventHub.emit('getFruitDetailAbilityData', data);

      const abilityWant = data.launchWant as Want;
      const fruitId = abilityWant.parameters?.fruitId as string || '';
      this.fruit = this.getFruit(fruitId)
    }
  }

  build() {
    Column() {
      Text('水果详情')
        .fontSize(60)
        .margin({ bottom: 10 })
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 30 })
        .fontColor('red')
        .fontWeight(FontWeight.Bold)

      Text(`水果数量：${this.fruitCount}`)
        .fontSize(40)
        .margin({ bottom: 10 })
        .fontColor('red')
      Text(this.fruit)
        .fontSize(40)
        .fontWeight(FontWeight.Bold)

      // Button('关闭当前ability')
      //   .fontSize(20)
      //   .fontColor('#FFF')
      //   .width(200)
      //   .height(40)
      //   .backgroundColor('blue')
      //   .borderRadius(5)
      //   .margin({ bottom: 10 })
      //   .onClick(() => {
      //     this.context.terminateSelf().catch((err: BusinessError) => {
      //       hilog.error(121212, '水果详情', `Failed to start SpecifiedAbility. Code is ${err.code}, message is ${err.message}`);
      //     })
      //   })
    }
    .height('100%')
    .width('100%')
  }
}