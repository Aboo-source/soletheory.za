# Sole Theory - Premium Streetwear E-Commerce

## Overview
Sole Theory is a premium streetwear sneakers and apparel e-commerce website featuring:
- 30 premium sneakers with full product details
- **120 clothing products across 4 categories (30 each)**
- Functional shopping cart with localStorage persistence
- Search functionality
- Checkout system
- Mobile-responsive design

## Recent Changes (October 28, 2025)

### ✅ Clothing Products Expansion - 120 Products Added!
- **Extracted 17 real fitted cap images** from uploaded zip file
- **Downloaded 90 license-free stock images** for products
- **Created 120 clothing products** (expanded from 24):
  - 30 Fitted Caps (New Era 59FIFTY) - Using real uploaded images
  - 30 Soccer Kits (Football Jerseys) - Stock images
  - 30 Tech Fleece (Nike) - Stock images
  - 30 Premium Clothing (Essentials, Rhude, Gallery Dept, etc) - Stock images

## Project Architecture

### Tech Stack
- **Framework**: Vite + Vanilla JavaScript
- **Deployment**: Replit (configured for port 5000)
- **Storage**: localStorage for cart persistence
- **Images**: Local image assets + stock images

### Key Files
- `main.js` - All product data, cart logic, and interactive functionality
  - Products array: 30 sneakers (lines 1-422)
  - clothingProducts array: 120 clothing items (lines 424-2074)
- `index.html` - Main structure and layout
- `style.css` - All styling and animations
- `vite.config.js` - Vite configuration for Replit environment
- `package.json` - Node dependencies

### Image Structure
```
IMAGES/
├── CLOTHING/
│   ├── caps/         (17 real images from uploaded zip)
│   ├── soccer/       (30 stock images)
│   ├── techfleece/   (30 stock images)
│   └── premium/      (30 stock images)
└── (sneaker images via URLs)
```

## Features

### Sneakers Section
- 30 premium sneakers with multiple color options
- 5 color variations per shoe
- UK sizing (6-12)
- Price range: R 699.99 - R 2,499.99

### Clothing Section (NEW - 120 Products!)

#### 1. Fitted Caps (30 products)
- New Era 59FIFTY caps from various teams
- **Real product images** from uploaded zip
- 4 color options per cap
- Hat sizes: 7, 7 1/4, 7 1/2, 7 3/4, 8
- Price range: R 1,099.95 - R 1,199.95

#### 2. Soccer Kits (30 products)
- Football jerseys from major teams worldwide
- 3 color options (Home, Away, Third)
- Sizes: S, M, L, XL, 2XL
- Price range: R 899.00 - R 1,299.00

#### 3. Tech Fleece (30 products)
- Nike Tech Fleece collection
- 4 color options per item
- Sizes: S, M, L, XL
- Price range: R 1,399.95 - R 2,399.95

#### 4. Premium Clothing (30 products)
- Luxury streetwear brands
- 4 color options per item
- Sizes: S, M, L, XL
- Price range: R 1,999.95 - R 4,499.95

### Shopping Cart
- Add products with specific color and size selections
- Persistent storage using localStorage
- Quantity management
- Total price calculation
- Remove items functionality

### Search
- Real-time search across all products (sneakers + clothing)
- Search by product name or price
- Live results panel with instant feedback

### Checkout
- Dedicated checkout page
- Order summary with itemized list
- Customer information form
- Payment options (Credit Card, PayPal, Klarna)

## User Preferences
- Clean, modern design aesthetic
- Premium streetwear focus
- South African pricing (Rands)
- Mobile-first responsive design

## Development

### Running Locally
```bash
npm install
npm run dev
```
Server runs on port 5000 (configured for Replit environment)

### Deployment Configuration
- **Development**: Vite dev server on port 5000
- **Deployment**: Configured in `deploy.yaml` for autoscale
- **Build command**: `npm run build`
- **Run command**: `npm run dev`

## Important Notes
- All clothing product images are **license-free stock images** (except fitted caps which use uploaded images)
- Cart data persists in localStorage
- Color selection changes product images dynamically
- Size selection is required before checkout
- Website fully functional with 150 total products (30 sneakers + 120 clothing)

## Documentation Files
- `CLOTHING_SETUP_GUIDE.md` - Original clothing setup guide
- `CLOTHING_PRODUCTS_COMPLETE.md` - Comprehensive 120-product documentation
- `IMAGES/CLOTHING/README.md` - Image organization guide
