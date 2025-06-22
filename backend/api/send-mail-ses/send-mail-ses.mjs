import { SESClient, SendEmailCommand } from '@aws-sdk/client-ses';

export const handler = async (event) => {
  const sesClient = new SESClient({ region: 'ap-northeast-1' });

  const params = {
    Source: 'no-reply@namabanana.com',
    Destination: {
      ToAddresses: ['frothybike8@gmail.com'],
    },
    Message: {
      Subject: {
        Data: 'フォームからのお問い合わせ',
      },
      Body: {
        Text: {
          Data: [
            `[お問い合わせ表題] : ${event.form.subject}`,
            `[メールアドレス] : ${event.form.email}`,
            `[お問い合わせ本文] : \n${event.form.body}`,
          ].join('\n'),
        },
      },
    },
  };

  const command = new SendEmailCommand(params);

  try {
    const data = await sesClient.send(command);
    console.log('Email sent successfully:', data);
  } catch (err) {
    console.error('Error sending email:', err);
  }
};
