module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes as Attr
import Html.Events as Events
import InteropDefinitions
import InteropPorts
import Json.Decode as Decode



-- MODEL


type alias Model =
    ()



-- INIT


init : Decode.Value -> ( Model, Cmd Msg )
init flags =
    case InteropPorts.decodeFlags flags of
        Err flagsError ->
            Debug.todo <| Debug.toString flagsError

        Ok _ ->
            ( (), Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    InteropPorts.toElm
        |> Sub.map
            (\toElm ->
                case toElm of
                    Err _ ->
                        NoOp

                    Ok _ ->
                        NoOp
            )



-- UPDATE


type Msg
    = NoOp
    | ImportFile


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ImportFile ->
            ( model, InteropDefinitions.ImportFile |> InteropPorts.fromElm )

        NoOp ->
            ( model, Cmd.none )



-- VIEW


mkTestAttribute : String -> Attribute msg
mkTestAttribute key =
    Attr.attribute "data-testid" (String.toLower key)


view : Model -> Browser.Document Msg
view model =
    { title = "Coconuts Demo1"
    , body =
        [ section [ Attr.class "tw-flex tw-w-screen tw-h-screen tw-items-center tw-justify-center" ]
            [ div []
                [ button
                    [ mkTestAttribute "flatfile-import-btn"
                    , Attr.id "import"
                    , Attr.class "tw-rounded-md tw-px-3 tw-ring-2"
                    , Events.onClick ImportFile
                    ]
                    [ text "Import File" ]
                ]
            ]
        ]
    }



-- MAIN


main : Program Decode.Value Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
