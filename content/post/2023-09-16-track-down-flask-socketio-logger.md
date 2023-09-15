---
title: "Track down `flask-socketio` logger"
date: 2023-09-16T01:32:49+09:00
tags: ["flask", "socketio", "engineio"]
toc: true
---

Flask supports the SocketIO connection via [`flask-socketio`](https://flask-socketio.readthedocs.io/) library. It's written by [Miguel Grinberg (@miguelgrinberg)](https://github.com/miguelgrinberg) as well as its underlining [`python-engineio`](https://github.com/miguelgrinberg/python-engineio) and [`python-socketio`](https://github.com/miguelgrinberg/python-socketio).

I tracked down the path to set the custom engineio logger.

<!--more-->

## `engineio_logger` argument of `flask-socketio`

As written in the `flask-socketio` documentation ([Getting Started — Flask-SocketIO documentation](https://flask-socketio.readthedocs.io/en/latest/getting_started.html#debugging-and-troubleshooting)), when `SocketIO` is initialized, we can customize the logging via `engineio_logger` parameter.

It looks like it takes one `boolean` value, `True | False`, but actually can take the third type `logging.Logger`.

> These arguments can be set to True to output logs to stderr, or to an object compatible with Python’s logging package where the logs should be emitted to. A value of False disables logging.

### In `flask-socketio`

The parameter `engineio_logger` will be taken as `**kwargs` and set to `server_options`, and then passed to `socketio.Server()` here: [Flask-SocketIO/src/flask_socketio/__init__.py at main · miguelgrinberg/Flask-SocketIO](https://github.com/miguelgrinberg/Flask-SocketIO/blob/main/src/flask_socketio/__init__.py#L243).

The next place is `python-socketio` library code.

### In `python-socketio`

In the `python-socketio` library, the server takes the above options as `**kwargs`. And it just passes through to `engineio.Server()` just renaming from `engineio_logger` to `logger` (returned from `_engineio_server_class()`): [python-socketio/src/socketio/server.py at main · miguelgrinberg/python-socketio](https://github.com/miguelgrinberg/python-socketio/blob/main/src/socketio/server.py#L134).

This is the almost same way as `flask-socketio`!

### In `python-engineio`

Finally, we entered the final library `python-engineio`. In fact, how it is passed is the same way again.

After checking the given type, it set the given logger to engineio options: [python-engineio/src/engineio/server.py at main · miguelgrinberg/python-engineio](https://github.com/miguelgrinberg/python-engineio/blob/main/src/engineio/server.py#L124)

## Summary
                                                            
- Flask SocketIO server can take just a standard Python `logging.Logger` as `engineio_logger` argument.
- Going through `flask-socketio` -> `python-socketio` -> `python-engineio`.
