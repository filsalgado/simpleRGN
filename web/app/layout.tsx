import './globals.css'
import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import { Providers } from './providers'
import { UserMenu } from '@/components/UserMenu'
import Link from 'next/link'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'SimpleRGN - Parochial Records',
  description: 'Genealogy and Parochial Record Management',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="pt">
      <head>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
      </head>
      <body className={inter.className}>
        <Providers>
          <nav className="navbar navbar-expand-lg bg-white shadow-sm border-bottom">
            <div className="container-fluid">
              <Link href="/" className="navbar-brand fw-bold text-primary">
                SimpleRGN
              </Link>
              <UserMenu />
            </div>
          </nav>
          {children}
        </Providers>
      </body>
    </html>
  )
}
