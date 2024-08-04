// @Provide 与 @Consume
import { router } from '@kit.ArkUI';

// Observed 与 @ObjectLink

@Entry
@Component
struct TempProvideConsume {
  @Provide state: TaskState = new TaskState();

  build() {
    Column({ space: 20 }) {
      TaskStatistics()
      TaskList()
    }.backgroundColor("#ffe7e5e5").padding(10)
  }
}


@Observed
class Task {
  static id: number = 1
  name: string = "任务" + Task.id++;
  finished: boolean = false;

  constructor(name: string = "任务" + Task.id++, status: boolean = false) {
    this.name = name;
    this.finished = status
  }
}


class TaskState {
  total: number = 0
  finished: number = 0
}


@Component
struct TaskStatistics {
  @Consume state: TaskState

  build() {
    Row() {
      Text("任务进度:").fontSize(24).fontWeight(FontWeight.Bold)
      Stack() {
        Progress({
          type: ProgressType.Ring,
          value: this.state.finished,
          total: this.state.total
        })
        Row() {
          Text(this.state.finished.toString()).fontColor("#36d").fontSize(20)
          Text(' / ' + this.state.total).fontSize(20)
        }
      }
    }
    .justifyContent(FlexAlign.SpaceEvenly)
    .width("100%")
    .backgroundColor(Color.White)
    .borderRadius(8)
    .padding(20)
  }
}


@Component
struct TaskList {
  @Consume state: TaskState
  @State @Watch("onTaskUpdated") tasks: Task[] = []

  onTaskUpdated() {
    this.state.total = this.tasks.length;
    this.state.finished = this.tasks.filter(item => item.finished).length
  }

  @Builder
  itemEnd(index: number) {
    // 构建尾端滑出组件
    Button({ type: ButtonType.Circle }) {
      Image($r("app.media.icon_delete"))
        .width(20)
        .height(20)
        .fillColor(Color.White)
    }
    .backgroundColor(Color.Red)
    .onClick(() => {
      this.tasks.splice(index, 1);
    })
    .width(30)
    .height(30)
    .margin({ left: 10 })
  }

  build() {
    Column() {
      Button("新增任务").onClick(() => {
        this.tasks.push(new Task())
      }).width("60%").margin({ bottom: 10 })
      List({ space: 10 }) {
        ForEach(this.tasks, (item: Task, index) => {
          ListItem() {
            // TaskCard({ task: item})
            TaskCard({ task: item, onTaskUpdated: this.onTaskUpdated.bind(this) })
          }.swipeAction({
            end: {
              builder: () => {
                this.itemEnd(index)
              },
            }
          })
        })
      }.layoutWeight(1).width("100%")
    }.height("80%")
  }
}

@Component
struct TaskCard {
  @ObjectLink task: Task
  // onTaskUpdated: () => void;
  onTaskUpdated?: () => void;

  private onClickFType() {
    if (this.onTaskUpdated) {
      this.onTaskUpdated();
    }
  }

  build() {
    Row() {
      Text(this.task.name)
        .decoration({ type: this.task.finished ? TextDecorationType.LineThrough : TextDecorationType.None })
        .fontColor(this.task.finished ? "#ff807d7d" : "#000")
        .onClick(() => {
          router.pushUrl(
            {
              url: "pages/TempTaskDetail",
              params: { id: "1", taskName: this.task.name }
            },
            router.RouterMode.Single,
            err => {
              if (err) {
                console.log("跳转路由失败")
              }
            }
          )
        })
      Blank()
      Checkbox({ name: 'checkbox2', group: 'checkboxGroup' })
        .select(this.task.finished)
        .selectedColor(0x39a2db)
        .shape(CheckBoxShape.ROUNDED_SQUARE)
        .onChange((value: boolean) => {
          this.task.finished = value;
          this.onClickFType();
        })
    }
    .width("100%")
    .padding(10)
    .backgroundColor(this.task.finished ? "#ffd2d2d2" : "#fff")
    .borderRadius(8)
    .shadow({
      radius: 6,
      color: "#1f000000",
      offsetX: 2,
      offsetY: 4
    })
  }
}