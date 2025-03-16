import { router } from '@kit.ArkUI';

@Entry
@Component
struct Debug_room {
  @State message: string = 'Hello World';
  build() {
    Column()
    {
      Button("网络测试").onClick(()=>{
        router.pushUrl({
          url:"pages/Internet"
        })
      })
      Button("上传测试").onClick(()=>{
        router.pushUrl({
          url:"pages/upload_test"
        })
      })
      Button("ECS测试").onClick(()=>{
        router.pushUrl({
          url:"pages/Server_Test"
        })
      })
      Button("图片网络显示测试").onClick(()=>{
        router.pushUrl({
          url:"pages/show_image_test"
        })
      })
    }
  }
}