import { CommonConstants } from '../common/constants/CommonConstants';
import { GlobalContext } from '../common/utils/GlobalContext';
import { router } from '@kit.ArkUI';
import Logger from "../common/utils/Logger"

@Preview
@CustomDialog
export default struct CustomDialogComponent {
  controller: CustomDialogController = new CustomDialogController({ 'builder': '' });
  cancel: Function = () => {
  };
  confirm: Function = () => {
  };

  build() {
    Column() {
      Column() {
        //
        // 欢迎您使用乐刻运动!
        // 我们非常重视您的个人信息和隐私保护。为了更好地保障您的个人权益，在您使用我们的产品前，请务必审慎阅读《乐刻运动用户协议》和《乐刻用户隐私政策》等乐刻运动《平台协议》内所有条款，尤其是:
        //   1、您向我们提供的信息，包括但不限于姓名、性别、生日、手机号等;
        // 2、基于您的明示授权，我们在您使用服务的过程中获得的信息，这类信息包括您的位置信息、设备信息等;
        // 3、我们如何使用您的信息:为您提供部分个性服务、验证身份等
        // 同意协议并继续
        // 暂不同意，进入浏览模式
        // 不同意，退出应用
        Column() {
          Text($r('app.string.dialog_text_title'))
            .fontColor($r('app.color.dialog_text_color'))
            .fontSize($r('app.float.dialog_text_privacy_size'))
            .textAlign(TextAlign.Center)
            .fontWeight(CommonConstants.DIALOG_TITLE_FONT_WEIGHT)
            .margin({ bottom: 5 })
          Text() {
            Span("我们非常重视您的个人信息和隐私保护。为了更好地保障您的个人权益，在您使用我们的产品前，请务必审慎阅读:")
            Span("《Harmony Bank用户隐私政策》").fontColor($r('app.color.dialog_text_statement_color'))
              .fontSize($r('app.float.dialog_common_text_size'))
              .onClick(() => {
                // globalThis.isJumpPrivacy = true;
                this.controller.close();
                GlobalContext.getContext().setObject('isJumpPrivacy', true);
                router.pushUrl({
                  url: CommonConstants.PRIVACY_PAGE_URL
                }).catch((error: Error) => {
                  Logger.error(CommonConstants.CUSTOM_DIALOG_TAG, 'custom dialog err' + JSON.stringify(error))
                })
              })
            Span("内所有条款，尤其是:")
            Span($r("app.string.dialog_text_privacy_content"))
          }.textIndent(32).fontSize($r('app.float.dialog_common_text_size')).lineHeight(24)
        }

        Row() {
          Text("退出应用")
            .fancy("#ffec7a7a")
            .onClick(() => {
              this.controller.close();
              this.cancel();
            })
          Blank()
            .backgroundColor($r('app.color.dialog_blank_background_color'))
            .width($r('app.float.dialog_blank_width'))
            .height($r('app.float.dialog_blank_height'))
          Text("同意并继续")
            .fancy()
            .onClick(() => {
              this.controller.close();
              this.confirm();
            })
        }
        .margin({ bottom: CommonConstants.DIALOG_ROW_MARGIN_BOTTOM })
      }
      .backgroundColor(Color.White)
      .width(CommonConstants.DIALOG_COMPONENT_WIDTH_PERCENT)
      .padding({ top: 10, left: 10, right: 10 })
      .borderRadius(CommonConstants.DIALOG_BORDER_RADIUS)
    }.width(CommonConstants.FULL_WIDTH)
    .height(CommonConstants.FULL_HEIGHT)
    .justifyContent(FlexAlign.Center)
    .backgroundColor("rgba(186, 185, 185, 0.80)")
  }
}

@Extend(Text)
function fancy(color:string = "#007DFF") {
  .fontColor(color)
  .fontSize($r("app.float.dialog_fancy_text_size"))
  .textAlign(TextAlign.Center)
  .fontWeight(FontWeight.Medium)
  .layoutWeight(CommonConstants.COMMON_LAYOUT_WEIGHT)
}
