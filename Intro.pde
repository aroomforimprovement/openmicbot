public class Intro {
  int slideTime = 7000;
  int introTimer = 0;
  int introCounter = 0;
  
  public void startIntro() {
   introTimer = millis();
   State.screen = State.INTRO;
   State.currentText = intro[0];
   loop();
  }
  public void doIntro() {
    if(millis() > introTimer + slideTime){
      if(introCounter < intro.length-1){
        introCounter++;
      }else{
        introCounter = 0; 
      }
      State.currentText = intro[introCounter];
      introTimer = millis();
    }
 }

 void endIntro() {
  State.screen = -1;
 }


 
}
