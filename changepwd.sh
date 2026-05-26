#!/bin/bash

curl -X POST -sSL -k -v "https://localhost:9211/_security/user/kibana_system/_password?pretty" -H 'Content-Type: application/json' -d'{"password" : "Changed!"}' -u elastic:Changed!
