LooFInterpreter LooFInterpreter = new LooFInterpreter();

class LooFInterpreter {
  
  
  
  
  
  
  
  
  
  
  void ExecuteNextEnvironmentStatements (LooFEnvironment Environment, int NumOfStatements) throws LooFInterpreterException  {
    if (Environment.Stopped) throw (new LooFInterpreterException (Environment, "this environment is in a stopped state.", new String[0]));
    for (int i = 0; i < NumOfStatements; i ++) {
      LooFStatement CurrentStatement = Environment.CurrentCodeData.Statements[Environment.CurrentLineNumber];
      ExecuteStatement (CurrentStatement, Environment);
      if (Environment.Stopped) return;
    }
  }
  
  
  
  
  
  void ExecuteStatement (LooFStatement CurrentStatement, LooFEnvironment Environment) throws LooFInterpreterException {
    
    // execute statement
    try {
      if (CurrentStatement.StatementType == StatementType_Assignment)
        ExecuteAssignmentStatement (CurrentStatement, Environment);
      else
        ExecuteFunctionStatement (CurrentStatement, Environment);
    } catch (LooFInterpreterException e) {
      HandleEnvironmentException (e);
    }
    
    // inc line number
    Environment.CurrentLineNumber ++;
    if (Environment.Stopped) return;
    int StatementsLength = Environment.CurrentCodeData.Statements.length;
    if (Environment.CurrentLineNumber >= StatementsLength) {
      Environment.CurrentLineNumber = StatementsLength - 1;
      throw (new LooFInterpreterException (Environment, "execution cannot reach the end of the file. (maybe a function is missing a return statement?)", new String[] {"ReachedEndOfFile"}));
    }
    
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
    
    LooFDataValue TargetTable = GetTargetTableForStatement (CurrentStatement, Environment, null);
    LooFDataValue IndexValue = EvaluateFormula (GetLastItemOf (IndexQueries), Environment, null);
    LooFDataValue OldVarValue = GetDataValueIndex (TargetTable, IndexValue, true, Environment, null);
    LooFDataValue NewVarValue = StatementAssignment.GetNewVarValue (OldVarValue, NewValueFormula, Environment);
    SetDataValueIndex (TargetTable, IndexValue, NewVarValue, Environment, null);
    
  }
  
  
  
  
  
  LooFDataValue GetTargetTableForStatement (LooFStatement CurrentStatement, LooFEnvironment Environment, LooFCodeData CodeData) {
    LooFDataValue TargetTable = GetVariableValue (CurrentStatement.VarName, Environment, true);
    LooFTokenBranch[] IndexQueries = CurrentStatement.IndexQueries;
    for (int i = 0; i < IndexQueries.length - 1; i ++) {
      LooFDataValue ValueToIndexWith = EvaluateFormula (IndexQueries[i], Environment, CodeData);
      TargetTable = GetDataValueIndex (TargetTable, ValueToIndexWith, false, Environment, CodeData);
    }
    return TargetTable;
  }
  
  
  
  
  
  void ExecuteFunctionStatement (LooFStatement Statement, LooFEnvironment Environment) {
    LooFInterpreterFunction StatementFunction = Statement.Function;
    LooFTokenBranch[] StatementArgs = Statement.Args;
    StatementFunction.HandleFunctionCall(StatementArgs, Environment);
  }
  
  
  
  
  
  
  
  
  
  
  void HandleEnvironmentException (LooFInterpreterException e) throws LooFInterpreterException  {
    
  }
  
  
  
  
  
  
  
  
  
  
  void SetVariableValue (String VariableName, LooFDataValue NewValue, LooFEnvironment Environment) {
    ArrayList <HashMap <String, LooFDataValue>> VariableListsStack = Environment.VariableListsStack;
    HashMap <String, LooFDataValue> CurrentVariableList = GetLastItemOf (VariableListsStack);
    if (NewValue.ValueType == DataValueType_Null) {
      CurrentVariableList.remove(VariableName);
      return;
    }
    CurrentVariableList.put(VariableName, NewValue);
  }
  
  
  
  
  
  LooFDataValue GetVariableValue (String VariableName, LooFEnvironment Environment, boolean CreateNullVar) {
    ArrayList <HashMap <String, LooFDataValue>> VariableListsStack = Environment.VariableListsStack;
    HashMap <String, LooFDataValue> CurrentVariableList = GetLastItemOf (VariableListsStack);
    LooFDataValue FoundVariableValue = CurrentVariableList.get(VariableName);
    if (FoundVariableValue != null) return CurrentVariableList.get(VariableName);
    if (!CreateNullVar) throw (new LooFInterpreterException (Environment, "could not find any variable named \"" + VariableName + "\".", new String[] {"VariableNotFound"}));
    LooFDataValue NewVariableValue = new LooFDataValue ();
    CurrentVariableList.put(VariableName, NewVariableValue);
    return NewVariableValue;
  }
  
  
  
  
  
  
  
  
  
  
  LooFDataValue EvaluateFormula (LooFTokenBranch Formula, LooFEnvironment Environment, LooFCodeData CodeData) {
    if (Formula.TokenType == TokenBranchType_PreEvaluatedFormula) return Formula.Result;
    ArrayList <LooFTokenBranch> FormulaTokens = ArrayToArrayList (Formula.Children);
    if (FormulaTokens.size() == 0) return new LooFDataValue();
    ArrayList <LooFDataValue> FormulaValues = GetFormulaValuesFromTokens (FormulaTokens, Environment, CodeData);
    
    int[] IndexQueryIndexes = Formula.IndexQueryIndexes;
    int[] FunctionIndexes = Formula.FunctionIndexes;
    FloatIntPair[] OperationIndexes = Formula.OperationIndexes;
    
    // evaluate indexes
    for (int CurrentTokenIndex : IndexQueryIndexes) {
      LooFDataValue IndexValue = EvaluateFormula (FormulaTokens.get(CurrentTokenIndex), Environment, CodeData);
      LooFDataValue NewValue = GetDataValueIndex (FormulaValues.get(CurrentTokenIndex - 1), IndexValue, false, Environment, CodeData);
      FormulaTokens.remove(CurrentTokenIndex);
      FormulaValues.remove(CurrentTokenIndex);
      FormulaValues.set(CurrentTokenIndex - 1, NewValue);
    }
    
    // evaluate functions
    for (int CurrentTokenIndex : FunctionIndexes) {
      LooFTokenBranch FunctionToken = FormulaTokens.get(CurrentTokenIndex);
      LooFEvaluatorFunction FunctionToCall = FunctionToken.Function;
      LooFDataValue FunctionInput = FormulaValues.get(CurrentTokenIndex + 1);
      LooFDataValue FunctionOutput = FunctionToCall.HandleFunctionCall (FunctionInput, Environment, CodeData);
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
      LooFDataValue OperationOutput = OperationToCall.HandleOperation (LeftValue, RightValue, Environment, CodeData);
      FormulaValues.set(CurrentTokenIndex - 1, OperationOutput);
      FormulaValues.remove(CurrentTokenIndex);
      FormulaValues.remove(CurrentTokenIndex);
      FormulaTokens.remove(CurrentTokenIndex);
      FormulaTokens.remove(CurrentTokenIndex);
    }
    
    if (FormulaValues.size() > 1) throw new AssertionError();
    
    return FormulaValues.get(0);
  }
  
  
  
  
  
  LooFDataValue EvaluateTable (LooFTokenBranch Formula, LooFEnvironment Environment, LooFCodeData CodeData) {
    ArrayList <LooFDataValue> TableChildren = new ArrayList <LooFDataValue> ();
    for (LooFTokenBranch CurrentToken : Formula.Children) {
      TableChildren.add(EvaluateFormula (CurrentToken, Environment, CodeData));
    }
    return new LooFDataValue (TableChildren, new HashMap <String, LooFDataValue> ());
  }
  
  
  
  
  
  ArrayList <LooFDataValue> GetFormulaValuesFromTokens (ArrayList <LooFTokenBranch> FormulaTokens, LooFEnvironment Environment, LooFCodeData CodeData) {
    ArrayList <LooFDataValue> FormulaValues = new ArrayList <LooFDataValue> ();
    for (LooFTokenBranch CurrentToken : FormulaTokens) {
      FormulaValues.add (GetDataValueFromToken (CurrentToken, Environment, CodeData));
    }
    return FormulaValues;
  }
  
  
  
  LooFDataValue GetDataValueFromToken (LooFTokenBranch CurrentToken, LooFEnvironment Environment, LooFCodeData CodeData) {
    switch (CurrentToken.TokenType) {
      
      default:
        throw new AssertionError();
      
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
        return EvaluateTable (CurrentToken, Environment, CodeData);
      
      case (TokenBranchType_Formula):
        return EvaluateFormula (CurrentToken, Environment, CodeData);
      
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
      
    }
  }
  
  
  
  
  
  LooFDataValue GetDataValueIndex (LooFDataValue SourceTable, LooFDataValue IndexValue, boolean AllowIndexOfArrayLength, LooFEnvironment Environment, LooFCodeData CodeData) {
    
    int CaseToUse = 0;
    
    // error if index is not a string or int
    switch (IndexValue.ValueType) {
      case (DataValueType_Int):
        break;
      case (DataValueType_String):
        CaseToUse += 1;
        break;
      default:
        ThrowLooFException (Environment, CodeData, "values cannot be indexed with " + DataValueTypeNames_PlusA[IndexValue.ValueType] + ".", new String[] {"InvalidIndexType", "IndexError"});
    }
    
    // error if data value is not indexable
    switch (SourceTable.ValueType) {
      case (DataValueType_Table):
        break;
      case (DataValueType_ByteArray):
        CaseToUse += 2;
        break;
      default:
        ThrowLooFException (Environment, CodeData, "cannot index value of type " + DataValueTypeNames_PlusA[SourceTable.ValueType] + ".", new String[] {"InvalidTypeIndexed", "IndexError"});
    }
    
    int IndexIntValue = (int) IndexValue.IntValue;
    String IndexStringValue = IndexValue.StringValue;
    
    // get index
    switch (CaseToUse) {
      
      case (0): // table[int]
        ArrayList <LooFDataValue> ArrayValue = SourceTable.ArrayValue;
        if (IndexIntValue < 0) ThrowLooFException (Environment, CodeData, "index (" + IndexIntValue + ") is out of bounds (negative).", new String[] {"NegativeIndex", "IndexError"});
        if (IndexIntValue > ArrayValue.size()) ThrowLooFException (Environment, CodeData, "index (" + IndexIntValue + ") is out of bounds (too large). (remember that indexes start at 0)", new String[] {"TooLargeIndex", "IndexError"});
        if (IndexIntValue == ArrayValue.size()) {
          if (!AllowIndexOfArrayLength) ThrowLooFException (Environment, CodeData, "index (" + IndexIntValue + ") is out of bounds (equal to table length). (remember that indexes start at 0)", new String[] {"TooLargeIndex", "IndexError"});
          return new LooFDataValue();
        }
        return ArrayValue.get((int) IndexIntValue);
      
      case (1): // table[string]
        HashMap <String, LooFDataValue> HashMapValue = SourceTable.HashMapValue;
        return HashMapValue.getOrDefault (IndexStringValue, new LooFDataValue());
      
      case (2): // byteArray[int]
        byte[] ByteArrayValue = SourceTable.ByteArrayValue;
        if (IndexIntValue < 0) ThrowLooFException (Environment, CodeData, "index (" + IndexIntValue + ") is out of bounds (negative).", new String[] {"NegativeIndex", "IndexError"});
        if (IndexIntValue >= ByteArrayValue.length) ThrowLooFException (Environment, CodeData, "index (" + IndexIntValue + ") is out of bounds (too large). (remember that indexes start at 0)", new String[] {"TooLargeIndex", "IndexError"});
        return new LooFDataValue ((long) ByteArrayValue[(int) IndexIntValue]);
      
      case (3): // byteArray[string]
        ThrowLooFException (Environment, CodeData, "cannot index byteArray with a string.", new String[] {"IndexError"});
      
      default:
        throw new AssertionError();
      
    }
    
  }
  
  
  
  
  
  void SetDataValueIndex (LooFDataValue TargetTable, LooFDataValue IndexValue, LooFDataValue NewVarValue, LooFEnvironment Environment, LooFCodeData CodeData) {
    int CaseToUse = 0;
    
    if (GetLastItemOf (TargetTable.LockLevels) > 0) ThrowLooFException (Environment, CodeData, "cannot set the index of a locked data value.", new String[] {"LockedValueSetAttempted"});
    
    switch (IndexValue.ValueType) {
      case (DataValueType_Int):
        break;
      case (DataValueType_String):
        CaseToUse += 1;
        break;
      default:
        ThrowLooFException (Environment, CodeData, "values cannot be indexed with " + DataValueTypeNames_PlusA[IndexValue.ValueType] + ".", new String[] {"InvalidIndexType", "IndexError"});
    }
    
    switch (TargetTable.ValueType) {
      case (DataValueType_Table):
        break;
      case (DataValueType_ByteArray):
        CaseToUse += 2;
        break;
      default:
        ThrowLooFException (Environment, CodeData, "cannot set the index of " + DataValueTypeNames_PlusA[TargetTable.ValueType] + ".", new String[] {"InvalidTypeIndexed", "IndexError"});
    }
    
    int IndexIntValue = (int) IndexValue.IntValue;
    String IndexStringValue = IndexValue.StringValue;
    
    switch (CaseToUse) {
      
      case (0): // table[int]
        if (IndexIntValue < 0) ThrowLooFException (Environment, CodeData, "index (" + IndexIntValue + ") is out of bounds (negative).", new String[] {"NegativeIndex", "IndexError"});
        ArrayList <LooFDataValue> ArrayValue = TargetTable.ArrayValue;
        int TargetTableSize = ArrayValue.size();
        if (IndexIntValue > TargetTableSize) ThrowLooFException (Environment, CodeData, "index (" + IndexIntValue + ") is out of bounds (too large; index has to be less than the length of the array to set an item or equal to add an item). (remember that indexes start at 0)", new String[] {"TooLargeIndex", "IndexError"});
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
        if (NewVarValue.ValueType != DataValueType_Int) ThrowLooFException (Environment, CodeData, "cannot set an index of a byteArray to " + DataValueTypeNames_PlusA[NewVarValue.ValueType] + " (index must be an int).", new String[] {"InvalidByteArrayValue", "IndexError"});
        if (IndexIntValue < 0) ThrowLooFException (Environment, CodeData, "index (" + IndexIntValue + ") is out of bounds (negative).", new String[] {"NegativeIndex", "IndexError"});
        byte[] ByteArrayValue = TargetTable.ByteArrayValue;
        if (IndexIntValue >= ByteArrayValue.length) ThrowLooFException (Environment, CodeData, "index (" + IndexIntValue + ") is out of bounds (too large). (remember that indexes start at 0)", new String[] {"TooLargeIndex", "IndexError"});
        ByteArrayValue[IndexIntValue] = (byte) NewVarValue.IntValue;
        return;
      
      case (3):
        ThrowLooFException (Environment, CodeData, "byteArrays cannot be indexes with strings.", new String[] {"IndexError"});
      
      default:
        throw new AssertionError();
      
    }
    
  }
  
  
  
  
  
  
  
  
  
  
}
