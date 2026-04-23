#!/bin/bash
#
# Launch Codex CLI using Ollama on goldmine-prime.
# Uses OpenAI-compatible env vars to talk directly to Ollama's API.

OPENAI_BASE_URL="http://192.168.1.145:11434/v1" \
    exec codex -m "gemma4:latest" "$@"
