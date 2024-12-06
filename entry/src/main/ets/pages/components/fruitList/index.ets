import { router } from '@kit.ArkUI';
import { common, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { DefaultFruitList, IFruit } from '../../../util';


AppStorage.setOrCreate('fruitList', JSON.parse(JSON.stringify(DefaultFruitList)));


@Component
export struct FruitList {
  @Prop canJumpDetail: boolean = true;
  @Prop jumpType: 'router' | 'ability' = 'ability';
  @StorageProp('fruitList') @Watch('onChangeFruitCount') fruitList: IFruit[] = [];
  @LocalStorageLink('fruitCount') fruitCount: number = DefaultFruitList.length;
  private context = getContext(this) as common.UIAbilityContext;

  onChangeFruitCount() {
    this.fruitCount = this.fruitList.length;
  }

  build() {
    Column() {
      Text(`水果数量：${this.fruitCount}`)
        .fontSize(30)
        .height(40)
        .margin({ bottom: 10 })
        .fontColor('green')

      ForEach(this.fruitList, (item: IFruit) => {
        Text(item.text)
          .fontSize(20)
          .height(40)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {

            if (!this.canJumpDetail) {
              return;
            }

            if (this.jumpType === 'ability') {
              let want: Want = {
                abilityName: 'FruitDetailAbility',
                bundleName: "com.example.my_demo",
                parameters: {
                  // 自定义信息
                  fruitId: item.id
                }
              };
              this.context.startAbility(want).then(() => {

              }).catch((err: BusinessError) => {
                hilog.error(121212, 'fruit detail: ',
                  `Failed to start SpecifiedAbility. Code is ${err.code}, message is ${err.message}`);
              })
            } else {
              router.pushUrl({
                url: 'pages/detail',
                params: { id: item.id }
              })
            }
          })
      })
    }
  }
}