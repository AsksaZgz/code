#!/bin/bash
ssh -L 5902:localhost:5901 $1
vncviewer localhost:2
