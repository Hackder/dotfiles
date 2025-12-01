if [ -f /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [ -f "$HOME/.rye/env" ]; then
  source "$HOME/.rye/env"
fi

export ANDROID_NDK_HOME="$HOMEBREW_PREFIX/share/android-ndk"
