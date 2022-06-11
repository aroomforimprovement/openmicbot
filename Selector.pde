public class Selector {
   public int numPeeps = 0;
   public ArrayList<Integer> peeps;
   public int selection;
   public boolean generated = false;
   
   void initSelector(){
      peeps = new ArrayList<Integer>();
      for(int i = 0; i < numPeeps; i++){
        peeps.add(i);
      }
   }
   
   void addSelection(int num){
     peeps.add(num);
   }
   
   void setSelection(SinOsc sine){
      if(peeps == null || peeps.size() == 0){
        return;
      }
      sine.amp(0.1f);
      int timer = millis();
      int delay = 100;
      int index = int(random(peeps.size()));
      int secret = peeps.get(index);
      int decoy = peeps.get(int(random(peeps.size())));
      playSound(0.1f);
      while(peeps.get(int(random(peeps.size()))) != decoy){
        while(millis() < timer + delay){
           int num = peeps.get(int(random(peeps.size())));
           selection = num;
        }
        timer = millis();
      }
      stopSound();
      selection = secret;
      peeps.remove(index);
      generated = true;
   }
}
