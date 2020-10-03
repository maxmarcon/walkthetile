# Walk the tile

## Description

The game is played on a 10 by 10 board. Each player controls a hero, which appears green to the controlling player.
You move the hero around with the _up_, _down_, _left_, and _right_ buttons, and attack with the _attack_ button.

Once you attack, all players in your immediate neighborhood will die and will appear in red. After 5 seconds they will be 
respawned to a random location.

You start the game with a hero's name of your choice by accessing the url `/game?name=<YOUR_NAME>`, otherwise a random
name will be generated for you.

## Local development

### Requirements:

* Elixir
* Yarn

### Installing dependencies

Before running the app or the tests, dependencies have to be installed with:

* `mix setup`

This will install both hex and npm packages.

### Running locally in development mode

1. `mix phx.server`
1. `access game at http://localhost:4000`

### Running the tests

The main application is an umbrella with two component apps: `wtt` and `wtt_web`.

Unit tests for each app can be run separately from the respective app folders:

1. `cd apps/(wtt|wtt_web)`
1. `mix test`

Alternatively, all tests can be run from the main umbrella folder:

1. `mix test`

The app does not include front-end unit tests, as this was not the focus of the assignment.

### Creating and running a production release

1. `yarn --cwd apps/wtt_web/assets deploy`
1. `MIX_ENV=prod mix release`
1. `SECRET_KEY_BASE=$(mix phx.gen.secret) _build/prod/rel/wtt/bin/wtt start`



 