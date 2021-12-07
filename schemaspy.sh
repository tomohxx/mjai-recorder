#!/bin/sh
docker run -v "$PWD/output:/output" -v "$PWD/schemaspy.properties:/schemaspy.properties" --net=host --rm schemaspy/schemaspy
