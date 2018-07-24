Table data; //table where we will read in and store values
Table Newdata; //table where we will read in and store values
Table feature; //table for feature extraction

float [] sensorVals;
float [] newSensorVals;
float [] Real;
float [] Imagine;
int total_data = 100;

void setup() {
  Newdata = new Table();
  for (int a =0; a<total_data-1; a++){
    Newdata.addColumn("Newinput"+a);
  }
  
  feature = new Table();
  //TIME DOMAIN FEATURES
  feature.addColumn("Max"); 
  feature.addColumn("Min");  
  feature.addColumn("WL"); 
  feature.addColumn("Mean"); 
  feature.addColumn("RMS"); 
  feature.addColumn("Var");
  feature.addColumn("WAMP"); 
  feature.addColumn("SSC");
  feature.addColumn("Log"); 
  //FREQUENCY DOMAIN FEATURES
  feature.addColumn("MaxF"); 
  feature.addColumn("MinF");  
  feature.addColumn("WLF"); 
  feature.addColumn("MeanF"); 
  feature.addColumn("RMSF"); 
  feature.addColumn("VarF");
  feature.addColumn("WAMPF"); 
  feature.addColumn("SSCF");
  feature.addColumn("LogF"); 

  sensorVals = new float [total_data]; 
  newSensorVals = new float [total_data]; 
  Real = new float [total_data]; 
  Imagine = new float [total_data]; 
  
  data = loadTable("datatest.csv", "header");
  for (int a = 0; a < data.getRowCount(); a++) {
    for (int b = 0; b < total_data; b++) {
      sensorVals[b] = data.getInt(a, b);
      float value = sensorVals[b];
      Real [b] = DFTreal(value,b);
      Imagine [b] = DFTimagine(value,b);
      newSensorVals [b] = sqrt( sq(Real [b]) + sq(Imagine [b]));
    }
    //entry data feature
    //Newdata = loadTable("data/Newdata.csv", "header");//add to table 
    TableRow newRowdata = Newdata.addRow();
    for(int i=0; i<total_data-1;i++){
    newRowdata.setFloat("Newinput"+i, newSensorVals [i]);
    saveTable(Newdata, "data/Newdata.csv");//save data to file
    }
    
//TIME DOMAIN FEATURES
    //find Maximum (Max) value
    float Max = max(sensorVals);
    //println(a);
    //print ("   ");

    //find Minimum (Min) value 
    float Min = min(sensorVals);

    //find Waveform Length (WL) value
    float WL = WL(sensorVals);

    //find Means Absolute Value (Mean) value
    float Sum = Sum(sensorVals);
    float Mean = Sum/total_data;
    
    //find Root Mean Square (RMS) value
    float SumSquare = SumSquare(sensorVals);
    Float RMS = SumSquare/total_data;

    //find Variance (Var) value
    float SumVAR = SumVAR(Mean, sensorVals);
    float Var = SumVAR/(total_data-1);

    //find Willison Amplitude (WAMP) value
    float WAMP = WAMP(Max, sensorVals);

    //find Slope Sign Change (SSC) value
    float SSC = SSC(Max, sensorVals);
    
    //find Log detector (Log) value
    float Log= log(Sum);

//FREQUENCY DOMAIN FEATURES

    //find Maximum (Max) value
    float MaxF = max(newSensorVals);
    println(a);
    //print ("   ");

    //find Minimum (Min) value 
    float MinF = min(newSensorVals);

    //find Waveform Length (WL) value
    float WLF = WL(newSensorVals);

    //find Means Absolute Value (Mean) value
    float SumF = Sum(newSensorVals);
    float MeanF = SumF/total_data;
    
    //find Root Mean Square (RMS) value
    float SumSquareF = SumSquare(newSensorVals);
    Float RMSF = SumSquareF/total_data;

    //find Variance (Var) value
    float SumVARF = SumVAR(MeanF, newSensorVals);
    float VarF = SumVARF/(total_data-1);

    //find Willison Amplitude (WAMP) value
    float WAMPF = WAMP(MaxF, newSensorVals);

    //find Slope Sign Change (SSC) value
    float SSCF = SSC(MaxF, newSensorVals);
    
    //find Log detector (Log) value
    float LogF = log(SumF);
    
//entry data feature
//feature = loadTable("data/feature.csv", "header");//add to table 
TableRow newRow = feature.addRow();
    
//TIME DOMAIN 
    newRow.setFloat("Max", Max);
    newRow.setFloat("Min", Min);  
    newRow.setFloat("WL", WL); 
    newRow.setFloat("Mean", Mean);  
    newRow.setFloat("RMS", RMS); 
    newRow.setFloat("Var", Var); 
    newRow.setFloat("WAMP", WAMP); 
    newRow.setFloat("SSC", SSC); 
    newRow.setFloat("Log", Log);
    
//FREQUENCY DOMAIN
    newRow.setFloat("MaxF", MaxF);
    newRow.setFloat("MinF", MinF);  
    newRow.setFloat("WLF", WLF); 
    newRow.setFloat("MeanF", MeanF);  
    newRow.setFloat("RMSF", RMSF); 
    newRow.setFloat("VarF", VarF); 
    newRow.setFloat("WAMPF", WAMPF); 
    newRow.setFloat("SSCF", SSCF); 
    newRow.setFloat("LogF", LogF); 
    saveTable(feature, "data/feature.csv");//save data to file
  }
}

//CONVERT TIME DOMAIN TO FREQUENCY DOMAIN
// Real part of X[k]
float DFTreal(float x, int k) {
  float real = 0.00;
    for (int i=0 ; i<(total_data/2)+1 ; ++i) 
    {
      real += x * cos(2 * PI * i * k  / total_data);
    }  
  return real;
}

// Imaginary part of X[k]
float DFTimagine(float x, int k) {
  float imagine = 0.00;
    for (int i=0 ; i<(total_data/2)+1 ; ++i) 
    {
      imagine += x * sin(2 * PI * i * k  / total_data);
    }  
  return imagine;
}

//DOMAIN FUNTION

//fuction WL
float WL(float[] arr) {
  float WL=0;
  for (int i =0; i<total_data-1; i++) {
    WL +=abs(arr[i+1]-arr[i]);
  }
  return WL;
}
//funtion Sum
float Sum(float [] arr) {
  float sum = 0;
  for (int i =0; i<total_data; i++) {
    sum +=abs(arr[i]);
  }
  return sum;
}

//funtion Sum
float SumSquare(float [] arr) {
  float sum = 0;
  for (int i =0; i<total_data; i++) {
    sum +=sq(arr[i]);
  }
  return sum;
}

//funtion SumVAR (xi-mean)^2
float SumVAR(float mean, float[] arr) {
  float SumVAR = 0; 
  for (int i =0; i<total_data; i++) {
    SumVAR += sq(mean - arr[i]);
  }
  return SumVAR;
}

//funtion WAMP
float WAMP(float max, float[] arr) {
  float result =0;
  float WAMP = 0; 
  for (int i = 0; i<total_data-1; i++) {
    float cek = abs(arr[i+1]-arr[i]);
    float threshold = max*30/100;
    // println(threshold);
    if ( cek >= threshold) {
      result = 1;
    } else {
      result = 0;
    }
    WAMP += result;
  }
  return WAMP;
}

//funtion SSC
float SSC(float max, float[] arr) {
  float result =0;
  float SSC = 0; 
  for (int i = 1; i<total_data-1; i++) {
    float cek = (arr[i]-arr[i-1])*(arr[i]-arr[i+1]);
    float threshold = max*30/100;
    // println(threshold);
    if ( cek >= threshold) {
      result = 1;
    } else {
      result=0;
    }
    SSC += result;
  }
  return SSC;
}

void draw() {
}
