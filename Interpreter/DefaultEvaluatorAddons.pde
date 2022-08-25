LooFEvaluatorOperation Operation_Add = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    if (LeftValue.ValueType == DataValueType_Int && RightValue.ValueType == DataValueType_Int) {
      long NewIntValue = LeftValue.IntValue + RightValue.IntValue;
      return new LooFDataValue (NewIntValue);
    }
    
    if (ValueIsNumber (LeftValue) && ValueIsNumber (RightValue)) {
      return new LooFDataValue (GetDataValueNumber (LeftValue) + GetDataValueNumber (RightValue));
    }
    
    ThrowLooFException (Environment, CodeData, AllCodeDatas, "the operation \"+\" can only add ints and floats, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " and " + DataValueTypeNames_PlusA[RightValue.ValueType] + ".", new String[] {"InvalidArgType"});
    throw new AssertionError();
    
  }
  @Override public float GetOrder() {return 4.0;}
};





LooFEvaluatorOperation Operation_Subtract = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    if (LeftValue.ValueType == DataValueType_Int && RightValue.ValueType == DataValueType_Int) {
      long NewIntValue = LeftValue.IntValue - RightValue.IntValue;
      return new LooFDataValue (NewIntValue);
    }
    
    if (ValueIsNumber (LeftValue) && ValueIsNumber (RightValue)) {
      return new LooFDataValue (GetDataValueNumber (LeftValue) - GetDataValueNumber (RightValue));
    }
    
    ThrowLooFException (Environment, CodeData, AllCodeDatas, "the operation \"-\" can only subtract ints and floats, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " and " + DataValueTypeNames_PlusA[RightValue.ValueType] + ".", new String[] {"InvalidArgType"});
    throw new AssertionError();
    
  }
  @Override public float GetOrder() {return 4.0;}
};





LooFEvaluatorOperation Operation_Multiply = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    if (LeftValue.ValueType == DataValueType_Int && RightValue.ValueType == DataValueType_Int) {
      long NewIntValue = LeftValue.IntValue * RightValue.IntValue;
      return new LooFDataValue (NewIntValue);
    }
    
    if (ValueIsNumber (LeftValue) && ValueIsNumber (RightValue)) {
      return new LooFDataValue (GetDataValueNumber (LeftValue) * GetDataValueNumber (RightValue));
    }
    
    ThrowLooFException (Environment, CodeData, AllCodeDatas, "the operation \"+\" can only multiply ints and floats, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " and " + DataValueTypeNames_PlusA[RightValue.ValueType] + ".", new String[] {"InvalidArgType"});
    throw new AssertionError();
    
  }
  @Override public float GetOrder() {return 5.0;}
};





LooFEvaluatorOperation Operation_Divide = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    if (LeftValue.ValueType == DataValueType_Int && RightValue.ValueType == DataValueType_Int) {
      if (RightValue.IntValue == 0) ThrowLooFException (Environment, CodeData, AllCodeDatas, "cannot divide by 0.", new String[] {"DivideByZero"});
      long NewIntValue = LeftValue.IntValue / RightValue.IntValue;
      return new LooFDataValue (NewIntValue);
    }
    
    if (ValueIsNumber (LeftValue) && ValueIsNumber (RightValue)) {
      double RightFloatValue = GetDataValueNumber (RightValue);
      if (RightFloatValue == 0) ThrowLooFException (Environment, CodeData, AllCodeDatas, "cannot divide by 0.", new String[] {"DivideByZero"});
      return new LooFDataValue (GetDataValueNumber (LeftValue) / RightFloatValue);
    }
    
    ThrowLooFException (Environment, CodeData, AllCodeDatas, "the operation \"/\" can only divide ints and floats, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " and " + DataValueTypeNames_PlusA[RightValue.ValueType] + ".", new String[] {"InvalidArgType"});
    throw new AssertionError();
    
  }
  @Override public float GetOrder() {return 5.0;}
};





LooFEvaluatorOperation Operation_Power = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    if (LeftValue.ValueType == DataValueType_Int && RightValue.ValueType == DataValueType_Int) {
      long NewIntValue = (long) Math.pow (LeftValue.IntValue, RightValue.IntValue);
      return new LooFDataValue (NewIntValue);
    }
    
    if (ValueIsNumber (LeftValue) && ValueIsNumber (RightValue)) {
      return new LooFDataValue (Math.pow (GetDataValueNumber (LeftValue), GetDataValueNumber (RightValue)));
    }
    
    ThrowLooFException (Environment, CodeData, AllCodeDatas, "the operation \"^\" can only take an int or float to the power of an int or float, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " to the power of " + DataValueTypeNames_PlusA[RightValue.ValueType] + ".", new String[] {"InvalidArgType"});
    throw new AssertionError();
    
  }
  @Override public float GetOrder() {return 8.0;}
};





LooFEvaluatorOperation Operation_Modulo = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    if (LeftValue.ValueType == DataValueType_Int && RightValue.ValueType == DataValueType_Int) {
      long NewIntValue = CorrectModulo (LeftValue.IntValue, RightValue.IntValue);
      return new LooFDataValue (NewIntValue);
    }
    
    if (ValueIsNumber (LeftValue) && ValueIsNumber (RightValue)) {
      return new LooFDataValue (CorrectModulo (GetDataValueNumber (LeftValue), GetDataValueNumber (RightValue)));
    }
    
    ThrowLooFException (Environment, CodeData, AllCodeDatas, "the operation \"%\" can only modulo ints and floats, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " and " + DataValueTypeNames_PlusA[RightValue.ValueType] + ".", new String[] {"InvalidArgType"});
    throw new AssertionError();
    
  }
  @Override public float GetOrder() {return 6.0;}
};





LooFEvaluatorOperation Operation_Concat = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    if (LeftValue.ValueType == DataValueType_Table && RightValue.ValueType == DataValueType_Table) {
      ArrayList <LooFDataValue> NewArrayValue = new ArrayList <LooFDataValue> ();
      NewArrayValue.addAll(LeftValue.ArrayValue);
      NewArrayValue.addAll(RightValue.ArrayValue);
      HashMap <String, LooFDataValue> NewHashMapValue = new HashMap <String, LooFDataValue> ();
      NewHashMapValue.putAll(LeftValue.HashMapValue);
      NewHashMapValue.putAll(RightValue.HashMapValue);
      return new LooFDataValue (NewArrayValue, NewHashMapValue);
    }
    
    String LeftValueString  = Function_ToString.HandleFunctionCall (LeftValue , Environment, CodeData, AllCodeDatas).StringValue;
    String RightValueString = Function_ToString.HandleFunctionCall (RightValue, Environment, CodeData, AllCodeDatas).StringValue;
    return new LooFDataValue (LeftValueString + RightValueString);
    
  }
  @Override public float GetOrder() {return 3.0;}
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFEvaluatorOperation Operation_Equals = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    switch (LeftValue.ValueType) {
      
      case (DataValueType_Null):
        return new LooFDataValue (RightValue.ValueType == DataValueType_Null);
      
      case (DataValueType_Int):
        if (RightValue.ValueType == DataValueType_Int) return new LooFDataValue (LeftValue.IntValue == RightValue.IntValue);
        if (RightValue.ValueType == DataValueType_Float) return new LooFDataValue (LeftValue.IntValue == RightValue.FloatValue);
        return new LooFDataValue (false);
      
      case (DataValueType_Float):
        if (RightValue.ValueType == DataValueType_Int) return new LooFDataValue (LeftValue.FloatValue == RightValue.IntValue);
        if (RightValue.ValueType == DataValueType_Float) return new LooFDataValue (LeftValue.FloatValue == RightValue.FloatValue);
        return new LooFDataValue (false);
      
      case (DataValueType_String):
        return new LooFDataValue (RightValue.ValueType == DataValueType_String && LeftValue.StringValue.equals(RightValue.StringValue));
      
      case (DataValueType_Bool):
        return new LooFDataValue (RightValue.ValueType == DataValueType_Bool && LeftValue.BoolValue == RightValue.BoolValue);
      
      case (DataValueType_Table):
        return new LooFDataValue (RightValue.ValueType == DataValueType_Table && LeftValue.ArrayValue.equals(RightValue.ArrayValue) && LeftValue.HashMapValue.equals(RightValue.HashMapValue));
      
      case (DataValueType_ByteArray):
        return new LooFDataValue (RightValue.ValueType == DataValueType_ByteArray && Arrays.equals(LeftValue.ByteArrayValue, RightValue.ByteArrayValue));
      
      case (DataValueType_Function):
        return new LooFDataValue (RightValue.equals(LeftValue));
      
      default:
        throw new AssertionError();
      
    }
  }
  @Override public float GetOrder() {return 2.0;}
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFEvaluatorOperation Operation_StrictEquals = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    return new LooFDataValue (LeftValue.equals(RightValue));
  };
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFEvaluatorOperation Operation_GreaterThan = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    if (LeftValue.ValueType == DataValueType_Int && RightValue.ValueType == DataValueType_Int) {
      return new LooFDataValue (LeftValue.IntValue > RightValue.IntValue);
    }
    
    if (ValueIsNumber (LeftValue) && ValueIsNumber (RightValue)) {
      return new LooFDataValue (GetDataValueNumber (LeftValue) > GetDataValueNumber (RightValue));
    }
    
    ThrowLooFException (Environment, CodeData, AllCodeDatas, "the operation \">\" can only compare ints and floats, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " and " + DataValueTypeNames_PlusA[RightValue.ValueType] + ".", new String[] {"InvalidArgType"});
    throw new AssertionError();
    
  }
  @Override public float GetOrder() {return 2.0;}
};





LooFEvaluatorOperation Operation_LessThan = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    if (LeftValue.ValueType == DataValueType_Int && RightValue.ValueType == DataValueType_Int) {
      return new LooFDataValue (LeftValue.IntValue < RightValue.IntValue);
    }
    
    if (ValueIsNumber (LeftValue) && ValueIsNumber (RightValue)) {
      return new LooFDataValue (GetDataValueNumber (LeftValue) < GetDataValueNumber (RightValue));
    }
    
    ThrowLooFException (Environment, CodeData, AllCodeDatas, "the operation \"<\" can only compare ints and floats, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " and " + DataValueTypeNames_PlusA[RightValue.ValueType] + ".", new String[] {"InvalidArgType"});
    throw new AssertionError();
    
  }
  @Override public float GetOrder() {return 2.0;}
};





LooFEvaluatorOperation Operation_NotEquals = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    switch (LeftValue.ValueType) {
      
      case (DataValueType_Null):
        return new LooFDataValue (RightValue.ValueType != DataValueType_Null);
      
      case (DataValueType_Int):
        if (RightValue.ValueType == DataValueType_Int) return new LooFDataValue (LeftValue.IntValue != RightValue.IntValue);
        if (RightValue.ValueType == DataValueType_Float) return new LooFDataValue (LeftValue.IntValue != RightValue.FloatValue);
        return new LooFDataValue (false);
      
      case (DataValueType_Float):
        if (RightValue.ValueType == DataValueType_Int) return new LooFDataValue (LeftValue.FloatValue != RightValue.IntValue);
        if (RightValue.ValueType == DataValueType_Float) return new LooFDataValue (LeftValue.FloatValue != RightValue.FloatValue);
        return new LooFDataValue (false);
      
      case (DataValueType_String):
        return new LooFDataValue (!(RightValue.ValueType == DataValueType_String && LeftValue.StringValue.equals(RightValue.StringValue)));
      
      case (DataValueType_Bool):
        return new LooFDataValue (!(RightValue.ValueType == DataValueType_Bool && LeftValue.BoolValue == RightValue.BoolValue));
      
      case (DataValueType_Table):
         return new LooFDataValue (!(RightValue.ValueType == DataValueType_Table && LeftValue.ArrayValue.equals(RightValue.ArrayValue) && LeftValue.HashMapValue.equals(RightValue.HashMapValue)));
      
      case (DataValueType_ByteArray):
        return new LooFDataValue (!(RightValue.ValueType == DataValueType_ByteArray && Arrays.equals(LeftValue.ByteArrayValue, RightValue.ByteArrayValue)));
      
      case (DataValueType_Function):
        return new LooFDataValue (!RightValue.equals(LeftValue));
      
      default:
        throw new AssertionError();
      
    }
  }
  @Override public float GetOrder() {return 2.0;}
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFEvaluatorOperation Operation_StrictNotEquals = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    return new LooFDataValue (!LeftValue.equals(RightValue));
  };
  @Override public float GetOrder() {return 2.0;}
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFEvaluatorOperation Operation_GreaterThanOrEqual = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    if (LeftValue.ValueType == DataValueType_Int && RightValue.ValueType == DataValueType_Int) {
      return new LooFDataValue (LeftValue.IntValue >= RightValue.IntValue);
    }
    
    if (ValueIsNumber (LeftValue) && ValueIsNumber (RightValue)) {
      return new LooFDataValue (GetDataValueNumber (LeftValue) >= GetDataValueNumber (RightValue));
    }
    
    ThrowLooFException (Environment, CodeData, AllCodeDatas, "the operation \">=\" can only compare ints and floats, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " and " + DataValueTypeNames_PlusA[RightValue.ValueType] + ".", new String[] {"InvalidArgType"});
    throw new AssertionError();
    
  }
  @Override public float GetOrder() {return 2.0;}
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFEvaluatorOperation Operation_LessThanOrEqual = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    if (LeftValue.ValueType == DataValueType_Int && RightValue.ValueType == DataValueType_Int) {
      return new LooFDataValue (LeftValue.IntValue <= RightValue.IntValue);
    }
    
    if (ValueIsNumber (LeftValue) && ValueIsNumber (RightValue)) {
      return new LooFDataValue (GetDataValueNumber (LeftValue) <= GetDataValueNumber (RightValue));
    }
    
    ThrowLooFException (Environment, CodeData, AllCodeDatas, "the operation \"<=\" can only compare ints and floats, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " and " + DataValueTypeNames_PlusA[RightValue.ValueType] + ".", new String[] {"InvalidArgType"});
    throw new AssertionError();
    
  }
  @Override public float GetOrder() {return 2.0;}
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFEvaluatorOperation Operation_And = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    LooFDataValue LeftValueAsBool = Function_ToBool.HandleFunctionCall (LeftValue, Environment, CodeData, AllCodeDatas);
    return (LeftValueAsBool.BoolValue) ? RightValue : new LooFDataValue (false);
  }
  @Override public float GetOrder() {return 1.0;}
};





LooFEvaluatorOperation Operation_Or = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    LooFDataValue LeftValueAsBool = Function_ToBool.HandleFunctionCall (LeftValue, Environment, CodeData, AllCodeDatas);
    return (LeftValueAsBool.BoolValue) ? LeftValue : RightValue;
  }
  @Override public float GetOrder() {return 1.0;}
};





LooFEvaluatorOperation Operation_OrDefault = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    return (LeftValue.ValueType != DataValueType_Null) ? LeftValue : RightValue;
  }
  @Override public float GetOrder() {return 1.0;}
};





LooFEvaluatorOperation Operation_Xor = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    LooFDataValue LeftValueAsBool = Function_ToBool.HandleFunctionCall (LeftValue, Environment, CodeData, AllCodeDatas);
    LooFDataValue RightValueAsBool = Function_ToBool.HandleFunctionCall (RightValue, Environment, CodeData, AllCodeDatas);
    return new LooFDataValue (LeftValueAsBool.BoolValue ^ RightValueAsBool.BoolValue);
  }
  @Override public float GetOrder() {return 1.0;}
};





LooFEvaluatorOperation Operation_BitwiseAnd = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    if (!(LeftValue.ValueType == DataValueType_Int && RightValue.ValueType == DataValueType_Int))
      ThrowLooFException (Environment, CodeData, AllCodeDatas, "the operation \"&&\" can only 'and' ints, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " and " + DataValueTypeNames_PlusA[RightValue.ValueType] + ".", new String[] {"InvalidArgType"});
    
    return new LooFDataValue (LeftValue.IntValue & RightValue.IntValue);
    
  }
  @Override public float GetOrder() {return 7.0;}
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFEvaluatorOperation Operation_BitwiseOr = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    if (!(LeftValue.ValueType == DataValueType_Int && RightValue.ValueType == DataValueType_Int))
      ThrowLooFException (Environment, CodeData, AllCodeDatas, "the operation \"||\" can only 'or' ints, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " and " + DataValueTypeNames_PlusA[RightValue.ValueType] + ".", new String[] {"InvalidArgType"});
    
    return new LooFDataValue (LeftValue.IntValue | RightValue.IntValue);
    
  }
  @Override public float GetOrder() {return 7.0;}
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFEvaluatorOperation Operation_BitwiseXor = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    if (!(LeftValue.ValueType == DataValueType_Int && RightValue.ValueType == DataValueType_Int))
      ThrowLooFException (Environment, CodeData, AllCodeDatas, "the operation \"^^\" can only 'xor' ints, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " and " + DataValueTypeNames_PlusA[RightValue.ValueType] + ".", new String[] {"InvalidArgType"});
    
    return new LooFDataValue (LeftValue.IntValue ^ RightValue.IntValue);
    
  }
  @Override public float GetOrder() {return 7.0;}
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFEvaluatorOperation Operation_ShiftRight = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    if (!(LeftValue.ValueType == DataValueType_Int && RightValue.ValueType == DataValueType_Int))
      ThrowLooFException (Environment, CodeData, AllCodeDatas, "the operation \">>\" can only shift an int with an int, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " with " + DataValueTypeNames_PlusA[RightValue.ValueType] + ".", new String[] {"InvalidArgType"});
    
    return new LooFDataValue (LeftValue.IntValue >> RightValue.IntValue);
    
  }
  @Override public float GetOrder() {return 7.0;}
  @Override public boolean AddToCombinedTokens() {return true;}
};





LooFEvaluatorOperation Operation_ShiftLeft = new LooFEvaluatorOperation() {
  @Override public LooFDataValue HandleOperation (LooFDataValue LeftValue, LooFDataValue RightValue, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    if (!(LeftValue.ValueType == DataValueType_Int && RightValue.ValueType == DataValueType_Int))
      ThrowLooFException (Environment, CodeData, AllCodeDatas, "the operation \"<<\" can only shift an int with an int, not " + DataValueTypeNames_PlusA[LeftValue.ValueType] + " with " + DataValueTypeNames_PlusA[RightValue.ValueType] + ".", new String[] {"InvalidArgType"});
    
    return new LooFDataValue (LeftValue.IntValue << RightValue.IntValue);
    
  }
  @Override public float GetOrder() {return 7.0;}
  @Override public boolean AddToCombinedTokens() {return true;}
};




















LooFEvaluatorFunction Function_Round = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    if (Input.ValueType == DataValueType_Float || Input.ValueType == DataValueType_Int) {
      return new LooFDataValue (Math.round(GetDataValueNumber (Input)));
    }
    
    ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function round can only round an int or a float, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    throw new AssertionError();
    
  }
};





LooFEvaluatorFunction Function_Floor = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    if (Input.ValueType == DataValueType_Float || Input.ValueType == DataValueType_Int) {
      return new LooFDataValue ((long) Math.floor(GetDataValueNumber (Input)));
    }
    
    ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function floor can only round an int or a float, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    throw new AssertionError();
    
  }
};





LooFEvaluatorFunction Function_Ceil = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    if (Input.ValueType == DataValueType_Float || Input.ValueType == DataValueType_Int) {
      return new LooFDataValue ((long) Math.ceil(GetDataValueNumber (Input)));
    }
    
    ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function ceil can only round an int or a float, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    throw new AssertionError();
    
  }
};





LooFEvaluatorFunction Function_Abs = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    switch (Input.ValueType) {
      
      case (DataValueType_Int):
         return new LooFDataValue (Math.abs (Input.IntValue));
      
      case (DataValueType_Float):
         return new LooFDataValue (Math.abs (Input.FloatValue));
      
      default:
        ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function abs can only take an int or a float, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
        throw new AssertionError();
      
    }
  }
};





LooFEvaluatorFunction Function_Sqrt = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    if (Input.ValueType == DataValueType_Float || Input.ValueType == DataValueType_Int) {
      return new LooFDataValue (Math.sqrt(GetDataValueNumber (Input)));
    }
    
    ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function sqrt can only take an int or a float, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    throw new AssertionError();
    
  }
};





LooFEvaluatorFunction Function_Sign = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    Result <Boolean> InputSign = GetDataValueSign (Input);
    
    if (InputSign.Err) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function sign can only take an int or a float, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    
    return new LooFDataValue (InputSign.Some ? 1 : -1);
    
  }
};





LooFEvaluatorFunction Function_Min = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    // ensure input is valid
    if (Input.ValueType != DataValueType_Table) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function min can only take a table, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    ArrayList <LooFDataValue> InputItems = Input.ArrayValue;
    int InputItemsSize = InputItems.size();
    if (InputItemsSize == 0) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function min cannot be called with an empty table.", new String[] {"TableIsEmpty", "IncorrectNumOfArgs", "InvalidArgType"});
    
    // ensure table contains only ints and floats
    boolean[] DataValueTypesInInput = GetDataValueTypesFoundInList (InputItems);
    boolean[] AllowedDataValueTypes = new boolean [NumOfDataValueTypes];
    AllowedDataValueTypes[DataValueType_Int] = true;
    AllowedDataValueTypes[DataValueType_Float] = true;
    for (int i = 0; i < AllowedDataValueTypes.length; i ++) {
      if (DataValueTypesInInput[i] && !AllowedDataValueTypes[i]) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function min can only take a table with ints and floats, but the table given contained a value of type " + DataValueTypeNames[i] + ".", new String[] {"InvalidArgType"});
    }
    
    // if there's a float
    if (DataValueTypesInInput[DataValueType_Float]) {
      LooFDataValue FirstItem = InputItems.get(0);
      double MinValue = GetDataValueNumber_Unsafe (FirstItem, Environment, CodeData, AllCodeDatas, "min");
      for (int i = 1; i < InputItemsSize; i ++) {
        LooFDataValue CurrentItem = InputItems.get(i);
        MinValue = Math.min (MinValue, GetDataValueNumber_Unsafe (CurrentItem, Environment, CodeData, AllCodeDatas, "min"));
      }
      return new LooFDataValue (MinValue);
    }
    
    // if it's all ints
    LooFDataValue FirstItem = InputItems.get(0);
    long MinValue = FirstItem.IntValue;
    for (int i = 1; i < InputItemsSize; i ++) {
      LooFDataValue CurrentItem = InputItems.get(i);
      MinValue = Math.min (MinValue, CurrentItem.IntValue);
    }
    return new LooFDataValue (MinValue);
    
  }
};





LooFEvaluatorFunction Function_Max = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    // ensure input is valid
    if (Input.ValueType != DataValueType_Table) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function max can only take a table, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    ArrayList <LooFDataValue> InputItems = Input.ArrayValue;
    int InputItemsSize = InputItems.size();
    if (InputItemsSize == 0) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function max cannot be called with an empty table.", new String[] {"TableIsEmpty", "IncorrectNumOfArgs", "InvalidArgType"});
    
    // ensure table contains only ints and floats
    boolean[] DataValueTypesInInput = GetDataValueTypesFoundInList (InputItems);
    boolean[] AllowedDataValueTypes = new boolean [NumOfDataValueTypes];
    AllowedDataValueTypes[DataValueType_Int] = true;
    AllowedDataValueTypes[DataValueType_Float] = true;
    for (int i = 0; i < AllowedDataValueTypes.length; i ++) {
      if (DataValueTypesInInput[i] && !AllowedDataValueTypes[i]) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function max can only take a table with ints and floats, but the table given contained a value of type " + DataValueTypeNames[i] + ".", new String[] {"InvalidArgType"});
    }
    
    // if there's a float
    if (DataValueTypesInInput[DataValueType_Float]) {
      LooFDataValue FirstItem = InputItems.get(0);
      double MaxValue = GetDataValueNumber_Unsafe (FirstItem, Environment, CodeData, AllCodeDatas, "max");
      for (int i = 1; i < InputItemsSize; i ++) {
        LooFDataValue CurrentItem = InputItems.get(i);
        MaxValue = Math.max (MaxValue, GetDataValueNumber_Unsafe (CurrentItem, Environment, CodeData, AllCodeDatas, "max"));
      }
      return new LooFDataValue (MaxValue);
    }
    
    // if it's all ints
    LooFDataValue FirstItem = InputItems.get(0);
    long MaxValue = FirstItem.IntValue;
    for (int i = 1; i < InputItemsSize; i ++) {
      LooFDataValue CurrentItem = InputItems.get(i);
      MaxValue = Math.max (MaxValue, CurrentItem.IntValue);
    }
    return new LooFDataValue (MaxValue);
    
  }
};





LooFEvaluatorFunction Function_Clamp = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    // ensure input is valid
    if (Input.ValueType != DataValueType_Table) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function clamp can only take a table, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    ArrayList <LooFDataValue> InputItems = Input.ArrayValue;
    int InputItemsSize = InputItems.size();
    if (InputItemsSize != 3) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function clamp can only take a table with three values, but the table given contains " + InputItemsSize + " items.", new String[] {"IncorrectNumOfArgs", "InvalidArgType"});
    LooFDataValue FirstArg  = InputItems.get(0);
    LooFDataValue SecondArg = InputItems.get(1);
    LooFDataValue ThirdArg  = InputItems.get(2);
    if (!ValueIsNumber (FirstArg )) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function clamp can only take an int or a float as its first arg, but the first arg was of type "   + DataValueTypeNames[FirstArg .ValueType] + ".", new String[] {"InvalidArgType"});
    if (!ValueIsNumber (SecondArg)) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function clamp can only take an int or a float as its second arg, but the second arg was of type " + DataValueTypeNames[SecondArg.ValueType] + ".", new String[] {"InvalidArgType"});
    if (!ValueIsNumber (ThirdArg )) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function clamp can only take an int or a float as its third arg, but the third arg was of type "   + DataValueTypeNames[ThirdArg .ValueType] + ".", new String[] {"InvalidArgType"});
    
    if (FirstArg.ValueType == DataValueType_Int && SecondArg.ValueType == DataValueType_Int && ThirdArg.ValueType == DataValueType_Int) {
      return new LooFDataValue (Math.min (Math.max (FirstArg.IntValue, SecondArg.IntValue), ThirdArg.IntValue));
    }
    
    double FirstArgFloat  = GetDataValueNumber (FirstArg);
    double SecondArgFloat = GetDataValueNumber (SecondArg);
    double ThirdArgFloat  = GetDataValueNumber (ThirdArg);
    
    return new LooFDataValue (Math.min (Math.max (FirstArgFloat, SecondArgFloat), ThirdArgFloat));
    
  }
  @Override public boolean CanBePreEvaluated() {return false;}
};






LooFEvaluatorFunction Function_Log = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    // ensure input is valid
    if (Input.ValueType != DataValueType_Table) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function log can only take a table, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    ArrayList <LooFDataValue> InputItems = Input.ArrayValue;
    int InputItemsSize = InputItems.size();
    if (InputItemsSize != 2) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function log can only take a table with two values, but the table given contains " + InputItemsSize + " items.", new String[] {"IncorrectNumOfArgs", "InvalidArgType"});
    LooFDataValue FirstArg  = InputItems.get(0);
    LooFDataValue SecondArg = InputItems.get(1);
    if (!ValueIsNumber (FirstArg )) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function log can only take an int or a float as its first arg, but the first arg was of type "   + DataValueTypeNames[FirstArg .ValueType] + ".", new String[] {"InvalidArgType"});
    if (!ValueIsNumber (SecondArg)) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function log can only take an int or a float as its second arg, but the second arg was of type " + DataValueTypeNames[SecondArg.ValueType] + ".", new String[] {"InvalidArgType"});
    
    double FirstArgFloat  = GetDataValueNumber (FirstArg);
    double SecondArgFloat = GetDataValueNumber (SecondArg);
    
    return new LooFDataValue (Math.log (FirstArgFloat) / Math.log (SecondArgFloat));
    
  }
};






LooFEvaluatorFunction Function_Log10 = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    if (!ValueIsNumber (Input)) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function log10 can only take an int or a float, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    
    return new LooFDataValue (Math.log10 (GetDataValueNumber (Input)));
    
  }
};






LooFEvaluatorFunction Function_ToDegrees = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    if (!ValueIsNumber (Input)) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function toDegrees can only take an int or a float, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    
    double InputFloat = GetDataValueNumber (Input);
    
    return new LooFDataValue (InputFloat / 180 * Math.PI);
    
  }
};






LooFEvaluatorFunction Function_Ln = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    if (!ValueIsNumber (Input)) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function ln can only take an int or a float, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    
    return new LooFDataValue (Math.log (GetDataValueNumber (Input)));
    
  }
};






LooFEvaluatorFunction Function_ToRadians = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    if (!ValueIsNumber (Input)) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function toRadians can only take an int or a float, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    
    double InputFloat = GetDataValueNumber (Input);
    
    return new LooFDataValue (InputFloat / Math.PI * 180);
    
  }
};





LooFEvaluatorFunction Function_Not = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    LooFDataValue InputAsBool = Function_ToBool.HandleFunctionCall (Input, Environment, CodeData, AllCodeDatas);
    InputAsBool.BoolValue = !InputAsBool.BoolValue;
    
    return InputAsBool;
    
  }
};





LooFEvaluatorFunction Function_BitwiseNot = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    if (Input.ValueType != DataValueType_Int) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function !! can only take an int, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    
    return new LooFDataValue (Input.IntValue ^ 0xffffffffffffffffL);
    
  }
};






LooFEvaluatorFunction Function_IsNaN = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    if (Input.ValueType != DataValueType_Float) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function isNaN can only take a float, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    return new LooFDataValue (Double.isNaN (Input.FloatValue));
  }
};






LooFEvaluatorFunction Function_IsInfinity = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    if (Input.ValueType != DataValueType_Float) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function isInfinity can only take a float, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    return new LooFDataValue (Double.isInfinite (Input.FloatValue));
  }
};





LooFEvaluatorFunction Function_Sin = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    if (!ValueIsNumber (Input)) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function sin can only take an int or a float, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    return new LooFDataValue (Math.sin (GetDataValueNumber (Input)));
  }
};



LooFEvaluatorFunction Function_Cos = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    if (!ValueIsNumber (Input)) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function cos can only take an int or a float, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    return new LooFDataValue (Math.cos (GetDataValueNumber (Input)));
  }
};



LooFEvaluatorFunction Function_Tan = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    if (!ValueIsNumber (Input)) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function tan can only take an int or a float, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    return new LooFDataValue (Math.tan (GetDataValueNumber (Input)));
  }
};



LooFEvaluatorFunction Function_ASin = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    if (!ValueIsNumber (Input)) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function asin can only take an int or a float, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    return new LooFDataValue (Math.asin (GetDataValueNumber (Input)));
  }
};



LooFEvaluatorFunction Function_ACos = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    if (!ValueIsNumber (Input)) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function acos can only take an int or a float, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    return new LooFDataValue (Math.acos (GetDataValueNumber (Input)));
  }
};



LooFEvaluatorFunction Function_ATan = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    if (!ValueIsNumber (Input)) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function atan can only take an int or a float, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    return new LooFDataValue (Math.atan (GetDataValueNumber (Input)));
  }
};



LooFEvaluatorFunction Function_ATan2 = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    // ensure input is valid
    if (Input.ValueType != DataValueType_Table) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function atan2 can only take a table, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    ArrayList <LooFDataValue> InputItems = Input.ArrayValue;
    int InputItemsSize = InputItems.size();
    if (InputItemsSize != 2) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function atan2 can only take a table with two values, but the table given contains " + InputItemsSize + " items.", new String[] {"IncorrectNumOfArgs", "InvalidArgType"});
    LooFDataValue FirstArg  = InputItems.get(0);
    LooFDataValue SecondArg = InputItems.get(1);
    if (!ValueIsNumber (FirstArg )) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function atan2 can only take an int or a float as its first arg, but the first arg was of type "   + DataValueTypeNames[FirstArg .ValueType] + ".", new String[] {"InvalidArgType"});
    if (!ValueIsNumber (SecondArg)) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function atan2 can only take an int or a float as its second arg, but the second arg was of type " + DataValueTypeNames[SecondArg.ValueType] + ".", new String[] {"InvalidArgType"});
    
    double FirstArgFloat  = GetDataValueNumber (FirstArg);
    double SecondArgFloat = GetDataValueNumber (SecondArg);
    
    return new LooFDataValue (Math.atan2 (FirstArgFloat, SecondArgFloat));
    
  }
};



LooFEvaluatorFunction Function_SinH = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    if (!ValueIsNumber (Input)) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function sinh can only take an int or a float, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    return new LooFDataValue (Math.sinh (GetDataValueNumber (Input)));
  }
};



LooFEvaluatorFunction Function_CosH = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    if (!ValueIsNumber (Input)) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function cosh can only take an int or a float, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    return new LooFDataValue (Math.cosh (GetDataValueNumber (Input)));
  }
};



LooFEvaluatorFunction Function_TanH = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    if (!ValueIsNumber (Input)) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function tanh can only take an int or a float, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    return new LooFDataValue (Math.tanh (GetDataValueNumber (Input)));
  }
};





LooFEvaluatorFunction Function_Random = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    if (!ValueIsNumber (Input)) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function random can only take an int or a float, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    
    double MaxValue = GetDataValueNumber (Input);
    return new LooFDataValue (Math.random() * MaxValue);
    
  }
  @Override public boolean CanBePreEvaluated() {return false;}
};





LooFEvaluatorFunction Function_RandomInt = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    switch (Input.ValueType) {
      
      case (DataValueType_Int):
        long MaxInt = Input.IntValue;
        return new LooFDataValue ((int) (Math.random() * (MaxInt + 1)));
      
      case (DataValueType_Table):
        if (Input.ArrayValue.size() != 2) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function randomInt can only take an int or a table of two ints, but a table with " + Input.ArrayValue.size() + " items was given.", new String[] {"InvalidArgType"});
        long MinInt = Input.ArrayValue.get(0).IntValue;
        MaxInt = Input.ArrayValue.get(1).IntValue;
        return new LooFDataValue (MinInt + (int) (Math.random() * ((MaxInt - MinInt) + 1)));
      
      default:
        ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function randomInt can only take an int or a table of two ints, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
        throw new AssertionError();
      
    }
  }
  @Override public boolean CanBePreEvaluated() {return false;}
};





LooFEvaluatorFunction Function_Chance = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    if (!ValueIsNumber (Input)) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function chance can only take an int or a float, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    
    double ChanceLimit = GetDataValueNumber (Input);
    if (ChanceLimit < 0 || ChanceLimit > 100) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function chance can only take a number from 0 to 100 (inclusive).", new String[] {"InvalidArgType"});
    
    return new LooFDataValue (Math.random() < ChanceLimit / 100);
    
  }
  @Override public boolean CanBePreEvaluated() {return false;}
};





LooFEvaluatorFunction Function_LengthOf = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    switch (Input.ValueType) {
      
      case (DataValueType_Table):
        return new LooFDataValue (Input.ArrayValue.size());
      
      case (DataValueType_String):
        return new LooFDataValue (Input.StringValue.length());
      
      case (DataValueType_ByteArray):
        return new LooFDataValue (Input.ByteArrayValue.length);
      
      default:
        ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function lengthOf can only take a table, string, or byteArray, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
        throw new AssertionError();
      
    }
  }
};





LooFEvaluatorFunction Function_TotalLengthOf = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    if (Input.ValueType != DataValueType_Table) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function totalItemsIn can only take a table, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    
    return new LooFDataValue (Input.ArrayValue.size() + Input.HashMapValue.size());
    
  }
};





LooFEvaluatorFunction Function_EndOf = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    switch (Input.ValueType) {
      
      case (DataValueType_Table):
        return new LooFDataValue (Input.ArrayValue.size() - 1);
      
      case (DataValueType_ByteArray):
        return new LooFDataValue (Input.ByteArrayValue.length - 1);
      
      default:
        ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function endOf can only take a table or a byteArray, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
        throw new AssertionError();
      
    }
  }
};





LooFEvaluatorFunction Function_LastItemOf = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    switch (Input.ValueType) {
      
      case (DataValueType_Table):
        ArrayList <LooFDataValue> ArrayValue = Input.ArrayValue;
        int ArrayValueSize = ArrayValue.size();
        if (ArrayValueSize == 0) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function lastItemOf cannot take an empty table.", new String[] {"TableIsEmpty"});
        return ArrayValue.get(ArrayValueSize - 1);
      
      case (DataValueType_ByteArray):
        byte[] ByteArrayValue = Input.ByteArrayValue;
        int ByteArrayValueSize = ByteArrayValue.length;
        if (ByteArrayValueSize == 0) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function lastItemOf cannot take an empty byteArray.", new String[] {"TableIsEmpty"});
        return new LooFDataValue ((long) ByteArrayValue[ByteArrayValueSize - 1]);
      
      default:
        ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function lastItemOf can only take a table or a byteArray, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
        throw new AssertionError();
      
    }
  }
};





LooFEvaluatorFunction Function_KeysOf = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    if (Input.ValueType != DataValueType_Table) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function keysOf can only take a table, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    
    Collection <String> InputKeys = Input.HashMapValue.keySet();
    ArrayList <LooFDataValue> KeysList = new ArrayList <LooFDataValue> ();
    KeysList.ensureCapacity (InputKeys.size());
    for (String CurrentKey : InputKeys) {
      KeysList.add(new LooFDataValue (CurrentKey));
    }
    
    return new LooFDataValue (KeysList, new HashMap <String, LooFDataValue> ());
    
  }
};





LooFEvaluatorFunction Function_ValuesOf = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    if (Input.ValueType != DataValueType_Table) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function valuesOf can only take a table, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    
    Collection <LooFDataValue> InputValues = Input.HashMapValue.values();
    ArrayList <LooFDataValue> ValuesList = new ArrayList <LooFDataValue> ();
    ValuesList.ensureCapacity (InputValues.size());
    for (LooFDataValue CurrentValue : InputValues) {
      ValuesList.add(CurrentValue);
    }
    
    return new LooFDataValue (ValuesList, new HashMap <String, LooFDataValue> ());
    
  }
};






LooFEvaluatorFunction Function_RandomItem = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    if (Input.ValueType != DataValueType_Table) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function randomItem can only take a table, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    
    // get table data
    ArrayList <LooFDataValue> ArrayValue = Input.ArrayValue;
    HashMap <String, LooFDataValue> HashMapValue = Input.HashMapValue;
    int ArraySize = ArrayValue.size();
    int HashMapSize = HashMapValue.size();
    int TotalSize = ArraySize + HashMapSize;
    
    if (TotalSize == 0) return new LooFDataValue();
    
    // choose item
    int ChosenIndex = (int) (Math.random() * TotalSize);
    
    // lands in array part
    if (ChosenIndex < ArraySize) {
      return ArrayValue.get(ChosenIndex);
    }
    
    // lands in hashmap part
    ChosenIndex -= ArraySize;
    return GetCollectionIndex (HashMapValue.values(), ChosenIndex);
    
  }
  @Override public boolean CanBePreEvaluated() {return false;}
};





LooFEvaluatorFunction Function_RandomArrayItem = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    if (Input.ValueType != DataValueType_Table) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function randomItem can only take a table, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    
    ArrayList <LooFDataValue> ArrayValue = Input.ArrayValue;
    if (ArrayValue.size() == 0) return new LooFDataValue();
    return ArrayValue.get((int) (Math.random() * ArrayValue.size()));
    
  }
  @Override public boolean CanBePreEvaluated() {return false;}
};





LooFEvaluatorFunction Function_RandomHashmapItem = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    if (Input.ValueType != DataValueType_Table) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function randomValue can only take a table, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    
    Collection <LooFDataValue> HashMapValues = Input.HashMapValue.values();
    return GetCollectionIndex (HashMapValues, (int) (Math.random() * HashMapValues.size()));
    
  }
  @Override public boolean CanBePreEvaluated() {return false;}
};





LooFEvaluatorFunction Function_FirstIndexOf = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    if (Input.ValueType != DataValueType_Table) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function firstIndexOfItem can only take a table, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    ArrayList <LooFDataValue> InputItems = Input.ArrayValue;
    int InputItemsSize = InputItems.size();
    if (InputItemsSize < 2 || InputItemsSize > 3) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function firstIndexOfItem can only take a table with 2 or 3 values, but the table given contains " + InputItemsSize + " items.", new String[] {"IncorrectNumOfArgs", "InvalidArgType"});
    LooFDataValue FirstArg  = InputItems.get(0);
    LooFDataValue SecondArg = InputItems.get(1);
    
    int StartIndex = 0;
    if (InputItemsSize == 3) {
      LooFDataValue ThirdArg = InputItems.get(2);
      if (ThirdArg.ValueType != DataValueType_Int) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function firstIndexOfItem can only take an int as its third arg, but the third arg was of type " + DataValueTypeNames_PlusA[ThirdArg.ValueType] + ".", new String[] {"InvalidArgType"});
      StartIndex = (int) ThirdArg.IntValue;
    }
    if (StartIndex < 0) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function firstIndexOfItem cannot have a negative starting index.", new String[] {"InvalidArgType"});
    
    switch (FirstArg.ValueType) {
      
      case (DataValueType_Table):
        ArrayList <LooFDataValue> ArrayValue = FirstArg.ArrayValue;
        int ArrayEndIndex = ArrayValue.size() - 1;
        for (int i = StartIndex; i < ArrayEndIndex; i ++) {
          if (ArrayValue.get(i).equals(SecondArg)) return new LooFDataValue ((long) i);
        }
        return new LooFDataValue (-1L);
      
      case (DataValueType_ByteArray):
        if (SecondArg.ValueType != DataValueType_Int) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function firstIndexOfItem can only take an int as its second arg when the first arg is of type byteArray, but the second arg was of type " + DataValueTypeNames_PlusA[SecondArg.ValueType] + ".", new String[] {"InvalidArgType"});
        byte SecondArgByte = (byte) SecondArg.IntValue;
        byte[] ByteArrayValue = FirstArg.ByteArrayValue;
        int ByteArrayEndIndex = ByteArrayValue.length - 1;
        for (int i = StartIndex; i < ByteArrayEndIndex; i ++) {
          if (ByteArrayValue[i] == SecondArgByte) return new LooFDataValue ((long) i);
        }
        return new LooFDataValue (-1L);
      
      default:
        ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function firstIndexOfItem can only take a table or a byteArray as its first arg, but the first arg was of type " + DataValueTypeNames_PlusA[FirstArg.ValueType] + ".", new String[] {"InvalidArgType"});
        throw new AssertionError();
      
    }
  }
};





LooFEvaluatorFunction Function_LastIndexOf = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    if (Input.ValueType != DataValueType_Table) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function lastIndexOfItem can only take a table, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    ArrayList <LooFDataValue> InputItems = Input.ArrayValue;
    int InputItemsSize = InputItems.size();
    if (InputItemsSize < 2 || InputItemsSize > 3) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function lastIndexOfItem can only take a table with 2 or 3 values, but the table given contains " + InputItemsSize + " items.", new String[] {"IncorrectNumOfArgs", "InvalidArgType"});
    LooFDataValue FirstArg  = InputItems.get(0);
    LooFDataValue SecondArg = InputItems.get(1);
    
    int StartIndex = 0;
    if (InputItemsSize == 3) {
      LooFDataValue ThirdArg = InputItems.get(2);
      if (ThirdArg.ValueType != DataValueType_Int) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function lastIndexOfItem can only take an int as its third arg, but the third arg was of type " + DataValueTypeNames_PlusA[ThirdArg.ValueType] + ".", new String[] {"InvalidArgType"});
      StartIndex = (int) ThirdArg.IntValue;
    }
    
    switch (FirstArg.ValueType) {
      
      case (DataValueType_Table):
        ArrayList <LooFDataValue> ArrayValue = FirstArg.ArrayValue;
        int ArraySize = ArrayValue.size() - 1;
        if (ArraySize == 0) return new LooFDataValue (-1L);
        if (StartIndex >= ArraySize) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function lastIndexOfItem cannot have a starting index greater than or equal to the given table.", new String[] {"InvalidArgType"});
        for (int i = StartIndex; i >= 0; i --) {
          if (ArrayValue.get(i).equals(SecondArg)) return new LooFDataValue ((long) i);
        }
        return new LooFDataValue (-1L);
      
      case (DataValueType_ByteArray):
        if (SecondArg.ValueType != DataValueType_Int) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function lastIndexOfItem can only take an int as its second arg when the first arg is of type byteArray, but the second arg was of type " + DataValueTypeNames_PlusA[SecondArg.ValueType] + ".", new String[] {"InvalidArgType"});
        byte SecondArgByte = (byte) SecondArg.IntValue;
        byte[] ByteArrayValue = FirstArg.ByteArrayValue;
        int ByteArraySize = ByteArrayValue.length - 1;
        if (ByteArraySize == 0) return new LooFDataValue (-1L);
        if (StartIndex >= ByteArraySize) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function lastIndexOfItem cannot have a starting index greater than or equal to the given table.", new String[] {"InvalidArgType"});
        for (int i = StartIndex; i >= 0; i --) {
          if (ByteArrayValue[i] == SecondArgByte) return new LooFDataValue ((long) i);
        }
        return new LooFDataValue (-1L);
      
      default:
        ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function firstIndexOfItem can only take a table or a byteArray as its first arg, but the first arg was of type " + DataValueTypeNames_PlusA[FirstArg.ValueType] + ".", new String[] {"InvalidArgType"});
        throw new AssertionError();
      
    }
  }
};





LooFEvaluatorFunction Function_AllIndexesOf = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    if (Input.ValueType != DataValueType_Table) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function allIndexesOfItem can only take a table, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    ArrayList <LooFDataValue> InputItems = Input.ArrayValue;
    int InputItemsSize = InputItems.size();
    if (InputItemsSize < 2 || InputItemsSize > 3) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function allIndexesOfItem can only take a table with 2 or 3 values, but the table given contains " + InputItemsSize + " items.", new String[] {"IncorrectNumOfArgs", "InvalidArgType"});
    LooFDataValue FirstArg  = InputItems.get(0);
    LooFDataValue SecondArg = InputItems.get(1);
    
    ArrayList <LooFDataValue> AllIndexesList = new ArrayList <LooFDataValue> ();
    
    switch (FirstArg.ValueType) {
      
      case (DataValueType_Table):
        ArrayList <LooFDataValue> ArrayValue = FirstArg.ArrayValue;
        int ArrayEndIndex = ArrayValue.size() - 1;
        for (int i = 0; i < ArrayEndIndex; i ++) {
          if (ArrayValue.get(i).equals(SecondArg)) AllIndexesList.add(new LooFDataValue ((long) i));
        }
        return new LooFDataValue (AllIndexesList, new HashMap <String, LooFDataValue> ());
      
      case (DataValueType_ByteArray):
        if (SecondArg.ValueType != DataValueType_Int) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function allIndexesOfItem can only take an int as its second arg when the first arg is of type byteArray, but the second arg was of type " + DataValueTypeNames_PlusA[SecondArg.ValueType] + ".", new String[] {"InvalidArgType"});
        byte SecondArgByte = (byte) SecondArg.IntValue;
        byte[] ByteArrayValue = FirstArg.ByteArrayValue;
        int ByteArrayEndIndex = ByteArrayValue.length - 1;
        for (int i = 0; i < ByteArrayEndIndex; i ++) {
          if (ByteArrayValue[i] == SecondArgByte) AllIndexesList.add(new LooFDataValue ((long) i));
        }
        return new LooFDataValue (AllIndexesList, new HashMap <String, LooFDataValue> ());
      
      default:
        ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function allIndexesOfItem can only take a table or a byteArray as its first arg, but the first arg was of type " + DataValueTypeNames_PlusA[FirstArg.ValueType] + ".", new String[] {"InvalidArgType"});
        throw new AssertionError();
      
    }
  }
};










LooFEvaluatorFunction Function_GetChar = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    if (Input.ValueType != DataValueType_Table) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function getChar can only take a table, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    ArrayList <LooFDataValue> Args = Input.ArrayValue;
    if (Args.size() != 2) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function getChar can only take a table with 2 values, but the table given contains " + Args.size() + " items.", new String[] {"InvalidNumOfArgs"});
    LooFDataValue StringDataValue = Args.get(0);
    LooFDataValue IndexDataValue = Args.get(1);
    if (StringDataValue.ValueType != DataValueType_String) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function getChar takes a string as its first argument, not " + DataValueTypeNames_PlusA[StringDataValue.ValueType] + ".", new String[] {"InvalidArgType"});
    if (IndexDataValue.ValueType != DataValueType_Int) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function getChar takes an int as its second argument, not " + DataValueTypeNames_PlusA[IndexDataValue.ValueType] + ".", new String[] {"InvalidArgType"});
    
    String StringIn = StringDataValue.StringValue;
    long Index = IndexDataValue.IntValue;
    char CharOut = StringIn.charAt((int) CorrectModulo (Index, StringIn.length()));
    return new LooFDataValue ((long) CharOut);
    
  }
};





LooFEvaluatorFunction Function_GetCharInts = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    if (Input.ValueType != DataValueType_String) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function getChars can only take a string, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    
    String StringIn = Input.StringValue;
    char[] InputChars = new char [StringIn.length()];
    
    StringIn.getChars (0, InputChars.length - 1, InputChars, 0);
    
    ArrayList <LooFDataValue> InputCharValues = new ArrayList <LooFDataValue> ();
    for (char CurrChar : InputChars) {
      InputCharValues.add (new LooFDataValue ((long) CurrChar));
    }
    
    return new LooFDataValue (InputCharValues, new HashMap <String, LooFDataValue> ());
    
  }
};





LooFEvaluatorFunction Function_GetCharBytes = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    if (Input.ValueType != DataValueType_String) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function getCharBytes can only take a string, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    
    String StringIn = Input.StringValue;
    char[] InputChars = new char [StringIn.length()];
    
    StringIn.getChars (0, InputChars.length - 1, InputChars, 0);
    
    ArrayList <LooFDataValue> InputCharValues = new ArrayList <LooFDataValue> ();
    for (char CurrChar : InputChars) {
      InputCharValues.add (new LooFDataValue ((long) CurrChar));
    }
    
    return new LooFDataValue (InputCharValues, new HashMap <String, LooFDataValue> ());
    
  }
};





LooFEvaluatorFunction Function_GetSubString = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    if (Input.ValueType != DataValueType_Table) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function getSubString can only take a table, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    ArrayList <LooFDataValue> Args = Input.ArrayValue;
    if (Args.size() != 3) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function getSubString can only take a table with 3 values, but the table given contains " + Args.size() + " items.", new String[] {"InvalidArgType"});
    LooFDataValue StringDataValue = Args.get(0);
    LooFDataValue StartIndexDataValue = Args.get(1);
    LooFDataValue EndIndexDataValue = Args.get(2);
    if (StringDataValue.ValueType != DataValueType_String) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function getSubString takes a string as its first argument, not " + DataValueTypeNames_PlusA[StringDataValue.ValueType] + ".", new String[] {"InvalidArgType"});
    if (StartIndexDataValue.ValueType != DataValueType_Int) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function getSubString takes an int as its second argument, not " + DataValueTypeNames_PlusA[StartIndexDataValue.ValueType] + ".", new String[] {"InvalidArgType"});
    if (EndIndexDataValue.ValueType != DataValueType_Int) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function getSubString takes an int as its third argument, not " + DataValueTypeNames_PlusA[EndIndexDataValue.ValueType] + ".", new String[] {"InvalidArgType"});
    
    String StringIn = StringDataValue.StringValue;
    long StartIndex = StartIndexDataValue.IntValue;
    long EndIndex = EndIndexDataValue.IntValue;
    int StringInLength = StringIn.length();
    
    StartIndex = CorrectModulo (StartIndex, StringInLength);
    EndIndex = CorrectModulo (EndIndex, StringInLength);
    
    return new LooFDataValue (StringIn.substring((int) StartIndex, (int) EndIndex));
    
  }
};





LooFEvaluatorFunction Function_ToInt = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    switch (Input.ValueType) {
      
      case (DataValueType_Null):
        ThrowLooFException (Environment, CodeData, AllCodeDatas, "cannot cast null to int.", new String[] {"InvalidCast", "InalidArgType"});
      
      case (DataValueType_Int):
        return new LooFDataValue (Input.IntValue);
      
      case (DataValueType_Float):
        return new LooFDataValue ((long) Math.floor (Input.FloatValue));
      
      case (DataValueType_String):
        try {
          return new LooFDataValue (Long.parseLong(Input.StringValue));
        } catch (NumberFormatException e) {
          ThrowLooFException (Environment, CodeData, AllCodeDatas, "cannot cast the string \"" + Input.StringValue + "\" to a number.", new String[] {"InvalidCast", "InalidArgType"});
        }
      
      case (DataValueType_Bool):
        return new LooFDataValue (Input.BoolValue ? (long) 1 : (long) 0);
      
      case (DataValueType_Table):
        ThrowLooFException (Environment, CodeData, AllCodeDatas, "cannot cast table to int.", new String[] {"InvalidCast", "InalidArgType"});
      
      case (DataValueType_ByteArray):
        ThrowLooFException (Environment, CodeData, AllCodeDatas, "cannot cast byteArray to int.", new String[] {"InvalidCast", "InalidArgType"});
      
      case (DataValueType_Function):
        ThrowLooFException (Environment, CodeData, AllCodeDatas, "cannot cast function to int", new String[] {"InvalidCast", "InvalidArgType"});
      
      default:
        throw new AssertionError();
      
    }
  }
};





LooFEvaluatorFunction Function_ToFloat = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    switch (Input.ValueType) {
      
      case (DataValueType_Null):
        ThrowLooFException (Environment, CodeData, AllCodeDatas, "cannot cast null to float.", new String[] {"InvalidCast", "InalidArgType"});
      
      case (DataValueType_Int):
        return new LooFDataValue ((double) Input.IntValue);
      
      case (DataValueType_Float):
        return new LooFDataValue (Input.FloatValue);
      
      case (DataValueType_String):
        try {
          return new LooFDataValue (Double.parseDouble(Input.StringValue));
        } catch (NumberFormatException e) {
          ThrowLooFException (Environment, CodeData, AllCodeDatas, "cannot cast string \"" + Input.StringValue + "\" to a float.", new String[] {"InvalidCast", "InalidArgType"});
        }
      
      case (DataValueType_Bool):
        return new LooFDataValue (Input.BoolValue ? (double) 1.0 :  (double) 0.0);
      
      case (DataValueType_Table):
        ThrowLooFException (Environment, CodeData, AllCodeDatas, "cannot cast table to float.", new String[] {"InvalidCast", "InalidArgType"});
      
      case (DataValueType_ByteArray):
        ThrowLooFException (Environment, CodeData, AllCodeDatas, "cannot cast byteArray to float.", new String[] {"InvalidCast", "InalidArgType"});
      
      case (DataValueType_Function):
        ThrowLooFException (Environment, CodeData, AllCodeDatas, "cannot cast function to float", new String[] {"InvalidCast", "InvalidArgType"});
      
      default:
        throw new AssertionError();
      
    }
  }
};





LooFEvaluatorFunction Function_ToString = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    switch (Input.ValueType) {
      
      case (DataValueType_Null):
        return new LooFDataValue ("null");
      
      case (DataValueType_Int):
        return new LooFDataValue (Input.IntValue + "");
      
      case (DataValueType_Float):
        return new LooFDataValue (Input.FloatValue + "");
      
      case (DataValueType_String):
        return new LooFDataValue (Input.StringValue);
      
      case (DataValueType_Bool):
        return new LooFDataValue (Input.BoolValue ? "true" : "false");
      
      case (DataValueType_Table):
        return new LooFDataValue (ConvertLooFDataValueToString (Input));
      
      case (DataValueType_ByteArray):
        return new LooFDataValue (new String (Input.ByteArrayValue));
    
      case (DataValueType_Function):
        String PageName = Input.FunctionPageValue;
        return new LooFDataValue ("Function at " + Input.FunctionLineValue + (PageName != null ? " in " + PageName : ""));
      
      default:
        throw new AssertionError();
      
    }
  }
};





LooFEvaluatorFunction Function_ToBool = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    return new LooFDataValue (GetDataValueTruthiness (Input, Environment, CodeData, AllCodeDatas));
  }
};





LooFEvaluatorFunction Function_NewFunction = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    if (Input.ValueType != DataValueType_Table) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function newFunction can only take a table, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    ArrayList <LooFDataValue> Args = Input.ArrayValue;
    int ArgsSize = Args.size();
    
    LooFDataValue LineNumberValue;
    switch (ArgsSize) {
      
      case (1):
        LineNumberValue = Args.get(0);
        if (LineNumberValue.ValueType != DataValueType_Int) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function newFunction can only take an int as its first arg when there is 1 arg, but the first arg was of type  " + DataValueTypeNames[LineNumberValue.ValueType] + " items.", new String[] {"InvalidArgType"});
        return new LooFDataValue (null, (int) LineNumberValue.IntValue);
      
      case (2):
        LineNumberValue = Args.get(0);
        LooFDataValue FileNameValue = Args.get(1);
        if (LineNumberValue.ValueType != DataValueType_Int) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function newFunction can only take an int as its first arg when there are 2 args, but the first arg was of type  " + DataValueTypeNames[LineNumberValue.ValueType] + ".", new String[] {"InvalidArgType"});
        if (FileNameValue.ValueType != DataValueType_String) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function newFunction can only take a string as its second arg when there are 2 args, but the second arg was of type  " + DataValueTypeNames[FileNameValue.ValueType] + ".", new String[] {"InvalidArgType"});
        return new LooFDataValue (FileNameValue.StringValue, (int) LineNumberValue.IntValue);
      
      default:
        ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function newFunction can only take a table with 1 or 2 values, but the table given contains " + Args.size() + " items.", new String[] {"InvalidArgType"});
        throw new AssertionError();
      
    }
    
  }
};





LooFEvaluatorFunction Function_GetFunctionLine = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    if (Input.ValueType != DataValueType_Function) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function getFunctionLine can only take a function, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    return new LooFDataValue (Input.FunctionLineValue);
  }
};



LooFEvaluatorFunction Function_GetFunctionFile = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    if (Input.ValueType != DataValueType_Function) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function getFunctionFile can only take a function, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    if (Input.FunctionPageValue == null) return new LooFDataValue();
    return new LooFDataValue (Input.FunctionPageValue);
  }
};





LooFEvaluatorFunction Function_TypeOf = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    return new LooFDataValue (DataValueTypeNames[Input.ValueType]);
  }
};





LooFEvaluatorFunction Function_IsNumber = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    return new LooFDataValue (ValueIsNumber (Input));
  }
};



LooFEvaluatorFunction Function_IsLocked = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    return new LooFDataValue (ValueIsLocked (Input));
  }
};



LooFEvaluatorFunction Function_NotNull = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    
    if (Input.ValueType == DataValueType_Null) throw (new LooFInterpreterException (Environment, "null value found", new String[] {"NullValue"}));
    
    return Input;
    
  }
};





LooFEvaluatorFunction Function_CloneValue = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    return Input.clone();
  }
};





LooFEvaluatorFunction Function_NewByteArray = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    if (Input.ValueType != DataValueType_Int) ThrowLooFException (Environment, CodeData, AllCodeDatas, "the evaluator function newByteArray takes an int as its first argument, not " + DataValueTypeNames_PlusA[Input.ValueType] + ".", new String[] {"InvalidArgType"});
    
    return new LooFDataValue (new byte [(int) Input.IntValue]);
    
  }
};





LooFEvaluatorFunction Function_TimeSince = new LooFEvaluatorFunction() {
  @Override public LooFDataValue HandleFunctionCall (LooFDataValue Input, LooFEnvironment Environment, LooFCodeData CodeData, HashMap <String, LooFCodeData> AllCodeDatas) {
    LooFInterpreterModule InterpreterModule = Environment.AddonsData.InterpreterModules.getOrDefault("Interpreter", null);
    if (InterpreterModule == null) ThrowLooFException (Environment, CodeData, AllCodeDatas, "cannot call timeSince without the Interpreter module.", new String[] {"MissingInterpreterModule"});
    LooFInterpreterModuleData InterpreterModuleData = (LooFInterpreterModuleData) Environment.ModuleDatas.get(InterpreterModule);
    
    double InputAsNum = GetDataValueNumber_Unsafe (Input, Environment, CodeData, AllCodeDatas, "timeSince");
    long ProgramStartMillis = InterpreterModuleData.StartMillis;
    long CurrentProgramRuntime = System.currentTimeMillis() - ProgramStartMillis;
    double TimeSinceInput_Millis = (double) CurrentProgramRuntime - InputAsNum * 1000;
    
    return new LooFDataValue (TimeSinceInput_Millis / 1000.0);
    
  }
  @Override public boolean CanBePreEvaluated() {return false;}
};
