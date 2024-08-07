import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hsbc/utils/app_colors.dart';
import 'package:hsbc/utils/app_stirngs.dart';

class WritePopup extends StatefulWidget {
  const WritePopup({super.key});

  @override
  State<WritePopup> createState() => _WritePopupState();
}

class _WritePopupState extends State<WritePopup> {
  // region Controller
  final commandTextCtrl = TextEditingController();

  // endregion

  // region build
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.maxFinite,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)), color: AppColors.backgroundColor),
        child: ListView(
          shrinkWrap: true,
          children: [header(), commandText(), submitBtn()],
        ));
  }

  // endregion

  // region commandText
  Widget commandText() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: TextField(
        autofocus: true,
        controller: commandTextCtrl,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: AvatarAppStrings.askAnything,
          hintText: AvatarAppStrings.askAnything,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(40)), borderSide: BorderSide(color: AppColors.darkGreyColor1, width: 0.5)),
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(40)), borderSide: BorderSide(color: AppColors.darkGreyColor1, width: 0.5)),
          enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(40)), borderSide: BorderSide(color: AppColors.darkGreyColor1, width: 0.5)),
        ),
      ),
    );
  }

  // endregion

  // region submitBtn
  Widget submitBtn() {
    return CupertinoButton(
      onPressed: () => Navigator.pop(context, commandTextCtrl.text),
      child: Container(
        height: 45,
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: AppColors.primaryColor),
        child: Center(
          child: Text(AvatarAppStrings.submit, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  // endregion

  // region header
  Widget header() {
    return Container(
      height: 54,
      color: Colors.white,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(left: 20, right: 10),
      child: Row(
        children: [
          Expanded(
              child:
                  Text(AvatarAppStrings.assistant, style: const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w500, fontSize: 18))),
          CupertinoButton(
              onPressed: () => Navigator.pop(context), padding: EdgeInsets.zero, child: const Icon(Icons.close, color: AppColors.greyColor)),
        ],
      ),
    );
  }

// endregion
}
