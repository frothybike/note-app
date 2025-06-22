"use client";

import { useForm } from "react-hook-form";
import { yupResolver } from "@hookform/resolvers/yup";
import * as yup from "yup";
import Head from "next/head";
import { useState } from "react";

type FormData = {
  subject: string;
  email: string;
  body: string;
};

const schema = yup.object().shape({
  subject: yup.string().required("表題を入力してください").max(50, "表題は50文字以内にしてください"),
  email: yup.string().required("メールアドレスを入力してください").email("有効なメールアドレスを入力してください"),
  body: yup.string().required("本文を入力してください"),
});

export default function ContactFormPage() {
  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
    reset,
  } = useForm<FormData>({
    resolver: yupResolver(schema),
  });

  const [submitted, setSubmitted] = useState(false);

  const onSubmit = async (data: FormData) => {
    try {
      const response = await fetch("https://jqi9ljoedk.execute-api.ap-northeast-1.amazonaws.com/v1/send", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(data),
      });

      if (response.ok) {
        alert("送信に成功しました");
        reset();
        setSubmitted(true);
      } else {
        alert("送信に失敗しました");
      }
    } catch (error) {
      alert("送信中にエラーが発生しました");
      console.error(error);
    }
  };

  return (
    <>
      <Head>
        <title>お問い合わせフォーム</title>
      </Head>
      <div className="container" style={{ maxWidth: "960px", margin: "60px auto" }}>
        <h2 className="title is-4">お問い合わせフォーム</h2>
        <form onSubmit={handleSubmit(onSubmit)}>
          <div className="field">
            <input className="input" placeholder="お問い合わせの表題" {...register("subject")} />
            <p className="help is-danger">{errors.subject?.message}</p>
          </div>
          <div className="field">
            <input className="input" placeholder="メールアドレス" {...register("email")} />
            <p className="help is-danger">{errors.email?.message}</p>
          </div>
          <div className="field">
            <textarea className="textarea" placeholder="お問い合わせ本文" {...register("body")} />
            <p className="help is-danger">{errors.body?.message}</p>
          </div>
          <div className="field">
            <button className="button is-link" type="submit" disabled={isSubmitting}>
              {isSubmitting ? "送信中です..." : "送信する"}
            </button>
          </div>
        </form>
      </div>
    </>
  );
}
