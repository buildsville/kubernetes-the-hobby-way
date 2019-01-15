#!/bin/bash
### create tokens for TLS bootstrapping ###

openssl rand -hex 3 2>/dev/null 1>token-id.txt
openssl rand -hex 8 2>/dev/null 1>token-secret.txt