
public class Timer {
   public int currentTime = 0;
   public int startTime = 0;
   public int timeLimit = 5*60;
   public int stopTime = 60*5;
   public int warningTime = 60;
   
   public void startTimer () {
     State.textSize = 512;
     startTime = millis();
     State.currentText = "5:00";
     State.screen = State.TIMER;
   }
   
   public void pauseTimer() {
      State.screen = -1; 
   }
   
   public void stopTimer(){
      State.screen = -1;
      stopTime = millis();
   }

  public int getElapsedTime() {
    int elapsed = 0;
    if(State.screen == State.TIMER){
      elapsed = (millis() - startTime);
    }
    return elapsed;
  }

  public int seconds() {
    return (getElapsedTime()/1000)%60; 
  }

  public int minutes() {
    return (getElapsedTime()/(1000*60))%60; 
  }

  public int hours() {
    return (getElapsedTime()/(1000*60*60))%24; 
  } 
}
