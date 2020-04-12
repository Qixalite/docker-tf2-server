#!/bin/sh
echo "Installing"
cd $HOME/tfserver
srcds/srcds_run -game tf $@
