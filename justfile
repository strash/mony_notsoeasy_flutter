set dotenv-filename := ".version"

default:
	@just --list

update:
	@flutter pub upgrade --major-versions

icons:
	@echo " 1. open Android Studio\n 2. File > Open... > \"android\"\n 3. use \"res\" folder"

build:
	@dart run build_runner build

migrate name:
	@bash migrate.sh \
		"{{name}}" \
		"m_$(date +%s)_{{snakecase(name)}}.dart" \
		"M$(date +%s){{uppercamelcase(name)}}"

run_local:
	@just update
	@flutter run --debug \
		--dart-define=DEV_DB_ON_DEVICE=false \
		--dart-define-from-file=.env \
		--dart-define-from-file=.version \
		--no-pub

run_ios:
	@just update
	@flutter run --debug \
		--dart-define=DEV_DB_ON_DEVICE=true \
		--dart-define-from-file=.env \
		--dart-define-from-file=.version \
		--no-pub

run_android:
	@just update
	@flutter run --debug \
		--dart-define=DEV_DB_ON_DEVICE=true \
		--dart-define-from-file=.env \
		--dart-define-from-file=.version \
		--flavor=dev_android_flavor \
		--no-pub

run_rustore:
	@just update
	@flutter run --debug \
		--dart-define=DEV_DB_ON_DEVICE=true \
		--dart-define-from-file=.env \
		--dart-define-from-file=.version \
		--flavor=dev_rustore_flavor \
		--no-pub

release:
	#@just test
	@echo "building apk"
	@ANDROID_HOME=$HOME/Library/Android/sdk \
	flutter build apk --tree-shake-icons --release --pub \
		--flavor=dev_android_flavor \
		--build-name=$BUILD_NAME --build-number=$BUILD_NUMBER \
		--split-debug-info=build/app/intermediates/native_debug_symbols \
		--obfuscate \
		--dart-define=DEV_DB_ON_DEVICE=false \
		--dart-define-from-file=.env \
		--dart-define-from-file=.version \
		--no-pub
	@echo "building rustore release"
	@ANDROID_HOME=$HOME/Library/Android/sdk \
	flutter build appbundle --tree-shake-icons --release --pub \
		--flavor=prod_rustore_flavor \
		--build-name=$BUILD_NAME --build-number=$BUILD_NUMBER \
		--split-debug-info=build/app/intermediates/native_debug_symbols \
		--obfuscate \
		--dart-define=DEV_DB_ON_DEVICE=false \
		--dart-define-from-file=.env \
		--dart-define-from-file=.version \
		--no-pub
	@echo "building google release and packing debug symbols"
	@ANDROID_HOME=$HOME/Library/Android/sdk \
	flutter build appbundle --tree-shake-icons --release --pub \
		--flavor=prod_android_flavor \
		--build-name=$BUILD_NAME --build-number=$BUILD_NUMBER \
		--split-debug-info=build/app/intermediates/native_debug_symbols \
		--obfuscate \
		--dart-define=DEV_DB_ON_DEVICE=false \
		--dart-define-from-file=.env \
		--dart-define-from-file=.version \
		--no-pub && \
	cd build/app/intermediates/merged_native_libs/prod_android_flavorRelease/mergeProd_android_flavorReleaseNativeLibs/out/lib && \
		zip -r symbols.zip ./x86_64 ./arm64-v8a ./armeabi-v7a

test:
	@flutter test --reporter=compact
