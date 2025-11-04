/*
  # Initial Database Schema for Sole Theory E-Commerce

  ## Summary
  Creates the core database schema for user management, cart persistence, orders, and email marketing.

  ## New Tables

  ### 1. `profiles`
  - `id` (uuid, primary key) - Links to auth.users
  - `email` (text, unique) - User email address
  - `full_name` (text) - User's full name
  - `phone` (text) - Contact phone number
  - `created_at` (timestamptz) - Account creation timestamp
  - `updated_at` (timestamptz) - Last update timestamp

  ### 2. `addresses`
  - `id` (uuid, primary key) - Address identifier
  - `user_id` (uuid, foreign key) - Links to profiles
  - `first_name` (text) - Shipping first name
  - `last_name` (text) - Shipping last name
  - `street_address` (text) - Street address
  - `apartment` (text, optional) - Apartment/suite number
  - `city` (text) - City name
  - `province` (text) - Province/state
  - `postal_code` (text) - Postal/ZIP code
  - `is_default` (boolean) - Default shipping address flag
  - `created_at` (timestamptz) - Creation timestamp

  ### 3. `cart_items`
  - `id` (uuid, primary key) - Cart item identifier
  - `user_id` (uuid, foreign key) - Links to profiles
  - `product_id` (integer) - Product identifier
  - `product_type` (text) - Type: 'sneaker' or 'clothing'
  - `product_name` (text) - Product name
  - `product_price` (numeric) - Product price
  - `product_image` (text) - Product image URL
  - `selected_color` (text) - Selected color
  - `selected_size` (text) - Selected size
  - `quantity` (integer) - Item quantity
  - `customization` (jsonb, optional) - Jersey name/number customization
  - `created_at` (timestamptz) - Item added timestamp
  - `updated_at` (timestamptz) - Last update timestamp

  ### 4. `orders`
  - `id` (uuid, primary key) - Order identifier
  - `user_id` (uuid, foreign key) - Links to profiles
  - `order_number` (text, unique) - Human-readable order number
  - `status` (text) - Order status: pending, processing, shipped, delivered, cancelled
  - `subtotal` (numeric) - Order subtotal
  - `delivery_fee` (numeric) - Delivery cost
  - `discount_amount` (numeric) - Discount applied
  - `promo_code` (text, optional) - Promo code used
  - `total` (numeric) - Total order amount
  - `delivery_method` (text) - Delivery type: standard, express, overnight
  - `payment_method` (text) - Payment method used
  - `payment_status` (text) - Payment status: pending, paid, failed
  - `shipping_address` (jsonb) - Shipping address details
  - `created_at` (timestamptz) - Order creation timestamp
  - `updated_at` (timestamptz) - Last update timestamp

  ### 5. `order_items`
  - `id` (uuid, primary key) - Order item identifier
  - `order_id` (uuid, foreign key) - Links to orders
  - `product_id` (integer) - Product identifier
  - `product_type` (text) - Type: 'sneaker' or 'clothing'
  - `product_name` (text) - Product name
  - `product_price` (numeric) - Product price at purchase
  - `product_image` (text) - Product image URL
  - `selected_color` (text) - Selected color
  - `selected_size` (text) - Selected size
  - `quantity` (integer) - Item quantity
  - `customization` (jsonb, optional) - Jersey customization details
  - `created_at` (timestamptz) - Creation timestamp

  ### 6. `newsletter_subscribers`
  - `id` (uuid, primary key) - Subscriber identifier
  - `email` (text, unique) - Subscriber email
  - `subscribed_at` (timestamptz) - Subscription timestamp
  - `is_active` (boolean) - Active subscription status

  ### 7. `promo_codes`
  - `id` (uuid, primary key) - Promo code identifier
  - `code` (text, unique) - Promo code string
  - `discount_type` (text) - Type: percentage or fixed
  - `discount_value` (numeric) - Discount amount/percentage
  - `min_purchase` (numeric, optional) - Minimum purchase requirement
  - `max_uses` (integer, optional) - Maximum total uses
  - `uses_count` (integer) - Current usage count
  - `valid_from` (timestamptz) - Valid from date
  - `valid_until` (timestamptz) - Expiry date
  - `is_active` (boolean) - Active status
  - `created_at` (timestamptz) - Creation timestamp

  ## Security
  - Row Level Security (RLS) enabled on all tables
  - Users can only access their own data
  - Promo codes are read-only for authenticated users
  - Newsletter subscriptions are insert-only

  ## Notes
  - All monetary values use numeric type for precision
  - Timestamps use timestamptz for timezone awareness
  - JSONB used for flexible data structures (addresses, customization)
  - Default values set for booleans and timestamps
*/

-- Create profiles table
CREATE TABLE IF NOT EXISTS profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email text UNIQUE NOT NULL,
  full_name text,
  phone text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own profile"
  ON profiles FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can insert own profile"
  ON profiles FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

-- Create addresses table
CREATE TABLE IF NOT EXISTS addresses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  first_name text NOT NULL,
  last_name text NOT NULL,
  street_address text NOT NULL,
  apartment text,
  city text NOT NULL,
  province text NOT NULL,
  postal_code text NOT NULL,
  is_default boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE addresses ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own addresses"
  ON addresses FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own addresses"
  ON addresses FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own addresses"
  ON addresses FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own addresses"
  ON addresses FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Create cart_items table
CREATE TABLE IF NOT EXISTS cart_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  product_id integer NOT NULL,
  product_type text NOT NULL CHECK (product_type IN ('sneaker', 'clothing')),
  product_name text NOT NULL,
  product_price numeric(10,2) NOT NULL,
  product_image text NOT NULL,
  selected_color text NOT NULL,
  selected_size text NOT NULL,
  quantity integer NOT NULL DEFAULT 1 CHECK (quantity > 0),
  customization jsonb,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE cart_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own cart"
  ON cart_items FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own cart items"
  ON cart_items FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own cart items"
  ON cart_items FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own cart items"
  ON cart_items FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Create orders table
CREATE TABLE IF NOT EXISTS orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES profiles(id) ON DELETE SET NULL,
  order_number text UNIQUE NOT NULL,
  status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled')),
  subtotal numeric(10,2) NOT NULL,
  delivery_fee numeric(10,2) NOT NULL DEFAULT 0,
  discount_amount numeric(10,2) NOT NULL DEFAULT 0,
  promo_code text,
  total numeric(10,2) NOT NULL,
  delivery_method text NOT NULL CHECK (delivery_method IN ('standard', 'express', 'overnight')),
  payment_method text NOT NULL,
  payment_status text NOT NULL DEFAULT 'pending' CHECK (payment_status IN ('pending', 'paid', 'failed', 'refunded')),
  shipping_address jsonb NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own orders"
  ON orders FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own orders"
  ON orders FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Create order_items table
CREATE TABLE IF NOT EXISTS order_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id uuid REFERENCES orders(id) ON DELETE CASCADE NOT NULL,
  product_id integer NOT NULL,
  product_type text NOT NULL CHECK (product_type IN ('sneaker', 'clothing')),
  product_name text NOT NULL,
  product_price numeric(10,2) NOT NULL,
  product_image text NOT NULL,
  selected_color text NOT NULL,
  selected_size text NOT NULL,
  quantity integer NOT NULL CHECK (quantity > 0),
  customization jsonb,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own order items"
  ON order_items FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM orders
      WHERE orders.id = order_items.order_id
      AND orders.user_id = auth.uid()
    )
  );

-- Create newsletter_subscribers table
CREATE TABLE IF NOT EXISTS newsletter_subscribers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email text UNIQUE NOT NULL,
  subscribed_at timestamptz DEFAULT now(),
  is_active boolean DEFAULT true
);

ALTER TABLE newsletter_subscribers ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can subscribe to newsletter"
  ON newsletter_subscribers FOR INSERT
  WITH CHECK (true);

-- Create promo_codes table
CREATE TABLE IF NOT EXISTS promo_codes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code text UNIQUE NOT NULL,
  discount_type text NOT NULL CHECK (discount_type IN ('percentage', 'fixed')),
  discount_value numeric(10,2) NOT NULL,
  min_purchase numeric(10,2) DEFAULT 0,
  max_uses integer,
  uses_count integer DEFAULT 0,
  valid_from timestamptz DEFAULT now(),
  valid_until timestamptz NOT NULL,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE promo_codes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view active promo codes"
  ON promo_codes FOR SELECT
  TO authenticated
  USING (is_active = true AND valid_from <= now() AND valid_until >= now());

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_addresses_user_id ON addresses(user_id);
CREATE INDEX IF NOT EXISTS idx_cart_items_user_id ON cart_items(user_id);
CREATE INDEX IF NOT EXISTS idx_orders_user_id ON orders(user_id);
CREATE INDEX IF NOT EXISTS idx_orders_order_number ON orders(order_number);
CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_promo_codes_code ON promo_codes(code);

-- Insert Black Friday promo code
INSERT INTO promo_codes (code, discount_type, discount_value, min_purchase, valid_from, valid_until, is_active)
VALUES ('BLACKFRIDAY', 'percentage', 40, 0, '2025-11-01'::timestamptz, '2025-12-31'::timestamptz, true)
ON CONFLICT (code) DO NOTHING;