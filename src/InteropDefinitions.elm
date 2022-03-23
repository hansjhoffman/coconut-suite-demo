module InteropDefinitions exposing (Flags, FromElm(..), ToElm, interop)

{-| This is the file home for all ports. Be sure to re-generate the TypeScript
declaration file `src/Main.elm.d.ts` and `src/InteropPorts.elm` for development
when changes are made to this file.
-}

import Json.Encode as JE
import TsJson.Decode as TsDecode exposing (Decoder)
import TsJson.Encode as TsEncode exposing (Encoder)


interop :
    { toElm : Decoder ToElm
    , fromElm : Encoder FromElm
    , flags : Decoder Flags
    }
interop =
    { toElm = toElm
    , fromElm = fromElm
    , flags = flags
    }


type FromElm
    = ImportFile


type alias ToElm =
    ()


type alias Flags =
    ()


fromElm : Encoder FromElm
fromElm =
    TsEncode.union (\vImport -> vImport)
        |> TsEncode.variantTagged "flatFileImporter" (TsEncode.object [])
        |> TsEncode.buildUnion



-- |> TsEncode.variantLiteral (JE.object [ ( "tag", JE.string "flatFileImporter" ) ])


toElm : Decoder ToElm
toElm =
    TsDecode.null ()


flags : Decoder Flags
flags =
    TsDecode.null ()
