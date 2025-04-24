import * as buttons from "../../page_compolents/buttons"
import { prompt, router } from '@kit.ArkUI'
import Badge, { badgeDisplay } from '../../class/Badge'
import {search_lyrics,search_bgms} from '../../page_compolents/searchData'
import { AVPlayerDemo } from "../../page_compolents/audio_play"

const scale_size =3.5

@Entry
@Component
struct Choose_Interaction {
  @StorageLink('taskid') taskid:string = ''
  @StorageLink('uid') uid:string = ''
  @StorageLink('badge_create') badge_create:Badge = { } as Badge
  @State now_img: string = this.badge_create.modified_url
  @State now_lyric:string = ''
  @State now_lyric_name: string = '无'
  @State isShow_choose_lyrics: boolean = false
  @State now_BGM:string = ''
  @State now_BGM_name: string = '无'
  @State isShow_choose_BGM: boolean = false
  @State now_video:string = ''
  @State isShow_generate_videos: boolean = false
  @State lyric_audio:AVPlayerDemo = new AVPlayerDemo
  @State bgm_audio:AVPlayerDemo = new AVPlayerDemo
  @State isBGMPlay:boolean = false
  @State now_film_cover: string = this.badge_create.film_cover

  @Builder select_sheet_lyrics() {
    choose_lyrics({
      selectedLyricsUrl: $now_lyric, // 使用 @Link 传递状态
      selectedLyricsname: $now_lyric_name,
      isShow_choose_lyrics: $isShow_choose_lyrics // 使用 @Link 传递状态
    })
  }

  @Builder select_sheet_BGMs() {
    choose_BGMs({
      selectedBGMUrl: $now_BGM, // 使用 @Link 传递状态
      selectedBGMname: $now_BGM_name,
      isShow_choose_BGM: $isShow_choose_BGM // 使用 @Link 传递状态
    })
  }

  @Builder sheet_generate_videos() {
    generate_videos({
      video_url: $now_video, // 使用 @Link 传递状态
      isShow_generate_videos: $isShow_generate_videos // 使用 @Link 传递状态
    })
  }

  build() {
    Stack() {
      Image($r("app.media.select_flash_back_backgroud")).expandSafeArea()
      Column({ space: 20 }) {
        Column()

        {
        buttons.back_button({ content: "上一步" }).alignSelf(ItemAlign.Start).padding({bottom:20})
        Blank()
          .height(20)

          Row()
          {

            Text("徽章互动化")
              .fontSize(36)
              .fontWeight(FontWeight.Bold)
              .alignSelf(ItemAlign.Start)
            if(this.now_BGM != '')
            {
              Button()
              {Image($r("app.media.identify_song")).size({width:20,height:20})}
              .padding(5)
              .onClick(async () => {
                if(this.isBGMPlay)
                {
                  this.bgm_audio.togglePlayPause()
                  this.isBGMPlay = !this.isBGMPlay
                }
                else
                {
                  this.bgm_audio.setPlayUrl(this.now_BGM)
                  this.isBGMPlay = !this.isBGMPlay
                }

              })


            }
          }.width('100%')
          }

        Column()
        {
          badgeDisplay({
            scale_size:scale_size,
            specification:this.badge_create.specification,
            flash_bottom:this.badge_create.flash_bottom,
            film_cover:this.now_film_cover,
            img_url:this.now_img
          })
            .onClick(async ()=>{
              if(this.now_lyric)
              {
                await this.lyric_audio.avPlayerLiveDemo(this.now_lyric)
                this.lyric_audio.replay()
              }
            })

        }.width('100%')
        .height(280)
        Column({space:20}) {
          buttons.long_function_button({
            text:"AI生成动态徽章",
            icon:$r("app.media.icon_dynamic")
          })
            .onClick(() => {
              this.isShow_generate_videos = true
            })
            .bindSheet($$this.isShow_generate_videos, this.sheet_generate_videos(), {
              detents: [SheetSize.LARGE],
              title: { title: "使用AI生成动态徽章" }

            })

          buttons.long_function_button({
            text:"选择台词",
            icon:$r("app.media.icon_dialog")
          }).onClick(() => {
            this.isShow_choose_lyrics = true

          })
            .bindSheet($$this.isShow_choose_lyrics, this.select_sheet_lyrics(), {
              detents: [SheetSize.LARGE],
              title: { title: "选择一个台词" }
            })

          buttons.long_function_button({
            text:"选择背景音乐",
            icon:$r("app.media.icon_bgm")
          }).onClick(() => {
            this.isShow_choose_BGM = true
          })
            .bindSheet($$this.isShow_choose_BGM, this.select_sheet_BGMs(), {
              detents: [SheetSize.LARGE],
              title: { title: "选择一个背景音乐" }
            })
        }
        .justifyContent(FlexAlign.Center)

        buttons.next_step_button()
          .onClick(()=>{

            this.badge_create.BGM_url = this.now_BGM
            this.badge_create.BGM_name = this.now_BGM_name
            this.badge_create.lyric_url = this.now_lyric
            this.badge_create.lyric_name = this.now_lyric_name
            this.badge_create.video_url = this.now_video
            router.pushUrl({ url: 'pages/Badge_Create_pages/completed' })

          })


      }.width('100%')
      .height('100%')
      .padding({ left: 20, right: 20 })
      .justifyContent(FlexAlign.SpaceBetween)
    }
  }
}

interface lyrics_information{
  lid:number
  title:string
  cv:string
  lyric_url:string
}

@Component
struct choose_lyrics {
  @Link selectedLyricsUrl: string; // 使用 @Link 接收父组件的状态
  @Link selectedLyricsname: string;
  @Link isShow_choose_lyrics: boolean; // 使用 @Link 接收父组件的状态
  @State lyrics: lyrics_information[] = [];
  @State audio:AVPlayerDemo = new AVPlayerDemo
  async aboutToAppear(): Promise<void> {
    this.lyrics = await search_lyrics("")
  }
  aboutToDisappear(): void {
    // 当选择歌词面板消失时，暂停音频并释放资源
    this.audio.pause();
    this.audio.release();
  }
  build() {
    Column() {
      Button('不使用台词')
        .buttonStyle(ButtonStyleMode.TEXTUAL)
        .width('100%')
        .onClick(() => {
          this.selectedLyricsUrl = ""; // 更新父组件的状态
          this.selectedLyricsname = '无';
          this.isShow_choose_lyrics = false; // 关闭选择面板
          this.audio.pause()
          this.audio.release()
        })
      Search({ placeholder: "搜索台词内容/角色名" })
        .width('90%')
        .searchButton("搜索")
        .onSubmit(async (query_name:string)=>{
          console.log(query_name)
          this.lyrics = await search_lyrics(query_name)
        })
      Scroll() {
        Column({space:10}) {
          ForEach(this.lyrics, (item: lyrics_information) => {
            Column()
            {
              Row()
              {
                Column()
                {
                  Text(item.title)
                    .fontSize(24)
                    .fontWeight(FontWeight.Bold)
                    .width('100%')
                  Text(item.cv)
                    .fontSize(16)
                    .fontWeight(FontWeight.Lighter)
                    .width('100%')
                }.layoutWeight(4)
                if(this.selectedLyricsUrl != item.lyric_url )
                {
                  Row({space:10})
                  {
                    Button()
                    {Image($r("app.media.identify_song")).size({width:20,height:20})}
                    .padding(5)
                    .onClick(async ()=>{
                      // 1. 加载新地址（首次调用或切换地址时使用）
                      await this.audio.setPlayUrl(item.lyric_url);
                      // 2. 立即重新播放
                      this.audio.replay();
                    })
                    Button()
                    {Image($r("app.media.checkmark")).size({width:20,height:20})}
                    .padding(5)
                    .onClick(()=>{
                      this.isShow_choose_lyrics = false;
                      this.selectedLyricsUrl = item.lyric_url
                      this.selectedLyricsname = item.title
                      this.audio.pause()
                      this.audio.release()
                    })
                  }

                }
                else
                {
                  Text("已选择")
                }

              }

            }
            .width('90%')
              .borderRadius(16)
              .backgroundColor('#E7EAEB')
            .padding(20)
          })
        }.width('90%')

        .margin(20)
        .borderRadius(32)
      }
      .height(550)
    }
  }
}

interface Bgms_information{
  bgmid:number
  title:string
  author:string
  bgm_url:string
}


@Component
struct choose_BGMs {
  @Link selectedBGMUrl: string; // 使用 @Link 接收父组件的状态
  @Link selectedBGMname:string;
  @Link isShow_choose_BGM: boolean; // 使用 @Link 接收父组件的状态
  @State lyrics: lyrics_information[] = [];
  @State bgms: Bgms_information[] = [
    {
      bgmid: 1,
      title: "BGM 1",
      author: "Author 1",
      bgm_url: "url1"
    },
    {
      bgmid: 2,
      title: "BGM 2",
      author: "Author 2",
      bgm_url: "url2"
    },
    {
      bgmid: 3,
      title: "BGM 3",
      author: "Author 3",
      bgm_url: "url3"
    }
  ];
  @State audio:AVPlayerDemo = new AVPlayerDemo
  async aboutToAppear(): Promise<void> {
    this.bgms = await search_bgms("")
  }
  aboutToDisappear(): void {
    // 当选择歌词面板消失时，暂停音频并释放资源
    this.audio.pause();
    this.audio.release();
  }
  build() {
    Column() {
      Button('不使用背景音乐')
        .buttonStyle(ButtonStyleMode.TEXTUAL)
        .width('100%')
        .onClick(() => {
          this.selectedBGMUrl = ""; // 更新父组件的状态
          this.selectedBGMname = '无';
          this.isShow_choose_BGM = false; // 关闭选择面板
          this.audio.pause()
          this.audio.release()
        })


      Column() {
        Search({ placeholder: "搜索音乐名/IP" })
          .width('90%')
          .searchButton("搜索")
        Scroll() {
          Grid() {
            ForEach(this.bgms, (item: Bgms_information) => {
              GridItem() {
                Column({ space: 5 }) {
                  Column({space:5}) {
                    Text(item.title)
                      .fontSize(16)
                      .fontWeight(FontWeight.Bold);
                    Text(item.author)
                      .fontColor(Color.Gray)
                  }
                  if(this.selectedBGMUrl != item.bgm_url )
                  {
                    Row({space:10})
                    {
                      Button()
                      {Image($r("app.media.identify_song")).size({width:20,height:20})}
                      .padding(5)
                      .onClick(()=>{
                        this.audio.setPlayUrl(item.bgm_url)
                        this.audio.replay()

                      })
                      Button()
                      {Image($r("app.media.checkmark")).size({width:20,height:20})}
                      .padding(5)
                      .onClick(()=>{
                        this.isShow_choose_BGM = false;
                        this.selectedBGMUrl = item.bgm_url
                        this.selectedBGMname = item.title
                        this.audio.pause()
                        this.audio.release()
                      })
                    }

                  }
                  else
                  {
                    Text("已选择")
                  }
                }
              }
              .backgroundColor('#E7EAEB')
              .padding({ top: 10, bottom: 10 })
              .borderRadius(16)
            });
          }
          .columnsTemplate('2fr 2fr')
          .width('100%')
          .height('100%')
          .rowsGap(20)
          .columnsGap(20);
        }.width('90%')
        .height('100%')
        .padding(5)
      }.width('100%')

    }
  }
}

@Component
struct generate_videos {
  @Link video_url: string; // 父组件视频URL
  @Link isShow_generate_videos: boolean; // 模态显示状态
  @State isGenerating: boolean = false; // 生成状态（替代isButtonEnabled）
  @State prompt: string = '帮我生成视频';
  private controller: VideoController = new VideoController()

  // ✅ 异步生成视频函数
  private async handleGenerate() {
    this.isGenerating = true; // 锁定状态
    try {
      // 模拟API调用（实际需替换为真实接口）
      this.video_url = "https://prod-ss-vidu.s3.cn-northwest-1.amazonaws.com.cn/infer/tasks/25/0423/17/812672482682093568/creation-01/video.mp4?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIARRHG6JR7EMNHVUWT%2F20250423%2Fcn-northwest-1%2Fs3%2Faws4_request&X-Amz-Date=20250423T170305Z&X-Amz-Expires=86400&X-Amz-SignedHeaders=host&response-cache-control=max-age%3D86400&response-content-disposition=attachment%3Bfilename%3Dvidu-general-4-2025-04-23T17%253A02%253A59Z.mp4&x-id=GetObject&X-Amz-Signature=3d61004a215582c9161e6b1e0445e499b61a9a4e94cba7911eed2983d399186b"; // 更新父组件URL
      prompt.showToast({message:"视频生成成功"})
      this.isShow_generate_videos = false; // 生成完成后关闭模态
    } catch (error) {
      console.error('视频生成失败:', error);
      prompt.showToast({ message: '生成失败，请重试' });
    } finally {
      this.isGenerating = false; // 释放状态
    }
  }

  build() {
    Column() {
      // 禁止退出按钮（模态关闭控制）
      if (this.isGenerating) {
        Text('生成中...')
          .fontSize(14)
          .fontColor(Color.Gray)
          .margin({ bottom: 10 });
      } else {
        Button('不使用动态徽章')
          .buttonStyle(ButtonStyleMode.TEXTUAL)
          .width('100%')
          .onClick(() => {
            this.isShow_generate_videos = false; // 允许正常关闭
          });
      }

      // 生成输入框和按钮
      Column({space:20}) {
        if(this.video_url == '')
        {
          Image($r('app.media.image_blank'))
            .size({width:300,height:300})
            .borderRadius(32)

        }
        else
        {
          Video({src:this.video_url,controller: this.controller})
            .controls(false) // 设置是否显示默认控制条
            .autoPlay(true) // 设置是否自动播放
            .onFinish(()=>{
              this.controller.setCurrentTime(0)
            })
            .size({width:300,height:300})
            .clipShape(new Circle({
              width: 300,
              height: 300
            })).onClick(()=>{
              this.controller.reset()
          })
        }
        Row({ space: 8 }) {
          Image($r('app.media.ai_ass')).height(22);
          TextInput({ placeholder: "输入一段描述，让AI生成动态徽章！" })
            .width('90%')
            .fontSize(12)
            .placeholderFont({ size: 12 })
            .backgroundColor('#FFFFFFFF')
            .onChange((content: string) => this.prompt = content);
        }
        .padding({left:10})
        .width('90%')
        .height(34)
        .backgroundColor('#ffffffff')
        .borderRadius(16)
        .alignItems(VerticalAlign.Center);
        // ✅ 生成按钮状态控制
        Button(this.isGenerating ? '生成中' : '生成')
          .enabled(!this.isGenerating) // 生成中禁用点击
          .onClick(() => this.handleGenerate()); // 触发异步生成
      }
    }
    .width('100%')
    .padding({ left: 20, right: 20 });
  }
}