#!/bin/sh

autoreconf --install || echo "autoreconf failed." >&2 && exit 1
