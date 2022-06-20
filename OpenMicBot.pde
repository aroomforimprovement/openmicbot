import processing.sound.*;

String[] intro;
String introWelcome;
String introSignUp;
Timer timer = new Timer();
Intro introBot = new Intro();
Selector selector = new Selector();
Break breakTime = new Break();
SinOsc sine;
//BeatDetector beat;
boolean shifted = false;
String newPlayer = "";
boolean naming = false;
String currentPerformer = "";
int smallSize = 20;
int midSize = 28;
int largeSize = 128;
int largestSize = 254;


//FFT fft;
//AudioIn in;
//int bands = 512;
//float[] spectrum = new float[bands];

void setup () {
 fullScreen();
 textSize(midSize);
 fill(255);
 sine = new SinOsc(this);
 //beat = new BeatDetector(this);
 //fft = new FFT(this, bands);
 //in = new AudioIn(this, 0);
 //in.start();
 //fft.input(in);
 Data data = new Data();
 intro = data.intro;
 introWelcome = data.introWelcome;
 introSignUp = data.introSignUp;
 
 background(0);
}

void draw () {
  int bg = 0;
  int c = 255;
  background(bg);
  noCursor();
  switch(State.screen){
    case State.TIMER:{
      int mins = 4 - timer.minutes();
      int secs = 60 - timer.seconds();
      String secString = ""+secs;
      if(secs < 60){
        if(secs < 10){
          secString = "0" + secString;
        }
        State.currentText = ""+mins+":"+secString;
      }
      if(mins < 1){
        //bg = 255;
        //c = 0;
        int pos = width/4;
        fill(255, 150, 0);
        if(secs%2 == 0){
          pos = width-width/4;
          fill(150, 0, 255);
        }
        ellipse(pos, height/2, width/6, width/6);
      }
      if(mins == 0 && secs == 1){
        timer.stopTimer();
        playSound(0.8);
      }
      stroke(c);
      fill(c);
      if(secs == 58){
        textSize(largestSize*1.5f);
        text(State.currentText, width/4-largestSize/4, height/4-largestSize/4, width-width/4, height-height/4);
      }else{
        textSize(largestSize);  
        text(State.currentText, width/4, height/4, width-width/4, height-height/4);
      }
      
      //background(bg);
      //fft.analyze(spectrum);
      //for(int i = 0; i < bands; i++){
      //  stroke(255, 255, i);
      //  strokeWeight(1);
      //  line(i, height, i*2, height - spectrum[i]*height*5);
      //  stroke(i, i, 255);
      //  line(width-i, height, width - i*2, height - spectrum[i]*height*5);
      //}
     }
     break;
     case State.BREAK:{
       int mins = 9 - breakTime.minutes();
       int secs = 60 - breakTime.seconds();
       String secString = ""+secs;
       if(secs < 60){
         if(secs < 10){
           secString = "0" + secString;
         }
         State.currentText = ""+mins+":"+secString;
       }
       if(mins < 1){
        bg = 255;
        c = 0;
       }
       stroke(255);
       fill(255);
       textSize(midSize);
       text("On break - back in ", 40, 40, width-width/4, height-height/4);
       textSize(largestSize);
       State.currentText = ""+mins+":"+secString;
       text(State.currentText, width/4, height/4, width-width/4, height-height/4);
     }
     break;
     case State.INTRO:{
       introBot.doIntro();
       stroke(255);
       textSize(smallSize);
       noFill();
       rect(10, 10, width/2-10, height/3, 20);
       rect(10, height/3+20, width/2-10, (height-height/3)-60, 20);
       fill(255);
       text(introWelcome, 30, 30, width/2-30, height/3);
       text(introSignUp, 30, height/3+30, width/2-30, height-height/8);
       text(State.currentText, width/2+20, 20, width/2-30, height-height/8);   
     }
     break;
     case State.INIT:{
       stroke(255);
       textSize(midSize);
       text("Set number of performers", 40, 40, width-width/4, height-height/4);
       textSize(largestSize);
       State.currentText = ""+selector.numPeeps;
       text(State.currentText, width/2, height/4, width-width/4, height-height/4);
     }
     break;
     case State.SELECTOR:{
       textSize(midSize);
       stroke(255);
       fill(255);
       String header = "Generate next performer";
       if(selector.generated){
          header = "The next performer is number";
       }
       text(header, 40, 40, width-width/4, height-height/4);  
       State.textSize = largestSize;
       textSize(largestSize);
       State.currentText = ""+selector.selection;
       text(State.currentText, width/2, height/4, width-width/4, height-height/4);
     }
     break;
     default:
       textSize(largeSize);
       stroke(255);
       fill(255);
       State.currentText = "Don't Panic";
       text(State.currentText, width/4, height/4, width-width/4, height-height/4);
       break;
  }
  
  if(State.performer.length() != 0){
    textSize(largeSize);
    text("@"+State.performer, width/4, height-height/6, width-width/4, height-height/8);
    
  }
      
}

void setSelection(){
    selector.setSelection(sine);
}

void keyPressed () {
  if(naming){
    if(key == BACKSPACE && currentPerformer.length() != 0){
      currentPerformer = currentPerformer.substring(0, currentPerformer.length() -1);
    }else if(key != '=' && key != '+'){
      currentPerformer = currentPerformer + key; 
      State.performer = currentPerformer;
    }
  }else if(shifted){
      switch(key){
        case '0':
        case '1':
        case '2':
        case '3':
        case '4':
        case '5':
        case '6':
        case '7':
        case '8':
        case '9':
          newPlayer += ""+key;
        break;
      }
      
  }else if(key == CODED){
    if(keyCode == UP){
      playSound(0.8);
    }else if(keyCode == DOWN){
      stopSound();
    }else if(keyCode == LEFT){
      if(State.screen == State.INIT && selector.numPeeps > 0){
         selector.numPeeps -= 1; 
      }
    }else if(keyCode == RIGHT){
      if(State.screen == State.INIT){
        selector.numPeeps += 1;
      }
    }else if(keyCode == CONTROL){
      breakTime.startTimer();
      State.screen = State.BREAK;
    }
  }else if(key == ENTER || key == RETURN){
    timer.startTimer();
  }else if(key == ' '){
    if(State.screen == State.INIT){
      selector.initSelector();
      State.screen = State.SELECTOR;
    }else if(State.screen == State.SELECTOR){
      State.performer = "";
      thread("setSelection");
    }else{
      State.screen = State.SELECTOR;
      selector.generated = false;
    }
  }else if(key == BACKSPACE){
    State.performer = "";
    if(State.screen == State.INTRO){
      introBot.endIntro();
    }else{
      introBot.startIntro(); 
    }
  }else if(key == TAB){
    selector.generated = false;
    State.screen = State.INIT;
  }else if(key == 'a' || key == 'A') {
    shifted = true;
  }else if(key == '+' || key == '='){
    naming = true;
  }
}

void keyReleased() {
   if(key == 'a' || key == 'A'){
       shifted = false;
       if(newPlayer.length() != 0){
         selector.peeps.add(parseInt(newPlayer));
         newPlayer = "";
       }
   }
   if(key == '=' || key == '+'){
     naming = false;
     //if(currentPerformer.length() != 0){
       State.performer = currentPerformer;
     //}
     currentPerformer = "";
   }
}

void playSound(float amp) {
  sine.amp(amp);
  sine.play();
}

void stopSound(){
  sine.amp(0);
  sine.stop();
}

void exit() {
  super.exit();
}
