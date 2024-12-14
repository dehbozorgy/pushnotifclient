// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TableUser.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TableUserAdapter extends TypeAdapter<TableUser> {
  @override
  final int typeId = 0;

  @override
  TableUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TableUser(
      isRegistered: fields[0] as bool,
      lstSubcription: (fields[1] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, TableUser obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.isRegistered)
      ..writeByte(1)
      ..write(obj.lstSubcription);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TableUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
