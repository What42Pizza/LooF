LooFInterpreterAssignment Assignment_Equals = new LooFInterpreterAssignment() {
  @Override public LooFDataValue GetNewVarValue (LooFDataValue OldVarValue, LooFTokenBranch InputValueFormula, LooFEnvironment Environment) {
    return LooFInterpreter.EvaluateFormula(InputValueFormula, Environment);
  }
};





LooFInterpreterAssignment Assignment_DefaultsTo = new LooFInterpreterAssignment() {
  @Override public LooFDataValue GetNewVarValue (LooFDataValue OldVarValue, LooFTokenBranch InputValueFormula, LooFEnvironment Environment) {
    return (OldVarValue.ValueType == DataValueType_Null)   ?   LooFInterpreter.EvaluateFormula(InputValueFormula, Environment)   :   OldVarValue;
  }
};





LooFInterpreterAssignment Assignment_PlusEquals = new LooFInterpreterAssignment() {
  @Override public LooFDataValue GetNewVarValue (LooFDataValue OldVarValue, LooFTokenBranch InputValueFormula, LooFEnvironment Environment) {
    if (!(OldVarValue.ValueType == DataValueType_Int || OldVarValue.ValueType == DataValueType_Float)) throw (new LooFInterpreterException (Environment, "the assignment '+=' only works on a var with an int or float value, but the var was of type " + DataValueTypeNames[OldVarValue.ValueType] + "."));
    LooFDataValue InputFormulaResult = LooFInterpreter.EvaluateFormula (InputValueFormula, Environment);
    if (!(InputFormulaResult.ValueType == DataValueType_Int || InputFormulaResult.ValueType == DataValueType_Float)) throw (new LooFInterpreterException (Environment, "the assignment '+=' only works with a value of type int or float, but the value was of type " + DataValueTypeNames[InputFormulaResult.ValueType] + "."));
    if (OldVarValue.ValueType == DataValueType_Int && InputFormulaResult.ValueType == DataValueType_Int) {
      return new LooFDataValue (OldVarValue.IntValue + InputFormulaResult.IntValue);
    }
    return new LooFDataValue (GetDataValueNumber (OldVarValue) + GetDataValueNumber (InputFormulaResult));
  }
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFInterpreterAssignment Assignment_MinusEquals = new LooFInterpreterAssignment() {
  @Override public LooFDataValue GetNewVarValue (LooFDataValue OldVarValue, LooFTokenBranch InputValueFormula, LooFEnvironment Environment) {
    if (!(OldVarValue.ValueType == DataValueType_Int || OldVarValue.ValueType == DataValueType_Float)) throw (new LooFInterpreterException (Environment, "the assignment '-=' only works on a var with an int or float value, but the var was of type " + DataValueTypeNames[OldVarValue.ValueType] + "."));
    LooFDataValue InputFormulaResult = LooFInterpreter.EvaluateFormula (InputValueFormula, Environment);
    if (!(InputFormulaResult.ValueType == DataValueType_Int || InputFormulaResult.ValueType == DataValueType_Float)) throw (new LooFInterpreterException (Environment, "the assignment '-=' only works with a value of type int or float, but the value was of type " + DataValueTypeNames[InputFormulaResult.ValueType] + "."));
    if (OldVarValue.ValueType == DataValueType_Int && InputFormulaResult.ValueType == DataValueType_Int) {
      return new LooFDataValue (OldVarValue.IntValue - InputFormulaResult.IntValue);
    }
    return new LooFDataValue (GetDataValueNumber (OldVarValue) - GetDataValueNumber (InputFormulaResult));
  }
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFInterpreterAssignment Assignment_TimesEquals = new LooFInterpreterAssignment() {
  @Override public LooFDataValue GetNewVarValue (LooFDataValue OldVarValue, LooFTokenBranch InputValueFormula, LooFEnvironment Environment) {
    if (!(OldVarValue.ValueType == DataValueType_Int || OldVarValue.ValueType == DataValueType_Float)) throw (new LooFInterpreterException (Environment, "the assignment '*=' only works on a var with an int or float value, but the var was of type " + DataValueTypeNames[OldVarValue.ValueType] + "."));
    LooFDataValue InputFormulaResult = LooFInterpreter.EvaluateFormula (InputValueFormula, Environment);
    if (!(InputFormulaResult.ValueType == DataValueType_Int || InputFormulaResult.ValueType == DataValueType_Float)) throw (new LooFInterpreterException (Environment, "the assignment '*=' only works with a value of type int or float, but the value was of type " + DataValueTypeNames[InputFormulaResult.ValueType] + "."));
    if (OldVarValue.ValueType == DataValueType_Int && InputFormulaResult.ValueType == DataValueType_Int) {
      return new LooFDataValue (OldVarValue.IntValue * InputFormulaResult.IntValue);
    }
    return new LooFDataValue (GetDataValueNumber (OldVarValue) * GetDataValueNumber (InputFormulaResult));
  }
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFInterpreterAssignment Assignment_DivideEquals = new LooFInterpreterAssignment() {
  @Override public LooFDataValue GetNewVarValue (LooFDataValue OldVarValue, LooFTokenBranch InputValueFormula, LooFEnvironment Environment) {
    if (!(OldVarValue.ValueType == DataValueType_Int || OldVarValue.ValueType == DataValueType_Float)) throw (new LooFInterpreterException (Environment, "the assignment '/=' only works on a var with an int or float value, but the var was of type " + DataValueTypeNames[OldVarValue.ValueType] + "."));
    LooFDataValue InputFormulaResult = LooFInterpreter.EvaluateFormula (InputValueFormula, Environment);
    if (!(InputFormulaResult.ValueType == DataValueType_Int || InputFormulaResult.ValueType == DataValueType_Float)) throw (new LooFInterpreterException (Environment, "the assignment '/=' only works with a value of type int or float, but the value was of type " + DataValueTypeNames[InputFormulaResult.ValueType] + "."));
    if (OldVarValue.ValueType == DataValueType_Int && InputFormulaResult.ValueType == DataValueType_Int) {
      if (InputFormulaResult.IntValue == 0) throw (new LooFInterpreterException (Environment, "cannot divide by 0."));
      return new LooFDataValue (OldVarValue.IntValue / InputFormulaResult.IntValue);
    }
    double InputFormulaResultNumberValue = GetDataValueNumber (InputFormulaResult);
    if (InputFormulaResultNumberValue == 0) throw (new LooFInterpreterException (Environment, "cannot divide by 0."));
    return new LooFDataValue (GetDataValueNumber (OldVarValue) / InputFormulaResultNumberValue);
  }
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFInterpreterAssignment Assignment_PowerEquals = new LooFInterpreterAssignment() {
  @Override public LooFDataValue GetNewVarValue (LooFDataValue OldVarValue, LooFTokenBranch InputValueFormula, LooFEnvironment Environment) {
    if (!(OldVarValue.ValueType == DataValueType_Int || OldVarValue.ValueType == DataValueType_Float)) throw (new LooFInterpreterException (Environment, "the assignment '^=' only works on a var with an int or float value, but the var was of type " + DataValueTypeNames[OldVarValue.ValueType] + "."));
    LooFDataValue InputFormulaResult = LooFInterpreter.EvaluateFormula (InputValueFormula, Environment);
    if (!(InputFormulaResult.ValueType == DataValueType_Int || InputFormulaResult.ValueType == DataValueType_Float)) throw (new LooFInterpreterException (Environment, "the assignment '^=' only works with a value of type int or float, but the value was of type " + DataValueTypeNames[InputFormulaResult.ValueType] + "."));
    if (OldVarValue.ValueType == DataValueType_Int && InputFormulaResult.ValueType == DataValueType_Int) {
      return new LooFDataValue (Math.pow(OldVarValue.IntValue, InputFormulaResult.IntValue));
    }
    return new LooFDataValue (Math.pow(GetDataValueNumber (OldVarValue), GetDataValueNumber (InputFormulaResult)));
  }
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFInterpreterAssignment Assignment_ModuloEquals = new LooFInterpreterAssignment() {
  @Override public LooFDataValue GetNewVarValue (LooFDataValue OldVarValue, LooFTokenBranch InputValueFormula, LooFEnvironment Environment) {
    if (!(OldVarValue.ValueType == DataValueType_Int || OldVarValue.ValueType == DataValueType_Float)) throw (new LooFInterpreterException (Environment, "the assignment '%=' only works on a var with an int or float value, but the var was of type " + DataValueTypeNames[OldVarValue.ValueType] + "."));
    LooFDataValue InputFormulaResult = LooFInterpreter.EvaluateFormula (InputValueFormula, Environment);
    if (!(InputFormulaResult.ValueType == DataValueType_Int || InputFormulaResult.ValueType == DataValueType_Float)) throw (new LooFInterpreterException (Environment, "the assignment '%=' only works with a value of type int or float, but the value was of type " + DataValueTypeNames[InputFormulaResult.ValueType] + "."));
    if (OldVarValue.ValueType == DataValueType_Int && InputFormulaResult.ValueType == DataValueType_Int) {
      return new LooFDataValue (CorrectModulo (OldVarValue.IntValue, InputFormulaResult.IntValue));
    }
    return new LooFDataValue (CorrectModulo (GetDataValueNumber (OldVarValue), GetDataValueNumber (InputFormulaResult)));
  }
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFInterpreterAssignment Assignment_ConcatEquals = new LooFInterpreterAssignment() {
  @Override public LooFDataValue GetNewVarValue (LooFDataValue OldVarValue, LooFTokenBranch InputValueFormula, LooFEnvironment Environment) {
    if (!(OldVarValue.ValueType == DataValueType_String || OldVarValue.ValueType == DataValueType_Table)) throw (new LooFInterpreterException (Environment, "the assignment '..=' only works on a var with an string or table value, but the var was of type " + DataValueTypeNames[OldVarValue.ValueType] + "."));
    LooFDataValue InputFormulaResult = LooFInterpreter.EvaluateFormula (InputValueFormula, Environment);
    if (OldVarValue.ValueType == DataValueType_String) {
      if (InputFormulaResult.ValueType != DataValueType_String) throw (new LooFInterpreterException (Environment, "the assignment '..=' can only concat a string when the var is of type string, but the value to concat was of type " + DataValueTypeNames[InputFormulaResult.ValueType] + "."));
      return new LooFDataValue (OldVarValue.StringValue + InputFormulaResult.StringValue);
    }
    if (InputFormulaResult.ValueType == DataValueType_Table) {
      OldVarValue.ArrayValue.addAll(InputFormulaResult.ArrayValue);
      return OldVarValue;
    }
    OldVarValue.ArrayValue.add(InputFormulaResult);
    return OldVarValue;
  }
  @Override public boolean AddToCombinedTokens() {return true;}
};










LooFInterpreterTweakAssignment TweakAssignment_PlusPlus = new LooFInterpreterTweakAssignment() {
  @Override public LooFDataValue GetNewVarValue (LooFDataValue OldVarValue, LooFEnvironment Environment) {
    if (!(OldVarValue.ValueType == DataValueType_Int || OldVarValue.ValueType == DataValueType_Float)) throw (new LooFInterpreterException (Environment, "the assignment '++' only works on a var with an int or float value, but the var was of type " + DataValueTypeNames[OldVarValue.ValueType] + "."));
    if (OldVarValue.ValueType == DataValueType_Int) {
      OldVarValue.IntValue ++;
      return OldVarValue;
    }
    OldVarValue.FloatValue ++;
    return OldVarValue;
  }
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFInterpreterTweakAssignment TweakAssignment_MinusMinus = new LooFInterpreterTweakAssignment() {
  @Override public LooFDataValue GetNewVarValue (LooFDataValue OldVarValue, LooFEnvironment Environment) {
    if (!(OldVarValue.ValueType == DataValueType_Int || OldVarValue.ValueType == DataValueType_Float)) throw (new LooFInterpreterException (Environment, "the assignment '--' only works on a var with an int or float value, but the var was of type " + DataValueTypeNames[OldVarValue.ValueType] + "."));
    if (OldVarValue.ValueType == DataValueType_Int) {
      OldVarValue.IntValue --;
      return OldVarValue;
    }
    OldVarValue.FloatValue --;
    return OldVarValue;
  }
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFInterpreterTweakAssignment TweakAssignment_NotNot = new LooFInterpreterTweakAssignment() {
  @Override public LooFDataValue GetNewVarValue (LooFDataValue OldVarValue, LooFEnvironment Environment) {
    if (OldVarValue.ValueType != DataValueType_Bool) throw (new LooFInterpreterException (Environment, "the assignment '!!' only works on a var with a bool value, but the var was of type " + DataValueTypeNames[OldVarValue.ValueType] + "."));
    OldVarValue.BoolValue ^= true;
    return OldVarValue;
  }
  @Override public boolean AddToCombinedTokens() {return true;}
};
