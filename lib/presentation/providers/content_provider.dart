import 'package:flutter/widgets.dart';
import '../../domain/repositories/content_repository.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/entities/testimonial_entity.dart';
import '../../domain/entities/stat_entity.dart';

class ContentProvider extends ChangeNotifier {
  final ContentRepository repository;

  List<ServiceEntity> _services = [];
  List<TestimonialEntity> _testimonials = [];
  List<StatEntity> _stats = [];

  bool _isLoading = false;

  ContentProvider({required this.repository}) {
    _loadAllContent();
  }

  List<ServiceEntity> get services => _services;
  List<TestimonialEntity> get testimonials => _testimonials;
  List<StatEntity> get stats => _stats;
  bool get isLoading => _isLoading;

  Future<void> _loadAllContent() async {
    _isLoading = true;
    notifyListeners();

    try {
      final futures = await Future.wait([
        repository.getServices(),
        repository.getTestimonials(),
        repository.getCompanyStats(),
      ]);

      _services = futures[0] as List<ServiceEntity>;
      _testimonials = futures[1] as List<TestimonialEntity>;
      _stats = futures[2] as List<StatEntity>;
    } catch (e) {
      debugPrint('Error loading content: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
