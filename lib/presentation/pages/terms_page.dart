import 'package:flutter/material.dart';
import '../widgets/legal_page_layout.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalPageLayout(
      title: 'Terms & Conditions',
      lastUpdated: 'September 26, 2026',
      children: [
        LegalIntro(
          'These terms govern your use of the Taxverse Business Consultancy ("Taxverse", "we", "us") website. By using the website you agree to them. If you do not agree, please do not use the website.',
        ),
        LegalSection(
          title: '1. General Information Only',
          paragraphs: [
            'The content on this website, including descriptions of our services, is provided for general information. It is not tax, legal, audit, accounting or financial advice, and should not be relied on as a substitute for advice tailored to your circumstances.',
            'Tax rates, due dates, thresholds and regulations change often. Although we try to keep the website accurate and current, we do not guarantee that it is complete, up to date or free of errors.',
          ],
        ),
        LegalSection(
          title: '2. No Client Relationship',
          paragraphs: [
            'Visiting this website, submitting an enquiry, or speaking with us about a possible engagement does not create a client relationship. A client relationship begins only when we agree to act for you in writing, for example through an engagement letter that sets out the scope of work and fees.',
          ],
          footnote:
              'Please do not send confidential documents, tax identifiers or bank details through the website enquiry forms.',
        ),
        LegalSection(
          title: '3. Our Services',
          paragraphs: [
            'Descriptions of services on the website are indicative. The actual scope, timelines, deliverables and fees for any engagement are those agreed in writing between you and Taxverse. Our work is carried out in line with applicable laws and professional standards, and depends on you giving us complete and accurate information and documents on time.',
          ],
        ),
        LegalSection(
          title: '4. Enquiries and Communications',
          paragraphs: [
            'The contact and consultation forms open a pre-filled WhatsApp message that you review and send yourself. By sending an enquiry you agree that we may contact you by phone, email or WhatsApp to respond. How we handle your personal information is described in our Privacy Policy.',
          ],
        ),
        LegalSection(
          title: '5. Intellectual Property',
          paragraphs: [
            'The website, including its text, graphics, logo, design and other material, belongs to Taxverse or its licensors and is protected by applicable intellectual property laws. You may view the website and share links to it for personal or internal business use. You may not copy, reproduce, modify, distribute or use its content commercially without our prior written permission.',
          ],
        ),
        LegalSection(
          title: '6. Acceptable Use',
          paragraphs: ['When using the website you agree not to:'],
          bullets: [
            'Use it for any unlawful, fraudulent or misleading purpose.',
            'Attempt to gain unauthorised access to, disrupt or overload the website or its hosting.',
            'Use automated tools to scrape or copy its content at scale.',
            'Submit false, defamatory or abusive information in our forms.',
          ],
        ),
        LegalSection(
          title: '7. Third-Party Links and Services',
          paragraphs: [
            'The website links to or embeds third-party services such as WhatsApp and Google Maps. We do not control these services and are not responsible for their content, availability or privacy practices. Your use of them is subject to their own terms.',
          ],
        ),
        LegalSection(
          title: '8. Disclaimer of Warranties',
          paragraphs: [
            'The website is provided "as is" and "as available". To the fullest extent permitted by law, we make no warranties, express or implied, about its accuracy, availability, reliability or fitness for a particular purpose.',
          ],
        ),
        LegalSection(
          title: '9. Limitation of Liability',
          paragraphs: [
            'To the fullest extent permitted by law, Taxverse will not be liable for any direct, indirect, incidental or consequential loss or damage arising from your use of, or reliance on, the website or its content. Nothing in these terms excludes liability that cannot be excluded under applicable law. Liability for professional services is governed by the engagement terms agreed in writing with the client, not by these website terms.',
          ],
        ),
        LegalSection(
          title: '10. Governing Law',
          paragraphs: [
            'These terms are governed by the laws of India. Any dispute arising from your use of the website is subject to the exclusive jurisdiction of the courts at Malappuram, Kerala.',
          ],
        ),
        LegalSection(
          title: '11. Changes to These Terms',
          paragraphs: [
            'We may update these terms from time to time. The "Last updated" date at the top of this page shows when they were last revised. Continued use of the website after a change means you accept the updated terms.',
          ],
        ),
        LegalContactSection(number: '12'),
      ],
    );
  }
}
