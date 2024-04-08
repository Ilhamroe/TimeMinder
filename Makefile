

build_android:
	@echo "Building app..."
	@flutter build apk --release

publish_app_dev:
	firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk --app 1:531786122829:android:f09bf17b7a098e1c96fe04 --groups "timeminder-dev" --release-notes-file release_notes.txt

build_publish_android: build_android publish_app_dev