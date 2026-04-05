import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/service_model.dart';
import '../models/testimonial_model.dart';
import '../models/stat_model.dart';

class StaticContentDataSource {
  Future<List<ServiceModel>> getServices() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return const [
      ServiceModel(
        title: 'Audit & Assurance',
        description:
            'Statutory, internal & bank audits with thorough due diligence',
        icon: FontAwesomeIcons.shieldHalved,
      ),
      ServiceModel(
        title: 'Taxation',
        description: 'Income tax, GST, international tax planning & litigation',
        icon: FontAwesomeIcons.fileInvoiceDollar,
      ),
      ServiceModel(
        title: 'Accounting & Payroll',
        description: 'Bookkeeping, payroll, MIS reporting & virtual CFO',
        icon: FontAwesomeIcons.calculator,
      ),
      ServiceModel(
        title: 'Registrations',
        description: 'Company incorporation, GST, FSSAI, MSME & more',
        icon: FontAwesomeIcons.fileContract,
      ),
      ServiceModel(
        title: 'Consulting & Advisory',
        description: 'Business setup, project finance, M&A advisory',
        icon: FontAwesomeIcons.buildingColumns,
      ),
      ServiceModel(
        title: 'IP & Others',
        description: 'Trademarks, patents, ISO certification & compliance',
        icon: FontAwesomeIcons.userShield,
      ),
    ];
  }

  Future<List<TestimonialModel>> getTestimonials() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return const [
      TestimonialModel(
        text:
            'Taxverse made our business setup process smooth and completely stress-free. From documentation to registration and compliance, their team handled everything professionally and on time. Their guidance helped us launch quickly without any delays. Highly reliable and supportive.',
        author: 'SIPGLOW',
        designation: 'Fresh Healthy Juice Brand',
      ),
      TestimonialModel(
        text:
            'Working with Taxverse has been an incredible experience. They resolved all our compliance issues within weeks. Their proactive communication is unmatched in the industry.',
        author: 'TechInnovate',
        designation: 'IT Startup',
      ),
      TestimonialModel(
        text:
            'Outstanding support during our company restructuring. The legal and financial guidance from Taxverse was instrumental in a smooth transition.',
        author: 'Anita Desai',
        designation: 'Chairperson, Desai Group',
      ),
      TestimonialModel(
        text:
            'As a startup, we needed a CA firm that understood speed and compliance equally. Taxverse delivered on both fronts without fail.',
        author: 'Vikram Patel',
        designation: 'Co-founder, FinEdge Technologies',
      ),
      TestimonialModel(
        text:
            'Taxverse helped us navigate complex GST regulations effortlessly. Their in-depth knowledge of the tax landscape saved us both time and money. We couldn\'t have asked for a better partner.',
        author: 'Meera Krishnan',
        designation: 'CFO, Horizon Exports',
      ),
      TestimonialModel(
        text:
            'From day one, the team at Taxverse has been professional, responsive, and thorough. They simplified our international tax planning and helped us expand into the UAE market seamlessly.',
        author: 'Rajesh Sharma',
        designation: 'Managing Director, Silverline Industries',
      ),
      TestimonialModel(
        text:
            'Their audit team is exceptional. Taxverse conducted a thorough statutory audit and identified key areas for improvement that directly impacted our bottom line.',
        author: 'Priya Menon',
        designation: 'Director, GreenLeaf Healthcare',
      ),
      TestimonialModel(
        text:
            'We\'ve relied on Taxverse for payroll and compliance for over three years. They are always ahead of deadlines and keep us fully compliant. A truly dependable partnership.',
        author: 'Arjun Nair',
        designation: 'CEO, CloudNine Solutions',
      ),
    ];
  }

  Future<List<StatModel>> getCompanyStats() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return const [
      StatModel(title: '6000+', subtitle: 'Happy Clients'),
      StatModel(title: '8+', subtitle: 'Years Experience'),
      StatModel(title: '15+', subtitle: 'Expert Staff'),
    ];
  }
}
