import { router } from '@kit.ArkUI';
import { FruitList } from './components/fruitList';
import { Want , common} from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';
const TAG: string = '[Webpage]';
const DOMAIN_NUMBER: number = 0xFF00;

@Entry({ storage: LocalStorage.getShared() })
@Component
struct Index {
  private context = getContext(this) as common.UIAbilityContext;

  build() {
    Column() {
      Text('首页')
        .fontSize(60)
        .margin({ bottom: 40 })
        .fontWeight(FontWeight.Bold)
        .fontColor('red')
        .fontWeight(FontWeight.Bold)


      Text('路由跳转方式 localStorage能共享count')
        .fontSize(20)
        .margin({ bottom: 20 })
        .fontWeight(FontWeight.Bold)
        .fontColor('red')
        .fontWeight(FontWeight.Bold)

      FruitList({jumpType: 'router'}).margin({ bottom: 40 });

      Text('ability跳转方式 localStorage不能共享count')
        .fontSize(20)
        .margin({ bottom: 20 })
        .fontWeight(FontWeight.Bold)
        .fontColor('red')
        .fontWeight(FontWeight.Bold)

      FruitList({jumpType: 'ability'}).margin({ bottom: 40 });


      Button('跳转WebPage')
        .fontSize(20)
        .fontColor('#FFF')
        .width(200)
        .height(40)
        .margin({ bottom: 10 })
        .backgroundColor('blue')
        .borderRadius(5)
        .onClick(() => {
          let want: Want = {
            abilityName: 'WebPageAbility',
            bundleName: "com.example.my_demo",
          };
          this.context.startAbility(want).then(() => {

          }).catch((err: BusinessError) => {
            hilog.error(DOMAIN_NUMBER, TAG, `Failed to start SpecifiedAbility. Code is ${err.code}, message is ${err.message}`);
          })
        })

    }
    .height('40%')
    .width('100%')
  }
}