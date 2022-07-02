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
  public LooFModuleData CreateModuleData() {
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
      
      
      
      case ("print"): {
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
        
      return;}
      
      
      
      default:
        throw (new LooFInterpreterException (Environment, "cannot understand the message \"" + FirstArg.StringValue + "\".", new String[] {"UnknownModuleMessage"}));
      
    }
  }
  
};










LooFInterpreterModule InterpreterModule_Files = new LooFInterpreterModule() {
  
  @Override
  public void HandleCall (LooFTokenBranch[] Args, LooFEnvironment Environment, LooFModuleData ModuleDataIn) {
    LooFDataValue FirstArg = LooFInterpreter.EvaluateFormula (Args[0], Environment, null, null);
    if (FirstArg.ValueType != DataValueType_String) throw (new LooFInterpreterException (Environment, "the first arg given to the Files module must be a string, but the first arg was of type " + DataValueTypeNames[FirstArg.ValueType] + ".", new String[] {"InvalidArgType"}));
    switch (FirstArg.StringValue) {
      
      
      
      case ("get program path"): {
        String ProgramFilePath = Environment.ProgramFilePath;
        String[] ProgramFilePathArray = ProgramFilePath.split("\\");
        ArrayList <LooFDataValue> ProgramFilePathValues = new ArrayList <LooFDataValue> ();
        for (String S : ProgramFilePathArray) {
          ProgramFilePathValues.add(new LooFDataValue (S));
        }
        LooFDataValue TableToPush = new LooFDataValue (ProgramFilePathValues, new HashMap <String, LooFDataValue> ());
        LooFInterpreter.PushValuesToStack (new LooFDataValue[] {TableToPush}, Environment);
      return;}
      
      
      
      case ("get file properties"): {
        if (Args.length != 2) throw (new LooFInterpreterException (Environment, "the message \"get file properties\" can only take 1 argument, but " + (Args.length - 1) + " were found.", new String[] {"InvalidArgsLength"}));
        LooFDataValue FileToReadValue = LooFInterpreter.EvaluateFormula (Args[1], Environment, null, null);
        
        Result <File> FileToReadResult = GetFileFromDataValue (FileToReadValue);
        if (FileToReadResult.Err) {
          switch (FileToReadResult.ErrCause) {
            case ("InvalidArgType"): throw (new LooFInterpreterException (Environment, "the message \"get file properties\" must take a string or table of strings as its first arg, but the first arg was of type " + DataValueTypeNames[FileToReadValue.ValueType] + ".", new String[] {"InvalidArgType"}));
            case ("NonStringItem"): throw (new LooFInterpreterException (Environment, "the message \"get file properties\" must take a string or table of strings as its first arg, but the first arg was a table that contained a non-string item.", new String[] {"InvalidArgType"}));
            case ("EmptyTable"): throw (new LooFInterpreterException (Environment, "the message \"get file properties\" must take a string or table of strings as its first arg, but the first arg was an empty table.", new String[] {"InvalidArgType"}));
            default: throw (new LooFInterpreterException (Environment, "could not read file: " + FileToReadResult.ErrCause, new String[] {"FileReadError"}));
          }
        }
        File FileToRead = FileToReadResult.Some;
        
        HashMap <String, LooFDataValue> TableToPushItems = new HashMap <String, LooFDataValue> ();
        try {
          
          boolean Exists = FileToRead.exists();
          if (!Exists) {
            TableToPushItems.put("Exists", new LooFDataValue (false));
            LooFDataValue TableToPush = new LooFDataValue (new ArrayList <LooFDataValue> (), TableToPushItems);
            LooFInterpreter.PushValuesToStack (new LooFDataValue[] {TableToPush}, Environment);
            return;
          }
          
          long Size = FileToRead.length(); // this seems like a janky way to do this, but I'm pretty sure it's the intended way
          boolean IsFolder = FileToRead.isDirectory();
          long LastModified = FileToRead.lastModified();
          boolean CanRead = FileToRead.canRead();
          boolean CanWrite = FileToRead.canWrite();
          
          TableToPushItems.put("Size"        , new LooFDataValue (Size        ));
          TableToPushItems.put("IsFolder"    , new LooFDataValue (IsFolder    ));
          TableToPushItems.put("IsFiel"      , new LooFDataValue (!IsFolder   ));
          TableToPushItems.put("LastModified", new LooFDataValue (LastModified));
          TableToPushItems.put("CanRead"     , new LooFDataValue (CanRead     ));
          TableToPushItems.put("CanWrite"    , new LooFDataValue (CanWrite    ));
          LooFDataValue TableToPush = new LooFDataValue (new ArrayList <LooFDataValue> (), TableToPushItems);
          LooFInterpreter.PushValuesToStack (new LooFDataValue[] {TableToPush}, Environment);
          
        } catch (SecurityException e) {
          throw (new LooFInterpreterException (Environment, "SecurityException while reading file data: " + e.getMessage(), new String[] {"FileReadError"}));
        }
        
      return;}
      
      
      
      case ("check file exists"): {
        if (Args.length != 2) throw (new LooFInterpreterException (Environment, "the message \"get file properties\" can only take 1 argument, but " + (Args.length - 1) + " were found.", new String[] {"InvalidArgsLength"}));
        LooFDataValue FileToReadValue = LooFInterpreter.EvaluateFormula (Args[1], Environment, null, null);
        
        Result <File> FileToReadResult = GetFileFromDataValue (FileToReadValue);
        if (FileToReadResult.Err) {
          switch (FileToReadResult.ErrCause) {
            case ("InvalidArgType"): throw (new LooFInterpreterException (Environment, "the message \"get file properties\" must take a string or table of strings as its first arg, but the first arg was of type " + DataValueTypeNames[FileToReadValue.ValueType] + ".", new String[] {"InvalidArgType"}));
            case ("NonStringItem"): throw (new LooFInterpreterException (Environment, "the message \"get file properties\" must take a string or table of strings as its first arg, but the first arg was a table that contained a non-string item.", new String[] {"InvalidArgType"}));
            case ("EmptyTable"): throw (new LooFInterpreterException (Environment, "the message \"get file properties\" must take a string or table of strings as its first arg, but the first arg was an empty table.", new String[] {"InvalidArgType"}));
            default: throw (new LooFInterpreterException (Environment, "could not read file: " + FileToReadResult.ErrCause, new String[] {"FileReadError"}));
          }
        }
        File FileToRead = FileToReadResult.Some;
        
        boolean FileExists = FileToRead.exists();
        
        ArrayList <LooFDataValue> TableToPushItems = new ArrayList <LooFDataValue> ();
        TableToPushItems.add(new LooFDataValue (FileExists));
        LooFDataValue TableToPush = new LooFDataValue (TableToPushItems, new HashMap <String, LooFDataValue> ());
        LooFInterpreter.PushValuesToStack (new LooFDataValue[] {TableToPush}, Environment);
        
      return;}
      
      
      
      default:
        throw (new LooFInterpreterException (Environment, "cannot understand the message \"" + FirstArg.StringValue + "\".", new String[] {"UnknownModuleMessage"}));
      
    }
  }
  
};





Result <File> GetFileFromDataValue (LooFDataValue DataValueIn) {
  switch (DataValueIn.ValueType) {
    
    case (DataValueType_String):
      return new Result (new File (DataValueIn.StringValue));
    
    case (DataValueType_Table):
      if (DataValueIn.ArrayValue.size() == 0) return (new Result <File> ()).SetCause("EmptyTable");
      Result <String[]> PathArrayResult = GetStringArrayFromDataValue (DataValueIn);
      if (PathArrayResult.Err) return (new Result <File> ()).SetCause("NonStringItem");
      String[] PathArray = PathArrayResult.Some;
      return new Result (new File (CombineStringsWithSeperator (PathArray, "/")));
    
    default:
      return (new Result <File> ()).SetCause("InvalidArgType");
    
  }
}
