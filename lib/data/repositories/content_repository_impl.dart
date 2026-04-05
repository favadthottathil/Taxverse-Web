import '../../domain/repositories/content_repository.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/entities/testimonial_entity.dart';
import '../../domain/entities/stat_entity.dart';
import '../datasources/static_content_data_source.dart';

class ContentRepositoryImpl implements ContentRepository {
  final StaticContentDataSource dataSource;

  ContentRepositoryImpl({required this.dataSource});

  @override
  Future<List<ServiceEntity>> getServices() async {
    return await dataSource.getServices();
  }

  @override
  Future<List<TestimonialEntity>> getTestimonials() async {
    return await dataSource.getTestimonials();
  }

  @override
  Future<List<StatEntity>> getCompanyStats() async {
    return await dataSource.getCompanyStats();
  }
}
