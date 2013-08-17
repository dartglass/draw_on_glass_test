import 'dart:html';
import 'dart:math';

class Line {
  int x;
  int y;
  String color;
  Line([this.x=0,this.y=0,this.color="blue"]);
}

class MultiTouchDraw {
  Map lines;
  List colors = const["red", "green", "yellow", "blue", "magenta", "orangered"];
  String color = "blue";
  CanvasRenderingContext2D context;
  Random random = new Random();

  void run() {
    CanvasElement canvas = document.query("#canvas");
    context = canvas.getContext("2d");

    DivElement div = document.query("#div");
    canvas.width = div.scrollWidth;
    canvas.height= div.scrollHeight;

    context.lineWidth = (random.nextDouble() * 35).ceil();
    context.lineCap = "round";
    lines = {};
    canvas.onTouchStart.listen(draw);
    //canvas.onTouchEnd.listen((_) => color = colors[(random.nextDouble()*colors.length).floor().toInt()]);
  }

  void draw(TouchEvent event) {
    //print("draw: $event");
    Touch t = event.touches.first;

    var id = t.identifier;
    num moveX;
    num moveY;
    bool wasEmpty = lines.isEmpty;
    if (lines.isEmpty) {
      lines[id] = new Line(t.page.x, t.page.y);
      lines[id].x = t.page.x;
      lines[id].y = t.page.y;
      moveX = lines[id].x;
      moveY = lines[id].y;
    } else {
      moveX = t.page.x - lines[id].x;
      moveY = t.page.y - lines[id].y;
    }

    //print("${lines[id]}, $moveX, $moveY");
    move(lines[id], moveX, moveY);

    if (!wasEmpty) {
      lines[id].x = lines[id].x + moveX;
      lines[id].y = lines[id].y + moveY;
    }
  }

  void move(line, changeX, changeY) {
    context.strokeStyle = color;
    context.beginPath();
    context.moveTo(line.x, line.y);

    context.lineTo(line.x + changeX, line.y + changeY);
    context.stroke();
    context.closePath();
  }
}

void main() {
  new MultiTouchDraw().run();
}

