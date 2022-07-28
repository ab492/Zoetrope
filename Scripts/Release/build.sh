#!/usr/bin/env bash

# Archive Zoetrope 
xcodebuild archive -project ~/Programming/Zoetrope/Zoetrope/Zoetrope.xcodeproj -scheme Zoetrope -configuration Release -archivePath "Zoetrope.xcarchive"

# Export and upload the archive to App Store Connect
xcodebuild -exportArchive -archivePath Zoetrope.xcarchive -exportOptionsPlist "ExportOptions.plist" -exportPath .

# Remove the archive
rm -r Zoetrope.xcarchive
