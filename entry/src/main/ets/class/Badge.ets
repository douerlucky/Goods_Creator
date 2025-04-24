class Badge{
  public specification:number = 58
  public flash_bottom: string = "app.media.flash_bottom_original" //闪底
  public fb_name:string = '无';
  public film_cover: string = ""//覆膜
  public fc_name:string = '无';
  public oriImg_url: string = '' //原始文件
  public modified_url: string = '' //修改的文件
  public lyric_url: string = '' //台词文件
  public lyric_name:string = '无' //台词名
  public BGM_url: string = '' //背景音乐文件
  public BGM_name: string = ''//背景音乐名
  public video_url: string = '' //视频文件
}

interface Updated_Badge{
  bid: number
  specification:number
  title:string
  img_url:string
  flash_bottom:string
  fb_name:string
  film_cover:string
  fc_name:string
  lyric_url:string
  lyric_name:string
  BGM_url:string
  BGM_name:string
  video_url:string
  update_time:string
}

@Component
struct badgeDisplay
{
  scale_size : number = 1.4
  specification:number = 56
  flash_bottom:string = ''
  film_cover:string = ''
  img_url:string = ''

  build() {
    Stack(){

      Image($r(this.flash_bottom))
        .size({ width: this.specification * this.scale_size, height: this.specification * this.scale_size })
        .clipShape(new Circle({
          width: this.specification * this.scale_size,
          height: this.specification * this.scale_size
        }))
      Image(this.img_url) // 直接使用接口返回的img_url
        .size({ width: this.specification * this.scale_size, height: this.specification * this.scale_size })
        .clipShape(new Circle({
          width: this.specification * this.scale_size,
          height: this.specification * this.scale_size
        }))
      Image($r(this.film_cover))
        .size({ width: this.specification * this.scale_size, height: this.specification * this.scale_size })
        .clipShape(new Circle({
          width: this.specification * this.scale_size,
          height: this.specification * this.scale_size
        }))
        .aspectRatio(1)
        .opacity(1) // 50% 透明度，可根据效果调整
        .blendMode(BlendMode.DARKEN) // 混合模式（可选：Screen、Overlay 等）

    }
  }
}

export default Badge
export {badgeDisplay,Updated_Badge}