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

run:
	@just update
	@flutter run --debug \
		--dart-define-from-file=.env \
		--dart-define-from-file=.version

# run_local_ios:
# 	@flutter run --debug --pub \
# 		--flavor=local_flavor \
# 		--dart-define-from-file=.env.local.ios \
# 		--dart-define-from-file=.version
#
# run_local_android:
# 	@flutter run --debug --pub \
# 		--flavor=local_flavor \
# 		--dart-define-from-file=.env.local.android \
# 		--dart-define-from-file=.version

# TODO тут из другого проекта пример
# build_android:
# 	@flutter test --test-randomize-ordering-seed=random --reporter=compact && \
# 		flutter build appbundle --tree-shake-icons --release --pub \
# 		--flavor=prod_flavor \
# 		--build-name=$BUILD_NAME --build-number=$BUILD_NUMBER \
# 		--split-debug-info=build/app/intermediates/native_debug_symbols \
# 		--obfuscate \
# 		--dart-define-from-file=.env \
# 		--dart-define-from-file=.version && \
# 		flutter build appbundle --tree-shake-icons --release --pub \
# 		--flavor=prod_rustore_flavor \
# 		--build-name=$BUILD_NAME --build-number=$BUILD_NUMBER \
# 		--split-debug-info=build/app/intermediates/native_debug_symbols \
# 		--obfuscate \
# 		--dart-define-from-file=.env \
# 		--dart-define-from-file=.version
# 	cd build/app/intermediates/merged_native_libs/prod_flavorRelease/mergeProd_flavorReleaseNativeLibs/out/lib && \
# 		zip -r symbols.zip ./x86_64 ./arm64-v8a ./armeabi-v7a

test:
	@flutter test --reporter=compact
