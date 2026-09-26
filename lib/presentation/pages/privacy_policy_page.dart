import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../widgets/legal_page_layout.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalPageLayout(
      title: 'Privacy Policy',
      lastUpdated: 'September 26, 2026',
      children: [
        LegalIntro(
          'Taxverse Business Consultancy ("Taxverse", "we", "us") respects your privacy. This policy explains what personal information we collect through this website, how we use it, and the choices you have.',
        ),
        LegalSection(
          title: '1. Information We Collect',
          paragraphs: [
            'We only collect the information you choose to give us when you get in touch. This is typically:',
          ],
          bullets: [
            'Your name, phone number and email address.',
            'The service you are interested in and any message you write in our enquiry or consultation forms.',
            'Any details you share when you call, email or message us.',
          ],
          footnote:
              'We do not ask for tax identifiers, bank details or financial documents through this website. Please do not include them in the enquiry forms.',
        ),
        LegalSection(
          title: '2. How Enquiry Forms Work',
          paragraphs: [
            'This website does not store form submissions on its own servers. When you submit the contact or consultation form, your details are placed into a pre-filled WhatsApp message that opens in WhatsApp (web or app) for you to review and send. The message is delivered to us through WhatsApp and is therefore also subject to WhatsApp\'s own terms and privacy policy.',
            'If you email or call us directly, we receive the information you provide through those channels.',
          ],
        ),
        LegalSection(
          title: '3. How We Use Your Information',
          bullets: [
            'To respond to your enquiry and arrange consultations.',
            'To provide the tax, accounting, compliance and advisory services you request.',
            'To meet our legal, regulatory and professional obligations.',
          ],
          footnote:
              'We do not sell your personal information, and we do not use it for third-party advertising.',
        ),
        LegalSection(
          title: '4. Cookies and Analytics',
          paragraphs: [
            'We do not set our own cookies or run analytics or advertising trackers on this website. If we introduce them in the future, we will update this policy and, where required, ask for your consent first.',
          ],
        ),
        LegalSection(
          title: '5. Third-Party Services',
          paragraphs: [
            'Some features rely on third parties, which have their own privacy practices:',
          ],
          bullets: [
            'Google Maps: the map on our Contact page loads only when you choose to view it. Google may then collect technical information such as your IP address and set cookies.',
            'WhatsApp (operated by Meta): used to deliver enquiry messages, as described above. Messages may be processed on servers outside India, under WhatsApp\'s own terms.',
            'Our website hosting provider, which processes standard server logs (such as IP address and browser type) needed to serve the site securely.',
          ],
        ),
        LegalSection(
          title: '6. Sharing of Information',
          paragraphs: [
            'We share personal information only with the people who need it to serve you (for example, our professionals working on your matter), with service providers acting on our behalf under confidentiality obligations, or where disclosure is required by law, a court order or a regulator.',
          ],
        ),
        LegalSection(
          title: '7. Retention and Security',
          paragraphs: [
            'If you send an enquiry and no engagement follows, we keep your details for up to 12 months from our last communication with you, and then delete them. If you become a client, we keep your records for as long as needed to provide our services and as required by applicable law and professional standards, and then delete or anonymise them.',
            'We use reasonable technical and organisational measures to protect the information we hold, but no method of transmission or storage is completely secure. If a personal data breach affects you, we will notify you and the relevant authority as required by law.',
          ],
        ),
        LegalSection(
          title: '8. Your Rights',
          paragraphs: [
            'Subject to applicable law, you have the right to:',
          ],
          bullets: [
            'Ask for a summary of the personal information we hold about you and how we use it.',
            'Have inaccurate or incomplete information corrected or updated.',
            'Have your information deleted when it is no longer needed for the purpose it was collected, unless the law requires us to keep it.',
            'Withdraw your consent at any time by emailing or calling us using the details below. Withdrawing is as easy as giving consent. It does not affect what we did before you withdrew, and we may keep information we are required by law to retain.',
            'Nominate another person to exercise these rights on your behalf if you die or become unable to do so.',
          ],
          footnote:
              'To make a request, contact us using the details in section 9. We may need to confirm your identity first.',
        ),
        LegalSection(
          title: '9. Grievances and Complaints',
          paragraphs: [
            'If you have a concern about how we handle your personal information, please contact us first:',
          ],
          bullets: [
            'Email: ${AppConstants.contactEmail}',
            'Phone: ${AppConstants.contactPhone}',
          ],
          footnote:
              'We aim to respond within 30 days and, in any case, within the period required by law. If you are not satisfied with our response, you may complain to the Data Protection Board of India under the Digital Personal Data Protection Act, 2023.',
        ),
        LegalSection(
          title: '10. Language',
          paragraphs: [
            'This policy is provided in English. On request, we will provide it in any language listed in the Eighth Schedule to the Constitution of India, including Malayalam.',
          ],
        ),
        LegalSection(
          title: '11. Children\'s Privacy',
          paragraphs: [
            'Our services are directed at businesses and adults. We do not knowingly collect personal information from children.',
          ],
        ),
        LegalSection(
          title: '12. Changes to This Policy',
          paragraphs: [
            'We may update this policy from time to time. The "Last updated" date at the top of this page shows when it was last revised. Continued use of the website after a change means you accept the updated policy.',
          ],
        ),
        LegalContactSection(number: '13'),
      ],
    );
  }
}
