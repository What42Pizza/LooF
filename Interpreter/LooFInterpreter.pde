LooFInterpreter LooFInterpreter = new LooFInterpreter();

class LooFInterpreter {
  
  
  
  
  
  
  
  
  
  
  LooFDataValue GetVariableValue (LooFEnvironment Environment, String VariableName, boolean CreateNullVar, String FileName, int LineNumber) {
    ArrayList <HashMap <String, LooFDataValue>> VariableListsStack = Environment.VariableListsStack;
    HashMap <String, LooFDataValue> CurrentVariableList = GetLastItemOf (VariableListsStack);
    LooFDataValue FoundVariableValue = CurrentVariableList.get(VariableName);
    if (FoundVariableValue == null) {
      if (CreateNullVar) {
        LooFDataValue NewVariableValue = new LooFDataValue ();
        CurrentVariableList.put(VariableName, NewVariableValue);
        return NewVariableValue;
      }
      throw (new LooFInterpreterException (Environment, FileName, LineNumber, "could not find any variables named \"" + VariableName + "\"."));
    }
    return CurrentVariableList.get(VariableName);
  }
  
  
  
  
  
  
  
  
  
  
  LooFDataValue EvaluateFormula (LooFTokenBranch Formula, LooFEnvironment Environment, String FileName, int LineNumber) {
    ArrayList <LooFTokenBranch> FormulaTokens = ArrayToArrayList (Formula.Children);
    if (FormulaTokens.size() == 0) return new LooFDataValue();
    ArrayList <LooFDataValue> FormulaValues = GetFormulaValuesFromTokens (FormulaTokens, Environment, FileName, LineNumber);
    
    // evaluate indexes
    for (int i = 1; i < FormulaTokens.size(); i ++) {
      LooFTokenBranch CurrentToken = FormulaTokens.get(i);
      if (CurrentToken.TokenType != TokenBranchType_Index) continue;
      LooFDataValue EvaluatedIndex = EvaluateFormula (CurrentToken, Environment, FileName, LineNumber);
      LooFDataValue NewValue = GetDataValueIndex (FormulaValues.get(i - 1), EvaluatedIndex, FormulaTokens.get(i - 1), Environment, FileName, LineNumber);
      FormulaTokens.remove(i);
      FormulaValues.remove(i);
      FormulaValues.set(i - 1, NewValue);
      i --;
    }
    
    // evaluate functions
    for (int i = FormulaTokens.size() - 2; i >= 0; i ++) {
      LooFTokenBranch CurrentToken = FormulaTokens.get(i);
      if (CurrentToken.TokenType != TokenBranchType_Function) continue;
      LooFDataValue FunctionInput = FormulaValues.get(i + 1);
    }
    
    return null;
  }
  
  
  
  
  
  ArrayList <LooFDataValue> GetFormulaValuesFromTokens (ArrayList <LooFTokenBranch> FormulaTokens, LooFEnvironment Environment, String FileName, int LineNumber) {
    ArrayList <LooFDataValue> FormulaValues = new ArrayList <LooFDataValue> ();
    for (LooFTokenBranch CurrentToken : FormulaTokens) {
      FormulaValues.add (GetDataValueFromToken (CurrentToken, Environment, FileName, LineNumber));
    }
    return FormulaValues;
  }
  
  
  
  LooFDataValue GetDataValueFromToken (LooFTokenBranch CurrentToken, LooFEnvironment Environment, String FileName, int LineNumber) {
    switch (CurrentToken.TokenType) {
      
      default:
        throw new AssertionError();
      
      case (TokenBranchType_Int):
        return new LooFDataValue (CurrentToken.IntValue);
      
      case (TokenBranchType_Float):
        return new LooFDataValue (CurrentToken.FloatValue);
      
      case (TokenBranchType_String):
        return new LooFDataValue (CurrentToken.StringValue);
      
      case (TokenBranchType_Bool):
        return new LooFDataValue (CurrentToken.BoolValue);
      
      case (TokenBranchType_Table):
        return null;
      
      case (TokenBranchType_Name):
        return GetVariableValue (Environment, CurrentToken.StringValue, false, FileName, LineNumber);
      
      case (TokenBranchType_Formula):
        return null;
      
      case (TokenBranchType_Index):
        return null;
      
      case (TokenBranchType_OutputVar):
        throw new AssertionError();
      
    }
  }
  
  
  
  
  
  LooFDataValue GetDataValueIndex (LooFDataValue TableDataValue, LooFDataValue IndexDataValue, LooFTokenBranch TableTokenSource, LooFEnvironment Environment, String FileName, int LineNumber) {
    
    int CaseToUse = 0;
    
    // error if source token is not indexable
    if (!(TableTokenSource.TokenType == TokenBranchType_Table || TableTokenSource.TokenType == TokenBranchType_Name)) throw (new LooFInterpreterException (Environment, FileName, LineNumber, "cannot index " + TokenBranchTypeNames_PlusA[TableTokenSource.TokenType] + "."));
    
    // error if index is not a string or int
    switch (IndexDataValue.ValueType) {
      default:
        throw (new LooFInterpreterException (Environment, FileName, LineNumber, "tables cannot be indexed with " + DataValueTypeNames_PlusA[IndexDataValue.ValueType] + "."));
      case (DataValueType_Int):
        break;
      case (DataValueType_String):
        CaseToUse += 1;
        break;
    }
    
    // error if data value is not indexable
    switch (TableDataValue.ValueType) {
      default:
        throw (new LooFInterpreterException (Environment, FileName, LineNumber, "cannot index " + DataValueTypeNames_PlusA[TableDataValue.ValueType] + "."));
      case (DataValueType_Table):
        break;
      case (DataValueType_ByteArray):
        CaseToUse += 2;
        break;
    }
    
    // get index
    switch (CaseToUse) {
      
      case (0): // table[int]
        long IndexIntValue_table = IndexDataValue.IntValue;
        ArrayList <LooFDataValue> ArrayValue = TableDataValue.ArrayValue;
        if (IndexIntValue_table < 0) throw (new LooFInterpreterException (Environment, FileName, LineNumber, "index is out of bounds (negative)."));
        if (IndexIntValue_table >= ArrayValue.size()) throw (new LooFInterpreterException (Environment, FileName, LineNumber, "index is out of bounds (too large)."));
        return ArrayValue.get((int)IndexIntValue_table);
      
      case (1): // table[string]
        String StringValue = IndexDataValue.StringValue;
        HashMap <String, LooFDataValue> HashMapValue = TableDataValue.HashMapValue;
        return HashMapValue.getOrDefault (StringValue, new LooFDataValue());
      
      case (2): // byteArray[int]
        long IndexIntValue_byteArray = IndexDataValue.IntValue;
        byte[] ByteArrayValue = TableDataValue.ByteArrayValue;
        if (IndexIntValue_byteArray < 0) throw (new LooFInterpreterException (Environment, FileName, LineNumber, "index is out of bounds (negative)."));
        if (IndexIntValue_byteArray >= ByteArrayValue.length) throw (new LooFInterpreterException (Environment, FileName, LineNumber, "index is out of bounds (too large)."));
        return new LooFDataValue ((long) ByteArrayValue[(int)IndexIntValue_byteArray]);
      
      case (3): // byteArray[string]
        throw (new LooFInterpreterException (Environment, FileName, LineNumber, "cannot index byteArray with a string"));
      
      default:
        throw new AssertionError();
      
    }
    
  }
  
  
  
  
  
  
  
  
  
  
}
