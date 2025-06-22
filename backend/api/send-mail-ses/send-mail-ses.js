'use strict'
const SDK = require('aws-sdk');

exports.handler = (event, context, callback) => {
    const ses = new SDK.SES({ region: 'ap-northeast-1' });
    const adminaddress = process.env.EMAIL_TO
    const email = {
        Source: process.env.EMAIL_FROM,
        Destination: { 
            ToAddresses: [ adminaddress ]            
        },
        Message: {
            Subject: { Data: "フォームからのお問い合わせ" },
            Body: {
                Text: { Data: [
                    '[お問い合わせ表題] : ' + event.form['subject'],
                    '[メールアドレス] : ' + event.form['email'],
                    '[お問い合わせ本文] : ' + "\n" + event.form['body']
                ].join("\n")}
            },
        },
    };
    ses.sendEmail(email, callback);
};