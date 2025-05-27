import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";

const inter = Inter({
  subsets: ["latin"],
  variable: "--font-inter",
});

export const metadata: Metadata = {
  title: "OTeePee - Automatic OTP Detection for macOS",
  description: "Never manually copy OTP codes again. OTeePee automatically monitors your iMessage for incoming OTP codes and copies them directly to your clipboard with helpful notifications.",
  keywords: ["OTP", "macOS", "2FA", "authentication", "clipboard", "iMessage", "automatic"],
  authors: [{ name: "OTeePee Team" }],
  openGraph: {
    title: "OTeePee - Automatic OTP Detection for macOS",
    description: "Never manually copy OTP codes again. OTeePee automatically monitors your iMessage for incoming OTP codes and copies them directly to your clipboard.",
    type: "website",
    url: "https://oteepee.vercel.app",
  },
  twitter: {
    card: "summary_large_image",
    title: "OTeePee - Automatic OTP Detection for macOS",
    description: "Never manually copy OTP codes again. Automatic OTP detection and clipboard copying for macOS.",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body
        className={`${inter.variable} antialiased font-sans`}
      >
        {children}
      </body>
    </html>
  );
}
