#!/bin/bash
if [ "`echo $(ioreg -c AppleBacklightDisplay) | grep '\"dsyp\"={\"min\"=0,\"max\"=2,\"value\"=2}'`" ]; then exit 0; else exit 1; fi
