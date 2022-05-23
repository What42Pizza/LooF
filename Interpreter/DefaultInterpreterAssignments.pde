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
