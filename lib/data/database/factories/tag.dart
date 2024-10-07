import "package:mony_app/data/database/dto/dto.dart";
import "package:mony_app/data/database/factories/factories.dart";

abstract interface class ITagDatabaseFactory<TOther>
    implements IFactory<TagDto, TOther> {}
