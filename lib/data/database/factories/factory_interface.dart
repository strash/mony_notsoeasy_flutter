abstract interface class IFactory<TDto, TOther> {
  TOther toModel(TDto dto);

  TDto toDto(TOther other);
}
