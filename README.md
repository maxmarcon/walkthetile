# Walk the tile

## Description

The game is played on a 10 by 10 board. Each player controls a hero, which to them appears in green.
You move the play around with the _up_, _down_, _left_, and _right_ buttons, and attack with the _attack_ button.

Once you attack, all players in your immediate neighborhood will die and will appear in red. After 5 seconds they will be 
respawned to a random location

You start the game with a hero's name of your choice by accessing the url `/game?name=<YOUR_NAME>`, otherwise a random
name will be generatefor you.

## Local development

### Requirements:

* Elixir and hex
* Yarn

### Running locally in development mode

1. `mix setup`
1. `mix phx.server`
1. `access game at http://localhost:4000`

### Creating and running a production release

1. `mix setup`
1. `yarn --cwd apps/wtt_web/assets deploy`
1. `MIX_ENV=prod mix release`
1. `SECRET_KEY_BASE=$(mix phx.gen.secret) URL_HOST=localhost _build/prod/rel/wtt/bin/wtt start`



 