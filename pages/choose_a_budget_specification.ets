import * as buttons from "../page_compolents/buttons"
import { router } from '@kit.ArkUI'

@Entry
@Component
struct Choose_a_budget_specification {
  @State specification: number = 58
  dialogController: CustomDialogController = new CustomDialogController({
    builder: MyCustomDialog({
      title: '调整自定义吧唧规格(单位为mm)',
      specification: $specification
    })
  })


  build() {
   Stack()
   {
     Image($r("app.media.Choose_a_buget_specification_background")).expandSafeArea()

     Column({space:20})
     {
       buttons.back_button({content:"主页"}).alignSelf(ItemAlign.Start)
       Blank()
         .height(20)
       Text("选择你想要创作的\n吧唧规格")
         .fontSize(36)
         .fontWeight(FontWeight.Bold)
       buttons.big_button({
         title: "58mm",
         desc: "最常见的大小规格\n" +
           "大多数使用场景\n" +
           "大多数人的选择",
         image_source: $r("app.media.budget_of_58mm")
       })
         .onClick(()=>{
           router.pushUrl({
             url:"pages/choose_flash_bottom",
             params: {
               budget_specification: 58
             }
           })
         })
       buttons.big_button({title:"75mm",
         desc: "更大的大小规格\n" +
           "适用于扎包",
         image_source: $r("app.media.budget_of_75mm")}).onClick(()=>{
         router.pushUrl({
           url:"pages/choose_flash_bottom",
           params: {
             budget_specification: 75
           }
         })
       })
       buttons.big_button({title:"自定义",
         desc: "不受限制\n" +
           "由你自己个性定义",
         image_source: $r("app.media.budget_of_DIY")})
         .onClick(()=> {
           this.dialogController.open()
         })
     }.width('100%')
     .height('100%')
     .padding({left:20,right:20})
   }


  }
}

// 自定义弹窗组件
@CustomDialog
struct MyCustomDialog {
  @Prop title: string = ''
  @Link specification: number
  controller: CustomDialogController = new CustomDialogController({ builder: null }) // 提供默认值

  build() {
    Column() {
      Text(this.title || "请输入内容")
        .fontSize(16)
        .margin(24)
        .padding({ left: 20 })
        .width("100%")

      Row({ space: 20 }) {
        Button("-")
          .onClick(() => {
            if (this.specification > 25) {
              this.specification -= 1
            }
          }).fontSize(18)
        TextInput({ placeholder: this.specification.toString() }).width(100).textAlign(TextAlign.Center)
          .type(InputType.Number)
          .onChange((value: string) => {
            if (Number(value) <= 25) {
              value = '26'
            } else if (Number(value) > 88) {
              value = '100'
            }
            this.specification = Number(value)
          })
        Button("+")
          .onClick(() => {
            if (this.specification < 87) {
              this.specification += 1
            }
          }).fontSize(18)
      }

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('取消')
          .onClick(() => {
            if (this.controller) {
              this.controller.close()
            }
          })
          .backgroundColor(0xffffff)
          .fontColor(Color.Black)

        Button('确定')
          .onClick(() => {
            router.pushUrl({
              url: "pages/choose_flash_bottom",
              params: {
                budget_specification: this.specification
              }
            })
            if (this.controller) {
              this.controller.close()
            }
          })
          .backgroundColor(0xffffff)
          .fontColor(Color.Red)
      }
      .margin({ top: 10, bottom: 10 })
    }
  }
}