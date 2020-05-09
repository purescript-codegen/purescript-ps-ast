module Test.Golden.DeclDataComplex.Actual where

import Language.PS.AST.Sugar
import Language.PS.AST.Types

import Data.Maybe (Maybe(..))
import Data.NonEmpty ((:|))
import Data.Tuple.Nested (type (/\), (/\))
import Prelude (map, ($), (<<<))

dataMapMap x y =
  (TypeConstructor $ qualifiedName (mkModuleName $ "Data" :| ["Map"]) (ProperName "Map"))
  `TypeApp`
  x
  `TypeApp`
  y

myExtension = nonQualifiedNameTypeConstructor "MyExtension"

actualModule :: Module
actualModule = Module
  { moduleName: mkModuleName $ "DeclDataComplex" :| []
  , imports: []
  , exports: []
  , declarations:
    [ DeclData
      { head: DataHead
        { dataHdName: ProperName "Foo"
        , dataHdVars: []
        }
      , constructors:
        [ DataCtor
          { dataCtorName: ProperName "Bar"
          , dataCtorFields:
            [ booleanType
            , typeRecord
              [ "foo" /\ numberType
              , "bar" /\ typeRecord [ "baz" /\ dataMapMap stringType numberType ]
              , "qwe" /\ typeRecord
                [ "rty" /\ (dataMapMap (typeRecord [ "asd" /\ numberType ]) (typeRecord [ "foo" /\ numberType, "bar" /\ (dataMapMap (dataMapMap (dataMapMap numberType booleanType) (dataMapMap numberType booleanType)) booleanType) ]))
                , "uio" /\ (dataMapMap (dataMapMap (dataMapMap numberType booleanType) (dataMapMap numberType booleanType)) booleanType)
                ]
              ]
            , TypeVar (Ident "a")
            , arrayType $ TypeVar (Ident "a")
            , arrayType $ typeRecord [ "foo" /\ numberType ]
            , TypeWildcard
            , TypeHole $ Ident "myhole"
            , TypeString "PsString"
            , TypeRow $ Row { rowLabels: [], rowTail: Nothing }
            , TypeRow $ Row { rowLabels: [], rowTail: Just myExtension }
            , TypeRow $ Row { rowLabels: mkRowLabels [ "rowField" /\ numberType ], rowTail: Nothing }
            , TypeRow $ Row { rowLabels: mkRowLabels [ "rowField" /\ numberType ], rowTail: Just myExtension }
            , TypeRow $ Row { rowLabels: mkRowLabels [ "rowField" /\ numberType, "rowField2" /\ numberType ], rowTail: Nothing }
            , TypeRow $ Row { rowLabels: mkRowLabels [ "rowField" /\ numberType, "rowField2" /\ numberType ], rowTail: Just myExtension }
            , TypeRow $ Row { rowLabels: mkRowLabels [ "rowField" /\ numberType, "rowField2" /\ numberType ], rowTail: Just $ TypeOp myExtension (nonQualifiedName $ OpName "+") (nonQualifiedNameTypeConstructor "MyOtherExtension") }
            , TypeRow $ Row
              { rowLabels: mkRowLabels [ "rowField" /\ numberType, "rowField2" /\ numberType ]
              , rowTail: Just $ TypeOp myExtension
                                      (nonQualifiedName $ OpName "+")
                                      ((nonQualifiedNameTypeConstructor "MyOtherExtension")
                                        `TypeApp`
                                        (typeRecord [ "someField" /\ numberType ])
                                      )
              }
            , TypeRow $ Row
              { rowLabels: mkRowLabels
                [ "rowField" /\ (typeRecord
                  [ "foo" /\ numberType
                  , "bar" /\ (dataMapMap (dataMapMap (dataMapMap numberType booleanType) (dataMapMap numberType booleanType)) booleanType)
                  , "baz" /\ (
                    (TypeConstructor $ nonQualifiedName (ProperName "Complex"))
                    `TypeApp`
                    (TypeConstructor $ nonQualifiedName (ProperName "A"))
                    `TypeApp`
                    (TypeConstructor $ nonQualifiedName (ProperName "B"))
                    `TypeApp`
                    (TypeConstructor $ nonQualifiedName (ProperName "C"))
                    `TypeApp`
                    (TypeConstructor $ nonQualifiedName (ProperName "D"))
                    `TypeApp`
                    (TypeConstructor $ nonQualifiedName (ProperName "F"))
                    `TypeApp`
                    (TypeConstructor $ nonQualifiedName (ProperName "G"))
                    `TypeApp`
                    (TypeConstructor $ nonQualifiedName (ProperName "H"))
                  )
                  , "qux" /\ (
                    (TypeConstructor $ nonQualifiedName (ProperName "Complex"))
                    `TypeApp`
                    (
                      (TypeConstructor $ nonQualifiedName (ProperName "A"))
                      `TypeApp`
                      (TypeConstructor $ nonQualifiedName (ProperName "B"))
                      `TypeApp`
                      (TypeConstructor $ nonQualifiedName (ProperName "C"))
                    )
                    `TypeApp`
                    (TypeConstructor $ nonQualifiedName (ProperName "D"))
                    `TypeApp`
                    (
                      (TypeConstructor $ nonQualifiedName (ProperName "F"))
                      `TypeApp`
                      (TypeConstructor $ nonQualifiedName (ProperName "G"))
                      `TypeApp`
                      (TypeConstructor $ nonQualifiedName (ProperName "H"))
                    )
                  )
                  ])
                ]
              , rowTail: Nothing
              }
            , TypeForall
              ((typeVarName "a") :| [(TypeVarKinded (Ident "b") (KindRow (KindName $ nonQualifiedName (ProperName "Type"))) )])
              (arrayType $ typeVar "a")
            , (arrayType $ typeVar "a") ====>> (maybeType $ typeVar "a")
            , TypeOp (nonQualifiedNameTypeConstructor "Array") (nonQualifiedName $ OpName "~>") (nonQualifiedNameTypeConstructor "Maybe")
            , TypeForall
              ((typeVarName "f") :| [])
              (TypeConstrained
                (Constraint { className: nonQualifiedName $ ProperName "Functor", args: [typeVar "f"] })
                (TypeOp (typeVar "f") (nonQualifiedName $ OpName "~>") (nonQualifiedNameTypeConstructor "Maybe"))
              )
            , TypeConstrained
              (Constraint { className: nonQualifiedName $ ProperName "MyClass", args: [typeVar "f", typeVar "g", typeVar "k"] })
              (TypeConstrained
                (Constraint { className: nonQualifiedName $ ProperName "MyClass2", args: [typeRecord $ [ "foo" /\ numberType ]] })
                (typeVar "f"))
            , TypeKinded
              (TypeConstructor $ nonQualifiedName $ ProperName "MyKindedType")
              ((kindNamed "CustomKind" ====>>> KindRow (kindNamed "Type")) ====>>> (kindNamed "Type"))
            , TypeKinded
              (TypeConstructor $ nonQualifiedName $ ProperName "MyKindedType")
              (kindNamed "CustomKind" ====>>> KindRow (kindNamed "Type") ====>>> (kindNamed "Type"))
            ]
          }
        , DataCtor
          { dataCtorName: ProperName "Baz"
          , dataCtorFields:
            [ TypeConstructor $ qualifiedName (mkModuleName $ "Prelude" :| []) (ProperName "Boolean")
            ]
          }
        ]
      }
    ]
  }
