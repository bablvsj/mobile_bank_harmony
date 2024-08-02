import { AbilityConstant, UIAbility, Want, Permissions, abilityAccessCtrl, bundleManager } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { TrainsLine, CommonConstants as Const } from '../common/constants/CommonConstants';
import Logger from "../common/utils/Logger"

let selectPage = "";
let currentWindowStage: window.WindowStage | null = null;

export default class EntryAbility extends UIAbility {
  private storage: LocalStorage = new LocalStorage();

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');

    this.restoringData(want, launchParam);

    if (want?.parameters?.params !== undefined) {
      let params: Record<string, string> = JSON.parse(want.parameters.params as string);
      if (params.url === 'train') {
        AppStorage.setOrCreate<number>('bottomTabIndex', want.parameters['bottomTabIndex'] as number);
        switch (Number.parseInt(params.lineIndex)) {
          case TrainsLine.LINE_ONE:
            AppStorage.setOrCreate<boolean>('showLineOne', true);
            break;
          case TrainsLine.LINE_TWO:
            AppStorage.setOrCreate<boolean>('showLineTwo', true);
            break;
          case TrainsLine.LINE_THREE:
            AppStorage.setOrCreate<boolean>('showLineThree', true);
            break;
          default:
            break;
        }
      } else if (params.url === 'introduction') {
        AppStorage.setOrCreate<number>('cardID', want.parameters['id'] as number);
      }
      Logger.info("want parameters params:",JSON.stringify(params))
      selectPage = params.url;
    }
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    // hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    //
    // windowStage.loadContent('pages/LauncherPage', (err: BusinessError<void>, data) => {
    //   if (err.code) {
    //     Logger.error(Const.ENTRY_ABILITY_TAG, 'Failed to load the content. Cause:' + JSON.stringify(err));
    //     return;
    //   }
    //   Logger.info(Const.ENTRY_ABILITY_TAG, 'Succeeded in loading the content. Data: ' + JSON.stringify(data));
    // });

    // Main window is created, set main page for this ability
    // Logger.info('%{public}s', 'Ability onWindowStageCreate');
    // // Set the full screen.
    // this.setFullSize(windowStage);
    let targetPage: string = '';
    // Select different pages based on the transferred targetPage
    Logger.info("selectPage:",selectPage)
    switch (selectPage) {
      case 'train':
        targetPage = 'pages/MainPage';
        break;
      case 'introduction':
        targetPage = 'pages/IntroductionPage';
        break;
      default:
        targetPage = 'pages/Splash';
    }
    if (currentWindowStage === null) {
      currentWindowStage = windowStage;
    }

    windowStage.loadContent(targetPage, (err, data) => {
      if (err.code) {
        Logger.error('Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      Logger.info('Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }


  async checkPermissions(): Promise<void> {
    const permissions: Array<Permissions> = ['ohos.permission.DISTRIBUTED_DATASYNC'];
    let grantStatus: abilityAccessCtrl.GrantStatus = await this.checkAccessToken(permissions[0]);
    // Open the dialog accord to the permission of the user.
    if (grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
      Logger.info('%{public}s', 'Permission already granted.');
    } else {
      let atManager = abilityAccessCtrl.createAtManager();
      try {
        atManager.requestPermissionsFromUser(this.context, permissions);
      } catch (err) {
        Logger.error('catch requestPermissions error');
        return;
      }
    }
  }

  restoringData(want: Want, launchParam: AbilityConstant.LaunchParam) {
    this.checkPermissions();
    // Recovering migrated data from want.
    if (launchParam.launchReason === AbilityConstant.LaunchReason.CONTINUATION && want?.parameters !== undefined) {
      // Recovering migrated data from want.
      AppStorage.setOrCreate<number>('currentZoneId', want.parameters['currentZoneId'] as number);
      AppStorage.setOrCreate<number>('offsetSum', want.parameters['offsetSum'] as number);
      AppStorage.setOrCreate<number>('bottomTabIndex', want.parameters['bottomTabIndex'] as number);
      AppStorage.setOrCreate<number>('imageHeight', want.parameters['imageHeight'] as number);
      AppStorage.setOrCreate<number>('arrowIconOpacity', want.parameters['arrowIconOpacity'] as number);
      AppStorage.setOrCreate<number>('aheadIndex', want.parameters['aheadIndex'] as number)
      AppStorage.setOrCreate<string>('isContinuation', Const.CAN_CONTINUATION);
      AppStorage.setOrCreate<number>('imageId', want.parameters['imageId'] as number);
      AppStorage.setOrCreate<boolean>('imageModalOpen', want.parameters['imageModalOpen'] as boolean);
      AppStorage.setOrCreate<number>('positionType', want.parameters['positionType'] as number);
      AppStorage.setOrCreate<number>('panelOpacity', want.parameters['panelOpacity'] as number);
      AppStorage.setOrCreate<number>('panelHeight', want.parameters['panelHeight'] as number);
      AppStorage.setOrCreate<number>('iconOpacity', want.parameters['iconOpacity'] as number);
      AppStorage.setOrCreate<boolean>('isDownImage', want.parameters['isDownImage'] as boolean);
      AppStorage.setOrCreate<string>('searchInput', want.parameters['searchInput'] as string);
      AppStorage.setOrCreate<boolean>('showLineOne', want.parameters['showLineOne'] as boolean);
      AppStorage.setOrCreate<boolean>('showLineTwo', want.parameters['showLineTwo'] as boolean);
      AppStorage.setOrCreate<boolean>('showLineThree', want.parameters['showLineThree'] as boolean);
      AppStorage.setOrCreate<number>('curIndex', want.parameters['curIndex'] as number);
      this.storage = new LocalStorage();
      this.context.restoreWindowStage(this.storage);
    }
  }

  async checkAccessToken(permission: Permissions): Promise<abilityAccessCtrl.GrantStatus> {
    let atManager = abilityAccessCtrl.createAtManager();
    let grantStatus: abilityAccessCtrl.GrantStatus = abilityAccessCtrl.GrantStatus.PERMISSION_DENIED;
    // Obtain the accessTokenID of the application
    let tokenId: number = 0;
    try {
      let bundleInfo: bundleManager.BundleInfo =
        await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
      let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
      tokenId = appInfo.accessTokenId;
    } catch (err) {
      Logger.error('Failed to get bundle info for self.');
    }
    // Check whether the permission is granted to the application
    try {
      grantStatus = await atManager.checkAccessToken(tokenId, permission);
    } catch (err) {
      Logger.error('Failed to check access token.');
    }
    return grantStatus;
  }

  onWindowStageRestore(windowStage: window.WindowStage) {
    this.setFullSize(windowStage);
  }

  setFullSize(windowStage: window.WindowStage) {
    let windowClass: window.Window | null = null;
    windowStage.getMainWindow((err, data) => {
      if (err.code) {
        return;
      }
      windowClass = data;
      let isLayoutFullScreen = true;
      windowClass.setWindowLayoutFullScreen(isLayoutFullScreen, (err) => {
        if (err.code) {
          return;
        }
      });
    })
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
