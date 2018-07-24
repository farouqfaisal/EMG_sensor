import processing.serial.*;
Serial myPort;//create local serial library
Table data; //table where we will read in and store values
String val; // variable collect serial data
float sensorVals[];
                     
void setup(){
String mySerial = Serial.list() [0];
myPort = new Serial (this, mySerial,9600);

//data = new Table(); //create table data
//for (int a = 0; a<100; a++){
//  data.addColumn("input"+ a);   
//  }   
}

void serialEvent(Serial myPort){
  val = myPort.readStringUntil('.'); //The [.] separator separates each Arduino loop. We will parse the data by each separator. 
  if (val!= null) { //We have a reading.. Record it
       val = trim(val); //gets rid of any whitespace or Unicode nonbreakable space
       //println(val); //useful for debugging
       float sensorVals[] = float(split(val, ',')); //parses the packet from Arduino 
       //println(sensorVals[0]); //debug
       
       data = loadTable("data/datatest.csv", "header");//add to table 
       TableRow newRow = data.addRow(); //add a row 
       for(int n=0; n<100; n++){
         newRow.setFloat("input"+n, sensorVals[n]);
         }
       saveTable(data, "data/datatest.csv");//save  
       println("stop.....");
    } 
}

void draw(){ 
    
}
