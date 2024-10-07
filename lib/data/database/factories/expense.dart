import "package:mony_app/data/database/dto/dto.dart";
import "package:mony_app/data/database/factories/factories.dart";

abstract interface class IExpenseDatabaseFactory<TOther>
    implements IFactory<ExpenseDto, TOther> {}
