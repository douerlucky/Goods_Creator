import * as buttons from '../page_compolents/buttons'
import PickerPhoto from '../page_compolents/file_update'
@Entry
@Component
struct Upload_picture {
  @State imgSrc:string | undefined = ''

  build() {
    Stack() {
        Image($r("app.media.select_flash_back_backgroud")).expandSafeArea()
      Column({ space: 20 }) {
        buttons.back_button()
          .alignSelf(ItemAlign.Start)
        Blank()
          .height(20)
        Text("打印柄图")
          .fontSize(36)
          .fontWeight(FontWeight.Bold)
          .alignSelf(ItemAlign.Start)
        Column()
        {
          Image(this.imgSrc)
            .width('100%')
            .height('100%')
            .borderRadius(8)
        }
        .width('70%')
        .height(300)
        .backgroundColor(Color.White)
        .borderRadius(8)
        .padding(20)

        Column() {
          Image($r('app.media.photo_galaary'))
            .width(42)
          Text("点击此处选择图片")
            .fontColor('#8F91AC')
            .fontSize(24)
        }
        .justifyContent(FlexAlign.Center)
        .borderWidth(3)
        .width('100%')
        .height(130)
        .borderStyle(BorderStyle.Dashed)
        .borderColor('#8F91AC')
        .onClick(async () => {
          const res = await PickerPhoto()
          this.imgSrc = res
        })
        buttons.next_step_button()
      }.width('100%')
      .height('100%')
      .padding({ left: 20, right: 20 })


    }
  }
}