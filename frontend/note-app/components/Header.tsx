import Link from 'next/link';
import React from 'react';

const Header: React.FC = () => {
  return (
    <header className="text-white body-font bg-blue-600">
      <div className="container mx-auto flex flex-wrap p-5 flex-col md:flex-row items-center">
        <Link href="/" className="flex title-font font-medium items-center mb-4 md:mb-0 md:ml-3 text-xl">
          NoteApp
        </Link>
        <nav className="md:ml-auto flex flex-wrap items-center text-base justify-center">
          <Link href="/" className="mx-4 md:mr-8 hover:text-gray-900">Home</Link>
          <Link href="/about" className="mx-4 md:mr-8 hover:text-gray-900">About</Link>
          <a href='/login' className="mx-4 md:mr-8 hover:text-gray-900">Login</a>
        </nav>
      </div>
    </header>
  );
};

export default Header;
