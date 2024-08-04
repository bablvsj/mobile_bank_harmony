import Logger from "../common/utils/Logger"

// @Prop 与 @Link 代码示例

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

class TaskState{
  total:number = 0
  finished:number = 0
}


@Entry
@Component
struct TempStatePage {
  @State state: TaskState = new TaskState();


  // @State @Watch("onTaskUpdated") tasks: Task[] =
  //   [new Task("学习Ts", false),
  //     new Task("打游戏三局", false),
  //     new Task("运动30minutes", false),
  //     new Task("陪老婆哦哦", false),
  //     new Task("每天学习3小时", false)];
  // @State message: string = 'Hello World';
  //
  // onTaskUpdated(){
  //   this.total = this.tasks.length;
  //   this.finished = this.tasks.filter(item=>item.finished).length
  // }

  build() {
    Column({ space: 20 }) {
      TaskStatistics({ total: this.state.total, finished: this.state.finished })
      // TaskList({tasks:this.tasks})
      TaskList({ state:this.state })

    }.backgroundColor("#ffe7e5e5").padding(10)
  }
}


@Component
struct TaskStatistics {
  @Prop finished: number
  @Prop total: number

  build() {
    Row() {
      Text("任务进度:").fontSize(24).fontWeight(FontWeight.Bold)
      Stack() {
        Progress({
          type: ProgressType.Ring,
          value: this.finished,
          total: this.total
        })
        Row() {
          Text(this.finished.toString()).fontColor("#36d").fontSize(20)
          Text(' / ' + this.total).fontSize(20)
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
  @Link state: TaskState
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
      }).width("60%")
      List({ space: 10 }) {
        ForEach(this.tasks, (item: Task, index) => {
          ListItem() {
            Row() {
              Text(item.name)
                .decoration({ type: item.finished ? TextDecorationType.LineThrough : TextDecorationType.None })
                .fontColor(item.finished ? "#ff807d7d" : "#000")
              Blank()
              Checkbox({ name: 'checkbox2', group: 'checkboxGroup' })
                .select(item.finished)
                .selectedColor(0x39a2db)
                .shape(CheckBoxShape.ROUNDED_SQUARE)
                .onChange((value: boolean) => {
                  item.finished = value;
                  this.onTaskUpdated()
                  // Logger.info(this.tasks)
                  // console.info('Checkbox2 change is' + value)
                })
            }
            .width("100%")
            .padding(10)
            .backgroundColor("#fff")
            .borderRadius(8)
            .shadow({
              radius: 6,
              color: "#1f000000",
              offsetX: 2,
              offsetY: 4
            })
          }.swipeAction({
            end: {
              builder: () => {
                this.itemEnd(index)
              },
            }
          })
        })
      }.layoutWeight(1)
    }
  }
}

@Component
struct TaskCard {
  @ObjectLink task: Task
  build() {
    Row() {
      Text(this.task.name)
        .decoration({ type: this.task.finished ? TextDecorationType.LineThrough : TextDecorationType.None })
        .fontColor(this.task.finished ? "#ff807d7d" : "#000")
      Blank()
      Checkbox({ name: 'checkbox2', group: 'checkboxGroup' })
        .select(this.task.finished)
        .selectedColor(0x39a2db)
        .shape(CheckBoxShape.ROUNDED_SQUARE)
        .onChange((value: boolean) => {
          this.task.finished = value;
          console.info('Checkbox2 change is' + value)
        })
    }
    .width("100%")
    .padding(10)
    .backgroundColor("#fff")
    .borderRadius(8)
    .shadow({
      radius: 6,
      color: "#1f000000",
      offsetX: 2,
      offsetY: 4
    })
  }
}