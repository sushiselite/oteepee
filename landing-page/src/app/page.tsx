import { Download, Shield, Zap, Bell, Lock, Eye, Github } from 'lucide-react'
import Link from 'next/link'

export default function Home() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-purple-50">
      {/* Header */}
      <header className="container mx-auto px-6 py-6">
        <nav className="flex items-center justify-between">
          <div className="flex items-center space-x-2">
            <div className="w-8 h-8 bg-gradient-to-r from-blue-600 to-purple-600 rounded-lg flex items-center justify-center">
              <span className="text-white font-bold text-sm">🔐</span>
            </div>
            <span className="text-xl font-bold text-gray-900">OTeePee</span>
          </div>
          <div className="flex items-center space-x-6">
            <Link href="#features" className="text-gray-600 hover:text-gray-900 transition-colors">
              Features
            </Link>
            <Link href="#download" className="text-gray-600 hover:text-gray-900 transition-colors">
              Download
            </Link>
            <Link href="https://github.com/sushiselite/oteepee" className="flex items-center space-x-2 text-gray-600 hover:text-gray-900 transition-colors">
              <Github className="w-4 h-4" />
              <span>GitHub</span>
            </Link>
          </div>
        </nav>
      </header>

      {/* Hero Section */}
      <section className="container mx-auto px-6 py-20 text-center">
        <div className="max-w-4xl mx-auto">
          <h1 className="text-5xl md:text-6xl font-bold text-gray-900 mb-6">
            Automatic OTP Detection
            <span className="block text-transparent bg-clip-text bg-gradient-to-r from-blue-600 to-purple-600">
              for macOS
            </span>
          </h1>
          <p className="text-xl text-gray-600 mb-8 max-w-2xl mx-auto">
            Never manually copy OTP codes again. OTeePee automatically monitors your iMessage for incoming OTP codes and copies them directly to your clipboard with helpful notifications.
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center items-center">
            <Link href="#download" className="bg-gradient-to-r from-blue-600 to-purple-600 text-white px-8 py-4 rounded-lg font-semibold hover:shadow-lg transition-all duration-200 flex items-center space-x-2">
              <Download className="w-5 h-5" />
              <span>Download for macOS</span>
            </Link>
            <Link href="https://github.com/sushiselite/oteepee" className="border border-gray-300 text-gray-700 px-8 py-4 rounded-lg font-semibold hover:bg-gray-50 transition-colors flex items-center space-x-2">
              <Github className="w-5 h-5" />
              <span>View on GitHub</span>
            </Link>
          </div>
          <p className="text-sm text-gray-500 mt-4">
            Requires macOS 15.0 (Sequoia) or later
          </p>
        </div>
      </section>

      {/* Features Section */}
      <section id="features" className="container mx-auto px-6 py-20">
        <div className="text-center mb-16">
          <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">
            Why Choose OTeePee?
          </h2>
          <p className="text-xl text-gray-600 max-w-2xl mx-auto">
            Built with privacy and simplicity in mind, OTeePee makes 2FA authentication seamless on macOS.
          </p>
        </div>

        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
          <div className="bg-white p-8 rounded-xl shadow-sm border border-gray-100 hover:shadow-md transition-shadow">
            <div className="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center mb-4">
              <Zap className="w-6 h-6 text-blue-600" />
            </div>
            <h3 className="text-xl font-semibold text-gray-900 mb-3">Instant Detection</h3>
            <p className="text-gray-600">
              Automatically monitors iMessage for incoming SMS/text messages containing OTP codes and copies them instantly.
            </p>
          </div>

          <div className="bg-white p-8 rounded-xl shadow-sm border border-gray-100 hover:shadow-md transition-shadow">
            <div className="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center mb-4">
              <Shield className="w-6 h-6 text-purple-600" />
            </div>
            <h3 className="text-xl font-semibold text-gray-900 mb-3">Smart Recognition</h3>
            <p className="text-gray-600">
              Recognizes various OTP formats including 4-8 digit codes, alphanumeric codes, and service-specific patterns.
            </p>
          </div>

          <div className="bg-white p-8 rounded-xl shadow-sm border border-gray-100 hover:shadow-md transition-shadow">
            <div className="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center mb-4">
              <Bell className="w-6 h-6 text-green-600" />
            </div>
            <h3 className="text-xl font-semibold text-gray-900 mb-3">Native Notifications</h3>
            <p className="text-gray-600">
              Shows native macOS notifications when OTPs are detected, so you always know when a code is ready.
            </p>
          </div>

          <div className="bg-white p-8 rounded-xl shadow-sm border border-gray-100 hover:shadow-md transition-shadow">
            <div className="w-12 h-12 bg-red-100 rounded-lg flex items-center justify-center mb-4">
              <Lock className="w-6 h-6 text-red-600" />
            </div>
            <h3 className="text-xl font-semibold text-gray-900 mb-3">Privacy First</h3>
            <p className="text-gray-600">
              Everything happens locally on your device. No data ever leaves your Mac, ensuring complete privacy.
            </p>
          </div>

          <div className="bg-white p-8 rounded-xl shadow-sm border border-gray-100 hover:shadow-md transition-shadow">
            <div className="w-12 h-12 bg-yellow-100 rounded-lg flex items-center justify-center mb-4">
              <Eye className="w-6 h-6 text-yellow-600" />
            </div>
            <h3 className="text-xl font-semibold text-gray-900 mb-3">Lightweight</h3>
            <p className="text-gray-600">
              Runs as a lightweight menu bar application in the background without slowing down your Mac.
            </p>
          </div>

          <div className="bg-white p-8 rounded-xl shadow-sm border border-gray-100 hover:shadow-md transition-shadow">
            <div className="w-12 h-12 bg-indigo-100 rounded-lg flex items-center justify-center mb-4">
              <Github className="w-6 h-6 text-indigo-600" />
            </div>
            <h3 className="text-xl font-semibold text-gray-900 mb-3">Open Source</h3>
            <p className="text-gray-600">
              Completely open source and transparent. Built with Swift using native macOS frameworks.
            </p>
          </div>
        </div>
      </section>

      {/* Supported Formats Section */}
      <section className="bg-gray-50 py-20">
        <div className="container mx-auto px-6">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">
              Supports All OTP Formats
            </h2>
            <p className="text-xl text-gray-600 max-w-2xl mx-auto">
              OTeePee recognizes various OTP formats commonly used by popular services.
            </p>
          </div>

          <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6 max-w-4xl mx-auto">
            <div className="bg-white p-6 rounded-lg shadow-sm border border-gray-100 text-center">
              <div className="text-2xl font-mono text-blue-600 mb-2">847291</div>
              <p className="text-sm text-gray-600">6-digit numeric codes</p>
            </div>
            <div className="bg-white p-6 rounded-lg shadow-sm border border-gray-100 text-center">
              <div className="text-xl font-mono text-purple-600 mb-2">G7K9M2</div>
              <p className="text-sm text-gray-600">Alphanumeric codes</p>
            </div>
            <div className="bg-white p-6 rounded-lg shadow-sm border border-gray-100 text-center">
              <div className="text-base font-mono text-green-600 mb-2">Your code: 582947</div>
              <p className="text-sm text-gray-600">Keyword patterns</p>
            </div>
            <div className="bg-white p-6 rounded-lg shadow-sm border border-gray-100 text-center">
              <div className="text-base font-mono text-red-600 mb-2">Apple ID: 739284</div>
              <p className="text-sm text-gray-600">Service-specific</p>
            </div>
          </div>
        </div>
      </section>

      {/* Download Section */}
      <section id="download" className="container mx-auto px-6 py-20">
        <div className="text-center mb-16">
          <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">
            Get Started Today
          </h2>
          <p className="text-xl text-gray-600 max-w-2xl mx-auto">
            Download OTeePee and never manually copy OTP codes again.
          </p>
        </div>

        <div className="max-w-2xl mx-auto">
          <div className="bg-white p-8 rounded-xl shadow-sm border border-gray-100">
            <h3 className="text-xl font-semibold text-gray-900 mb-6 text-center">Choose Your Download</h3>
            
            <div className="space-y-4">
              <Link href="https://github.com/sushiselite/oteepee/releases/download/v0.27/OTeePee.dmg" className="block w-full bg-gradient-to-r from-blue-600 to-purple-600 text-white p-4 rounded-lg font-semibold hover:shadow-lg transition-all duration-200 text-center">
                <div className="flex items-center justify-center space-x-2">
                  <Download className="w-5 h-5" />
                  <span>Download v0.27 (DMG)</span>
                </div>
                <p className="text-sm text-blue-100 mt-1">Latest stable release</p>
              </Link>
              
              <Link href="https://github.com/sushiselite/oteepee/releases/latest" className="block w-full border border-gray-300 text-gray-700 p-4 rounded-lg font-semibold hover:bg-gray-50 transition-colors text-center">
                <div className="flex items-center justify-center space-x-2">
                  <Download className="w-5 h-5" />
                  <span>View All Releases</span>
                </div>
                <p className="text-sm text-gray-500 mt-1">Browse all versions</p>
              </Link>
            </div>

            <div className="mt-8 p-4 bg-yellow-50 border border-yellow-200 rounded-lg">
              <h4 className="font-semibold text-yellow-800 mb-2">Required Permissions</h4>
              <ul className="text-sm text-yellow-700 space-y-1">
                <li>• <strong>Full Disk Access</strong> - To read the iMessage database</li>
                <li>• <strong>Accessibility</strong> - For menu bar functionality</li>
              </ul>
            </div>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-gray-900 text-white py-12">
        <div className="container mx-auto px-6">
          <div className="flex flex-col md:flex-row justify-between items-center">
            <div className="flex items-center space-x-2 mb-4 md:mb-0">
              <div className="w-8 h-8 bg-gradient-to-r from-blue-600 to-purple-600 rounded-lg flex items-center justify-center">
                <span className="text-white font-bold text-sm">🔐</span>
              </div>
              <span className="text-xl font-bold">OTeePee</span>
            </div>
            
            <div className="flex items-center space-x-6">
              <Link href="https://github.com/sushiselite/oteepee" className="flex items-center space-x-2 text-gray-300 hover:text-white transition-colors">
                <Github className="w-5 h-5" />
                <span>GitHub</span>
              </Link>
              <Link href="https://github.com/sushiselite/oteepee/issues" className="text-gray-300 hover:text-white transition-colors">
                Issues
              </Link>
              <Link href="https://github.com/sushiselite/oteepee/blob/main/LICENSE" className="text-gray-300 hover:text-white transition-colors">
                MIT License
              </Link>
            </div>
          </div>
          
          <div className="border-t border-gray-800 mt-8 pt-8 text-center text-gray-400">
            <p>&copy; 2024 OTeePee. Built with ❤️ for the macOS community.</p>
            <p className="mt-2 text-sm">All processing happens locally on your device. No data ever leaves your Mac.</p>
          </div>
        </div>
      </footer>
    </div>
  )
}
