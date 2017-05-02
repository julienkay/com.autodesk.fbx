// ***********************************************************************
// Copyright (c) 2017 Unity Technologies. All rights reserved.
//
// Licensed under the ##LICENSENAME##.
// See LICENSE.md file in the project root for full license information.
// ***********************************************************************

#ifdef IGNORE_ALL_INCLUDE_SOME
// Unignore class
%rename("%s") FbxDataType;
%rename("%s") FbxDataType::~FbxDataType;

%rename("%s") FbxDataType::Valid;
%rename("%s") FbxDataType::Is;
%rename("%s") FbxDataType::GetType;
%rename("%s") FbxDataType::GetName;

/* Provide more convenient access to a global. */
%rename("%s") FbxDataType::GetNameForIO;

#endif

/* todo */
%ignore FbxDataType::FbxDataType(const FbxPropertyHandle& pTypeInfoHandle);
%ignore FbxDataType::GetTypeInfoHandle;

/* Constructors.
 *
 * Create/Destroy are defined, but they're acting exactly like the ctor/dtor, so just use
 * ctor/dtor.
 *
 * There's also the mapping from enum to data type, which is handled as a global function
 * in Fbx, but fits well as a constructor.
 */
%ignore FbxDataType::Create;
%ignore FbxDataType::Destroy;
%extend FbxDataType {
  FbxDataType(const char* pName, const EFbxType pType) {
    return new FbxDataType(FbxDataType::Create(pName, pType));
  }
  FbxDataType(const char* pName, const FbxDataType& pDataType) {
    return new FbxDataType(FbxDataType::Create(pName, pDataType));
  }
  FbxDataType(EFbxType pType) {
    return new FbxDataType(FbxGetDataTypeFromEnum(pType));
  }
}

/* No assignment. Use the copy constructor instead */
%ignore FbxDataType::operator=;

/* Equality. The hash code could be improved. */
%define_equality_from_operator(FbxDataType);
%extend FbxDataType { %proxycode %{
  public override int GetHashCode() { return GetName().GetHashCode(); }
%} }

/*
 * GetType is a special function in C#, so we need to rename it.
 */
%rename("ToEnum") FbxDataType::GetType;

/*
 * This is a global function, but it fits as a member function.
 */
%extend FbxDataType {
  const char *GetNameForIO() {
    return FbxGetDataTypeNameForIO(*$self);
  }
}

/* Add a ToString function. */
%define_tostring(FbxDataType, GetName());

/* Take in a whole bunch of constants. Mark them all immutable.
 * Should we put them in the FbxDataTypes namespace?
 * The list of constants is generated by a script. */
%define %fbxdatatype(NAME)
%rename("%s") NAME;
%immutable NAME;
%enddef
#ifndef SWIG_GENERATING_TYPEDEFS
/* This file is generated, so we must not include it when generating typedefs. */
%include "fbxdatatypeconstants.i"
#endif

%include "fbxsdk/core/fbxdatatypes.h"