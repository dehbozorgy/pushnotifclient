
import 'package:hive/hive.dart';

part 'TableUser.g.dart';

@HiveType(typeId: 0)
class TableUser {

  @HiveField(0)
  final bool isRegistered;

  @HiveField(1)
  final List<String> lstSubcription;

  TableUser({
    required this.isRegistered,
    required this.lstSubcription});

}