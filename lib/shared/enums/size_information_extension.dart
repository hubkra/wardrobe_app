import 'package:wardrobe_app/shared/enums/size_information.dart';

extension SizeInformationExtension on SizeInformation {
  static SizeInformation fromString(String value) {
    return SizeInformation.values.firstWhere(
      (size) => size.toString() == 'SizeInformation.$value',
      orElse: () => SizeInformation.XL,
    );
  }
}
