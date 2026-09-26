import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/service_model.dart';
import '../models/testimonial_model.dart';
import '../models/stat_model.dart';

class StaticContentDataSource {
  Future<List<ServiceModel>> getServices() async {
    return const [
      ServiceModel(
        title: 'Audit & Assurance',
        description: 'Statutory & internal audits with thorough due diligence',
        icon: FontAwesomeIcons.shieldHalved,
      ),
      ServiceModel(
        title: 'Taxation',
        description: 'Income tax, GST & litigation',
        icon: FontAwesomeIcons.fileInvoiceDollar,
      ),
      ServiceModel(
        title: 'Accounting & Payroll',
        description:
            'Bookkeeping, payroll, MIS reporting & financial statements',
        icon: FontAwesomeIcons.calculator,
      ),
      ServiceModel(
        title: 'Registrations',
        description: 'Company incorporation, GST, FSSAI, MSME',
        icon: FontAwesomeIcons.fileContract,
      ),
      ServiceModel(
        title: 'Consulting & Advisory',
        description: 'Business setup, project finance, project report',
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
    return const [
      TestimonialModel(
        text:
            'Running a creative agency like Clydea is all about ideas, execution, and growth. But behind every strong brand, there has to be a strong financial backbone.\n\n'
            'We were facing real challenges in managing accounts and tax compliance properly. That’s when Taxverse stepped in and brought structure to the chaos. Their team handled everything with clarity, precision, and complete professionalism.\n\n'
            'Now our accounting and tax processes run smoothly, and we can focus fully on scaling Clydea without worrying about numbers. Especially Taxverse VCFO Service.\n\n'
            'If you are struggling with accounts or tax handling, Taxverse is the team you want on your side.',
        author: 'Mr. Naju',
        designation: 'CEO of Clydea · Branding Agency',
      ),
      TestimonialModel(
        text:
            'I was facing a serious GST-related issue late at night and honestly did not expect to receive any assistance at that hour. However, the team at Taxverse responded immediately, understood the situation clearly, and handled the matter with remarkable professionalism.\n\n'
            'They approached the issue calmly and systematically, guiding me through each step and ensuring that everything was resolved correctly. The entire matter was successfully cleared the same night, which was incredibly reassuring.\n\n'
            'What impressed me most was their commitment to supporting their clients beyond regular working hours. Their prompt response, attention to detail, problem-solving approach, and dedication reflect the same level of professionalism and reliability that one would expect from a trusted Taxverse Business Consultancy.\n\n'
            'Team Taxverse truly stands out for its dependability, technical professionalism, and commitment to delivering the right solutions when they matter most.',
        author: 'Mr. Shakeeb Cholakkal',
        designation:
            'CEO of Corbal Steel Engineering · Steel Structuring Company',
      ),
      TestimonialModel(
        text:
            'We have had an excellent experience working with Taxverse for our company’s tax, accounts and compliance requirements. Their team has consistently demonstrated a high level of professionalism, expertise, and attention to detail in handling our tax matters.\n\n'
            'What particularly stands out is their ability to provide clear and practical guidance, respond promptly to our queries, and ensure that our requirements are handled efficiently and within the necessary timelines. Their proactive approach and commitment to accuracy have given us greater confidence in managing our tax and compliance responsibilities.\n\n'
            'We truly appreciate the reliability, responsiveness, and professional service provided by the team at Taxverse. We would confidently recommend Taxverse to businesses looking for dependable and professional tax advisory and compliance support.',
        author: 'Structrafic Engineering Pvt. Ltd.',
        designation: '',
      ),
    ];
  }

  Future<List<StatModel>> getCompanyStats() async {
    return const [
      StatModel(title: '600+', subtitle: 'Clients'),
      StatModel(title: '2+', subtitle: 'Years Experience'),
      StatModel(title: '15+', subtitle: 'Expert Staff'),
    ];
  }
}
