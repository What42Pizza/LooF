LooFInterpreterFunction InterpreterFunction_Push = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 1, CodeData, LineNumber);
  }
  @Override public String toString() {return "'push'";}
};





LooFInterpreterFunction InterpreterFunction_Pop = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Unbounded (Statement, 1, CodeData, LineNumber);
    LooFCompiler.SimplifyAllOutputVars (Statement, CodeData, LineNumber);
  }
  @Override public String toString() {return "'pop'";}
};





LooFInterpreterFunction InterpreterFunction_Call = new LooFInterpreterFunction() {
  String NewIPFileName;
  Integer NewIPLineNumber;
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Unbounded (Statement, 1, CodeData, LineNumber);
    ReturnValue Return = GetFunctionCallData (Statement.Args, false, CodeData, LineNumber, "call");
    NewIPFileName = Return.StringValue;
    NewIPLineNumber = Return.IntegerValue;
  }
  @Override public String toString() {return "'call'";}
};





ReturnValue GetFunctionCallData (LooFTokenBranch[] Args, boolean GetErrorTypesToCatch, LooFCodeData CodeData, int LineNumber, String FunctionName) {
  LooFTokenBranch FirstArg = Args[0];
  if (FirstArg.TokenType != TokenBranchType_PreEvaluatedFormula) return new ReturnValue(); // if we don't know the type of the first value, we can't figure out anything else
  LooFDataValue FirstArgValue = FirstArg.Result;
  ReturnValue Return = new ReturnValue ();
  switch (FirstArgValue.ValueType) {
    
    
    
    case (DataValueType_Int):
      
      // line number
      Return.IntValue = (int) FirstArgValue.IntValue;
      
      // error types to catch
      if (GetErrorTypesToCatch)
        Return.StringArrayValue = GetErrorTypesToCatch (Args[1], CodeData, LineNumber, 2);
      
      return Return;
    
    
    
    case (DataValueType_String):
      if (Args.length == 1) throw (new LooFCompileException (CodeData, LineNumber, FunctionName + "statements that take a string as its first arg must have an int as its second arg, but only one arg was found. (maybe you don't need quotation marks?)"));
      
      // file name
      Return.StringValue = FirstArgValue.StringValue;
      
      // line number
      LooFTokenBranch SecondArg = Args[1];
      if (SecondArg.TokenType == TokenBranchType_PreEvaluatedFormula) {
        LooFDataValue SecondArgValue = SecondArg.Result;
        if (SecondArgValue.ValueType != DataValueType_Int) throw (new LooFCompileException (CodeData, LineNumber, FunctionName + "statements that take a string as its first arg must have an int as its second arg, but the second arg was of type " + TokenBranchTypeNames[SecondArg.TokenType] + ". (maybe you don't need quotation marks?)"));
        Return.IntegerValue = (int) SecondArgValue.IntValue;
      }
      
      // error types to catch
      if (GetErrorTypesToCatch)
        Return.StringArrayValue = GetErrorTypesToCatch (Args[2], CodeData, LineNumber, 3);
      
      return Return;
    
    
    
    default:
      throw (new LooFCompileException (CodeData, LineNumber, FunctionName + "statements must take an int or a string as its first arg, but the first arg was of type " + TokenBranchTypeNames[FirstArgValue.ValueType] + "."));
    
    
    
  }
}





String[] GetErrorTypesToCatch (LooFTokenBranch InputArg, LooFCodeData CodeData, int LineNumber, int ArgNumber) {
  if (InputArg.TokenType != TokenBranchType_PreEvaluatedFormula) return null;
  LooFDataValue InputArgValue = InputArg.Result;
  if (InputArgValue.ValueType != DataValueType_Table) throw (new LooFCompileException (CodeData, LineNumber, "arg number " + ArgNumber + " was expected to be a table for the error types to catch, but the table given was of type " + TokenBranchTypeNames[InputArgValue.ValueType] + "."));
  ArrayList <LooFDataValue> ErrorTypesAsValues = InputArgValue.ArrayValue;
  String[] ErrorTypesToCatch = new String [ErrorTypesAsValues.size()];
  for (int i = 0; i < ErrorTypesToCatch.length; i ++) {
    LooFDataValue CurrentErrorTypeAsValue = ErrorTypesAsValues.get(i);
    if (CurrentErrorTypeAsValue.ValueType != DataValueType_String) throw (new LooFCompileException (CodeData, LineNumber, "arg number " + ArgNumber + " was expected to be a table of strings for the error types to catch, but the table given contained a value of type " + TokenBranchTypeNames[CurrentErrorTypeAsValue.ValueType] + "."));
    String CurrentErrorTypeToCatch = CurrentErrorTypeAsValue.StringValue;
    ErrorTypesToCatch[i] = CurrentErrorTypeToCatch;
  }
  return ErrorTypesToCatch;
}





LooFInterpreterFunction InterpreterFunction_Return = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Unbounded (Statement, 0, CodeData, LineNumber);
  }
  @Override public String toString() {return "'return'";}
};





LooFInterpreterFunction InterpreterFunction_ReturnIf = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Unbounded (Statement, 1, CodeData, LineNumber);
  }
  @Override public String toString() {return "'returnIf'";}
};





LooFInterpreterFunction InterpreterFunction_If = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 1, 2, CodeData, LineNumber);
  }
  @Override public String toString() {return "'if'";}
};





LooFInterpreterFunction InterpreterFunction_Skip = new LooFInterpreterFunction() {
  int MatchingEndStatementIndex;
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 0, CodeData, LineNumber);
    MatchingEndStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"end"}, LineNumber, +1, CodeData.Statements, CodeData);
  }
  @Override public int GetBlockLevelChange() {
    return 1;
  }
  @Override public String toString() {return "'skip' (end at " + MatchingEndStatementIndex + ")";}
};





LooFInterpreterFunction InterpreterFunction_End = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 0, CodeData, LineNumber);
  }
  @Override public int GetBlockLevelChange() {
    return -1;
  }
  @Override public String toString() {return "'end'";}
};





LooFInterpreterFunction InterpreterFunction_Loop = new LooFInterpreterFunction() {
  int MatchingRepeatStatementIndex;
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 0, 4, CodeData, LineNumber);
    LooFTokenBranch[] Args = Statement.Args;
    if (Args.length > 0) LooFCompiler.SimplifySingleOutputVar (Statement, 0, CodeData, LineNumber);
    MatchingRepeatStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"repeat", "repeatIf"}, LineNumber, +1, CodeData.Statements, CodeData);
  }
  @Override public int GetBlockLevelChange() {
    return 1;
  }
  @Override public String toString() {return "'loop' (repeat at " + MatchingRepeatStatementIndex + ")";}
};





LooFInterpreterFunction InterpreterFunction_ForEach = new LooFInterpreterFunction() {
  int MatchingRepeatStatementIndex;
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 2, 3, CodeData, LineNumber);
    LooFTokenBranch[] Args = Statement.Args;
    LooFCompiler.SimplifySingleOutputVar (Statement, 0, CodeData, LineNumber);
    if (Args.length == 3) LooFCompiler.SimplifySingleOutputVar (Statement, 2, CodeData, LineNumber);
    MatchingRepeatStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"repeat", "repeatIf"}, LineNumber, +1, CodeData.Statements, CodeData);
  }
  @Override public int GetBlockLevelChange() {
    return 1;
  }
  @Override public String toString() {return "'forEach' (repeat at " + MatchingRepeatStatementIndex + ")";}
};





LooFInterpreterFunction InterpreterFunction_While = new LooFInterpreterFunction() {
  int MatchingRepeatStatementIndex;
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 1, CodeData, LineNumber);
    MatchingRepeatStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"repeat", "repeatIf"}, LineNumber, +1, CodeData.Statements, CodeData);
  }
  @Override public int GetBlockLevelChange() {
    return 1;
  }
  @Override public String toString() {return "'while' (repeat at " + MatchingRepeatStatementIndex + ")";}
};





LooFInterpreterFunction InterpreterFunction_Repeat = new LooFInterpreterFunction() {
  int MatchingLoopingStatementIndex;
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 0, CodeData, LineNumber);
    MatchingLoopingStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"loop", "forEach", "while"}, LineNumber, -1, CodeData.Statements, CodeData);
  }
  @Override public int GetBlockLevelChange() {
    return -1;
  }
  @Override public String toString() {return "'repeat' (loop at " + MatchingLoopingStatementIndex + ")";}
};





LooFInterpreterFunction InterpreterFunction_RepeatIf = new LooFInterpreterFunction() {
  int MatchingLoopingStatementIndex;
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 1, CodeData, LineNumber);
    MatchingLoopingStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"loop", "forEach", "while"}, LineNumber, -1, CodeData.Statements, CodeData);
  }
  @Override public int GetBlockLevelChange() {
    return -1;
  }
  @Override public String toString() {return "'repeatIf' (loop at " + MatchingLoopingStatementIndex + ")";}
};





LooFInterpreterFunction InterpreterFunction_Continue = new LooFInterpreterFunction() {
  int MatchingLoopingStatementIndex;
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 0, CodeData, LineNumber);
    MatchingLoopingStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"loop", "forEach", "while"}, LineNumber, -1, CodeData.Statements, CodeData);
  }
  @Override public String toString() {return "'continue' (loop at " + MatchingLoopingStatementIndex + ")";}
};





LooFInterpreterFunction InterpreterFunction_ContinueIf = new LooFInterpreterFunction() {
  int MatchingLoopingStatementIndex;
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 1, CodeData, LineNumber);
    MatchingLoopingStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"loop", "forEach", "while"}, LineNumber, -1, CodeData.Statements, CodeData);
  }
  @Override public String toString() {return "'continueIf' (loop at " + MatchingLoopingStatementIndex + ")";}
};





LooFInterpreterFunction InterpreterFunction_Break = new LooFInterpreterFunction() {
  int MatchingRepeatStatementIndex;
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 0, CodeData, LineNumber);
    MatchingRepeatStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"repeat", "repeatIf"}, LineNumber, +1, CodeData.Statements, CodeData);
  }
  @Override public String toString() {return "'break' (repeat at " + MatchingRepeatStatementIndex + ")";}
};





LooFInterpreterFunction InterpreterFunction_BreakIf = new LooFInterpreterFunction() {
  int MatchingRepeatStatementIndex;
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 1, CodeData, LineNumber);
    MatchingRepeatStatementIndex = LooFCompiler.FindStatementOnSameLevel (new String[] {"repeat", "repeatIf"}, LineNumber, +1, CodeData.Statements, CodeData);
  }
  @Override public String toString() {return "'breakIf' (repeat at " + MatchingRepeatStatementIndex + ")";}
};





LooFInterpreterFunction InterpreterFunction_Error = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 1, 2, CodeData, LineNumber);
  }
  @Override public String toString() {return "'error'";}
};





LooFInterpreterFunction InterpreterFunction_ErrorIf = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Bounded (Statement, 2, 3, CodeData, LineNumber);
  }
  @Override public String toString() {return "'errorIf'";}
};





LooFInterpreterFunction InterpreterFunction_Try = new LooFInterpreterFunction() {
  String NewIPFileName;
  Integer NewIPLineNumber;
  String[] ErrorTypesToCatch;
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Unbounded (Statement, 2, CodeData, LineNumber);
    ReturnValue Return = GetFunctionCallData (Statement.Args, true, CodeData, LineNumber, "try");
    NewIPFileName = Return.StringValue;
    NewIPLineNumber = Return.IntegerValue;
    ErrorTypesToCatch = Return.StringArrayValue;
  }
  @Override public String toString() {return "'call'";}
};





LooFInterpreterFunction InterpreterFunction_CallOutside = new LooFInterpreterFunction() {
  @Override public void HandleFunctionCall (LooFTokenBranch[] Args, LooFEnvironment Environment) {
    
  }
  @Override public void FinishStatement (LooFStatement Statement, LooFCodeData CodeData, int LineNumber) {
    LooFCompiler.EnsureStatementHasCorrectNumberOfArgs_Unbounded (Statement, 1, CodeData, LineNumber);
  }
  @Override public String toString() {return "'callOutside'";}
};
