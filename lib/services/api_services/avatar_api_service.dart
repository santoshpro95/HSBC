import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dioPackage;
import 'package:hsbc/model/api_error_response.dart';
import 'package:hsbc/model/gpt_api_response.dart';
import 'package:hsbc/utils/app_constants.dart';
import 'package:hsbc/utils/app_stirngs.dart';

class AvatarApiService {
// region | Constructor |
  AvatarApiService();

// endregion

// region gptApi
  Future<GPTApiResponse> gptApi(String query) async {
    try {
      // get body
      var body = {
        "model": "gpt-4o-mini",
        "messages": [
          {"role": "user", "content": query},
          {'role': 'system', 'content': AvatarAppStrings.answerOfQuestion},
        ],
        "temperature": 0.5
      };

      // get header
      var headerData = {"Authorization": "Bearer ${AvatarAppConstants.gptApiKey}"};

      // call api
      var response = await Dio().post(AvatarAppConstants.gptApiUrl, data: json.encode(body), options: dioPackage.Options(headers: headerData));

      // return response;
      return GPTApiResponse.fromJson(response.data);
    } on dioPackage.DioException catch (error) {
      if (error.response == null) {
        if (error.type.index == AvatarAppConstants.noInternet) {
          throw ApiErrorResponse(error: Error(message: AvatarAppStrings.noInternetMessage));
        } else {
          throw ApiErrorResponse(error: Error(message: error.message));
        }
      } else {
        throw ApiErrorResponse.fromJson(error.response!.data);
      }
    } catch (exception) {
      throw ApiErrorResponse(error: Error(message: AvatarAppStrings.errorMessage));
    }
  }
// endregion
}
