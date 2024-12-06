import { promptAction, router } from '@kit.ArkUI';
import { webview } from '@kit.ArkWeb';
import { IFruit } from '../util';
import { FruitList } from './components/fruitList';

class LinkClass {
  messageFromHtml(value: string) {
    console.log('messageFromHtml value', value)
  }
}

@Entry({ storage: LocalStorage.getShared() })
@Component
struct WebPage {
  webController: webview.WebviewController = new webview.WebviewController();
  @State linkObj: LinkClass = new LinkClass();
  @StorageLink('fruitList') fruitList: IFruit[] = [];
  @State fruitRandomName: string = '加水果';

  aboutToAppear() {

  }

  build() {
    Column() {
      Text('WebPage')
        .fontSize(60)
        .margin({ bottom: 10 })
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 30 })
        .fontColor('red')
        .fontWeight(FontWeight.Bold)
      // Web component loading H5.
      Web({ src: $rawfile("index.html"), controller: this.webController })
        .zoomAccess(false)
        .aspectRatio(1)
        .margin({ bottom: 10 })
        .javaScriptProxy({
          object: this.linkObj,
          name: 'linkObj',
          methodList: ['messageFromHtml'],
          controller: this.webController
        })
        .width('100%')
        .height(30)

      Button('增加水果')
        .fontSize(20)
        .fontColor('#FFF')
        .width(200)
        .height(40)
        .backgroundColor('blue')
        .borderRadius(5)
        .onClick(() => {

          this.fruitList.push({
            id: Math.random().toString(),
            text: this.fruitRandomName
          })
          this.fruitRandomName += '-A'


        })
      FruitList({ canJumpDetail: false })

    }
    .width('100%')
    .height('100%')
  }
}