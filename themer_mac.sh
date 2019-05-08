#! /bin/bash
ssb="/Applications/Slack.app/Contents/Resources/app.asar.unpacked/src/static/ssb-interop.js"
slackDir="/Applications/Slack.app"
theme=https://raw.github.com/bmmcclint/slack_themes/master/theme.txt
themeLocation=~/Downloads/theme.txt
hasTheme="https://cdn.rawgit.com/laCour/slack-night-mode/master/css/raw/black.css"

if grep $hasTheme -q $ssb; then
  if pgrep -x "Slack" > /dev/null
    then
      echo "Slack is already themed and running..."
    else
      echo "Slack is already themed and not running, starting now..."
      open $slackDir
    fi
 else
  killall Slack
  if [ -e $themeLocation ]; then
    echo "theme file exists, skipping download step"
  else
    echo "downloading theme file..."
    wget -q $theme -O $themeLocation
  fi
  echo "Applying theme to slack..."
  cat $themeLocation >> $ssb
  echo "Starting slack..."
  open $slackDir
fi
