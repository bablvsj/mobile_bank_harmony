import { router } from '@kit.ArkUI';

@Entry
@Component
struct TempTaskDetail {
  @State message: string = 'Hello TaskDetail';
  @State paramsDetail:object = router.getParams();

  build() {
    Column() {
      Text(this.message)
        .id('TempTaskDetailHelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })

      if(this.paramsDetail&&this.paramsDetail)
      {
        Text(JSON.stringify(this.paramsDetail))
      }

      Button("Back").onClick(()=>{
        router.back()
      }).alignRules({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      })
    }
    .height('100%')
    .width('100%')
  }
}