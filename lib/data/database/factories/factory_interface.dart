abstract interface class IFactory<FDto, TOther> {
  TOther from(FDto dto);

  FDto to(TOther other);
}
