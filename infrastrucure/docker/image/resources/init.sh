#!/bin/bash

restic -r $RESTIC_REPOSITORY/db --verbose init
restic -r $RESTIC_REPOSITORY/files --verbose init
