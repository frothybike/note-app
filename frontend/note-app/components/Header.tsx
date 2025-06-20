import Link from 'next/link';
import React from 'react';

const Header: React.FC = () => {
  return (
    <header style={headerStyle}>
      <nav style={navStyle}>
        <Link href="/" style={linkStyle}>Home</Link>
        <Link href="/about" style={linkStyle}>About</Link>
        <Link href="/contact" style={linkStyle}>Contact</Link>
      </nav>
    </header>
  );
};

const headerStyle: React.CSSProperties = {
  backgroundColor: '#333',
  padding: '1rem',
  color: 'white',
};

const navStyle: React.CSSProperties = {
  display: 'flex',
  gap: '1rem',
};

const linkStyle: React.CSSProperties = {
  color: 'white',
  textDecoration: 'none',
};

export default Header;
