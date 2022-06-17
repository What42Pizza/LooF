LooFInterpreterModule InterpreterModule_Interpreter = new LooFInterpreterModule() {
  
  
  
  @Override
  public void HandleCall (LooFTokenBranch[] Args, LooFEnvironment Environment, LooFModuleData ModuleDataIn) {
    LooFInterpreterModuleData ModuleData = (LooFInterpreterModuleData) ModuleDataIn;
    LooFDataValue FirstArg = LooFInterpreter.EvaluateFormula (Args[0], Environment, null, null);
    if (FirstArg.ValueType != DataValueType_String) throw (new LooFInterpreterException (Environment, "the first arg given to the Interpreter module must be a string, but the first arg was of type " + DataValueTypeNames[FirstArg.ValueType] + ".", new String[] {"InvalidArgType"}));
    switch (FirstArg.StringValue) {
      
      case ("get start time"):
        if (Args.length > 1) throw (new LooFInterpreterException (Environment, "the message \"get start time\" cannot take any extra arguments.", new String[] {"InvalidArgsLength"}));
        LooFDataValue StartTime = new LooFDataValue (ModuleData.StartTime);
        LooFInterpreter.PushValuesToStack (new LooFDataValue[] {StartTime}, Environment);
        return;
      
      case ("stop"):
        if (Args.length > 1) throw (new LooFInterpreterException (Environment, "the message \"stop\" cannot take any extra arguments.", new String[] {"InvalidArgsLength"}));
        Environment.Stopped = true;
        return;
      
      default:
        throw (new LooFInterpreterException (Environment, "cannot understand the message \"" + FirstArg.StringValue + "\".", new String[] {"UnknownModuleMessage"}));
      
    }
  }
  
  
  
  @Override
  public LooFModuleData CreateModuleData (LooFEnvironment Environment) {
    double StartTime = System.currentTimeMillis();
    return new LooFInterpreterModuleData (StartTime);
  }
  
};



class LooFInterpreterModuleData extends LooFModuleData {
  
  double StartTime;
  
  public LooFInterpreterModuleData (double StartTime) {
    this.StartTime = StartTime;
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
          ToPrint += Function_ToString.HandleFunctionCall(ValuesToPrintArray.get(i), Environment, null, null).StringValue;
        }
        print (ToPrint);
        
        return;
      
      
      
      default:
        throw (new LooFInterpreterException (Environment, "cannot understand the message \"" + FirstArg.StringValue + "\".", new String[] {"UnknownModuleMessage"}));
      
    }
  }
  
};
