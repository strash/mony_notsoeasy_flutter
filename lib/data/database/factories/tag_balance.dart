import "package:mony_app/data/database/dto/tag_balance.dart";
import "package:mony_app/data/database/factories/factory_interface.dart";

abstract interface class ITagBalanceDatabaseFactory<TOther>
    implements IFactory<TagBalanceDto, TOther> {}
