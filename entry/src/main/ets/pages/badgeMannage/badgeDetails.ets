import { badgeDisplay,Updated_Badge } from '../../class/Badge'
import * as buttons from '../../page_compolents/buttons'
import { Font } from '@ohos.arkui.UIContext'
import { promptAction, router } from '@kit.ArkUI'
import { deleteBadge } from '../../page_compolents/deleteImage'
import { AVPlayerDemo } from "../../page_compolents/audio_play"

// 定义谷子信息接口
const scale_size:number = 3.5
let badge: Updated_Badge = router.getParams() as Updated_Badge; // 获取传递过来的参数对象

// interface GeneratedObjectLiteralInterface_1 {
//   bid: number;
//   specification: number;
//   title: string;
//   img_url: string;
//   flash_bottom: string;
//   film_cover: string;
//   lyric_url: string;
//   BGM_url: string;
//   video_url: string;
//   update_time: string;
// }
//
// let badge: Updated_Badge={
//   bid: 1,
//   specification:56,
//   title:'123',
//   img_url:'https://goods-creator-data.oss-cn-hangzhou.aliyuncs.com/images/badge_images/1_yll.png',
//   flash_bottom:'',
//   film_cover:'',
//   lyric_url:'',
//   BGM_url:'',
//   video_url:'',
//   update_time:''
//
// } as Updated_Badge

@Entry
@Component
struct MyGoodsPage {
  @StorageLink('uid') uid:string = ''
  @State private isMenuVisible: boolean = false;
  @State lyric_audio:AVPlayerDemo = new AVPlayerDemo
  @State bgm_audio:AVPlayerDemo = new AVPlayerDemo
  @State islyricPlay:boolean =  false
  @State isBGMPlay:boolean = false
  

  onPageHide() {
    // 页面隐藏时释放音频资源
    this.lyric_audio.release()
    this.bgm_audio.release()
  }

  // 显示确认删除对话框
  private showDeleteDialog() {
    const dialog: AlertDialogParamWithConfirm = {
      title: "确认删除",
      message: "您确定要删除此项吗？",
      confirm: {
        value: "确定",
        action: async () => {
          // 执行删除操作
          this.lyric_audio.release()
          this.bgm_audio.release()
          promptAction.showToast({ message: "已删除" });
          await deleteBadge(badge.bid.toString(),this.uid )
          router.clear()
          router.pushUrl({url: "pages/Index"})
          router.clear()
        }
      },
      cancel: () => {
        // 取消删除操作
        promptAction.showToast({ message: "已取消删除" });
      }
    };
    AlertDialog.show(dialog);
  }
  @State isShow: boolean = false
  @Builder more_info() {
    more_info({
      badge_info: badge, // 使用 @Link 传递状态
      isShow: $isShow // 使用 @Link 传递状态
    })
  }

  build() {
    Stack(){
      Image($r('app.media.badgeDetail'))
        .expandSafeArea()
      Column(){
        Column()
        {
          Row() {
            buttons.back_button()
              .layoutWeight(1)
            Text(badge.title)
              .width('100%')
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Center)
              .layoutWeight(1)
            Blank().layoutWeight(1)
          }
          .width('90%')
          .height(50)
          .borderRadius(32)
          .shadow(ShadowStyle.OUTER_DEFAULT_MD)
          .backgroundColor('#99f5f5f5')
          .padding({left:10})
        }


        Column() {

          badgeDisplay({
            scale_size:scale_size,
            specification:badge.specification,
            flash_bottom:badge.flash_bottom,
            film_cover:badge.film_cover,
            img_url:badge.img_url
          }).onClick(()=>{
            if(badge.lyric_url)
            {
              if(this.islyricPlay)
              {
                this.lyric_audio.togglePlayPause()
                this.islyricPlay = !this.islyricPlay
              }
              else
              {
                this.lyric_audio.setPlayUrl(badge.lyric_url)
                this.islyricPlay = !this.islyricPlay
              }
            }

          })
        }
        .width('100%')
        .margin({ top:25,bottom:25 })
        Row(){
          buttons.mini_button({icon:$r('app.media.icon_download'),text:"下载"})
          buttons.mini_button({icon:$r('app.media.more_information'),text:"详情"})
            .onClick(() => {
              this.isShow = true
            })
            .bindSheet($$this.isShow, this.more_info(), {
              detents: [SheetSize.MEDIUM, SheetSize.LARGE, 350],
              title: { title: "徽章信息" }
            })
          buttons.mini_button({icon:$r('app.media.delete'),text:"删除"})
            .bindMenu([
              {
                value: "确认删除",
                action: () => {
                  this.showDeleteDialog();
                }
              }
            ])
        }.width('80%')
        .height(60)
        .backgroundColor('#99f5f5f5')
        .borderRadius(32)
        .shadow(ShadowStyle.OUTER_DEFAULT_MD)
        .justifyContent(FlexAlign.SpaceEvenly)
      }.height('100%')
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Row({space:20})
      {
        if(badge.lyric_url)
         Image($r("app.media.icon_dialog")).width(24)
        if(badge.BGM_url)
          Image($r("app.media.icon_bgm")).width(24)
      }.offset({x:-140,y:-290})
      .borderRadius(32)
      .backgroundColor('#99f5f5f5')
      .padding({left:20,right:20,top:10,bottom:10})
      .shadow(ShadowStyle.OUTER_DEFAULT_MD)
      if(badge.BGM_url)
      {
        Button()
        {Row({space:5}){
          Image($r("app.media.identify_song")).size({width:20,height:20})
          if(!this.isBGMPlay)
            Text("播放背景音乐")
              .fontColor( Color.White)
          else
            Text("暂停背景音乐")
              .fontColor( Color.White)
        }}
        .padding(5)
        .onClick(()=>{
          if(this.isBGMPlay)
          {
            this.bgm_audio.togglePlayPause()
            this.isBGMPlay = !this.isBGMPlay
          }
          else
          {
            this.bgm_audio.setPlayUrl(badge.BGM_url)
            this.isBGMPlay = !this.isBGMPlay
          }

        }).offset({y:250})
        .borderRadius(32)
        .padding({left:20,right:20,top:10,bottom:10})
        .shadow(ShadowStyle.OUTER_DEFAULT_MD)

      }

    }
    }
}

class DividerTmp {
  strokeWidth: Length = 1
  startMargin: Length = 60
  endMargin: Length = 10
  color: ResourceColor = '#ffe9f0f0'

  constructor(strokeWidth: Length, startMargin: Length, endMargin: Length, color: ResourceColor) {
    this.strokeWidth = strokeWidth
    this.startMargin = startMargin
    this.endMargin = endMargin
    this.color = color
  }
}


@Component
struct more_info {
  @State egDivider: DividerTmp = new DividerTmp(1, 60, 10, '#ffe9f0f0')
  @Prop badge_info: Updated_Badge; // 使用 @Link 接收父组件的状态
  @Link isShow: boolean; // 使用 @Link 接收父组件的状态
  @Builder itemHead(text: string) {
    // 列表分组的头部组件，对应联系人分组A、B等位置的组件
    Text(text)
      .fontSize(20)
      .backgroundColor('#fff1f3f5')
      .width('100%')
      .padding(5)
  }
  build() {
    List() {
      ListItemGroup({ header: this.itemHead('基本信息') }){
        ListItem(){
          Column({space:5}){
            infos({title:"徽章ID",content:this.badge_info.bid.toString()})
            infos({title:"规格",content:`${this.badge_info.specification.toString()} mm`})
            infos({title:"名称",content:this.badge_info.title})
            infos({title:"上传时间",content:this.badge_info.update_time})
          }
        }
      }
      ListItemGroup({ header: this.itemHead('高级信息') }){
        ListItem(){
          Column({space:5}){
            infos({title:"闪底名称",content:this.badge_info.fb_name})
            infos({title:"覆膜名称",content:this.badge_info.fc_name})
            infos({title:"台词名称",content:this.badge_info.lyric_name})
            infos({title:"背景音乐名称",content:this.badge_info.BGM_name})
          }
        }
      }
    }
    .width('90%')
    .divider(this.egDivider)
    .scrollBar(BarState.Auto)
    }
}

@Component
struct infos{
  public title:string = ''
  public content:string = ''
  build() {
    Row()
    {
      Text(this.title).fontWeight(FontWeight.Bold).textAlign(TextAlign.Center).width('50%')
      Text(this.content).textAlign(TextAlign.Center).width('50%')
    }
    .backgroundColor(Color.White)
    .height(30)
    .width('100%')
    .borderRadius(16)
    .justifyContent(FlexAlign.SpaceBetween)
  }
}