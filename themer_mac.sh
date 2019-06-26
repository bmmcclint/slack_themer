#! /bin/bash
ssb="/Applications/Slack.app/Contents/Resources/app.asar.unpacked/src/static/ssb-interop.js"
slackDir="/Applications/Slack.app"
theme=https://raw.github.com/bmmcclint/slack_themer/master/theme.txt
themeLocation=~/Downloads/theme.txt
hasTheme="https://cdn.rawgit.com/laCour/slack-night-mode/master/css/raw/black.css"
plist=https://raw.github.com/bmmcclint/slack_themer/master/slackthemer.plist
localPlist=~/Library/LaunchAgents/slackthemer.plist
now=$(date)

if [ -e localPlist ]; then 
  echo "$now downloading plist..."
  wget -q $plist -O $localPlist
  sed -i '' 's/~/\/Users\/'$USER'/g' $localPlist
  launchctl load $localPlist
else
  echo "$now plist exists, skipping step..."
fi

if grep $hasTheme -q $ssb; then
  if pgrep -x "Slack" > /dev/null
    then
      echo "$now Slack is already themed and running..."
    else
      echo "$now Slack is already themed and not running, starting now..."
      open $slackDir
    fi
 else
   if pgrep -x "Slack" > /dev/null 
   then
    killall Slack
  fi
  if [ -e $themeLocation ]; then
    echo "$now theme file exists, skipping download step"
  else
    echo "$now downloading theme file..."
    wget -q $theme -O $themeLocation
  fi
  echo "$now Applying theme to slack..."
  cat $themeLocation >> $ssb
  echo "$now Starting slack..."
  open $slackDir
fi
