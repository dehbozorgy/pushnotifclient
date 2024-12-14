import 'package:hive_flutter/adapters.dart';
import '/ModelDataBase/TableUser.dart';

Future SaveUser(TableUser data) async {
  var tbl = await Hive.openBox<TableUser>('TableUser');
  await tbl.add(data);
  await tbl.close();
}

Future<TableUser?> GetUser() async {
  var tbl = await Hive.openBox<TableUser>('TableUser');
  TableUser? data;
  try{
    data = tbl.values.last;
  }
  catch(e){}
  await tbl.close();
  return data;
}

Future DeletAllUser() async {
  var tbl = await Hive.openBox<TableUser>('TableUser');
  await tbl.deleteFromDisk();
  await tbl.close();
}