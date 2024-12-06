import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';


interface Data {
  context: Context;
  launchWant: Want;
}

export default class FruitDetailAbility extends UIAbility {


  private want: Want | null = null;
  getAbilityDataCallback: Function | undefined = undefined;
  windowStage: window.WindowStage | undefined = undefined;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
   console.log('[FruitDetailAbility]', 'FruitDetailAbility onCreate');

    this.want = want;

    this.context.eventHub.on('getFruitDetailAbilityData',(data: Data): void => {
      console.log('[FruitDetailAbility]', JSON.stringify(data));
      data.context = this.context;
      if(this.want){
        data.launchWant = this.want;
      }
    })
  }

  // 如果是单例模式(默认)，再次打开ability会走到这里，需要重新加载页面
  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam){
    this.want = want;
    this.windowStage?.loadContent('pages/detail', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    this.windowStage = windowStage;
    windowStage.loadContent('pages/detail', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }
  //
  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }
}
