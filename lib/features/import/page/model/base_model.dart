import "package:flutter/foundation.dart";
import "package:intl/intl.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/models/account.dart";
import "package:mony_app/domain/models/category.dart";
import "package:mony_app/domain/models/transaction_type_enum.dart";
import "package:mony_app/domain/services/database/vo/account.dart";
import "package:mony_app/domain/services/database/vo/category.dart";
import "package:mony_app/domain/services/database/vo/imported_csv.dart";
import "package:mony_app/features/import/page/model/enum.dart";
import "package:mony_app/features/import/validator/validator.dart";

part "./model_account.dart";
part "./model_category.dart";
part "./model_column.dart";
part "./model_column_validation.dart";
part "./model_csv.dart";
part "./model_transaction_type.dart";

sealed class ImportModel {
  bool isReady();

  void dispose();
}
