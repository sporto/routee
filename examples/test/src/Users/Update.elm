module Users.Update (..) where

import Effects exposing (Effects, Never)
import Debug
import Task
import Hop.Navigate exposing (navigateTo, addQuery, setQuery)
import Hop.Types exposing (Config, Location)
import Models
import Users.Models exposing (..)
import Users.Actions exposing (Action, Action(..))
import Users.Routing.Utils


type alias UpdateModel =
  { users : List User
  , location : Location
  , routerConfig : Config Models.Route
  }


update : Action -> UpdateModel -> ( UpdateModel, Effects Action )
update action model =
  case Debug.log "action" action of
    NavigateTo path ->
      ( model, Effects.map HopAction (navigateTo model.routerConfig path) )

    Show id ->
      let
        path =
          Users.Routing.Utils.reverseWithPrefix (Users.Models.UserRoute id)

        fx =
          Task.succeed (NavigateTo path)
            |> Effects.task
      in
        ( model, fx )

    ShowStatus id ->
      let
        path =
          Users.Routing.Utils.reverseWithPrefix (Users.Models.UserStatusRoute id)

        fx =
          Task.succeed (NavigateTo path)
            |> Effects.task
      in
        ( model, fx )

    AddQuery query ->
      let
        fx =
          Effects.map HopAction (addQuery model.routerConfig query model.location)
      in
        ( model, fx )

    SetQuery query ->
      let
        fx =
          Effects.map HopAction (setQuery model.routerConfig query model.location)
      in
        ( model, fx )

    HopAction () ->
      ( model, Effects.none )
