import CommonConstants from "../common/constants/CommonConstants"


@Entry
@Component
struct IntroductionPage {
  build() {
    Stack() {
      // 背景图
      // Image($r('app.media.ic_launcher_background'))
      //   .width(CommonConstants.FULL_WIDTH)
      //   .height(CommonConstants.FULL_HEIGHT)
      Column() {
        // 启动页logo
        Image($r('app.media.logo'))
          .width($r('app.float.launcher_logo_size'))
          .height($r('app.float.launcher_logo_size'))
          .margin({ top: CommonConstants.LAUNCHER_IMAGE_MARGIN_TOP })
        // 健康生活文字
        Text($r('app.string.healthy_life_text'))
          .width($r('app.float.launcher_life_text_width'))
          .height($r('app.float.launcher_life_text_height'))
          .healthyLifeTextStyle(FontWeight.Bold,
            CommonConstants.LAUNCHER_LIFE_TEXT_SPACING,
            $r('app.float.launcher_text_title_size'),
            $r('app.color.launcher_text_title_color'))
          .margin({ top: CommonConstants.LAUNCHER_TEXT_TITLE_MARGIN_TOP })
        // 健康生活说明
        Text($r('app.string.healthy_life_introduce'))
          .height(CommonConstants.LAUNCHER_TEXT_INTRODUCE_HEIGHT)
          .healthyLifeTextStyle(FontWeight.Normal,
            CommonConstants.LAUNCHER_TEXT_INTRODUCE_SPACING,
            $r('app.float.launcher_text_introduce_size'),
            $r('app.color.launcher_text_introduce_color'))
          .opacity($r('app.float.launcher_text_opacity'))
          .margin({ top: CommonConstants.LAUNCHER_TEXT_INTRODUCE_MARGIN_TOP })
      }
      .height(CommonConstants.FULL_HEIGHT)
      .width(CommonConstants.FULL_WIDTH)
    }
  }
}

// 健康生活字体公共样式
@Extend(Text) function healthyLifeTextStyle (fontWeight: number,
  textAttribute: number, fontSize: Resource, fontColor: Resource) {
  .fontWeight(fontWeight)
  .letterSpacing(textAttribute)
  .fontSize(fontSize)
  .fontColor(fontColor)
}