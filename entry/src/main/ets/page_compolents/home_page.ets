import {router} from '@kit.ArkUI'
import * as buttons from '../page_compolents/buttons'
import { search_user_Badges } from '../page_compolents/searchData'; // 假设此文件包含接口定义
import { badgeDisplay,Updated_Badge } from '../class/Badge'; // 假设此文件包含接口定义
import { speechRecognizer } from '@kit.CoreSpeechKit';

const scale_size:number = 1.4


@Preview
@Component
struct home_page {
  @StorageLink('uid') uid:string = '3'
  @State myBadge:Updated_Badge[] = []
  async aboutToAppear() {
    this.myBadge = await search_user_Badges(this.uid)
  }

  build() {

      Column()
      {
        Button("debug room").onClick(()=>{
          router.pushUrl({
            url:"pages/Debug_pages/debug_room"
          })
        })
        Search({placeholder:'搜索收藏'}).width('90%')
          .searchButton("搜索")
        Row({space : 15})
        {
          Text("我的收藏馆")
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
          Image($r('app.media.more'))
            .width(10)
          Blank().width(10)
          Image($r('app.media.add_folder'))
            .width(36)
          Image($r('app.media.user_info'))
            .width(36)
            .onClick(()=>{
              router.pushUrl({
                url: "pages/account_etc/user_info",
              })
            })

        }.width('100%')
        // 使用Grid布局主体内容
        Grid() {
          ForEach(this.myBadge, (item: Updated_Badge) => {
            GridItem() {
            Column({ space: 5 }){
             Column() {
               badgeDisplay({
                 scale_size:scale_size,
                 specification:item.specification,
                 flash_bottom:item.flash_bottom,
                 film_cover:item.film_cover,
                 img_url:item.img_url
               })


             }
             .size({ width: 140, height: 140 })
             .borderRadius(32)
             .backgroundColor('#F5F5F5')
             .justifyContent(FlexAlign.Center)
             Text(item.title)
           }.onClick(()=>{
             router.pushUrl({
               url:"pages/badgeMannage/badgeDetails",
               params: item // 添加params属性，传递自定义参数
             })
            })
            }
          })
        }
        .columnsTemplate('1fr 1fr')
        .rowsGap(10)
        .layoutWeight(1)
        .margin({ top: 20 })
      }.padding({left:20,right:20})
    .width('100%')
    .height('100%')
  }
}

export default home_page