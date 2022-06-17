LooFInterpreter LooFInterpreter = new LooFInterpreter();

class LooFInterpreter {
  
  
  
  
  
  
  
  
  
  
  void ExecuteNextEnvironmentStatements (LooFEnvironment Environment, int NumOfStatements) throws LooFInterpreterException  {
    if (Environment.Stopped) throw (new LooFInterpreterException (Environment, "this environment is in a stopped state.", new String[0]));
    for (int i = 0; i < NumOfStatements; i ++) {
      ExecuteNextStatement (Environment);
      if (Environment.Stopped) return;
    }
  }
  
  
  
  void ExecuteNextStatement (LooFEnvironment Environment) throws LooFInterpreterException {
    LooFStatement CurrentStatement = Environment.CurrentCodeData.Statements[Environment.CurrentLineNumber];
    
    try {
      switch (CurrentStatement.StatementType) {
        
        case (StatementType_Assignment):
          ExecuteAssignmentStatement (CurrentStatement, Environment);
          break;
        
        case (StatementType_Function):
          ExecuteFunctionStatement (CurrentStatement, Environment);
          break;
        
      }
    } catch (LooFInterpreterException e) {
      HandleEnvironmentException (e, Environment);
    }
    
    IncrementEnvironmentLineNumber (Environment);
    
  }
  
  
  
  void IncrementEnvironmentLineNumber (LooFEnvironment Environment) {
    
    Environment.CurrentLineNumber ++;
    if (Environment.Stopped) return;
    
    int StatementsLength = Environment.CurrentCodeData.Statements.length;
    if (Environment.CurrentLineNumber < StatementsLength) return;
    Environment.CurrentLineNumber = StatementsLength - 1; // this makes the exception work correctly
    throw (new LooFInterpreterException (Environment, "execution cannot reach the end of the file. (maybe a function is missing a return statement?)", new String[] {"ReachedEndOfFile"}));
    
  }
  
  
  
  
  
  void ExecuteAssignmentStatement (LooFStatement CurrentStatement, LooFEnvironment Environment) {
    String OutputVarName = CurrentStatement.VarName;
    LooFInterpreterAssignment StatementAssignment = CurrentStatement.Assignment;
    LooFTokenBranch[] IndexQueries = CurrentStatement.IndexQueries;
    LooFTokenBranch NewValueFormula = CurrentStatement.NewValueFormula;
    
    if (IndexQueries.length == 0) {
      LooFDataValue OldVarValue = GetVariableValue (OutputVarName, Environment, true);
      LooFDataValue NewVarValue = StatementAssignment.GetNewVarValue (OldVarValue, NewValueFormula, Environment);
      SetVariableValue (OutputVarName, NewVarValue, Environment);
      return;
    }
    
    LooFDataValue TargetTable = GetTargetTableForStatement (CurrentStatement, Environment);
    LooFDataValue IndexValue = EvaluateFormula (LastItemOf (IndexQueries), Environment, null, null);
    LooFDataValue OldVarValue = GetDataValueIndex (TargetTable, IndexValue, true, Environment);
    LooFDataValue NewVarValue = StatementAssignment.GetNewVarValue (OldVarValue, NewValueFormula, Environment);
    SetDataValueIndex (TargetTable, IndexValue, NewVarValue, Environment);
    
  }
  
  
  
  LooFDataValue GetTargetTableForStatement (LooFStatement CurrentStatement, LooFEnvironment Environment) {
    LooFDataValue TargetTable = GetVariableValue (CurrentStatement.VarName, Environment, true);
    LooFTokenBranch[] IndexQueries = CurrentStatement.IndexQueries;
    for (int i = 0; i < IndexQueries.length - 1; i ++) {
      LooFDataValue ValueToIndexWith = EvaluateFormula (IndexQueries[i], Environment, null, null);
      TargetTable = GetDataValueIndex (TargetTable, ValueToIndexWith, false, Environment);
    }
    return TargetTable;
  }
  
  
  
  
  
  void ExecuteFunctionStatement (LooFStatement Statement, LooFEnvironment Environment) {
    LooFInterpreterFunction StatementFunction = Statement.Function;
    StatementFunction.HandleFunctionCall(Statement, Environment);
  }
  
  
  
  
  
  
  
  
  
  
  void HandleEnvironmentException (LooFInterpreterException CurrentException, LooFEnvironment Environment) throws LooFInterpreterException  {
    ArrayList <String> StackTracePages = new ArrayList <String> ();
    ArrayList <Integer> StackTraceLines = new ArrayList <Integer> ();
    ArrayList <Boolean> AttemptErrorCatches = Environment.CallStackAttemptErrorCatches;
    boolean CanPassErrors = true;
    
    while (AttemptErrorCatches.size() > 0) {
      
      String CurrentPageName = LastItemOf (Environment.CallStackPageNames);
      int CurrentLineNumber = LastItemOf (Environment.CallStackLineNumbers);
      String[] CurrentErrorTypesToPass = LastItemOf (Environment.CallStackErrorTypesToPass);
      boolean AttemptErrorCatch = LastItemOf (AttemptErrorCatches);
      
      ReturnFromFunction (Environment);
      
      if (!(CanPassErrors && AnyItemsMatch (CurrentException.ErrorTypeTags, CurrentErrorTypesToPass))) {
        CanPassErrors = false;
        StackTracePages.add(CurrentPageName);
        StackTraceLines.add(CurrentLineNumber);
      }
      
      if (AttemptErrorCatch) {
        LooFStatement CurrentEnvironmentStatement = Environment.CurrentCodeData.Statements[Environment.CurrentLineNumber];
        boolean ErrorWasCaught = CurrentEnvironmentStatement.Function.AttemptErrorCatch(CurrentException, CurrentEnvironmentStatement, StackTracePages, StackTraceLines, Environment);
        if (ErrorWasCaught) return;
      }
      
    }
    
    throw (new LooFInterpreterException ("Uncaught error during execution:     " + CurrentException.Message, StackTracePages, StackTraceLines));
    
  }
  
  
  
  
  
  
  
  
  
  
  void JumpToFunction (LooFEnvironment Environment, String NewPageName, int NewLineNumber, int ExpectedGeneralStackSize, boolean AttemptErrorCatch) {
    if (NewLineNumber < 0) throw (new LooFInterpreterException (Environment, "the function being jumped to has a negative line number.", new String[] {"JumpToFunctionError", "NegativeLineNumber"}));
    NewLineNumber --;
    
    // add call stack data
    Environment.VariableListsStack.add(new HashMap <String, LooFDataValue> ());
    Environment.CallStackPageNames.add(Environment.CurrentPageName);
    Environment.CallStackLineNumbers.add(Environment.CurrentLineNumber);
    Environment.CallStackAttemptErrorCatches.add(AttemptErrorCatch);
    Environment.CallStackErrorTypesToPass.add(new String [0]);
    Environment.CallStackExpectedGeneralStackSizes.add(ExpectedGeneralStackSize);
    Environment.CallStackInitialLockedValuesSizes.add(Environment.CallStackLockedValues.size());
    
    // set current page
    if (NewPageName != null) {
      Environment.CurrentPageName = NewPageName;
      LooFCodeData NewCodeData = Environment.AllCodeDatas.getOrDefault(NewPageName, null);
      if (NewCodeData == null) throw (new LooFInterpreterException (Environment, "jump to function failed because the page \"" + NewPageName + "\" does not exist.", new String[] {"JumpToFunctionError", "PageNotFound"}));
      Environment.CurrentCodeData = NewCodeData;
    }
    
    int StatementsLength = Environment.CurrentCodeData.Statements.length;
    if (NewLineNumber >= StatementsLength) {
      ReturnFromFunction (Environment);
      throw (new LooFInterpreterException (Environment, "the function being jumped to is past the end of the file.", new String[] {"JumpToFunctionError", "LineNumberTooLarge"}));
    }
    
    // set current line
    Environment.CurrentLineNumber = NewLineNumber;
    
  }
  
  
  
  
  
  void ReturnFromFunction (LooFEnvironment Environment) {
    
    // remove call stack data
    RemoveLastItem (Environment.VariableListsStack);
    String NewPageName = RemoveLastItem (Environment.CallStackPageNames);
    int NewLineNumber = RemoveLastItem (Environment.CallStackLineNumbers);
    RemoveLastItem (Environment.CallStackAttemptErrorCatches);
    RemoveLastItem (Environment.CallStackErrorTypesToPass);
    RemoveLastItem (Environment.CallStackExpectedGeneralStackSizes);
    int InitialLockedValuesSize = RemoveLastItem (Environment.CallStackInitialLockedValuesSizes);
    
    // set current page
    if (!Environment.CurrentPageName.equals(NewPageName)) {
      Environment.CurrentPageName = NewPageName;
      LooFCodeData NewCodeData = Environment.AllCodeDatas.getOrDefault(NewPageName, null);
      if (NewCodeData == null) throw (new LooFInterpreterException (Environment, "return from function failed because the page \"" + NewPageName + "\" no longer exists.", new String[] {"PageNotFound"}));
      Environment.CurrentCodeData = NewCodeData;
    }
    
    // set current line
    Environment.CurrentLineNumber = NewLineNumber;
    
    // unlock args
    UnlockCallStackValues (Environment, InitialLockedValuesSize);
    
  }
  
  
  
  void UnlockCallStackValues (LooFEnvironment Environment, int InitialLockedValuesSize) {
    ArrayList <LooFDataValue[]> LockedValues = Environment.CallStackLockedValues;
    
    while (LockedValues.size() > InitialLockedValuesSize) {
      LooFDataValue[] ValuesToUnlock = RemoveLastItem (LockedValues);
      for (LooFDataValue CurrentValue : ValuesToUnlock) {
        DecreaseDataValueLockLevel (CurrentValue);
      }
    }
    
  }
  
  
  
  
  
  
  
  
  
  
  void SetVariableValue (String VariableName, LooFDataValue NewValue, LooFEnvironment Environment) {
    if (VariableName.equals("_")) return;
    ArrayList <HashMap <String, LooFDataValue>> VariableListsStack = Environment.VariableListsStack;
    HashMap <String, LooFDataValue> CurrentVariableList = LastItemOf (VariableListsStack);
    CurrentVariableList.put(VariableName, NewValue);
  }
  
  
  
  
  
  LooFDataValue GetVariableValue (String VariableName, LooFEnvironment Environment, boolean CreateNullVar) {
    if (VariableName.equals("_")) return new LooFDataValue();
    
    // if var exists
    HashMap <String, LooFDataValue> CurrentVariableList = LastItemOf (Environment.VariableListsStack);
    LooFDataValue FoundVariableValue = CurrentVariableList.get(VariableName);
    if (FoundVariableValue != null) return CurrentVariableList.get(VariableName);
    
    // if var doesn't exist
    if (!CreateNullVar) throw (new LooFInterpreterException (Environment, "could not find any variable named \"" + VariableName + "\".", new String[] {"VariableNotFound"}));
    LooFDataValue NewVariableValue = new LooFDataValue ();
    CurrentVariableList.put(VariableName, NewVariableValue);
    return NewVariableValue;
    
  }
  
  
  
  
  
  void PushValuesToStack (LooFDataValue[] NewValues, LooFEnvironment Environment) {
    Environment.GeneralStack.add(new LooFDataValue (ArrayToArrayList (NewValues), new HashMap <String, LooFDataValue> ()));
  }
  
  
  
  
  
  
  
  
  
  
  LooFDataValue EvaluateFormula (LooFTokenBranch Formula, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    if (Formula.TokenType == TokenBranchType_PreEvaluatedFormula) return Formula.Result;
    ArrayList <LooFTokenBranch> FormulaTokens = ArrayToArrayList (Formula.Children);
    if (FormulaTokens.size() == 0) return new LooFDataValue();
    ArrayList <LooFDataValue> FormulaValues = GetFormulaValuesFromTokens (FormulaTokens, Environment, CodeData, AllCodeDatas);
    
    int[] IndexQueryIndexes = Formula.IndexQueryIndexes;
    int[] FunctionIndexes = Formula.FunctionIndexes;
    FloatIntPair[] OperationIndexes = Formula.OperationIndexes;
    
    // evaluate indexes
    for (int CurrentTokenIndex : IndexQueryIndexes) {
      LooFDataValue IndexValue = EvaluateFormula (FormulaTokens.get(CurrentTokenIndex), Environment, CodeData, AllCodeDatas);
      LooFDataValue NewValue = GetDataValueIndex (FormulaValues.get(CurrentTokenIndex - 1), IndexValue, false, Environment);
      FormulaTokens.remove(CurrentTokenIndex);
      FormulaValues.remove(CurrentTokenIndex);
      FormulaValues.set(CurrentTokenIndex - 1, NewValue);
    }
    
    // evaluate functions
    for (int CurrentTokenIndex : FunctionIndexes) {
      LooFTokenBranch FunctionToken = FormulaTokens.get(CurrentTokenIndex);
      LooFEvaluatorFunction FunctionToCall = FunctionToken.Function;
      LooFDataValue FunctionInput = FormulaValues.get(CurrentTokenIndex + 1);
      LooFDataValue FunctionOutput = FunctionToCall.HandleFunctionCall (FunctionInput, Environment, CodeData, AllCodeDatas);
      FormulaTokens.remove(CurrentTokenIndex + 1);
      FormulaValues.remove(CurrentTokenIndex + 1);
      FormulaValues.set(CurrentTokenIndex, FunctionOutput);
    }
    
    // evaluator operations
    for (FloatIntPair CurrentTokenIndexPair : OperationIndexes) {
      int CurrentTokenIndex = CurrentTokenIndexPair.IntValue;
      LooFTokenBranch OperationToken = FormulaTokens.get(CurrentTokenIndex);
      LooFEvaluatorOperation OperationToCall = OperationToken.Operation;
      LooFDataValue LeftValue = FormulaValues.get(CurrentTokenIndex - 1);
      LooFDataValue RightValue = FormulaValues.get(CurrentTokenIndex + 1);
      LooFDataValue OperationOutput = OperationToCall.HandleOperation (LeftValue, RightValue, Environment, CodeData, AllCodeDatas);
      FormulaValues.set(CurrentTokenIndex - 1, OperationOutput);
      FormulaValues.remove(CurrentTokenIndex);
      FormulaValues.remove(CurrentTokenIndex);
      FormulaTokens.remove(CurrentTokenIndex);
      FormulaTokens.remove(CurrentTokenIndex);
    }
    
    if (FormulaValues.size() > 1) throw new AssertionError();
    
    return FormulaValues.get(0);
  }
  
  
  
  
  
  LooFDataValue EvaluateTable (LooFTokenBranch TableIn, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    ArrayList <LooFDataValue> ArrayValue = new ArrayList <LooFDataValue> ();
    HashMap <String, LooFDataValue> HashMapValue = new HashMap <String, LooFDataValue> ();
    
    // array items
    for (LooFTokenBranch CurrentToken : TableIn.Children) {
      ArrayValue.add(EvaluateFormula (CurrentToken, Environment, CodeData, AllCodeDatas));
    }
    
    // hashmap items
    Set <String> KeySet = TableIn.HashMapChildren.keySet();
    for (String CurrentKey : KeySet) {
      HashMapValue.put(CurrentKey, EvaluateFormula (TableIn.HashMapChildren.get(CurrentKey), Environment, CodeData, AllCodeDatas));
    }
    
    return new LooFDataValue (ArrayValue, HashMapValue);
  }
  
  
  
  
  
  ArrayList <LooFDataValue> GetFormulaValuesFromTokens (ArrayList <LooFTokenBranch> FormulaTokens, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    ArrayList <LooFDataValue> FormulaValues = new ArrayList <LooFDataValue> ();
    for (LooFTokenBranch CurrentToken : FormulaTokens) {
      FormulaValues.add (GetDataValueFromToken (CurrentToken, Environment, CodeData, AllCodeDatas));
    }
    return FormulaValues;
  }
  
  
  
  LooFDataValue GetDataValueFromToken (LooFTokenBranch CurrentToken, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    switch (CurrentToken.TokenType) {
      
      case (TokenBranchType_Null):
        return new LooFDataValue();
      
      case (TokenBranchType_Int):
        return new LooFDataValue (CurrentToken.IntValue);
      
      case (TokenBranchType_Float):
        return new LooFDataValue (CurrentToken.FloatValue);
      
      case (TokenBranchType_String):
        return new LooFDataValue (CurrentToken.StringValue);
      
      case (TokenBranchType_Bool):
        return new LooFDataValue (CurrentToken.BoolValue);
      
      case (TokenBranchType_Table):
        return EvaluateTable (CurrentToken, Environment, CodeData, AllCodeDatas);
      
      case (TokenBranchType_Formula):
        return EvaluateFormula (CurrentToken, Environment, CodeData, AllCodeDatas);
      
      case (TokenBranchType_Index):
        return null;
      
      case (TokenBranchType_VarName):
        return GetVariableValue (CurrentToken.StringValue, Environment, false);
      
      case (TokenBranchType_OutputVar):
        throw new AssertionError();
      
      case (TokenBranchType_EvaluatorOperation):
        return null;
      
      case (TokenBranchType_EvaluatorFunction):
        return null;
      
      case (TokenBranchType_PreEvaluatedFormula):
        return CurrentToken.Result.clone();
      
      default:
        throw new AssertionError();
      
    }
  }
  
  
  
  
  
  LooFDataValue GetDataValueIndex (LooFDataValue SourceTable, LooFDataValue IndexValue, boolean AllowIndexOfArrayLength, LooFEnvironment Environment) {
    
    int CaseToUse = 0;
    
    // error if index is not a string or int
    switch (IndexValue.ValueType) {
      case (DataValueType_Int):
        break;
      case (DataValueType_String):
        CaseToUse += 1;
        break;
      default:
        ThrowLooFException (Environment, null, null, "values cannot be indexed with " + DataValueTypeNames_PlusA[IndexValue.ValueType] + ".", new String[] {"InvalidIndexType", "IndexError"});
    }
    
    // error if data value is not indexable
    switch (SourceTable.ValueType) {
      case (DataValueType_Table):
        break;
      case (DataValueType_ByteArray):
        CaseToUse += 2;
        break;
      default:
        ThrowLooFException (Environment, null, null, "cannot index value of type " + DataValueTypeNames_PlusA[SourceTable.ValueType] + ".", new String[] {"InvalidTypeIndexed", "IndexError"});
    }
    
    int IndexIntValue = (int) IndexValue.IntValue;
    String IndexStringValue = IndexValue.StringValue;
    
    // get index
    switch (CaseToUse) {
      
      case (0): // table[int]
        ArrayList <LooFDataValue> ArrayValue = SourceTable.ArrayValue;
        if (IndexIntValue < 0) ThrowLooFException (Environment, null, null, "index (" + IndexIntValue + ") is out of bounds (negative).", new String[] {"IndexOutOfBounds", "NegativeIndex", "IndexError"});
        if (IndexIntValue > ArrayValue.size()) ThrowLooFException (Environment, null, null, "index (" + IndexIntValue + ") is out of bounds (too large). (remember that indexes start at 0)", new String[] {"IndexOutOfBounds", "TooLargeIndex", "IndexError"});
        if (IndexIntValue == ArrayValue.size()) {
          if (!AllowIndexOfArrayLength) ThrowLooFException (Environment, null, null, "index (" + IndexIntValue + ") is out of bounds (equal to table length). (remember that indexes start at 0)", new String[] {"IndexOutOfBounds", "TooLargeIndex", "IndexError"});
          return new LooFDataValue();
        }
        return ArrayValue.get((int) IndexIntValue);
      
      case (1): // table[string]
        HashMap <String, LooFDataValue> HashMapValue = SourceTable.HashMapValue;
        return HashMapValue.getOrDefault (IndexStringValue, new LooFDataValue());
      
      case (2): // byteArray[int]
        byte[] ByteArrayValue = SourceTable.ByteArrayValue;
        if (IndexIntValue < 0) ThrowLooFException (Environment, null, null, "index (" + IndexIntValue + ") is out of bounds (negative).", new String[] {"IndexOutOfBounds", "NegativeIndex", "IndexError"});
        if (IndexIntValue >= ByteArrayValue.length) ThrowLooFException (Environment, null, null, "index (" + IndexIntValue + ") is out of bounds (too large). (remember that indexes start at 0)", new String[] {"IndexOutOfBounds", "TooLargeIndex", "IndexError"});
        return new LooFDataValue ((long) ByteArrayValue[(int) IndexIntValue]);
      
      case (3): // byteArray[string]
        ThrowLooFException (Environment, null, null, "cannot index byteArray with a string.", new String[] {"IndexError", "InvalidArgType"});
      
      default:
        throw new AssertionError();
      
    }
    
  }
  
  
  
  
  
  void SetDataValueIndex (LooFDataValue TargetTable, LooFDataValue IndexValue, LooFDataValue NewVarValue, LooFEnvironment Environment) {
    int CaseToUse = 0;
    
    if (LastItemOf (TargetTable.LockLevels) > 0) ThrowLooFException (Environment, null, null, "cannot set the index of a locked data value.", new String[] {"LockedValueSetAttempted"});
    
    switch (IndexValue.ValueType) {
      case (DataValueType_Int):
        break;
      case (DataValueType_String):
        CaseToUse += 1;
        break;
      default:
        ThrowLooFException (Environment, null, null, "values cannot be indexed with " + DataValueTypeNames_PlusA[IndexValue.ValueType] + ".", new String[] {"InvalidIndexType", "IndexError"});
    }
    
    switch (TargetTable.ValueType) {
      case (DataValueType_Table):
        break;
      case (DataValueType_ByteArray):
        CaseToUse += 2;
        break;
      default:
        ThrowLooFException (Environment, null, null, "cannot set the index of " + DataValueTypeNames_PlusA[TargetTable.ValueType] + ".", new String[] {"InvalidTypeIndexed", "IndexError"});
    }
    
    int IndexIntValue = (int) IndexValue.IntValue;
    String IndexStringValue = IndexValue.StringValue;
    
    switch (CaseToUse) {
      
      case (0): // table[int]
        if (IndexIntValue < 0) ThrowLooFException (Environment, null, null, "index (" + IndexIntValue + ") is out of bounds (negative).", new String[] {"NegativeIndex", "IndexError"});
        ArrayList <LooFDataValue> ArrayValue = TargetTable.ArrayValue;
        int TargetTableSize = ArrayValue.size();
        if (IndexIntValue > TargetTableSize) ThrowLooFException (Environment, null, null, "index (" + IndexIntValue + ") is out of bounds (too large; index has to be less than the length of the array to set an item or equal to add an item). (remember that indexes start at 0)", new String[] {"TooLargeIndex", "IndexError"});
        if (IndexIntValue == TargetTableSize) {
          ArrayValue.add(NewVarValue);
          return;
        }
        ArrayValue.set(IndexIntValue, NewVarValue);
        return;
      
      case (1): // table[string]
        HashMap <String, LooFDataValue> HashMapValue = TargetTable.HashMapValue;
        if (NewVarValue.ValueType == DataValueType_Null) {
          HashMapValue.remove(IndexStringValue);
          return;
        }
        HashMapValue.put(IndexStringValue, NewVarValue);
        return;
      
      case (2): // byteArray[int]
        if (NewVarValue.ValueType != DataValueType_Int) ThrowLooFException (Environment, null, null, "cannot set an index of a byteArray to " + DataValueTypeNames_PlusA[NewVarValue.ValueType] + " (index must be an int).", new String[] {"InvalidByteArrayValue", "IndexError"});
        if (IndexIntValue < 0) ThrowLooFException (Environment, null, null, "index (" + IndexIntValue + ") is out of bounds (negative).", new String[] {"NegativeIndex", "IndexError"});
        byte[] ByteArrayValue = TargetTable.ByteArrayValue;
        if (IndexIntValue >= ByteArrayValue.length) ThrowLooFException (Environment, null, null, "index (" + IndexIntValue + ") is out of bounds (too large). (remember that indexes start at 0)", new String[] {"TooLargeIndex", "IndexError"});
        ByteArrayValue[IndexIntValue] = (byte) NewVarValue.IntValue;
        return;
      
      case (3):
        ThrowLooFException (Environment, null, null, "byteArrays cannot be indexes with strings.", new String[] {"IndexError"});
      
      default:
        throw new AssertionError();
      
    }
    
  }
  
  
  
  
  
  
  
  
  
  
}
