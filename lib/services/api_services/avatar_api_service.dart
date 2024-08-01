import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dioPackage;
import 'package:hsbc/model/api_error_response.dart';
import 'package:hsbc/model/avtar_video_response.dart';
import 'package:hsbc/model/current_rate_of_currency_response.dart';
import 'package:hsbc/model/gpt_api_response.dart';
import 'package:hsbc/utils/app_constants.dart';
import 'package:hsbc/utils/app_stirngs.dart';

class AvatarApiService {
// region | Constructor |
  AvatarApiService();

// endregion

  // region currentRateOfExchange
  Future<CurrentRateOfCurrencyResponse> currentRateOfExchange() async {
    try {
      // call api
      var response = await Dio().get(AvatarAppConstants.currentExchangeRateApi);

      // return response;
      return CurrentRateOfCurrencyResponse.fromJson(response.data);
    } on dioPackage.DioException catch (error) {
      if (error.response == null) {
        if (error.type.index == AvatarAppConstants.noInternet) {
          throw ApiErrorResponse(message: AvatarAppStrings.noInternetMessage);
        } else {
          throw ApiErrorResponse(message: error.message);
        }
      } else {
        throw ApiErrorResponse.fromJson(error.response!.data);
      }
    } catch (exception) {
      throw ApiErrorResponse(message: AvatarAppStrings.errorMessage);
    }
  }

// endregion

  // region generateVideo
  Future<AvatarVideoResponse> generateVideo(String content) async {
    try {
      // get body
      var body = {"text": content};

      // call api
      var response = await Dio().post(AvatarAppConstants.avatarVideoGenerateApiUrl, data: json.encode(body));

      // return response;
      return AvatarVideoResponse.fromJson(response.data);
    } catch (exception) {
      return AvatarVideoResponse(url: "");
    }
  }

// endregion

// region gptApi
  Future<GPTApiResponse> gptApi(String content) async {
    try {
      // get body
      var body = {
        "model": "gpt-4o-mini",
        "messages": [
          {"role": "user", "content": content}
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
          throw ApiErrorResponse(message: AvatarAppStrings.noInternetMessage);
        } else {
          throw ApiErrorResponse(message: error.message);
        }
      } else {
        throw ApiErrorResponse.fromJson(error.response!.data);
      }
    } catch (exception) {
      throw ApiErrorResponse(message: AvatarAppStrings.errorMessage);
    }
  }
// endregion
}
