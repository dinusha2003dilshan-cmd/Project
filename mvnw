#!/usr/bin/env bash
# Lightweight Maven wrapper (Unix). Downloads Apache Maven on first run and executes it.
MAVEN_VERSION=3.9.6
WRAPPER_DIR="$(dirname "$0")/.mvn/wrapper"
MAVEN_DIR="$WRAPPER_DIR/apache-maven-$MAVEN_VERSION"

if [ ! -x "$MAVEN_DIR/bin/mvn" ]; then
  echo "Maven not present locally; downloading Apache Maven $MAVEN_VERSION..."
  mkdir -p "$WRAPPER_DIR"
  url="https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz"
  tmp="/tmp/maven-$MAVEN_VERSION-$$.tar.gz"
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$url" -o "$tmp" || { echo "Download failed"; exit 1; }
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$tmp" "$url" || { echo "Download failed"; exit 1; }
  else
    echo "curl or wget required to download Maven"; exit 1
  fi
  tar -xzf "$tmp" -C "$WRAPPER_DIR" || { echo "Extract failed"; exit 1; }
  rm -f "$tmp"
fi

exec "$MAVEN_DIR/bin/mvn" "$@"
