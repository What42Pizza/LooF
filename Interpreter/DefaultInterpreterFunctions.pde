LooFInterpreterFunction InterpreterFunction_Push = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFStatement Statement, LooFEnvironment Environment) {
    LooFTokenBranch[] Args = Statement.Args;
    
    LooFDataValue ValueToAdd = LooFInterpreter.EvaluateFormula (Args[0], Environment, null, null);
    Environment.GeneralStack.add(ValueToAdd);
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (CurrentStatement, 1, CodeData, AllCodeDatas, LineNumber);
  }
  @Override public String toString (LooFStatement CurrentStatement) {return "'push'";}
};





LooFInterpreterFunction InterpreterFunction_Pop = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFStatement Statement, LooFEnvironment Environment) {
    LooFTokenBranch[] Args = Statement.Args;
    
    LooFDataValue PoppedValue = RemoveLastItem (Environment.GeneralStack);
    LooFTokenBranch FirstArg = Args[0];
    LooFInterpreter.SetVariableValue (FirstArg.StringValue, PoppedValue, Environment);
    if (Args.length == 1) return;
    
    if (PoppedValue.ValueType != DataValueType_Table) throw (new LooFInterpreterException (Environment, "attempted to pop table values into vars, but the popped value was of type " + DataValueTypeNames[PoppedValue.ValueType] + ".", new String[] {"NonTableValueOnGeneralStack", "InvalidArgType"}));
    ArrayList <LooFDataValue> PoppedValueItems = PoppedValue.ArrayValue;
    int EndIndex = Math.min (PoppedValueItems.size() + 1, Args.length);
    for (int i = 1; i < EndIndex; i ++) {
      LooFInterpreter.SetVariableValue (Args[i].StringValue, PoppedValueItems.get(i - 1), Environment);
    }
    for (int i = EndIndex; i < Args.length; i ++) {
      LooFInterpreter.SetVariableValue (Args[i].StringValue, new LooFDataValue(), Environment);
    }
    
  }
  
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Unbounded (CurrentStatement, 1, CodeData, AllCodeDatas, LineNumber);
    LooFCompiler.SimplifyAllOutputVars (CurrentStatement, CodeData, AllCodeDatas, LineNumber);
  }
  @Override public String toString (LooFStatement CurrentStatement) {return "'pop'";}
};





LooFInterpreterFunction InterpreterFunction_Call = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFStatement Statement, LooFEnvironment Environment) {
    LooFTokenBranch[] Args = Statement.Args;
    LooFAdditionalCallStatementData AdditionalData = (LooFAdditionalCallStatementData) Statement.AdditionalData;
    
    int ExpectedGeneralStackSize = Environment.GeneralStack.size();
    
    // push args
    if (Args.length > 1) {
      ArrayList <LooFDataValue> ArgsToPush = new ArrayList <LooFDataValue> ();
      for (int i = 1; i < Args.length; i ++) {
        ArgsToPush.add(LooFInterpreter.EvaluateFormula (Args[i], Environment, null, null));
      }
      LooFDataValue ValueToPush = new LooFDataValue (ArgsToPush, new HashMap <String, LooFDataValue> ());
      Environment.GeneralStack.add(ValueToPush);
    }
    
    // pre-evaluated
    if (AdditionalData.NewIPLineNumber != null) {
      LooFInterpreter.JumpToFunction (Environment, AdditionalData.NewIPPageName, AdditionalData.NewIPLineNumber, ExpectedGeneralStackSize, false);
      return;
    }
    
    LooFDataValue FunctionToCall = LooFInterpreter.EvaluateFormula (Args[0], Environment, null, null);
    if (FunctionToCall.ValueType != DataValueType_Function) throw (new LooFInterpreterException (Environment, "'call' statements must take a function as its first arg, but the first arg was of type " + DataValueTypeNames[FunctionToCall.ValueType] + ".", new String[] {"InvalidArgType"}));
    LooFInterpreter.JumpToFunction (Environment, FunctionToCall.FunctionPageValue, FunctionToCall.FunctionLineValue, ExpectedGeneralStackSize, false);
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Unbounded (CurrentStatement, 1, CodeData, AllCodeDatas, LineNumber);
    Tuple3 <Integer, String, String[]> ReturnValue = GetFunctionCallData (CurrentStatement.Args, false, CodeData, AllCodeDatas, LineNumber, "'call'");
    CurrentStatement.AdditionalData = new LooFAdditionalCallStatementData (ReturnValue.Value1, ReturnValue.Value2);
  }
  @Override public String toString (LooFStatement CurrentStatement) {
    LooFAdditionalCallStatementData AdditionalData = (LooFAdditionalCallStatementData) CurrentStatement.AdditionalData;
    return "'call' (File: " + AdditionalData.NewIPPageName + ", line: " + AdditionalData.NewIPLineNumber + ")";
  }
};



class LooFAdditionalCallStatementData extends LooFAdditionalStatementData {
  
  Integer NewIPLineNumber;
  String NewIPPageName;
  
  public LooFAdditionalCallStatementData (Integer NewIPLineNumber, String NewIPPageName) {
    this.NewIPLineNumber = NewIPLineNumber;
    this.NewIPPageName = NewIPPageName;
  }
  
}





Tuple3 <Integer, String, String[]> GetFunctionCallData (LooFTokenBranch[] Args, boolean GetErrorTypesToCatch, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber, String FunctionName) {
  LooFTokenBranch FirstArg = Args[0];
  if (FirstArg.TokenType != TokenBranchType_PreEvaluatedFormula) return new Tuple3 <Integer, String, String[]> (null, null, null); // if we don't know the type of the first value, we can't figure out anything else
  LooFDataValue FirstArgValue = FirstArg.Result;
  if (FirstArgValue.ValueType != DataValueType_Function) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, FunctionName + " statements must take a function as its first arg, but the first arg was of type " + DataValueTypeNames[FirstArgValue.ValueType] + "."));
  Tuple3 <Integer, String, String[]> ReturnValue = new Tuple3 <Integer, String, String[]> (FirstArgValue.FunctionLineValue, FirstArgValue.FunctionPageValue, null);
  if (GetErrorTypesToCatch) ReturnValue.Value3 = LooFCompiler.GetStringArrayFromStatementArg (Args[1], 2, CodeData, AllCodeDatas, LineNumber);
  return ReturnValue;
}





LooFInterpreterFunction InterpreterFunction_Return = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFStatement Statement, LooFEnvironment Environment) {
    LooFTokenBranch[] Args = Statement.Args;
    
    if (Environment.GeneralStack.size() != LastItemOf (Environment.CallStackExpectedGeneralStackSizes)) throw (new LooFInterpreterException (Environment, "the size of the general stack is not the same as when the function was called.", new String[] {"IncorrectGeneralStackSize"}));
    
    if (Args.length > 0) {
      LooFDataValue ValueToPush = GetReturnStatementValueToPush (Args, 0, Environment);
      if (ValueToPush != null) Environment.GeneralStack.add(ValueToPush);
    }
    
    LooFInterpreter.ReturnFromFunction(Environment);
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Unbounded (CurrentStatement, 0, CodeData, AllCodeDatas, LineNumber);
  }
  @Override public String toString (LooFStatement CurrentStatement) {return "'return'";}
};





LooFInterpreterFunction InterpreterFunction_ReturnRaw = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFStatement Statement, LooFEnvironment Environment) {
    LooFTokenBranch[] Args = Statement.Args;
    
    if (Environment.GeneralStack.size() != LastItemOf (Environment.CallStackExpectedGeneralStackSizes)) throw (new LooFInterpreterException (Environment, "the size of the general stack is not the same as when the function was called.", new String[] {"IncorrectGeneralStackSize"}));
    
    LooFDataValue ValueToPush = LooFInterpreter.EvaluateFormula (Args[0], Environment, null, null);
    if (ValueToPush != null) Environment.GeneralStack.add(ValueToPush);
    
    LooFInterpreter.ReturnFromFunction(Environment);
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (CurrentStatement, 1, CodeData, AllCodeDatas, LineNumber);
  }
  @Override public String toString (LooFStatement CurrentStatement) {return "'returnRaw'";}
};





LooFInterpreterFunction InterpreterFunction_ReturnIf = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFStatement Statement, LooFEnvironment Environment) {
    LooFTokenBranch[] Args = Statement.Args;
    
    LooFDataValue FirstArgValue = LooFInterpreter.EvaluateFormula (Args[0], Environment, null, null);
    if (!GetDataValueTruthiness (FirstArgValue, Environment, null, null)) return;
    
    if (Environment.GeneralStack.size() != LastItemOf (Environment.CallStackExpectedGeneralStackSizes)) throw (new LooFInterpreterException (Environment, "the size of the general stack is not the same as when the function was called.", new String[] {"IncorrectGeneralStackSize"}));
    
    if (Args.length > 1) {
      LooFDataValue ValueToPush = GetReturnStatementValueToPush (Args, 1, Environment);
      if (ValueToPush != null) Environment.GeneralStack.add(ValueToPush);
    }
    
    LooFInterpreter.ReturnFromFunction(Environment);
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Unbounded (CurrentStatement, 1, CodeData, AllCodeDatas, LineNumber);
  }
  @Override public String toString (LooFStatement CurrentStatement) {return "'returnIf'";}
};





LooFInterpreterFunction InterpreterFunction_ReturnRawIf = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFStatement Statement, LooFEnvironment Environment) {
    LooFTokenBranch[] Args = Statement.Args;
    
    LooFDataValue FirstArgValue = LooFInterpreter.EvaluateFormula (Args[0], Environment, null, null);
    if (!GetDataValueTruthiness (FirstArgValue, Environment, null, null)) return;
    
    if (Environment.GeneralStack.size() != LastItemOf (Environment.CallStackExpectedGeneralStackSizes)) throw (new LooFInterpreterException (Environment, "the size of the general stack is not the same as when the function was called.", new String[] {"IncorrectGeneralStackSize"}));
    
    LooFDataValue ValueToPush = LooFInterpreter.EvaluateFormula (Args[1], Environment, null, null);
    if (ValueToPush != null) Environment.GeneralStack.add(ValueToPush);
    
    LooFInterpreter.ReturnFromFunction(Environment);
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (CurrentStatement, 2, CodeData, AllCodeDatas, LineNumber);
  }
  @Override public String toString (LooFStatement CurrentStatement) {return "'returnRawIf'";}
};



LooFDataValue GetReturnStatementValueToPush (LooFTokenBranch[] Args, int ArgsStart, LooFEnvironment Environment) {
  ArrayList <LooFDataValue> ArgsAsValues = new ArrayList <LooFDataValue> ();
  for (int i = ArgsStart; i < Args.length; i ++) {
    ArgsAsValues.add(LooFInterpreter.EvaluateFormula (Args[i], Environment, null, null));
  }
  return new LooFDataValue (ArgsAsValues, new HashMap <String, LooFDataValue> ());
}





LooFInterpreterFunction InterpreterFunction_If = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFStatement Statement, LooFEnvironment Environment) {
    LooFTokenBranch[] Args = Statement.Args;
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (CurrentStatement, 1, 2, CodeData, AllCodeDatas, LineNumber);
  }
  @Override public String toString (LooFStatement CurrentStatement) {return "'if'";}
};





LooFInterpreterFunction InterpreterFunction_Skip = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFStatement Statement, LooFEnvironment Environment) {
    LooFTokenBranch[] Args = Statement.Args;
    LooFAdditionalSkipStatementData AdditionalData = (LooFAdditionalSkipStatementData) Statement.AdditionalData;
    
    Environment.CurrentLineNumber = AdditionalData.MatchingEndStatementIndex - 1;
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (CurrentStatement, 0, 1, CodeData, AllCodeDatas, LineNumber);
    int MatchingEndStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"end"}, LineNumber, +1, CodeData.Statements, CodeData, AllCodeDatas);
    LooFTokenBranch[] Args = CurrentStatement.Args;
    if (Args.length == 0) {
      CurrentStatement.AdditionalData = new LooFAdditionalSkipStatementData (MatchingEndStatementIndex, false);
      return;
    }
    Boolean StartsFunction = LooFCompiler.GetBoolFromStatementArg (Args[0], 1, CodeData, AllCodeDatas, LineNumber);
    if (StartsFunction == null) ThrowLooFException (null, CodeData, AllCodeDatas, "'skip' statements can only take a final bool arg or no args.", new String[] {"InvalidArgType"});
    CurrentStatement.AdditionalData = new LooFAdditionalSkipStatementData (MatchingEndStatementIndex, StartsFunction);
  }
  @Override public int GetBlockLevelChange() {
    return 1;
  }
  @Override public String toString (LooFStatement CurrentStatement) {
    LooFAdditionalSkipStatementData AdditionalData = (LooFAdditionalSkipStatementData) CurrentStatement.AdditionalData;
    return "'skip' ('end' at: " + AdditionalData.MatchingEndStatementIndex + "; starts function: " + AdditionalData.StartsFunction + ")";
  }
};



class LooFAdditionalSkipStatementData extends LooFAdditionalStatementData {
  
  int MatchingEndStatementIndex;
  boolean StartsFunction;
  
  public LooFAdditionalSkipStatementData (int MatchingEndStatementIndex, boolean StartsFunction) {
    this.MatchingEndStatementIndex = MatchingEndStatementIndex;
    this.StartsFunction = StartsFunction;
  }
  
}





LooFInterpreterFunction InterpreterFunction_End = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFStatement Statement, LooFEnvironment Environment) {
    LooFTokenBranch[] Args = Statement.Args;
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (CurrentStatement, 0, CodeData, AllCodeDatas, LineNumber);
    int MatchingSkipStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"skip"}, LineNumber, -1, CodeData.Statements, CodeData, AllCodeDatas);
    LooFStatement MatchingSkipStatement = CodeData.Statements[MatchingSkipStatementIndex];
    LooFAdditionalSkipStatementData SkipStatementData = (LooFAdditionalSkipStatementData) MatchingSkipStatement.AdditionalData;
    if (SkipStatementData == null) throw new LooFCompilerException ("");
    CurrentStatement.AdditionalData = new LooFAdditionalEndStatementData (SkipStatementData.StartsFunction);
  }
  @Override public int GetBlockLevelChange() {
    return -1;
  }
  @Override public String toString (LooFStatement CurrentStatement) {return "'end'";}
};



class LooFAdditionalEndStatementData extends LooFAdditionalStatementData {
  
  boolean EndsFunction;
  
  public LooFAdditionalEndStatementData (boolean EndsFunction) {
    this.EndsFunction = EndsFunction;
  }
  
}





LooFInterpreterFunction InterpreterFunction_Loop = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFStatement Statement, LooFEnvironment Environment) {
    LooFTokenBranch[] Args = Statement.Args;
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (CurrentStatement, 0, 4, CodeData, AllCodeDatas, LineNumber);
    LooFTokenBranch[] Args = CurrentStatement.Args;
    if (Args.length > 0) LooFCompiler.SimplifySingleOutputVar (CurrentStatement, 0, CodeData, AllCodeDatas, LineNumber);
    int MatchingRepeatStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"repeat", "repeatIf"}, LineNumber, +1, CodeData.Statements, CodeData, AllCodeDatas);
    CurrentStatement.AdditionalData = new LooFAdditionalLoopingStatementData (MatchingRepeatStatementIndex);
  }
  @Override public int GetBlockLevelChange() {
    return 1;
  }
  @Override public String toString (LooFStatement CurrentStatement) {
    LooFAdditionalLoopingStatementData AdditionalData = (LooFAdditionalLoopingStatementData) CurrentStatement.AdditionalData;
    return "'loop' ('repeat' at: " + AdditionalData.MatchingRepeatStatementIndex + ")";
  }
};





LooFInterpreterFunction InterpreterFunction_ForEach = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFStatement Statement, LooFEnvironment Environment) {
    LooFTokenBranch[] Args = Statement.Args;
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (CurrentStatement, 2, 3, CodeData, AllCodeDatas, LineNumber);
    LooFTokenBranch[] Args = CurrentStatement.Args;
    LooFCompiler.SimplifySingleOutputVar (CurrentStatement, 0, CodeData, AllCodeDatas, LineNumber);
    if (Args.length == 3) LooFCompiler.SimplifySingleOutputVar (CurrentStatement, 2, CodeData, AllCodeDatas, LineNumber);
    int MatchingRepeatStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"repeat", "repeatIf"}, LineNumber, +1, CodeData.Statements, CodeData, AllCodeDatas);
    CurrentStatement.AdditionalData = new LooFAdditionalLoopingStatementData (MatchingRepeatStatementIndex);
  }
  @Override public int GetBlockLevelChange() {
    return 1;
  }
  @Override public String toString (LooFStatement CurrentStatement) {
    LooFAdditionalLoopingStatementData AdditionalData = (LooFAdditionalLoopingStatementData) CurrentStatement.AdditionalData;
    return "'forEach' ('repeat' at: " + AdditionalData.MatchingRepeatStatementIndex + ")";
  }
};





LooFInterpreterFunction InterpreterFunction_While = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFStatement Statement, LooFEnvironment Environment) {
    LooFTokenBranch[] Args = Statement.Args;
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (CurrentStatement, 1, CodeData, AllCodeDatas, LineNumber);
    int MatchingRepeatStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"repeat", "repeatIf"}, LineNumber, +1, CodeData.Statements, CodeData, AllCodeDatas);
    CurrentStatement.AdditionalData = new LooFAdditionalLoopingStatementData (MatchingRepeatStatementIndex);
  }
  @Override public int GetBlockLevelChange() {
    return 1;
  }
  @Override public String toString (LooFStatement CurrentStatement) {
    LooFAdditionalLoopingStatementData AdditionalData = (LooFAdditionalLoopingStatementData) CurrentStatement.AdditionalData;
    return "'while' ('repeat' at: " + AdditionalData.MatchingRepeatStatementIndex + ")";
  }
};



class LooFAdditionalLoopingStatementData extends LooFAdditionalStatementData {
  
  int MatchingRepeatStatementIndex;
  
  public LooFAdditionalLoopingStatementData (int MatchingRepeatStatementIndex) {
    this.MatchingRepeatStatementIndex = MatchingRepeatStatementIndex;
  }
  
}





LooFInterpreterFunction InterpreterFunction_Repeat = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFStatement Statement, LooFEnvironment Environment) {
    LooFTokenBranch[] Args = Statement.Args;
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (CurrentStatement, 0, CodeData, AllCodeDatas, LineNumber);
    int MatchingLoopingStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"loop", "forEach", "while"}, LineNumber, -1, CodeData.Statements, CodeData, AllCodeDatas);
    CurrentStatement.AdditionalData = new LooFAdditionalRepeatingStatementData (MatchingLoopingStatementIndex);
  }
  @Override public int GetBlockLevelChange() {
    return -1;
  }
  @Override public String toString (LooFStatement CurrentStatement) {
    LooFAdditionalRepeatingStatementData AdditionalData = (LooFAdditionalRepeatingStatementData) CurrentStatement.AdditionalData;
    return "'repeat' (loop at " + AdditionalData.MatchingLoopingStatementIndex + ")";
  }
};





LooFInterpreterFunction InterpreterFunction_RepeatIf = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFStatement Statement, LooFEnvironment Environment) {
    LooFTokenBranch[] Args = Statement.Args;
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (CurrentStatement, 1, CodeData, AllCodeDatas, LineNumber);
    int MatchingLoopingStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"loop", "forEach", "while"}, LineNumber, -1, CodeData.Statements, CodeData, AllCodeDatas);
    CurrentStatement.AdditionalData = new LooFAdditionalRepeatingStatementData (MatchingLoopingStatementIndex);
  }
  @Override public int GetBlockLevelChange() {
    return -1;
  }
  @Override public String toString (LooFStatement CurrentStatement) {
    LooFAdditionalRepeatingStatementData AdditionalData = (LooFAdditionalRepeatingStatementData) CurrentStatement.AdditionalData;
    return "'repeatIf' (loop at " + AdditionalData.MatchingLoopingStatementIndex + ")";
  }
};





LooFInterpreterFunction InterpreterFunction_Continue = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFStatement Statement, LooFEnvironment Environment) {
    LooFTokenBranch[] Args = Statement.Args;
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (CurrentStatement, 0, CodeData, AllCodeDatas, LineNumber);
    int MatchingLoopingStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"loop", "forEach", "while"}, LineNumber, -1, CodeData.Statements, CodeData, AllCodeDatas);
    CurrentStatement.AdditionalData = new LooFAdditionalRepeatingStatementData (MatchingLoopingStatementIndex);
  }
  @Override public String toString (LooFStatement CurrentStatement) {
    LooFAdditionalRepeatingStatementData AdditionalData = (LooFAdditionalRepeatingStatementData) CurrentStatement.AdditionalData;
    return "'continue' (loop at " + AdditionalData.MatchingLoopingStatementIndex + ")";
  }
};





LooFInterpreterFunction InterpreterFunction_ContinueIf = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFStatement Statement, LooFEnvironment Environment) {
    LooFTokenBranch[] Args = Statement.Args;
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (CurrentStatement, 1, CodeData, AllCodeDatas, LineNumber);
    int MatchingLoopingStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"loop", "forEach", "while"}, LineNumber, -1, CodeData.Statements, CodeData, AllCodeDatas);
    CurrentStatement.AdditionalData = new LooFAdditionalRepeatingStatementData (MatchingLoopingStatementIndex);
  }
  @Override public String toString (LooFStatement CurrentStatement) {
    LooFAdditionalRepeatingStatementData AdditionalData = (LooFAdditionalRepeatingStatementData) CurrentStatement.AdditionalData;
    return "'continueIf' (loop at " + AdditionalData.MatchingLoopingStatementIndex + ")";
  }
};



class LooFAdditionalRepeatingStatementData extends LooFAdditionalStatementData {
  
  
  int MatchingLoopingStatementIndex;
  
  public LooFAdditionalRepeatingStatementData (int MatchingLoopingStatementIndex) {
    this.MatchingLoopingStatementIndex = MatchingLoopingStatementIndex;
  }
  
}





LooFInterpreterFunction InterpreterFunction_Break = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFStatement Statement, LooFEnvironment Environment) {
    LooFTokenBranch[] Args = Statement.Args;
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (CurrentStatement, 0, CodeData, AllCodeDatas, LineNumber);
    int MatchingRepeatStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"repeat", "repeatIf"}, LineNumber, +1, CodeData.Statements, CodeData, AllCodeDatas);
    CurrentStatement.AdditionalData = new LooFAdditionalBreakStatementData (MatchingRepeatStatementIndex);
  }
  @Override public String toString (LooFStatement CurrentStatement) {
    LooFAdditionalBreakStatementData AdditionalData = (LooFAdditionalBreakStatementData) CurrentStatement.AdditionalData;
    return "'break' (repeat at " + AdditionalData.MatchingRepeatStatementIndex + ")";
  }
};





LooFInterpreterFunction InterpreterFunction_BreakIf = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFStatement Statement, LooFEnvironment Environment) {
    LooFTokenBranch[] Args = Statement.Args;
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (CurrentStatement, 1, CodeData, AllCodeDatas, LineNumber);
    int MatchingRepeatStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"repeat", "repeatIf"}, LineNumber, +1, CodeData.Statements, CodeData, AllCodeDatas);
    CurrentStatement.AdditionalData = new LooFAdditionalBreakStatementData (MatchingRepeatStatementIndex);
  }
  @Override public String toString (LooFStatement CurrentStatement) {
    LooFAdditionalBreakStatementData AdditionalData = (LooFAdditionalBreakStatementData) CurrentStatement.AdditionalData;
    return "'breakIf' (repeat at " + AdditionalData.MatchingRepeatStatementIndex + ")";
  }
};



class LooFAdditionalBreakStatementData extends LooFAdditionalStatementData {
  
  int MatchingRepeatStatementIndex;
  
  public LooFAdditionalBreakStatementData (int MatchingRepeatStatementIndex) {
    this.MatchingRepeatStatementIndex = MatchingRepeatStatementIndex;
  }
  
}





LooFInterpreterFunction InterpreterFunction_Error = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFStatement Statement, LooFEnvironment Environment) {
    LooFTokenBranch[] Args = Statement.Args;
    LooFAdditionalErrorStatementData AdditionalData = (LooFAdditionalErrorStatementData) Statement.AdditionalData;
    
    String ErrorMessage = GetErrorStatementErrorMessage (Args[0], AdditionalData, Environment, "first");
    if (Args.length == 1) throw (new LooFInterpreterException (Environment, ErrorMessage, new String [0]));
    
    String[] ErrorTypeTags = GetErrorStatementErrorTypeTags (Args[1], AdditionalData, Environment, "second");
    throw (new LooFInterpreterException (Environment, ErrorMessage, ErrorTypeTags));
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (CurrentStatement, 1, 2, CodeData, AllCodeDatas, LineNumber);
    LooFTokenBranch[] Args = CurrentStatement.Args;
    String ErrorMessage = LooFCompiler.GetStringFromStatementArg (Args[0], 1, CodeData, AllCodeDatas, LineNumber);
    String[] ErrorTypeTags = (Args.length == 2) ? LooFCompiler.GetStringArrayFromStatementArg (Args[1], 2, CodeData, AllCodeDatas, LineNumber) : null;
    CurrentStatement.AdditionalData = new LooFAdditionalErrorStatementData (ErrorMessage, ErrorTypeTags);
  }
  @Override public String toString (LooFStatement CurrentStatement) {
    LooFAdditionalErrorStatementData AdditionalData = (LooFAdditionalErrorStatementData) CurrentStatement.AdditionalData;
    return "'error' (Message: " + AdditionalData.ErrorMessage + "; error type tags: {" + CombineStringsWithSeperator (AdditionalData.ErrorTypeTags, ", ") + "})";
  }
};





LooFInterpreterFunction InterpreterFunction_ErrorIf = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFStatement Statement, LooFEnvironment Environment) {
    LooFTokenBranch[] Args = Statement.Args;
    LooFAdditionalErrorStatementData AdditionalData = (LooFAdditionalErrorStatementData) Statement.AdditionalData;
    
    LooFDataValue ConditionValue = LooFInterpreter.EvaluateFormula (Args[0], Environment, null, null);
    boolean Condition = GetDataValueTruthiness (ConditionValue, Environment, null, null);
    if (!Condition) return;
    
    String ErrorMessage = GetErrorStatementErrorMessage (Args[1], AdditionalData, Environment, "second");
    if (Args.length == 2) throw (new LooFInterpreterException (Environment, ErrorMessage, new String [0]));
    
    String[] ErrorTypeTags = GetErrorStatementErrorTypeTags (Args[2], AdditionalData, Environment, "third");
    throw (new LooFInterpreterException (Environment, ErrorMessage, ErrorTypeTags));
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (CurrentStatement, 2, 3, CodeData, AllCodeDatas, LineNumber);
    LooFTokenBranch[] Args = CurrentStatement.Args;
    String ErrorMessage = LooFCompiler.GetStringFromStatementArg (Args[1], 2, CodeData, AllCodeDatas, LineNumber);
    String[] ErrorTypeTags = (Args.length == 2) ? LooFCompiler.GetStringArrayFromStatementArg (Args[2], 3, CodeData, AllCodeDatas, LineNumber) : null;
    CurrentStatement.AdditionalData = new LooFAdditionalErrorStatementData (ErrorMessage, ErrorTypeTags);
  }
  @Override public String toString (LooFStatement CurrentStatement) {
    LooFAdditionalErrorStatementData AdditionalData = (LooFAdditionalErrorStatementData) CurrentStatement.AdditionalData;
    return "'errorIf' (Message: " + AdditionalData.ErrorMessage + "; error type tags: {" + CombineStringsWithSeperator (AdditionalData.ErrorTypeTags, ", ") + "})";
  }
};



class LooFAdditionalErrorStatementData extends LooFAdditionalStatementData {
  
  String ErrorMessage;
  String[] ErrorTypeTags;
  
  public LooFAdditionalErrorStatementData (String ErrorMessage, String[] ErrorTypeTags) {
    this.ErrorMessage = ErrorMessage;
    this.ErrorTypeTags = ErrorTypeTags;
  }
  
}



String GetErrorStatementErrorMessage (LooFTokenBranch Arg, LooFAdditionalErrorStatementData AdditionalData, LooFEnvironment Environment, String ArgIndexName) {
  
  if (AdditionalData.ErrorMessage != null) return AdditionalData.ErrorMessage;
  
  LooFDataValue ErrorMessageValue = LooFInterpreter.EvaluateFormula (Arg, Environment, null, null);
  if (ErrorMessageValue.ValueType != DataValueType_String) throw (new LooFInterpreterException (Environment, "'error' statements must take a string as its " + ArgIndexName + " arg, but the " + ArgIndexName + " arg was of type " + DataValueTypeNames[ErrorMessageValue.ValueType] + ".", new String[] {"InvalidArgType"}));
  return ErrorMessageValue.StringValue;
  
}



String[] GetErrorStatementErrorTypeTags (LooFTokenBranch Arg, LooFAdditionalErrorStatementData AdditionalData, LooFEnvironment Environment, String ArgIndexName) {
  
  if (AdditionalData.ErrorTypeTags != null) return AdditionalData.ErrorTypeTags;
  
  LooFDataValue ErrorTypeTagsValue = LooFInterpreter.EvaluateFormula (Arg, Environment, null, null);
  if (ErrorTypeTagsValue.ValueType != DataValueType_Table) throw (new LooFInterpreterException (Environment, "'error' statements must take a table of string as its " + ArgIndexName + " arg, but the " + ArgIndexName + " arg was of type " + DataValueTypeNames[ErrorTypeTagsValue.ValueType] + ".", new String[] {"InvalidArgType"}));
  ArrayList <LooFDataValue> ErrorTypeTagsList = ErrorTypeTagsValue.ArrayValue;
  String[] ErrorTypeTags = new String [ErrorTypeTagsList.size()];
  for (int i = 0; i < ErrorTypeTags.length; i ++) {
    LooFDataValue CurrentErrorType = ErrorTypeTagsList.get(i);
    if (CurrentErrorType.ValueType != DataValueType_String) throw (new LooFInterpreterException (Environment, "'error' statements must take a table of strings as its " + ArgIndexName + " arg, but the table given has a value of type " + DataValueTypeNames[CurrentErrorType.ValueType] + ".", new String[] {"InvalidArgType"}));
    ErrorTypeTags[i] = CurrentErrorType.StringValue;
  }
  return ErrorTypeTags;
  
}





LooFInterpreterFunction InterpreterFunction_SetPassedErrors = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFStatement Statement, LooFEnvironment Environment) {
    LooFTokenBranch[] Args = Statement.Args;
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (CurrentStatement, 1, CodeData, AllCodeDatas, LineNumber);
    String[] ErrorTypesToPass = LooFCompiler.GetStringArrayFromStatementArg (CurrentStatement.Args[0], 1, CodeData, AllCodeDatas, LineNumber);
    CurrentStatement.AdditionalData = new LooFAdditionalSetPassedErrorsStatementData (ErrorTypesToPass);
  }
  @Override public String toString (LooFStatement CurrentStatement) {
    LooFAdditionalSetPassedErrorsStatementData AdditionalData = (LooFAdditionalSetPassedErrorsStatementData) CurrentStatement.AdditionalData;
    return "'setPassedErrors' (Error type tags: {" + CombineStringsWithSeperator (AdditionalData.ErrorTypesToPass, ", ") + "})";
  }
};



class LooFAdditionalSetPassedErrorsStatementData extends LooFAdditionalStatementData {
  
  String[] ErrorTypesToPass;
  
  public LooFAdditionalSetPassedErrorsStatementData (String[] ErrorTypesToPass) {
    this.ErrorTypesToPass = ErrorTypesToPass;
  }
  
}





LooFInterpreterFunction InterpreterFunction_Try = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFStatement Statement, LooFEnvironment Environment) {
    LooFTokenBranch[] Args = Statement.Args;
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Unbounded (CurrentStatement, 2, CodeData, AllCodeDatas, LineNumber);
    Tuple3 <Integer, String, String[]> ReturnValue = GetFunctionCallData (CurrentStatement.Args, true, CodeData, AllCodeDatas, LineNumber, "'try'");
    CurrentStatement.AdditionalData = new LooFAdditionalTryStatementData (ReturnValue.Value1, ReturnValue.Value2, ReturnValue.Value3);
  }
  @Override public String toString (LooFStatement CurrentStatement) {
    LooFAdditionalTryStatementData AdditionalData = (LooFAdditionalTryStatementData) CurrentStatement.AdditionalData;
    return "'try' (File: " + AdditionalData.NewIPFileName + ", line: " + AdditionalData.NewIPLineNumber + "; error types to catch: {" + CombineStringsWithSeperator (AdditionalData.ErrorTypesToCatch, ", ") + "})";
  }
};



class LooFAdditionalTryStatementData extends LooFAdditionalStatementData {
  
  Integer NewIPLineNumber;
  String NewIPFileName;
  String[] ErrorTypesToCatch;
  
  public LooFAdditionalTryStatementData (Integer NewIPLineNumber, String NewIPFileName, String[] ErrorTypesToCatch) {
    this.NewIPLineNumber = NewIPLineNumber;
    this.NewIPFileName = NewIPFileName;
    this.ErrorTypesToCatch = ErrorTypesToCatch;
  }
  
}





LooFInterpreterFunction InterpreterFunction_CallOutside = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFStatement Statement, LooFEnvironment Environment) {
    LooFTokenBranch[] Args = Statement.Args;
    LooFAdditionalCallOutsideStatementData AdditionalData = (LooFAdditionalCallOutsideStatementData) Statement.AdditionalData;
    
    LooFInterpreterModule ModuleToCall = GetCallStatementModule (Args[0], AdditionalData, Environment);
    LooFModuleData ModuleData = Environment.ModuleDatas.get(ModuleToCall);
    
    ModuleToCall.HandleCall (RemoveFirstItem (Args, LooFTokenBranch.class), Environment, ModuleData);
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Unbounded (CurrentStatement, 1, CodeData, AllCodeDatas, LineNumber);
    LooFTokenBranch[] Args = CurrentStatement.Args;
    String ModuleName = LooFCompiler.GetStringFromStatementArg (Args[0], 1, CodeData, AllCodeDatas, LineNumber);
    LooFInterpreterModule ModuleToCall = AddonsData.InterpreterModules.getOrDefault (ModuleName, null);
    if (ModuleToCall == null) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "could not find any module named \"" + ModuleName + "\"."));
    CurrentStatement.AdditionalData = new LooFAdditionalCallOutsideStatementData (ModuleName, ModuleToCall);
  }
  @Override public String toString (LooFStatement CurrentStatement) {
    LooFAdditionalCallOutsideStatementData AdditionalData = (LooFAdditionalCallOutsideStatementData) CurrentStatement.AdditionalData;
    return "'callOutside' (Module name: " + AdditionalData.ModuleName + ")";
  }
};



class LooFAdditionalCallOutsideStatementData extends LooFAdditionalStatementData {
  
  String ModuleName;
  LooFInterpreterModule ModuleToCall;
  
  public LooFAdditionalCallOutsideStatementData (String ModuleName, LooFInterpreterModule ModuleToCall) {
    this.ModuleName = ModuleName;
    this.ModuleToCall = ModuleToCall;
  }
  
}



LooFInterpreterModule GetCallStatementModule (LooFTokenBranch Arg, LooFAdditionalCallOutsideStatementData AdditionalData, LooFEnvironment Environment) {
  
  if (AdditionalData.ModuleToCall != null) return AdditionalData.ModuleToCall;
    
  LooFDataValue ModuleNameValue = LooFInterpreter.EvaluateFormula (Arg, Environment, null, null);
  if (ModuleNameValue.ValueType != DataValueType_String) throw (new LooFInterpreterException (Environment, "'callOutside' statements must take a string as its first arg, but the arg was of type " + DataValueTypeNames[ModuleNameValue.ValueType] + ".", new String[] {"InvalidArgType"}));
  String ModuleName = ModuleNameValue.StringValue;
  HashMap <String, LooFInterpreterModule> InterpreterModules = Environment.AddonsData.InterpreterModules;
  LooFInterpreterModule FoundModule = InterpreterModules.getOrDefault(ModuleName, null);
  if (FoundModule == null) throw (new LooFInterpreterException (Environment, "could not find any module named \"" + ModuleName + "\".", new String[] {"InvalidArgType"}));
  return FoundModule;
  
}





LooFInterpreterFunction InterpreterFunction_TODO = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFStatement Statement, LooFEnvironment Environment) {
    LooFTokenBranch[] Args = Statement.Args;
    
    throw (new LooFInterpreterException (Environment, Args[0].StringValue, new String[] {"TODO"}));
    
  }
  @Override public void FinishStatement (LooFStatement CurrentStatement, LooFAddonsData AddonsData, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (CurrentStatement, 1, CodeData, AllCodeDatas, LineNumber);
    LooFTokenBranch[] Args = CurrentStatement.Args;
    String Details = LooFCompiler.GetStringFromStatementArg (Args[0], 1, CodeData, AllCodeDatas, LineNumber);
    if (Details == null) throw (new LooFCompilerException (CodeData, AllCodeDatas, LineNumber, "'TODO:' statements must take a final string as its only arg"));
    CurrentStatement.AdditionalData = new LooFAdditionalTODOStatementData (Details);
  }
  @Override
  public boolean AddToCombinedTokens() {return true;}
  @Override public String toString (LooFStatement CurrentStatement) {
    LooFAdditionalTODOStatementData AdditionalData = (LooFAdditionalTODOStatementData) CurrentStatement.AdditionalData;
    return "'TODO:' (Details: " + AdditionalData.Details + ")";
  }
};



class LooFAdditionalTODOStatementData extends LooFAdditionalStatementData {
  
  String Details;
  
  public LooFAdditionalTODOStatementData (String Details) {
    this.Details = Details;
  }
  
}
