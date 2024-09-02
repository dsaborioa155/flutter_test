import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:restaurant_tour/domain/models/restaurant.dart';

//const _apiKey =
//  'v13cQJUXGrvAeEdtA03XQZb_yy73cSSSCzJ1TOr1hlOv4HSYcB1DMjXqZOdgPt0EyAqGhCH3Y3c-SV0zARaoi58RqeLznypjWrlFml-IAB9frUfMydz5yimleBnRZnYx';
const _apiKey =
    'lky4O5vqungH4LEQ52FoepS9rci3P0Jp_JHCTyYPwqBjvgq921vavoTKp1TQAXB8_CqVWiMBK4WcUx9BL0OgC2GwK1owBx6t0DGFMaP_SGND814JGavglDuKxgjUZnYx';

@lazySingleton
class YelpRepository {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.yelp.com',
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/graphql',
      },
    ),
  );

  YelpRepository();

  /// Returns a response in this shape
  /// {
  /// "data": {
  ///   "search": {
  ///     "total": 5056,
  ///     "business": [
  ///       {
  ///         "id": "faPVqws-x-5k2CQKDNtHxw",
  ///         "name": "Yardbird Southern Table & Bar",
  ///         "price": "$$",
  ///         "rating": 4.5,
  ///         "photos": [
  ///           "https:///s3-media4.fl.yelpcdn.com/bphoto/_zXRdYX4r1OBfF86xKMbDw/o.jpg"
  ///         ],
  ///         "reviews": [
  ///           {
  ///             "id": "sjZoO8wcK1NeGJFDk5i82Q",
  ///             "rating": 5,
  ///             "user": {
  ///               "id": "BuBCkWFNT_O2dbSnBZvpoQ",
  ///               "image_url": "https:///s3-media2.fl.yelpcdn.com/photo/v8tbTjYaFvkzh1d7iE-pcQ/o.jpg",
  ///               "name": "Gina T.",
  ///               "text": "I love this place! The food is amazing and the service is great."
  ///             }
  ///           },
  ///           {
  ///             "id": "okpO9hfpxQXssbTZTKq9hA",
  ///             "rating": 5,
  ///             "user": {
  ///               "id": "0x9xu_b0Ct_6hG6jaxpztw",
  ///               "image_url": "https:///s3-media3.fl.yelpcdn.com/photo/gjz8X6tqE3e4praK4HfCiA/o.jpg",
  ///               "name": "Crystal L.",
  ///               "text": "Greate place to eat"
  ///             }
  ///           },
  ///        ...
  ///     ]
  ///   }
  /// }
  ///
  Future<RestaurantQueryResult?> getRestaurants({int offset = 0}) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        '/v3/graphql',
        data: _getQuery(offset),
      );
      return RestaurantQueryResult.fromJson(response.data!['data']['search']);
    } catch (e) {
      return null;
    }
  }

  String _getQuery(int offset) {
    return '''
query getRestaurants {
  search(location: "Las Vegas", limit: 20, offset: $offset) {
    total    
    business {
      id
      name
      price
      rating
      photos
      reviews {
        id
        rating
        text
        user {
          id
          image_url
          name
        }
      }
      categories {
        title
        alias
      }
      hours {
        is_open_now
      }
      location {
        formatted_address
      }
    }
  }
}
''';
  }
}
