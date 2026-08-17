---
name: Academic Precision
colors:
  surface: '#faf8ff'
  surface-dim: '#d9d9e4'
  surface-bright: '#faf8ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f2f3fe'
  surface-container: '#ededf8'
  surface-container-high: '#e7e7f2'
  surface-container-highest: '#e1e2ec'
  on-surface: '#191b23'
  on-surface-variant: '#424654'
  inverse-surface: '#2e3038'
  inverse-on-surface: '#f0f0fb'
  outline: '#737785'
  outline-variant: '#c3c6d6'
  surface-tint: '#0056d2'
  primary: '#0040a1'
  on-primary: '#ffffff'
  primary-container: '#0056d2'
  on-primary-container: '#ccd8ff'
  inverse-primary: '#b2c5ff'
  secondary: '#4a5e88'
  on-secondary: '#ffffff'
  secondary-container: '#bacfff'
  on-secondary-container: '#435881'
  tertiary: '#822800'
  on-tertiary: '#ffffff'
  tertiary-container: '#a93802'
  on-tertiary-container: '#ffcebd'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#dae2ff'
  primary-fixed-dim: '#b2c5ff'
  on-primary-fixed: '#001847'
  on-primary-fixed-variant: '#0040a1'
  secondary-fixed: '#d8e2ff'
  secondary-fixed-dim: '#b2c6f7'
  on-secondary-fixed: '#001a41'
  on-secondary-fixed-variant: '#32466f'
  tertiary-fixed: '#ffdbcf'
  tertiary-fixed-dim: '#ffb59b'
  on-tertiary-fixed: '#380d00'
  on-tertiary-fixed-variant: '#812800'
  background: '#faf8ff'
  on-background: '#191b23'
  surface-variant: '#e1e2ec'
  surface-accent: '#F0F5FF'
  border-subtle: '#E2E8F0'
  status-success: '#10B981'
  status-error: '#EF4444'
  status-warning: '#F59E0B'
typography:
  display-lg:
    fontFamily: Hanken Grotesk
    fontSize: 40px
    fontWeight: '800'
    lineHeight: 48px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Hanken Grotesk
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Hanken Grotesk
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 36px
  headline-md:
    fontFamily: Hanken Grotesk
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  title-sm:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 28px
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-sm:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-caps:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '700'
    lineHeight: 16px
    letterSpacing: 0.06em
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  sidebar-width: 260px
  container-max: 1280px
  gutter: 1.5rem
  margin-mobile: 1rem
  margin-desktop: 2.5rem
  stack-xs: 0.25rem
  stack-sm: 0.75rem
  stack-md: 1.5rem
  stack-lg: 3rem
---

## Brand & Style

This design system is defined by **Modern Minimalism** with a specific focus on academic rigor and institutional trust. It moves away from generic corporate aesthetics toward a "Scholarly Modern" feel—combining the clarity of Swiss design with the warmth of contemporary digital interfaces.

The brand personality is authoritative yet accessible, designed to evoke a sense of focused intellectual growth. The visual style utilizes **Tonal Layering** and **High-Contrast Typography** to create a structured environment where information is the protagonist. The interface should feel "invisible," receding to prioritize data visualization and performance metrics, ensuring a low cognitive load for researchers and educators.

## Colors

The palette transition replaces deep indigo with a vibrant, authoritative **Royal Blue** as the primary driver for action and identity. 

- **Primary:** The Royal Blue (#0056D2) is the core brand identifier, used for primary buttons, active states, and focus indicators.
- **Secondary:** A Deep Navy (#001A41) provides grounding and is used for text headers and high-contrast UI elements to maintain an academic weight.
- **Neutral/Surface:** The system relies on a "Pure Paper" philosophy. Backgrounds are predominantly white, with secondary containers using a very soft blue-tinted gray to maintain a cool, clean professional atmosphere.
- **Functional:** Status colors are high-chroma but used sparingly to ensure they do not compete with the primary brand color.

## Typography

The system uses a pairing of **Hanken Grotesk** for headlines and **Inter** for functional text. This combination bridges the gap between modern startups and traditional academic publishing.

- **Headlines:** Hanken Grotesk provides a sharp, contemporary geometric feel. Use tight letter-spacing for display sizes to create a "dense" and authoritative look.
- **Body:** Inter is used for its exceptional legibility in data-heavy environments. 
- **Scale:** Maintain a strict vertical rhythm. Large headlines should collapse significantly on mobile to avoid orphaned words.
- **Emphasis:** Use font-weight (Bold/SemiBold) rather than color to denote hierarchy within body text to keep the interface clean.

## Layout & Spacing

The layout is built on a **Fixed-Fluid hybrid model** that emphasizes structured discovery.

- **The Rail & Sidebar:** Use a 260px sidebar for primary navigation. On desktop, this is fixed. On tablet, it collapses to a slim rail (64px).
- **The Content Canvas:** Main content resides in a fluid container with a max-width of 1280px. This ensures that data tables and dashboards don't become unreadable on ultra-wide monitors.
- **Rhythm:** An 8px base grid governs all spacing. Use `stack-lg` (48px) to separate major sections and `stack-sm` (12px) for internal component grouping.
- **Responsive Behavior:** At 1024px, margins increase to 40px to provide more "breathing room" for complex data visualizations.

## Elevation & Depth

This design system uses **Tonal Layering** and **Low-Contrast Outlines** to define hierarchy, avoiding heavy shadows to maintain a clean, flat academic aesthetic.

- **Level 0 (Base):** The canvas background, using pure white or the lightest neutral tint.
- **Level 1 (Sectional):** Secondary areas like sidebars or "well" containers use a subtle tonal shift (#F8FAFC) instead of a shadow.
- **Level 2 (Interactive):** Cards and floating elements use a 1px solid border (#E2E8F0). A very soft, blur-heavy ambient shadow (4px blur, 2% opacity) is only applied to hover states to indicate lift.
- **Focus:** Interactive elements (inputs, focused buttons) use a 2px outer glow in the primary color with 20% opacity to provide a "halo" effect without adding physical depth.

## Shapes

The shape language is **Soft (0.25rem)**, reflecting precision and technical accuracy. 

- **Standard Components:** Buttons, input fields, and tags use the base `rounded` (4px). This small radius maintains a serious, structured look while appearing more modern than sharp corners.
- **Large Containers:** KPI cards and modal windows use `rounded-lg` (8px) to create a gentle distinction from smaller UI elements.
- **Data Elements:** Bar charts and progress indicators should have minimal rounding (2px) to ensure the data points remain accurate and clear.

## Components

- **Primary Buttons:** Solid Royal Blue (#0056D2) with white text. Use 10px 20px padding for a substantial, professional feel.
- **KPI Cards:** Defined by a 1px border (#E2E8F0), no shadow. The value uses `headline-lg` in Secondary Navy, with a `label-caps` descriptor above it.
- **Data Tables:** Row-based with subtle dividers. Header cells use `label-caps` with a tinted background (#F0F5FF). Active or "Selected" rows use a vertical 4px Royal Blue "accent bar" on the left edge.
- **Input Fields:** Use a 1px border. On focus, the border transitions to Royal Blue with a soft glow. Labels should always be visible (never placeholder-only) to support academic accessibility.
- **Status Badges:** Use a "Pill" shape with a muted background (10% opacity of the status color) and dark text.
- **Sidebar Nav:** Active links use a subtle background tint and a bolded font-weight. Icons should be "Outlined" style with a 1.5px stroke weight to match the typography.