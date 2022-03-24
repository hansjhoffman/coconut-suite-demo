module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes as Attr
import Html.Events as Events
import InteropDefinitions
import InteropPorts
import Json.Decode as Decode
import Svg
import Svg.Attributes as SvgAttr



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
            ( model
            , InteropDefinitions.ImportFile
                |> InteropPorts.fromElm
            )

        NoOp ->
            ( model, Cmd.none )



-- VIEW


mkTestAttribute : String -> Attribute msg
mkTestAttribute key =
    Attr.attribute "data-testid" (String.toLower key)


view : Model -> Browser.Document Msg
view _ =
    { title = "Coconuts Demo1"
    , body =
        [ section []
            [ div [ Attr.class "tw-flex tw-flex-col tw-items-center tw-justify-center" ]
                [ Svg.svg
                    [ SvgAttr.viewBox "-600 -600 1200 1200"
                    , SvgAttr.height "500"
                    , SvgAttr.width "500"
                    , SvgAttr.version "1.1"
                    ]
                    [ Svg.g [ SvgAttr.transform "scale(1 -1)" ]
                        [ Svg.polygon
                            [ SvgAttr.fill "rgba(18, 147, 216, 1)"
                            , SvgAttr.points "-280,-90 0,190 280,-90"
                            , SvgAttr.transform "translate(0 -210) rotate(0)"
                            ]
                            []
                        , Svg.polygon
                            [ SvgAttr.fill "rgba(18, 147, 216, 1)"
                            , SvgAttr.points "-280,-90 0,190 280,-90"
                            , SvgAttr.transform "translate(-210 0) rotate(-90)"
                            ]
                            []
                        , Svg.polygon
                            [ SvgAttr.fill "rgba(18, 147, 216, 0.75)"
                            , SvgAttr.points "-198,-66 0,132 198,-66"
                            , SvgAttr.transform "translate(207 207) rotate(-45)"
                            ]
                            []
                        , Svg.polygon
                            [ SvgAttr.fill "rgba(18, 147, 216, 1)"
                            , SvgAttr.points "-130,0 0,-130 130,0 0,130"
                            , SvgAttr.transform "translate(150 0) rotate(0)"
                            ]
                            []
                        , Svg.polygon
                            [ SvgAttr.fill "rgba(18, 147, 216, 0.75)"
                            , SvgAttr.points "-191,61 69,61 191,-61 -69,-61"
                            , SvgAttr.transform "translate(-89 239) rotate(0)"
                            ]
                            []
                        , Svg.polygon
                            [ SvgAttr.fill "rgba(18, 147, 216, 0.75)"
                            , SvgAttr.points "-130,-44 0,86  130,-44"
                            , SvgAttr.transform "translate(0 106) rotate(-180)"
                            ]
                            []
                        , Svg.polygon
                            [ SvgAttr.fill "rgba(18, 147, 216, 0.75)"
                            , SvgAttr.points "-130,-44 0,86  130,-44"
                            , SvgAttr.transform "translate(256 -150) rotate(-270)"
                            ]
                            []
                        ]
                    ]
                , button
                    [ mkTestAttribute "flatfile-import-btn"
                    , Attr.id "import"
                    , Attr.class "tw-rounded-md tw-px-3 tw-ring-2"
                    , Events.onClick ImportFile
                    ]
                    [ text "Upload with Flatfile" ]
                ]
            ]
        ]
    }



-- <g transform="scale(1 -1)"><polygon fill="rgba(18, 147, 216, 1)" points="-280,-90 0,190 280,-90" transform="translate(0 -210) rotate(0)" data-darkreader-inline-fill="" style="--darkreader-inline-fill:#0e76ad;"></polygon><polygon fill="rgba(18, 147, 216, 1)" points="-280,-90 0,190 280,-90" transform="translate(-210 0) rotate(-90)" data-darkreader-inline-fill="" style="--darkreader-inline-fill:#0e76ad;"></polygon><polygon fill="rgba(18, 147, 216, 0.75)" points="-198,-66 0,132 198,-66" transform="translate(207 207) rotate(-45)" data-darkreader-inline-fill="" style="--darkreader-inline-fill:rgba(14, 118, 173, 0.75);"></polygon><polygon fill="rgba(18, 147, 216, 1)" points="-130,0 0,-130 130,0 0,130" transform="translate(150 0) rotate(0)" data-darkreader-inline-fill="" style="--darkreader-inline-fill:#0e76ad;"></polygon><polygon fill="rgba(18, 147, 216, 0.75)" points="-191,61 69,61 191,-61 -69,-61" transform="translate(-89 239) rotate(0)" data-darkreader-inline-fill="" style="--darkreader-inline-fill:rgba(14, 118, 173, 0.75);"></polygon><polygon fill="rgba(18, 147, 216, 0.75)" points="-130,-44 0,86  130,-44" transform="translate(0 106) rotate(-180)" data-darkreader-inline-fill="" style="--darkreader-inline-fill:rgba(14, 118, 173, 0.75);"></polygon><polygon fill="rgba(18, 147, 216, 0.75)" points="-130,-44 0,86  130,-44" transform="translate(256 -150) rotate(-270)" data-darkreader-inline-fill="" style="--darkreader-inline-fill:rgba(14, 118, 173, 0.75);"></polygon></g></svg>
-- MAIN


main : Program Decode.Value Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
