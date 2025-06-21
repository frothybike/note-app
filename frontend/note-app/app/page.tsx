export default function Home() {
  return (
    <main className="text-gray-600 body-font">
      <div className="mx-auto p-5 container">
        <div className="py-5 text-center">
          <h1 className="mb-5 text-4xl font-extrabold text-gray-900">NoteAppへようこそ</h1>
          <p className="mb-10">シンプルなメモ帳アプリです。</p>
          <a href="/signup" className="bg-blue-600 text-white px-5 py-3 rounded-2xl">今すぐ登録する</a>
        </div>
      </div>
    </main>
  );
}
