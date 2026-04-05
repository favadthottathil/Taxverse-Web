import '../entities/service_entity.dart';
import '../entities/testimonial_entity.dart';
import '../entities/stat_entity.dart';

abstract class ContentRepository {
  Future<List<ServiceEntity>> getServices();
  Future<List<TestimonialEntity>> getTestimonials();
  Future<List<StatEntity>> getCompanyStats();
}
