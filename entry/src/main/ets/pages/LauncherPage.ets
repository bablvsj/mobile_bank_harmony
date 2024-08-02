import { CommonConstants } from '../common/constants/CommonConstants';
import { common } from '@kit.AbilityKit';
import { preferences } from '@kit.ArkData';
import Logger from "../common/utils/Logger"
import { GlobalContext } from '../common/utils/GlobalContext';
import CustomDialogComponent from '../view/CustomDialogComponent';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct LauncherPage {
  private context?:common.UIAbilityContext;
  private timerId:number = 0;
  private isJumpToIntroduction:boolean = false;
  @State message: string = 'Hello World';

  dialogController:CustomDialogController = new CustomDialogController({
    builder:CustomDialogComponent({
      cancel:()=>{
        this.onCancel();
      },
      confirm:()=>{
        this.onConfirm();
      }
    }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: CommonConstants.DIALOG_CONTROLLER_DY_OFFSET },
    customStyle: true,
    autoCancel: false
  })

  getDataPreference(common:Object){
    // 获取preferences 实例
    return preferences.getPreferences(getContext(common),CommonConstants.PREFERENCES_FILE_NAME)
  }

  onCancel(){
    this.context?.terminateSelf()
  }

  onConfirm(){
    this.saveIsPrivacy();
    this.jumpToAdvertisingPage();
  }

  saveIsPrivacy() {
    let preferences:Promise<preferences.Preferences> = this.getDataPreference(this);

    preferences.then((result:preferences.Preferences)=>{
      let privacyPut = result.put(CommonConstants.PREFERENCES_KEY_PRIVACY,false)  // 将数据写入缓存的Preferences实例中
      result.flush();  // 写入持久化文件
      privacyPut.then(()=>{
        Logger.info("privacy file","读取政策文件状态 写入缓存成功")
      }).catch((err: Error) => {
            Logger.error(CommonConstants.LAUNCHER_PAGE_TAG, '读取政策文件失败, err: ' + err);
          });
    })
  }

  jumpToAdvertisingPage() {
    this.timerId = setTimeout(() => {
      this.isJumpToIntroduction = true;
      router.pushUrl({
        url: CommonConstants.INTRODUCTION_PAGE_URL
      }).catch((error: Error) => {
        Logger.error(CommonConstants.LAUNCHER_PAGE_TAG, 'LauncherPage pushUrl error ' + JSON.stringify(error));
      });
    }, CommonConstants.LAUNCHER_DELAY_TIME);
  }

  onPageShow() {
    this.context = getContext(this) as common.UIAbilityContext;
    this.getDataPreference(this).then((preferences:preferences.Preferences)=>{
      preferences.get(CommonConstants.PREFERENCES_KEY_PRIVACY,true).then((value)=>{
        Logger.info(CommonConstants.LAUNCHER_PAGE_TAG,"onPageShow privacy value:" +value)

        if(value){
          // let isJumpPrivacy: boolean = (GlobalContext.getContext().
          // getObject('isJumpPrivacy') as boolean) ?? false;

          let isJumpPrivacy: boolean = (GlobalContext.getContext().getObject('isJumpPrivacy') as boolean ?? false)

          if(!isJumpPrivacy){
            this.dialogController.open()
          }
        }

      })
    })
    // this.getDataPreference
  }



  build() {
    Column({ space: 16 }) {
      Image($r('app.media.app_icon')).width(80).height(80).margin({ top: 150 })
      Text("Harmony Bank ").fontSize(24).healthyLifeTextStyle(FontWeight.Bold,
        CommonConstants.LAUNCHER_LIFE_TEXT_SPACING,
        $r('app.float.launcher_text_title_size'),
        $r('app.color.launcher_text_title_color'))
      Text("Find the best company stock for your investment").fontSize(12)
        // .healthyLifeTextStyle(FontWeight.Normal,
        // CommonConstants.LAUNCHER_TEXT_INTRODUCE_SPACING,
        // $r('app.float.launcher_text_introduce_size'),
        // $r('app.color.launcher_text_introduce_color'))
    }.height(CommonConstants.FULL_HEIGHT)
    .width(CommonConstants.FULL_WIDTH)
    // .backgroundColor()
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}

@Extend(Text)
function healthyLifeTextStyle(fontWeight: number, textAttribute: number, fontSize: Resource, fontColor: Resource) {
  .fontWeight(fontWeight)
  .letterSpacing(textAttribute)
  .fontSize(fontSize)
  .fontColor(fontColor)
}