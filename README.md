# Go Places

An upbeat, colorful community theme for Discourse: soft pastel colors, round shapes and banners above the topic lists.

These theme components install with it:

| Component | Adds |
| --- | --- |
| [Full width](https://github.com/discourse/discourse-full-width-component) | Full-width page and header layout |
| [Discovery Sidebar](https://github.com/discourse/discourse-discovery-sidebar) | Space, topic and resource panels next to the topic lists |

## Banners

A banner sits above the navigation in the topic list's column, at one fixed height so the page doesn't jump between banners.

- **Top menu banner:** replaces core's welcome banner on the top menu pages. Each entry in `top_menu_banners` has a title, description, image and dark image. The entry without a page shows everywhere; an entry with a page picked replaces it on that page. Without an image, the banner on Latest, New and Hot shows a Fluent Emoji illustration (party popper, sparkles, fire). No search field: the header search sits right above it.
- **Category banner:** on category pages, the category's name and description on a wash of its color, with its logo at the banner's end. Category background images aren't shown.

## Layout

The search field in the header starts at the main column's edge, up to 24rem wide. The page widens by the discovery sidebar's width while a panel renders. The top menu has no Categories tab, whatever the `top_menu` site setting lists; the `/categories` page still works. Topic lists have no Views column.

## Credits

Illustrations: [Fluent Emoji](https://github.com/microsoft/fluentui-emoji) by Microsoft (MIT)
