# OTeePee Landing Page

This is the landing page for [OTeePee](https://github.com/sushiselite/oteepee), a macOS application for automatic OTP detection and clipboard copying.

## 🚀 Built With

- **Next.js 15** - React framework for production
- **TypeScript** - Type safety and better developer experience
- **Tailwind CSS** - Utility-first CSS framework
- **Lucide React** - Beautiful icons
- **Vercel** - Deployment platform

## 🛠 Development

### Prerequisites

- Node.js 18+ 
- npm or yarn

### Getting Started

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Run the development server:**
   ```bash
   npm run dev
   ```

3. **Open your browser:**
   Navigate to [http://localhost:3000](http://localhost:3000)

### Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run start` - Start production server
- `npm run lint` - Run ESLint

## 🚀 Deployment

### Deploy to Vercel

1. **Connect your repository to Vercel:**
   - Go to [vercel.com](https://vercel.com)
   - Import your GitHub repository
   - Vercel will automatically detect it's a Next.js project

2. **Configure deployment:**
   - Root Directory: `landing-page`
   - Build Command: `npm run build`
   - Output Directory: `.next`

3. **Deploy:**
   - Vercel will automatically deploy on every push to main branch
   - You'll get a unique URL for your landing page

### Manual Deployment

```bash
# Build the project
npm run build

# Deploy to Vercel CLI
npx vercel --prod
```

## 📁 Project Structure

```
landing-page/
├── src/
│   └── app/
│       ├── layout.tsx      # Root layout with metadata
│       ├── page.tsx        # Main landing page
│       └── globals.css     # Global styles
├── public/                 # Static assets
├── vercel.json            # Vercel configuration
└── package.json           # Dependencies and scripts
```

## 🎨 Features

- **Responsive Design** - Works on all devices
- **Modern UI** - Clean, professional design with gradients
- **SEO Optimized** - Proper meta tags and Open Graph
- **Fast Loading** - Optimized with Next.js
- **Accessible** - Built with accessibility in mind

## 🔗 Links

- **Live Site:** [https://oteepee.vercel.app](https://oteepee.vercel.app)
- **Main Repository:** [https://github.com/sushiselite/oteepee](https://github.com/sushiselite/oteepee)
- **Issues:** [https://github.com/sushiselite/oteepee/issues](https://github.com/sushiselite/oteepee/issues)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](../LICENSE) file for details.
