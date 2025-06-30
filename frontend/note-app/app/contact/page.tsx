"use client";

import { useForm } from "react-hook-form";
import { yupResolver } from "@hookform/resolvers/yup";
import * as yup from "yup";
import Head from "next/head";
import { useRouter } from "next/navigation";

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
  const router = useRouter();
  
  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
    reset,
  } = useForm<FormData>({
    resolver: yupResolver(schema),
  });

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
        reset();
        router.push("/contact/thanks");
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
      <div className="max-w-2xl mx-auto px-4 py-12">
        <h2 className="text-2xl font-semibold mb-6 text-center">お問い合わせフォーム</h2>
        <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
          <div>
            <input
              type="text"
              placeholder="お問い合わせの表題"
              {...register("subject")}
              className="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
            {errors.subject && (
              <p className="text-sm text-red-600 mt-1">{errors.subject.message}</p>
            )}
          </div>

          <div>
            <input
              type="email"
              placeholder="メールアドレス"
              {...register("email")}
              className="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
            {errors.email && (
              <p className="text-sm text-red-600 mt-1">{errors.email.message}</p>
            )}
          </div>

          <div>
            <textarea
              placeholder="お問い合わせ本文"
              {...register("body")}
              rows={6}
              className="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
            {errors.body && (
              <p className="text-sm text-red-600 mt-1">{errors.body.message}</p>
            )}
          </div>

          <div>
            <button
              type="submit"
              disabled={isSubmitting}
              className={`w-full py-2 px-4 rounded-md text-white font-semibold ${
                isSubmitting
                  ? "bg-gray-400 cursor-not-allowed"
                  : "bg-blue-600 hover:bg-blue-700"
              }`}
            >
              {isSubmitting ? "送信中です..." : "送信する"}
            </button>
          </div>
        </form>
      </div>
    </>
  );
}
