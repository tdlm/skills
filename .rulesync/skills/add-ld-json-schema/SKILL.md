---
name: add-ld-json-schema
description: Add JSON-LD structured data (schema.org) to a page. Creates a co-located ldJson.ts module with the full @graph schema and renders it via a Script tag. Use when a JIRA ticket requests structured data, schema markup, or JSON-LD for a page.
targets: ["*"]
---

# Add JSON-LD Schema to a Page

## Before You Start

1. **Get the JIRA ticket** -- Read it via Atlassian MCP for the schema types, sample markup, and acceptance criteria.
2. **Identify the content source** -- Schema content typically comes from one of:
   - The JIRA ticket description (sample JSON-LD block)
   - A SharePoint/external document provided by SEO (ask the user if referenced)
   - Existing FAQ data in the codebase (may need conversion from JSX to plain text)
3. **Find the target page** -- Locate the `page.tsx` and understand its route group (`(product-pages)`, `(moneylion-theme)`, etc.).

## Reference Implementations

- **Product page (Instacash):** `src/app/(product-pages)/cash-advance/instacash/ldJson.ts`
- **Collection page (Personal Loans):** `src/app/(moneylion-theme)/personal-loans/_module/ldJson.ts`
- **Collection page (Cash Advance):** `src/app/(moneylion-theme)/cash-advance/_module/ldJson.ts`

## Workflow

### Step 1: Determine Schema Types

The `@graph` array always includes **Organization** and **BreadcrumbList**. The remaining types depend on the page's purpose:

| Page type | Typical schema types |
|-----------|---------------------|
| Product page (1P) | Organization, WebSite, WebPage, SoftwareApplication, FinancialProduct, BreadcrumbList, FAQPage |
| Comparison / "best-of" list | Organization, CollectionPage, BreadcrumbList, ItemList, FAQPage |
| Content / editorial page | Organization, WebPage, BreadcrumbList, FAQPage |

Choose `@type` for ItemList entries based on what the page compares:
- Loans → `LoanOrCredit`
- Apps → `SoftwareApplication`
- Generic products → `FinancialProduct` or `Product`

### Step 2: Gather Content

**FAQ data:**
- If the source is a document, use the FAQ entries from the document (plain text).
- If the source is existing JSX-based FAQ data in the codebase, convert to plain-text or HTML strings. Supported HTML tags in Google's FAQPage schema: `<p>`, `<a>`, `<strong>`, `<b>`, `<em>`, `<i>`, `<sup>`, `<sub>`. Tags like `<ul>`, `<li>`, `<h3>` are not officially supported but won't cause validation errors -- Google ignores them.
- The JSON-LD FAQ data is **separate** from the rendered FAQ component on the page. They may have different content. Do not modify the existing FAQ component or its data files.

**ItemList data (if applicable):**
- Source lender/app/product entries from the ticket or SEO document.
- Each entry needs: name, provider/type, description, and typically Pros/Cons as `additionalProperty`.
- Exclude data that goes stale without code pushes (APR ranges, specific dollar amounts, interest rates, loan terms) unless explicitly told to keep them.

**Organization entity:**
Always reuse the same Organization block for consistency across pages:

```typescript
{
  '@type': 'Organization',
  '@id': 'https://www.moneylion.com/#organization',
  name: 'MoneyLion',
  url: 'https://www.moneylion.com/',
  logo: {
    '@type': 'ImageObject',
    url: 'https://www.moneylion.com/images/logo.svg',
  },
  sameAs: [
    'https://www.facebook.com/moneylion',
    'https://www.instagram.com/moneylion',
    'https://www.linkedin.com/company/moneylion',
    'https://twitter.com/moneylion',
    'https://en.wikipedia.org/wiki/MoneyLion',
  ],
}
```

### Step 3: Create `ldJson.ts`

**File location:** Co-located with the page.
- If the page has a `_module/` directory, place it at `_module/ldJson.ts`
- Otherwise, place it at `ldJson.ts` next to `page.tsx`

**File structure:**

```typescript
// 1. Data arrays at the top (FAQ items, list entries, etc.)
const faqItems = [
  { question: '...', answer: '...' },
]

const listEntries = [
  { name: '...', provider: '...', description: '...', pros: '...', cons: '...' },
]

// 2. Exported schema object with @graph array
export const pageNameJsonLd = {
  '@context': 'https://schema.org/',
  '@graph': [
    // Organization (always included)
    { '@type': 'Organization', ... },

    // Page type (WebPage, CollectionPage, etc.)
    { '@type': 'CollectionPage', ... },

    // BreadcrumbList (always included)
    { '@type': 'BreadcrumbList', ... },

    // ItemList (if applicable) -- .map() from data array
    { '@type': 'ItemList', itemListElement: listEntries.map(...) },

    // FAQPage (if applicable) -- .map() from data array
    { '@type': 'FAQPage', mainEntity: faqItems.map(...) },
  ],
}
```

**Naming convention:** Export name follows the pattern `{pageName}JsonLd` (e.g., `instacashJsonLd`, `personalLoansJsonLd`, `cashAdvanceJsonLd`).

**`@id` convention:** Use the page URL with a fragment identifier: `https://www.moneylion.com/{path}#{type}` (e.g., `#webpage`, `#breadcrumb`, `#faq`, `#loanlist`).

### Step 4: Update `page.tsx`

Minimal changes -- two imports and one JSX element:

```tsx
import Script from 'next/script'
import { pageNameJsonLd } from './_module/ldJson' // or './ldJson'

// Render as the first child inside the outermost wrapper component:
<Script id="schema" type="application/ld+json">
  {JSON.stringify(pageNameJsonLd)}
</Script>
```

The `<Script>` tag is non-visual and does not affect document flow. It can be placed as a child of any wrapper (`<Page>`, `<View>`, etc.).

### Step 5: Validate

1. **Schema.org Validator** ([validator.schema.org](https://validator.schema.org/)) -- Paste the raw JSON. Validates all schema types against the full spec.
2. **Google Rich Results Test** ([search.google.com/test/rich-results](https://search.google.com/test/rich-results)) -- Paste the full HTML with the `<script>` tag. Only reports on rich-result-eligible types (FAQ, Breadcrumb, Product, etc.). Other types (Organization, CollectionPage, ItemList) won't appear here but are still valid.
3. "Unnamed item" in Rich Results Test is expected for FAQPage entities without a `name` field.

## Rules

- JSON-LD schema data is always **static** -- no runtime fetching or dynamic generation.
- Do not modify existing FAQ components or their data files. The JSON-LD FAQ is a separate plain-text representation.
- Do not modify existing metadata exports (`generateMetadata`, `export const metadata`).
- The Organization entity must be consistent across all pages (same `@id`, logo, sameAs).
- Exclude schema properties that would go stale without code pushes (rates, terms, amounts) unless the ticket or user explicitly says to include them.
- When converting JSX FAQ data to schema text, strip React components and map to plain text or supported HTML tags. Images and unsupported tags should be replaced with text descriptions.
