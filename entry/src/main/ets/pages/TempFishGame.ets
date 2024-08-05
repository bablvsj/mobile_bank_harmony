import { CommonConstants as Const } from '../common/constants/CommonConstants';
import { router, window } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct TempFishGame {
  @State message: string = 'Hello World';
  @State fishX: number = 200
  @State fishY: number = 100
  // 小鱼角度
  @State angle: number = 0
  // 小鱼图片
  @State src: Resource = $r('app.media.fish')
  // 是否开始游戏
  @State isBegin: boolean = false
  // 摇杆中心区域坐标
  private centerX: number = 100
  private centerY: number = 180
  // 大、小圆半径
  private maxRadius: number = 80
  private radius: number = 20
  // 摇杆小圆球初始位置
  @State positionX: number = this.centerX;
  @State positionY: number = this.centerY;

  build() {
    Row() {
      Stack() {
        // 返回按钮
        Button('返回')
          .position({ x: 0, y: 0 })
          .backgroundColor('#20101010')
          .onClick(() => {
            // 返回上一页
            router.back()
          })

        if (!this.isBegin) {
          // 开始按钮
          Button('开始游戏')
            .onClick(() => {
              animateTo(
                { duration: 1000 },
                () => {
                  // 点击后显示小鱼
                  this.isBegin = true
                }
              )
            })

        } else {
          // 小鱼图片
          Image(this.src)
            .position({ x: this.fishX - 20, y: this.fishY - 20 })
            .rotate({ angle: this.angle, centerX: '50%', centerY: '50%' })
            .width(40)
            .height(40)//.animation({duration: 500, curve: Curve.Smooth})
            .transition({
              type: TransitionType.Insert,
              opacity: 0,
              translate: { x: -250 }
            })


          // Row() {
          //   Button('←').backgroundColor('#20101010')
          //     .onClick(() => {
          //       animateTo(
          //         { duration: 500 },
          //         () => {
          //           this.fishX -= 20
          //           this.src = $r('app.media.fish_rev')
          //         }
          //       )
          //     })
          //   Column({ space: 40 }) {
          //     Button('↑').backgroundColor('#20101010')
          //       .onClick(() => {
          //         animateTo(
          //           { duration: 500 },
          //           () => {
          //             this.fishY -= 20
          //           }
          //         )
          //       })
          //     Button('↓').backgroundColor('#20101010')
          //       .onClick(() => {
          //         animateTo(
          //           { duration: 500 },
          //           () => {
          //             this.fishY += 20
          //           }
          //         )
          //       })
          //   }
          //
          //   Button('→').backgroundColor('#20101010')
          //     .onClick(() => {
          //       animateTo(
          //         { duration: 500 },
          //         () => {
          //           this.fishX += 20
          //           this.src = $r('app.media.fish')
          //         }
          //       )
          //     })
          // }
          // .height(240)
          // .width(240)
          // .justifyContent(FlexAlign.Center)
          // .position({ x: -20, y: 50 })
        }


        // 操作按钮
        Row() {
          Circle({ width: this.maxRadius * 2, height: this.maxRadius * 2 })
            .fill("#20101010")
            .position({ x: this.centerX - this.maxRadius, y: this.centerY - this.maxRadius })
            .onTouch(this.handleTouchEvent)
          Circle({ width: this.radius * 2, height: this.radius * 2 })
            .fill("#403A3a3a")
            .position({ x: this.positionX - this.radius, y: this.positionY - this.radius })
        }

      }
      .height('100%').width('100%')
    }
    .height('100%')
    .width('100%')
    .backgroundImage($r('app.media.sea'))
    .backgroundImageSize({ height: '105%', width: '100%' })
  }

  handleTouchEvent(event: TouchEvent) {
    // 获取手指位置坐标

    let x = event.touches[0].x
    let y = event.touches[0].y

    //    计算手指与中心点的坐标差值
    let vx = x - this.centerX;
    let vy = y - this.centerY;


    //   计算手指与中心点连线和x轴正半轴的夹角,单位弧度
    let angle = Math.atan2(vy, vx);


    //    计算手指与中心点的距离，最大为外圆的半径。

    let distance = this.getDistance(vx, vy)


    // 计算距离

    this.positionX = this.centerX


  }

  getDistance(x: number, y: number) {
    let d = Math.sqrt(x * x + y * y)
    return Math.min(d,this.maxRadius)
  }
}

