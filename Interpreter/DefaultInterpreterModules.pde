LooFInterpreterModule InterpreterModule_Interpreter = new LooFInterpreterModule() {
  
  
  
  @Override
  public void HandleCall (LooFTokenBranch[] Args, LooFEnvironment Environment, LooFModuleData ModuleDataIn) {
    LooFInterpreterModuleData ModuleData = (LooFInterpreterModuleData) ModuleDataIn;
    LooFDataValue FirstArg = LooFInterpreter.EvaluateFormula (Args[0], Environment, null, null);
    if (FirstArg.ValueType != DataValueType_String) throw (new LooFInterpreterException (Environment, "the first arg given to the Interpreter module must be a string, but the first arg was of type " + DataValueTypeNames[FirstArg.ValueType] + ".", new String[] {"InvalidArgType"}));
    switch (FirstArg.StringValue) {
      
      case ("stop"):
        if (Args.length > 1) throw (new LooFInterpreterException (Environment, "the message \"stop\" cannot take any extra arguments.", new String[] {"InvalidArgsLength"}));
        Environment.Stopped = true;
        return;
      
      case ("pause"): {
        if (Args.length != 2) throw (new LooFInterpreterException (Environment, "the message \"pause\" can only take 1 argument, but " + (Args.length - 1) + " were found.", new String[] {"InvalidArgsLength"}));
        LooFDataValue PauseTimeValue = LooFInterpreter.EvaluateFormula (Args[1], Environment, null, null);
        PauseTimeValue.IntValue *= 1000; PauseTimeValue.FloatValue *= 1000;
        Result <Long> PauseTimeLongResult = GetDataValueInt (PauseTimeValue);
        if (PauseTimeLongResult.Err) throw (new LooFInterpreterException (Environment, "the message \"pause\" must take an int or float as its first arg, but the first arg was of type " + DataValueTypeNames[PauseTimeValue.ValueType] + ".", new String[] {"InvalidArgType"}));
        long PauseTimeLong = PauseTimeLongResult.Some;
        Environment.Paused = true;
        Environment.PauseEndMillis = System.currentTimeMillis() + PauseTimeLong;
      return;}
      
      case ("pause until"): {
        if (Args.length != 2) throw (new LooFInterpreterException (Environment, "the message \"pause\" can only take 1 argument, but " + (Args.length - 1) + " were found.", new String[] {"InvalidArgsLength"}));
        LooFDataValue PauseEndTimeValue = LooFInterpreter.EvaluateFormula (Args[1], Environment, null, null);
        PauseEndTimeValue.IntValue *= 1000; PauseEndTimeValue.FloatValue *= 1000;
        Result <Long> PauseEndTimeLongResult = GetDataValueInt (PauseEndTimeValue);
        if (PauseEndTimeLongResult.Err) throw (new LooFInterpreterException (Environment, "the message \"pause\" must take an int or float as its first arg, but the first arg was of type " + DataValueTypeNames[PauseEndTimeValue.ValueType] + ".", new String[] {"InvalidArgType"}));
        long PauseEndTimeLong = PauseEndTimeLongResult.Some;
        Environment.Paused = true;
        Environment.PauseEndMillis = ModuleData.StartMillis + PauseEndTimeLong;
      return;}
      
      default:
        throw (new LooFInterpreterException (Environment, "cannot understand the message \"" + FirstArg.StringValue + "\".", new String[] {"UnknownModuleMessage"}));
      
    }
  }
  
  
  
  @Override
  public LooFModuleData CreateModuleData (LooFEnvironment Environment) {
    long StartTime = System.currentTimeMillis();
    return new LooFInterpreterModuleData (StartTime);
  }
  
};



class LooFInterpreterModuleData extends LooFModuleData {
  
  long StartMillis;
  
  public LooFInterpreterModuleData (long StartMillis) {
    this.StartMillis = StartMillis;
  }
  
}










LooFInterpreterModule InterpreterModule_Console = new LooFInterpreterModule() {
  
  @Override
  public void HandleCall (LooFTokenBranch[] Args, LooFEnvironment Environment, LooFModuleData ModuleDataIn) {
    LooFDataValue FirstArg = LooFInterpreter.EvaluateFormula (Args[0], Environment, null, null);
    if (FirstArg.ValueType != DataValueType_String) throw (new LooFInterpreterException (Environment, "the first arg given to the Console module must be a string, but the first arg was of type " + DataValueTypeNames[FirstArg.ValueType] + ".", new String[] {"InvalidArgType"}));
    switch (FirstArg.StringValue) {
      
      
      
      case ("print"):
        if (Args.length != 2) throw (new LooFInterpreterException (Environment, "the message \"print\" must take 2 arguments, \"print\" and a table for the value to print.", new String[] {"InvalidArgsLength"}));
        
        LooFDataValue ValuesToPrintTable = LooFInterpreter.EvaluateFormula (Args[1], Environment, null, null);
        if (ValuesToPrintTable.ValueType != DataValueType_Table) throw (new LooFInterpreterException (Environment, "the message \"print\" must take a table as its additional arg, but the first additional arg was of type " + DataValueTypeNames[ValuesToPrintTable.ValueType] + ".", new String[] {"InvalidArgsLength"}));
        ArrayList <LooFDataValue> ValuesToPrintArray = ValuesToPrintTable.ArrayValue;
        
        if (ValuesToPrintArray.size() == 0) throw (new LooFInterpreterException (Environment, "the message \"print\" cannot take an empty table as its additional arg.", new String[] {"InvalidArgsLength"}));
        
        String ToPrint = Function_ToString.HandleFunctionCall(ValuesToPrintArray.get(0), Environment, null, null).StringValue;
        for (int i = 1; i < ValuesToPrintArray.size(); i ++) {
          ToPrint += " " + Function_ToString.HandleFunctionCall(ValuesToPrintArray.get(i), Environment, null, null).StringValue;
        }
        print (ToPrint);
        
        return;
      
      
      
      default:
        throw (new LooFInterpreterException (Environment, "cannot understand the message \"" + FirstArg.StringValue + "\".", new String[] {"UnknownModuleMessage"}));
      
    }
  }
  
};
