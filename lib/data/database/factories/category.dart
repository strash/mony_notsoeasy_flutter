import "package:mony_app/data/database/dto/dto.dart";
import "package:mony_app/data/database/factories/factories.dart";

abstract interface class ICategoryDatabaseFactory<TOther>
    implements IFactory<CategoryDto, TOther> {}
