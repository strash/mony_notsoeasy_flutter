abstract interface class IFactory<FDto, TOther> {
  TOther toModel(FDto dto);

  FDto toDto(TOther other);
}
