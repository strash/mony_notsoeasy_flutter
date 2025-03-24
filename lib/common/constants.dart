import "dart:ui";

// .env
const kDbName = String.fromEnvironment("DB_NAME", defaultValue: "my.db");
const kDevPathToLocalDb = String.fromEnvironment("DEV_PATH_TO_LOCAL_DB");
const kSupportEmail = String.fromEnvironment("SUPPORT_EMAIL");
const kPrivacyPolicyHost = String.fromEnvironment("PRIVACY_POLICY_HOST");
const kPrivacyPolicyPath = String.fromEnvironment(
  "PRIVACY_POLICY_PATH",
  defaultValue: "/privacy_policy",
);

// dynamic env var
const kIsDbOnDevice = bool.fromEnvironment(
  "DEV_DB_ON_DEVICE",
  defaultValue: true,
);

// .version
const kBuildName = String.fromEnvironment("BUILD_NAME");
const kBuildNumber = String.fromEnvironment("BUILD_NUMBER");
const kMigrateVersion = int.fromEnvironment("MIGRATE_VERSION", defaultValue: 1);

// other
const double kTranslucentPanelOpacity = .5;
const double kTranslucentPanelBlurSigma = 25.0;

const kAmountPattern = r"^[-+]?(?:0|^[-+]?[1-9]\d*?)(?:[.,]\d{0,2})?$";
const kNewTransactionAmountPattern = r"\d*?[.,]\d{2}$";

final kDefaultCurrencyCode =
    PlatformDispatcher.instance.locales.firstOrNull?.languageCode
                .toLowerCase() ==
            "ru"
        ? "RUB"
        : "USD";

/// -1,000,000,000.00
const kMaxAmountLength = 14;
const kMaxTitleLength = 150;
