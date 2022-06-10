import processing.sound.*;


String[] intro;
String introWelcome;
String introSignUp;
Timer timer = new Timer();
Intro introBot = new Intro();
Selector selector = new Selector();
Break breakTime = new Break();
SinOsc sine;
BeatDetector beat;
boolean shifted = false;
String newPlayer = "";

FFT fft;
AudioIn in;
int bands = 512;
float[] spectrum = new float[bands];

void setup () {
 //size(displayWidth, displayHeight); 
 //size(600, 600);
 fullScreen();
 textSize(128);
 fill(255);
 sine = new SinOsc(this);
 beat = new BeatDetector(this);
 fft = new FFT(this, bands);
 in = new AudioIn(this, 0);
 in.start();
 fft.input(in);
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
        bg = 255;
        c = 0;
      }
      if(mins == 0 && secs == 1){
        timer.stopTimer();
        sine.amp(1);
        sine.play();
      }
      background(bg);
      stroke(c);
      fill(c);
      textSize(512);
      text(State.currentText, width/4, height/4, width-width/4, height-height/4);
      fft.analyze(spectrum);
      for(int i = 0; i < bands; i++){
        stroke(255, 255, i);
        strokeWeight(1);
        line(i, height, i*2, height - spectrum[i]*height*5);
        stroke(i, i, 255);
        line(width-i, height, width - i*2, height - spectrum[i]*height*5);
      }
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
       textSize(128);
       text("On break - back in ", 40, 40, width-width/4, height-height/4);
       textSize(512);
       State.currentText = ""+mins+":"+secString;
       text(State.currentText, width/4, height/4, width-width/4, height-height/4);
     }
     break;
     case State.INTRO:{
       introBot.doIntro();
       stroke(255);
       textSize(64);
       noFill();
       rect(10, 10, width/2-20, height/3, 20);
       rect(10, height/3+20, width/2-20, (height-height/3)-60, 20);
       fill(255);
       text(introWelcome, 30, 30, width/2-30, height/3);
       text(introSignUp, 30, height/3+30, width/2-30, height-height/8);
       text(State.currentText, width/2+20, 20, width/2-30, height-height/8);   
     }
     break;
     case State.INIT:{
       stroke(255);
       textSize(128);
       text("Set number of performers", 40, 40, width-width/4, height-height/4);
       textSize(512);
       State.currentText = ""+selector.numPeeps;
       text(State.currentText, width/2, height/4, width-width/4, height-height/4);
     }
     break;
     case State.SELECTOR:{
       textSize(128);
       stroke(255);
       fill(255);
       String header = "Generate next performer";
       if(selector.generated){
          header = "The next performer is number";
       }
       text(header, 40, 40, width-width/4, height-height/4);  
       State.textSize = 512;
       textSize(512);
       State.currentText = ""+selector.selection;
       text(State.currentText, width/2, height/4, width-width/4, height-height/4);
     }
     break;
     default:
       textSize(254);
       stroke(255);
       fill(255);
       State.currentText = "Don't Panic";
       text(State.currentText, width/4, height/4, width-width/4, height-height/4);
       break;
  }
}

void setSelection(){
    selector.setSelection(sine);
}

void keyPressed () {
  if(key == CODED){
    if(keyCode == UP){
      sine.amp(1);
      sine.play();
    }else if(keyCode == DOWN){
      sine.stop();
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
    }else if(keyCode == SHIFT){
      shifted = true;
    }
  }else if(key == ENTER || key == RETURN){
    timer.startTimer();
  }else if(key == ' '){
    if(State.screen == State.INIT){
      selector.initSelector();
      State.screen = State.SELECTOR;
    }else if(State.screen == State.SELECTOR){
      thread("setSelection");
    }else{
      State.screen = State.SELECTOR;
      selector.generated = false;
    }
  }else if(key == BACKSPACE){
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
}
